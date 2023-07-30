require 'capybara'
require 'selenium-webdriver'

ENV['FONTCONFIG_FILE'] = '/opt/.fonts/fonts.conf'

Capybara.register_driver :chrome_headless do |app|
  version = Capybara::Selenium::Driver.load_selenium
  options_key = Capybara::Selenium::Driver::CAPS_VERSION.satisfied_by?(version) ? :capabilities : :options
  browser_options = ::Selenium::WebDriver::Chrome::Options.new.tap do |options|
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument("--disable-gpu")
    options.add_argument("--window-size=1280x1696")
    options.add_argument("--single-process")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--homedir=/tmp")
  end

  browser_options.binary = '/opt/bin/headless-chromium'
  driver_path = '/opt/bin/chromedriver'
  service = Selenium::WebDriver::Service.chrome(path: driver_path)

  Capybara::Selenium::Driver.new(app,
                                 browser: :chrome,
                                 service: service,
                                 options_key => browser_options)
end
Capybara.javascript_driver = :chrome_headless
