import requests
import re
from openai import OpenAI
from . import API

openai_api_key = API.ChatGPT_API
bing_api_key = API.Bing_API

# openai_api_key = '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'
# bing_api_key  = 'ceb224e364e74104b706e569452c1dd4'

def bing_search(query, bing_api_key, count=10):
    url = "https://api.bing.microsoft.com/v7.0/search"
    headers = {"Ocp-Apim-Subscription-Key": bing_api_key}
    params = {"q": query, "count": count}
    response = requests.get(url, headers=headers, params=params)
    return response.json()

def extract_cost_from_search(search_results):
    prices = []
    for result in search_results.get('webPages', {}).get('value', []):
        found_prices = re.findall(r'\b\d{1,3}(?:,\d{3})*(?:\.\d+)?\s*INR\b', result.get('snippet', ''))
        prices.extend(found_prices)

    if not prices:  # Fallback search if no prices found
        return "Price not found"

    prices = [float(price.replace(',', '').split()[0]) for price in prices]
    most_frequent_price = max(set(prices), key=prices.count)
    return f"{most_frequent_price} INR"

# def process_with_gpt(product_name, search_snippet, cost):
#     client = OpenAI(api_key=openai_api_key)
#     prompt = (
#         f"Analyze the web search data: '{search_snippet}' for '{product_name}'. "
#         f"Need the 'Cost':{cost} details in the field. \n"
#         f"Give me the Official Reviews and Specifications of the product. \n"
#         "(Note) No offers and Discounts prices should be mentioned. Only the Official Procing and Specifications should be mentioned. \n"
#         "I Need the entire details of the product specification based on the product and its components. (Note: If it is a Mobile then the datas should be like: Screen Size, Battery Life, Camera Quality, RAM, ROM, Procerssor, Screen Size, Display Type, Screen Resolution, Operating System, Processor, RAM, Internal Storage, Rear Camera, Front Camera, Battery, Fingerprint Sensor, Connectivity, Water and Dust Resistance, Security Features, Other Features etc. and all the Specifications of the product details Required.)"
#         "All the Ddetails : Cost, Specifications, Reviews, Ratings, etc (These Fields are Must). should be in the List format. \n"
#         "All the information are mandatory so the datas must be featched from the web search. \n"
#         "All the data should be fetched from the official website of the product. \n"
#         "(Note): All the Specifications should be True and Correct (All the Information that you provide are very Crusial and most important). \n"
#         "Make a accurate search for the correct specification where some simular models of the product might have different specification, that should not be mentioned in the actual product specification. \n"
#         "Make a Cross check in the web for the Cotrrect specification. \n"
#         # "Mostly try to get all datas as much as possible. \n"
#         # "Don't give any Suggestions at the filan, only the results is to be given. \n"
#         )

#     try:
#         response = client.chat.completions.create(
#             model="gpt-4-turbo-preview",
#             messages=[
#                 {"role": "system", "content": "Extract product specifications and cost in JSON format."},
#                 {"role": "user", "content": prompt}
#             ]
#         )
#         return response.choices[0].message.content
#     except Exception as e:
#         return f"An error occurred: {str(e)}"


def process_with_gpt(product_name, search_snippet, cost):
    client = OpenAI(api_key=openai_api_key)
    prompt = (
        f"Based on the most recent official product information available online for '{product_name}', "
        f"and considering the identified cost of {cost}, "
        "extract the latest official reviews and specifications. If the official product details are not available, "
        "search for the most reliable and recent information from other reputable sources. It's imperative to ensure all details, "
        "such as the chip model, are accurate and reflect the latest specifications. "
        "\n\n(Note: Prioritize information from the official product website. If such information is insufficient or unavailable, "
        "then and only then resort to other credible online sources while ensuring the information is up-to-date and correct.) \n\n"
        "Specifications needed include, but are not limited to, Screen Size, Battery Life, Camera Quality, RAM, ROM, Processor, Display Type, "
        "Screen Resolution, Operating System, and other relevant product details. "
        "Ensure accuracy by cross-verifying with official product websites first, followed by other reputable sources. "
        "\n\nProvide the information in a structured format, focusing on Cost, Specifications, Reviews, and Ratings. "
        "All information provided must be double-checked for its accuracy and currentness."
    )

    try:
        response = client.chat.completions.create(
            model="gpt-4-turbo-preview",
            messages=[
                {"role": "system", "content": "Extract product specifications and cost in a structured format."},
                {"role": "user", "content": prompt}
            ]
        )
        return response.choices[0].message.content
    except Exception as e:
        return f"An error occurred: {str(e)}"


def get_official_data(product_name):    
    try:
        search_results = bing_search(product_name, bing_api_key)
        search_snippet = search_results['webPages']['value'][0]['snippet'] if 'webPages' in search_results else "No relevant data found."

        cost = extract_cost_from_search(search_results)
        if cost == "Price not found":
            # Perform a targeted search for price if not found initially
            price_search_results = bing_search(f"{product_name} price", bing_api_key, count=5)
            cost = extract_cost_from_search(price_search_results)

        processed_response = process_with_gpt(product_name, search_snippet, cost)
        print(processed_response)
        return processed_response
    except Exception as e:
        return f"An error occurred: {str(e)}"

# Usage Example
# get_official_data('iphone 12', 'screen size, battery life, camera quality')

# if __name__ == '__main__':
#     get_official_data('OnePlus 11')