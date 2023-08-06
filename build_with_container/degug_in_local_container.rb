require 'json'
require 'selenium-webdriver'

module LambdaFunction
  class Handler
    class << self
      def process(event:, context:)
        content = "hogehoge"

        content = use_selenium

        build_response(content)
      end

      def use_library
        HolidayJapan.name(Date.new(2021, 8, 8)) # 山の日
      end

      def use_selenium
        ENV["HOME"] = "/tmp"

        Proc.new{|statement| puts "#{statement}:"; puts `#{statement}`}.call("whoami")
        Proc.new{|statement| puts "#{statement}:"; puts `#{statement}`}.call("echo $HOME")
        Proc.new{|statement| puts "#{statement}:"; puts `#{statement}`}.call("id sbx_user1051")
        # Proc.new{|statement| puts "#{statement}:"; puts `#{statement}`}.call("headless-chromium --version")
        # Proc.new{|statement| puts "#{statement}:"; puts `#{statement}`}.call("/var/task/chromedriver --version")
        # p "google-chromeコマンド実行 開始"
        # p `headless-chromium --no-sandbox --headless --window-size=1440,990 --disable-dev-shm-usage --disable-extensions start-maximized disable-infobars`
        # p "google-chromeコマンド実行 終了"

        session = gen_accessor
        # 10秒待っても読み込まれない場合は、エラーが発生する
        session.manage.timeouts.implicit_wait = 10
        # ページ遷移する
        session.navigate.to "https://google.com/"

        # ページのタイトルを出力する
        session.title
      end

      private

      def build_response(content)
        {
          statusCode: 200,
          error_message: nil,
          body: {
            message: content,
            # input: event
          }.to_json
        }
      end

      LAMBDA_TASK_ROOT = "/var/task"
      def gen_accessor
        # ENV["FONTCONFIG_FILE"] = "#{LAMBDA_TASK_ROOT}/lambda_fonts/fonts.conf"
        # ENV["FONTCONFIG_PATH"] = "#{LAMBDA_TASK_ROOT}/lambda_fonts"

        options = ::Selenium::WebDriver::Chrome::Options.new(
          binary: "/opt/bin/headless-chromium"
        )
        options.headless!
        options.add_argument("--no-sandbox")
        options.add_argument("--headless")
        options.add_argument("--disable-dev-shm-usage") # unknown error: DevToolsActivePort file doesn't exist対策
        # options.add_argument("--disable-gpu") # 最近の通例では付けなくて良いようになった、付けてはいけないと言われている

        # 一旦は全部ONにしたけどエラー変わらなかった群
        # options.add_argument("--disable-extensions")
        # options.add_argument("start-maximized")
        # options.add_argument("disable-infobars")
        # options.add_argument("--single-process")
        # options.add_argument("--remote-debugging-port=9222")

        # #2017 メモリ不足対策として小さなウィンドウを指定
        options.add_argument("window-size=1440,990")

        client = ::Selenium::WebDriver::Remote::Http::Default.new
        client.open_timeout = 300
        client.read_timeout = 300

        service = ::Selenium::WebDriver::Service.chrome(path: "/opt/bin/chromedriver")
        ::Selenium::WebDriver.for(:chrome, options: options, http_client: client, service: service)
      end
    end
  end
end

if __FILE__ == $0
  p LambdaFunction::Handler.process(event: nil, context: nil)
end
