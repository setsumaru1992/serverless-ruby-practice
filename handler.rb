require 'json'
require 'holiday_japan'

def hello(event:, context:)
  build_response("Go Serverless v1.0! Your function executed successfully!")
end

def library_function(event:, context:)
  holidayName = HolidayJapan.name(Date.new(2021, 8, 8))
  holidayName # 山の日
  build_response(holidayName)
end

def heavy_function(event:, context:)
  sleep 120
  build_response("heavy process finished")
end

def env_value_function(event:, context:)
  build_response("全関数共通: #{ENV["COMMON_VAL"]}, 関数特有: #{ENV["FUNCTION_ENV"]}")
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
