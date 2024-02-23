from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

def scrape_product(product_url):
    # Setup Chrome options for headless mode
    chrome_options = Options()
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--window-size=1920,1080")
    chrome_options.add_argument("--disable-notifications")
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--verbose")
    chrome_options.add_experimental_option("prefs", {
        "download.default_directory": "/path/to/download/dir",
        "download.prompt_for_download": False,
        "download.directory_upgrade": True,
        "safebrowsing.enabled": True
    })

    product_details = []

    # Initialize WebDriver
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)

    try:
        # Navigate to the product page
        driver.get(product_url)

        # Wait for the page to load and title to be present
        WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.CSS_SELECTOR, "span.B_NuCI")))

        # Scrape the title and price
        title = driver.find_element(By.CSS_SELECTOR, "span.B_NuCI").text
        price = driver.find_element(By.CSS_SELECTOR, "div._30jeq3").text
        website_name = "Flipkart"

        # Attempt to scrape specifications, if available
        try:
            specifications = driver.find_element(By.CSS_SELECTOR, "div._1mXcCf").text
        except:
            specifications = "Specifications not found"

        product_details = [title, price, specifications, website_name]

    except Exception as e:
        product_details = ["Error retrieving product details"]

    finally:
        driver.quit()
        return product_details

# # Example product URL
# product_url = "https://www.naaptol.com/smartphones/4g-dual-sim-big-screen-super-fast-android-mobile-k510/p/12612636.html?ntzoneid=9282&nts=Cat_Now_Trending&ntz=Cat_Now_Trending"
# details = scrape_product(product_url)
# print(details)
