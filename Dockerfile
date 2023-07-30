FROM lambci/lambda:build-ruby2.7

WORKDIR /tmp

RUN yum install -y unzip && \
    curl -SL https://chromedriver.storage.googleapis.com/86.0.4240.22/chromedriver_linux64.zip > chromedriver.zip && \
    curl -SL https://github.com/adieuadieu/serverless-chrome/releases/download/v1.0.0-57/stable-headless-chromium-amazonlinux-2.zip > headless-chromium.zip && \
    unzip chromedriver.zip && \
    unzip headless-chromium.zip

RUN yum install -y libX11

ADD build/Gemfile Gemfile
ADD build/Gemfile.lock Gemfile.lock
RUN bundle install --path vendor/bundle

CMD cp /tmp/chromedriver /opt/bin/ && \
    cp /tmp/headless-chromium /opt/bin/ && \
    # chromium
    cp /usr/lib64/libexpat.so.1 /opt/lib/ && \
    cp /usr/lib64/libuuid.so.1 /opt/lib/ && \
    # chromedriver
    cp /usr/lib64/libglib-2.0.so.0 /opt/lib/ && \
    cp /usr/lib64/libX11.so.6 /opt/lib/ && \
    cp /usr/lib64/libxcb.so.1 /opt/lib/ && \
    cp /usr/lib64/libXau.so.6 /opt/lib/ && \
    cp /usr/lib64/libX11-xcb.so.1 /opt/lib/ && \
    # 上記以外
    cp -r /tmp/vendor/bundle/ruby/2.7.0 /opt/ruby/gems