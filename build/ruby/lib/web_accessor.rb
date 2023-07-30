require 'selenium-webdriver'

module WebAccessor
  class Base
    def initialize(close_each_access: true)
      @close_each_access = close_each_access
    end

    def close
      @accessor.quit if @accessor.present?
    end

    private

    # ブラウザアクセスしてスクレイピングを行う
    #
    # 注意
    # - 引数のブロック内で冪等性を担保する、つまり何度行なっても同じ結果になる、2度同じプロセスを踏んだときに1度目の値があるからと言って悪さをするような実装にしてはいけない
    #   - 理由：retry時にretry前の値が残っていると結果がおかしくなるため。
    #   - 対策
    #     - ブロック外の値を使わない
    #     - ブロック外の値を使うとしても、ブロック内で"="で丸々置き換えて、そのブロックで独立した値を使えるようにする
    #       - ブロック内の値をメソッドの返り値として返却するためにブロック外で変数定義する場合
    def access(pre_access_params: {}, post_access_params: {}, &process)
      max_retry_count = 0 # 1
      retry_count = 0
      begin
        if @accessor.nil?
          @accessor = gen_accessor
          pre_access(@accessor, pre_access_params)
        end
        yield(@accessor)
        post_access(@accessor, post_access_params)
      rescue => e
        if retry_count < max_retry_count
          puts(e)
          retry_count += 1
          puts("リトライ #{retry_count}/#{max_retry_count}")
          sleep 120
          retry
        else
          # screenshot_path = Rails.root.join("tmp", "error_crawl_#{Time.now.strftime("%Y%m%d%H%M%S")}.png")
          # @accessor.save_screenshot(screenshot_path) if @accessor.present?
          puts("スクレイピングエラー発生。")
          terminate_accessor # 閉じない設定でもエラー時は特別。
          raise e
        end
      ensure
        terminate_accessor if @close_each_access
      end
    end

    def gen_accessor
      ENV["FONTCONFIG_FILE"] = "/opt/.fonts/fonts.conf"
      ENV["FONTCONFIG_PATH"] = "/opt/.fonts"
      
      options = ::Selenium::WebDriver::Chrome::Options.new(
        binary: "/opt/bin/headless-chromium"
      )
      options.headless!
      options.add_argument("--no-sandbox")
      options.add_argument("--headless")
      # options.add_argument("--disable-gpu")
      options.add_argument("--disable-dev-shm-usage")
      options.add_argument("--disable-extensions")
      options.add_argument("start-maximized")
      options.add_argument("disable-infobars")
      # options.add_argument("--remote-debugging-port=9222")
      # #2017 メモリ不足対策として小さなウィンドウを指定
      options.add_argument("window-size=1440,990")

      client = ::Selenium::WebDriver::Remote::Http::Default.new
      client.open_timeout = 300
      client.read_timeout = 300
      
      service = ::Selenium::WebDriver::Service.chrome(path: "/opt/bin/chromedriver")
      ::Selenium::WebDriver.for(:chrome, options: options, http_client: client, service: service)
    end

    def terminate_accessor
      return if @accessor.nil?

      @accessor.quit
      @accessor = nil
    end

    def pre_access(accessor, args) end

    def post_access(accessor, args) end

    def visit(url)
      @accessor.get(url)
      puts("WebAccess: #{url}")
      sleep(1)
    end

    def get_content(target_element: nil, by: :xpath, selector: nil, &parser)
      target = target_element || @accessor
      element = target.find_element(by, selector)
      text = element.text
      if block_given?
        yield(text)
      else
        text
      end
    end

    def click_js_trigger(target_element: nil, by: :xpath, selector: nil, wait_target_by: :tag_name, wait_target_selector: "body")
      target = target_element || @accessor
      element = target.find_element(by, selector)
      element.click
      sleep(1)
      ::Selenium::WebDriver::Wait.new(timeout: 300).until do
        @accessor.find_element(wait_target_by, wait_target_selector).displayed?
      end
    end

    def switch_to_iframe(iframe_xpath)
      iframe = @accessor.find_element(:xpath, iframe_xpath)
      @accessor.switch_to.frame(iframe)
    end

    def switch_to_new_tab
      new_tab = @accessor.window_handles.last
      @accessor.switch_to.window(new_tab)
    end
  end
end
