FROM lambci/lambda:build-ruby2.7

WORKDIR /tmp

RUN yum update -y
RUN yum install -y unzip && \
    curl -SL https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/115.0.5790.170/linux64/chromedriver-linux64.zip > chromedriver.zip && \
    unzip chromedriver.zip
# RUN yum install -y ipa-gothic-fonts ipa-mincho-fonts

ADD build_with_container/Gemfile Gemfile
ADD build_with_container/Gemfile.lock Gemfile.lock
RUN bundle install --path vendor/bundle

ADD ./lambda_with_container/ruby_selenium_base/google-chrome.repo /etc/yum.repos.d/google-chrome.repo
# https://support.google.com/chrome/thread/219101233/google-chrome-114-cannot-be-installed-on-centos7-and-rhel7?hl=en
RUN yum install -y google-chrome-stable.x86_64 --nogpgcheck

CMD echo 1
