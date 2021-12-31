require 'aws-sdk-lambda'
require 'json'

# https://docs.aws.amazon.com/ja_jp/sdk-for-ruby/v3/developer-guide/lambda-ruby-example-run-function.html
lambda_client = Aws::Lambda::Client.new(
  # https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-sdk-lambda/lib/aws-sdk-lambda/client.rb#L81
  http_open_timeout: 300,
)
response = lambda_client.invoke({
  function_name: "ruby-practice-dev-hello",
  # https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-sdk-lambda/lib/aws-sdk-lambda/client.rb#L2670
  invocation_type: 'RequestResponse',
  log_type: 'None',
})

# response # #<struct Aws::Lambda::Types::InvocationResponse status_code=200, function_error=nil, log_result=nil, payload=#<StringIO:0x0000563d2c77f2d0>, executed_version="$LATEST">
# response.status_code # 200
# JSON.parse(response.payload.string) # {"statusCode"=>200, "body"=>"{\"message\":\"Go Serverless v1.0! Your function executed successfully!\"}"}

p response