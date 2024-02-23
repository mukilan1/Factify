from openai import OpenAI
from . import API

def ChatBot(prompt_text):
    client = OpenAI(api_key=API.ChatGPT_API)  # Replace with your actual API key

    response = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[
            {"role": "system", "content": ("Your name is Factbot" "Company Name : Factify"
                "You are a chat bot who helps consumers with misleading product information. "
                "Devise a system that analyses product listings for instances when crucial "
                "information such as pricing, availability, or specifications is omitted, "
                "incorrectly presented, or kept hidden or disguised over long periods. "
                "every questions asked by the user will be relavent to the consumers with misleading product information. "
                "every answer given by the chatbot should be short and clear. "
            )},
            {"role": "user", "content": prompt_text}
        ]
    )

    # Correctly accessing the message content
    return response.choices[0].message.content
