from openai import OpenAI
from . import API

openai_api_key = API.ChatGPT_API


def compare_specifications(ecommerce_specs, official_specs):
    client = OpenAI(api_key= openai_api_key)  # Replace with your actual API key

  

    prompt = (
       
               f"This is the E-Commerce data: '{ecommerce_specs}', and this is the Official data: '{official_specs}', The official data will be in the JSON Formate. \n"
               "Compare the E-Commerce data against the Official data. And Identify the specifications that are incorrect and provide details on what is incorrect in the E-Commerce data when compared to the Official Data.\n"
               "Mention the name of the product in the 'name' section. \n"
               "feel of the product in the 'feel' section as Good, Bad, Fair, and Worst. Both the feel and rating should be associated. Only one output in the String without any other additional information other than (Good, Bad, Fair, and Worst) dont give numbers also. \n"
               "Mention specific cost details in the detailed Sentence formate with the difference with the costs mentioned in the 'Cost' section. Only in the sentence formate.\n"
               "Mention the Transparency issue if any in the 'Transparency' section (Excluding the Cost).With the name of the Parts where it happened. If no Transparency issue then mention mention it as there is no Transparency issues present in the E-Commerce Data. Only in the sentence formate. \n"
               "Mention the Rating issue if any in the 'Rating' section in integer from 1 to 5 for the Comparission (Excluding the Cost).in Integer \n"
               "Mention the Suggestion if any in the 'Suggestion' section (Excluding the Cost). If no Suggestion about the issue then mention it in a positive way. Only in the sentence formate. Spelling formate is not to be mention in the Suggestion\n"
                "Mention the Wrong data if any in the 'WrongData' section (Excluding the Cost). With the name of the Parts where it happened. If no WrongData then mention it as there is no Wrong Data present in the E-Commerce Data. Only in the sentence formate. \n"
                "Menion the Misleading info if any in the 'MisleadingData' section (Excluding the Cost).  With the name of the Parts where it happened. Only in the sentence formate. The data from the different websites are not a Misleading information.\n"
                "Mention the Omitted information based on the product in the 'omitted' section (Excluding the Cost)"
                "Note: All the Data responces should only be in the JSON formate. \n"
                "All the data of the Keys should be in the Sentence formate. not in any other Datatype or formate only in String(Sentence) \n"
                "Compare like a Human and provide the results.\n"
                "Maintain the order of the keys as mentioned above in a constantway all time. (Note) All the formate of output are casesencitive. \n"
                "If once a product is with the same specifications is compared then the same product is compared with the same specifications compared again Note that the responce should be constant without dynamic changes. \n"
                "Don't Use any other datatypes other than String(Sentence) for the responce (Excluding Rating). \n" 
                "Dont mention any symbols in the responce. Example if Cost use Rs. rather than using symbol for it.\n"
                # "If Some of the Data Not present in the Official data or mentioned as NotFound or Not Present, then Ignore that data and continue the process. \n"
                )

    

    try:
        response = client.chat.completions.create(
            model="gpt-4-turbo-preview",
            messages=[
                {"role": "system", "content": ("Give me in JSON format in proper contents.\n"
                                               "Do not mention anything except the json object.\n"
                                               "Give only the JSON object.\n"
                                               "Dont give (```json ... ```) with the output.\n"\
                                                "The data representations other than the given formate are strictly not allowed.\n"
                                               )},
                {"role": "user", "content": prompt}
            ]
        )
        return response.choices[0].message.content[:-1] + f",\"ecommerce_specs\": \"{ecommerce_specs}\" {"}"}"
    except Exception as e:
        return f"An error occurred: {str(e)}"


# if __name__ == '__main__':

#     official_specs = ['Apple iPhone 15 (Blue, 128 GB), ₹66,999, Highlights: 128 GB ROM, 15.49 cm (6.1 inch) Super Retina XDR Display, 48MP + 12MP | 12MP Front Camera, A16 Bionic Chip, 6 Core Processor Processor, Available on Apple.com.']
#     ecommerce_specs = ['Apple iPhone 15 (Blue, 128 GB)', '₹66,999', 'Highlights128 GB ROM15.49 cm (6.1 inch) Super Retina XDR Display48MP + 12MP | 12MP Front Camera, A16 Bionic Chip, 6 Core Processor Processor', 'Flipkart']
#     print(compare_specifications(ecommerce_specs=ecommerce_specs, official_specs=official_specs))


