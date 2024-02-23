import openai
import requests
from bs4 import BeautifulSoup
import re  # Import the regular expression module
from . import API
openai.api_key = API.ChatGPT_API

def chat_with_gpt3(messages):
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=messages
    )
    return response['choices'][0]['message']['content']

def search_product(product_name, site=None):
    # Define the search query
    query = f'"{product_name}"'
    if site:
        query += f" site:{site}"

    # Google Search URL (Note: Google may block automated search queries)
    url = f"https://www.google.com/search?q={query}"

    try:
        # Perform the search
        response = requests.get(url)
        response.raise_for_status()

        # Parse the HTML content
        soup = BeautifulSoup(response.text, 'html.parser')

        # Find all search result links (assuming Google's HTML structure)
        for link in soup.find_all('a'):
            href = link.get('href')
            if href and "url?q=" in href:
                # Extract the actual URL from the Google search result link using regex
                match = re.search(r'url\?q=(?P<url>.*?)&', href)
                if match:
                    actual_url = match.group("url")
                    return actual_url

    except requests.RequestException as e:
        print(f"Error: {e}")

    # Return None if no URL is found
    return None

def identify_product_and_website(title):
    # Start the conversation with the provided title
    messages = [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": f"Remove specifications and identify the product name and official website for the title: {title}"}
    ]

    # Get the response from GPT-3.5
    response = chat_with_gpt3(messages)

    # Extract product name directly from GPT-3.5 response
    product_name = response.strip()

    # Use the product name to search for the actual website
    actual_url = search_product(product_name, site="")

    # Return the result
    return product_name, actual_url

# Example usage
scraped_title = "Google Pixel 7a (Charcoal, 128 GB) (8 GB RAM)"
product, website = identify_product_and_website(scraped_title)

# Print the result
print(f"Product Name: {product}")
print(f"Actual Website: {website}")
