def prepare_environment
  load_library
  set_environment_variables
end

def load_library
  load_selenium_library
  require_relative "web_accessor.rb"
end

def set_environment_variables
  ENV["FONTCONFIG_FILE"] = "/opt/.fonts/fonts.conf"
  ENV["FONTCONFIG_PATH"] = "/opt/.fonts"
end

def load_selenium_library
  log "require 'selenium-webdriver'開始(1分くらいかかる)"
  require 'selenium-webdriver'
  log "require 'selenium-webdriver'終了"
end

def main
  # p "hoge"
  url = "https://example.com/"
  p DebugWebAccessor.new.url_access(url)
end

def log(message)
  print "#{Time.now + 9*60*60}: #{message}\n"
end

prepare_environment

# 本当はload_libraryの前に書きたいけど、このメソッド終了後でないとWebAccessorを読めないのでこの位置
class DebugWebAccessor < ::WebAccessor::Base
  def url_access(url)
    return_value = ""
    access do |accessor|
      visit(url)
      return_value = accessor.title
    end
    return_value
  end
end

main