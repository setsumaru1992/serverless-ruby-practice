FROM public.ecr.aws/lambda/ruby:2.7

ENV GEM_HOME=${LAMBDA_TASK_ROOT}
COPY Gemfile ${LAMBDA_TASK_ROOT}
RUN bundle install

# yum版chromeを使うなら必要かは不明
ADD lambda_fonts lambda_fonts
ENV FONTCONFIG_FILE=${LAMBDA_TASK_ROOT}/lambda_fonts/fonts.conf
ENV FONTCONFIG_PATH=${LAMBDA_TASK_ROOT}/lambda_fonts

RUN yum install -y unzip && \
    # curl -SL https://chromedriver.storage.googleapis.com/86.0.4240.22/chromedriver_linux64.zip > chromedriver.zip && \
    curl -SL https://chromedriver.storage.googleapis.com/97.0.4692.71/chromedriver_linux64.zip > chromedriver.zip && \
    # curl -SL https://github.com/adieuadieu/serverless-chrome/releases/download/v1.0.0-57/stable-headless-chromium-amazonlinux-2.zip > headless-chromium.zip && \
    unzip chromedriver.zip
    # unzip chromedriver.zip && \
    # unzip headless-chromium.zip

# yum版chromeを使うなら必要かは不明
RUN yum install -y libX11

ADD google-chrome.repo /etc/yum.repos.d/google-chrome.repo
RUN yum -y install google-chrome-stable libOSMesa