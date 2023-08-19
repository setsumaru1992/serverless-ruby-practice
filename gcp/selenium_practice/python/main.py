import os

from selenium import webdriver


def crawler(request):
    chrome_options = webdriver.ChromeOptions()
    chrome_options.add_argument('--headless')
    chrome_options.add_argument('--disable-gpu')
    chrome_options.add_argument('--window-size=1280x1696')
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--hide-scrollbars')
    chrome_options.add_argument('--enable-logging')
    chrome_options.add_argument('--log-level=0')
    chrome_options.add_argument('--v=99')
    chrome_options.add_argument('--single-process')
    chrome_options.add_argument('--ignore-certificate-errors')
    chrome_options.binary_location = os.getcwd() + "/bin/headless-chromium"
    driver = webdriver.Chrome(
        os.getcwd() + "/bin/chromedriver", chrome_options=chrome_options)

    driver.get('https://en.wikipedia.org/wiki/Special:Random')
    line = driver.find_element_by_class_name('firstHeading').text
    print(line)
    driver.quit()
    return line