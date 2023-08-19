#! /bin/bash

CHROME_FILE=headless-chromium_serverless-chrome_v1.0.0-37
CHROME_ZIP=${CHROME_FILE}.zip
curl -SL https://github.com/adieuadieu/serverless-chrome/releases/download/v1.0.0-37/stable-headless-chromium-amazonlinux-2017-03.zip > $CHROME_ZIP
unzip $CHROME_ZIP
rm $CHROME_ZIP
ln -s $CHROME_FILE headless-chromium

CHROME_DRIVER_FILE=headless-chromium_serverless-chrome_v1.0.0-37
CHROME_DRIVER_ZIP=${CHROME_DRIVER_FILE}.zip
curl -SL https://chromedriver.storage.googleapis.com/2.37/chromedriver_linux64.zip > $CHROME_DRIVER_ZIP
unzip $CHROME_DRIVER_ZIP
rm $CHROME_DRIVER_ZIP
ln -s $CHROME_DRIVER_FILE headless-chromium