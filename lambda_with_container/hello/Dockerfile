FROM 241875560804.dkr.ecr.ap-northeast-1.amazonaws.com/lambda_ruby_selenium_base:latest

# RUN cp -r /opt/google ${LAMBDA_TASK_ROOT} && \
#   unlink /usr/bin/google-chrome && \
#   ln -s ${LAMBDA_TASK_ROOT}/google/chrome/google-chrome /usr/bin/google-chrome

COPY app.rb ${LAMBDA_TASK_ROOT}

COPY Gemfile ${LAMBDA_TASK_ROOT}
RUN bundle install

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "app.LambdaFunction::Handler.process" ]
