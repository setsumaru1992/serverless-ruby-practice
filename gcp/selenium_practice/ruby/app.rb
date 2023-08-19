require 'json'
require 'selenium-webdriver'
require "functions_framework"

def gen_accessor
  # ENV["FONTCONFIG_FILE"] = "#{LAMBDA_TASK_ROOT}/lambda_fonts/fonts.conf"
  # ENV["FONTCONFIG_PATH"] = "#{LAMBDA_TASK_ROOT}/lambda_fonts"

  options = ::Selenium::WebDriver::Chrome::Options.new(
    binary: "#{__dir__}/bin/headless-chromium"
  )
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

  service = ::Selenium::WebDriver::Service.chrome(path: "#{__dir__}/bin/chromedriver")
  ::Selenium::WebDriver.for(:chrome, options: options, http_client: client, service: service)
end

FunctionsFramework.http "ruby_crawler" do |_request|
    session = gen_accessor
  # 10秒待っても読み込まれない場合は、エラーが発生する
  session.manage.timeouts.implicit_wait = 10
  # ページ遷移する
  session.navigate.to "https://google.com/"

  # ページのタイトルを出力する
  session.title
end