FROM public.ecr.aws/lambda/ruby:2.7

ENV GEM_HOME=${LAMBDA_TASK_ROOT}
COPY Gemfile ${LAMBDA_TASK_ROOT}
RUN bundle install

# yum版chromeを使うなら必要かは不明
ADD lambda_fonts lambda_fonts
ENV FONTCONFIG_FILE=/opt/.fonts/fonts.conf
ENV FONTCONFIG_PATH=/opt/.fonts/

RUN yum install -y unzip && \
    curl -SL https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/115.0.5790.170/linux64/chromedriver-linux64.zip > chromedriver.zip && \
    unzip chromedriver.zip
    
ADD google-chrome.repo /etc/yum.repos.d/google-chrome.repo
RUN yum install -y google-chrome-stable.x86_64 --nogpgcheck
CMD echo "a"