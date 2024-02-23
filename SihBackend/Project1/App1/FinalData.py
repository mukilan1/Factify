from .import ProductSearchMain
from . import CompareDatas
from . import OfficialProduct
import json

def CompareData(Data):
    product_data = ProductSearchMain.scrape_product(Data)
    print(product_data)

    # Extract product name from product_data
    product_name = product_data[0]  # Adjust the key if necessary

    official_data = OfficialProduct.get_official_data(product_name)
    # OfficialProductData.get_official_data(product_name)

    compare_data_raw = CompareDatas.compare_specifications(product_data, str(official_data))
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>")
    print(compare_data_raw)
    
    # Check if compare_data_raw is a string and convert it to a dictionary
    try:
        compare_data = json.loads(compare_data_raw) if isinstance(compare_data_raw, str) else compare_data_raw
    except json.JSONDecodeError:
        # Handle the case where compare_data_raw is not a valid JSON string
        return {'error': 'Invalid data format'}

    # Construct the post_data dictionary based on comparison results
    post_data = {
        'name': compare_data.get('name', ''),  # Ensure this field exists in your model
        'feel': compare_data.get('feel', ''),
        'NotsimilarData': compare_data.get('NotsimilarData', ''),  # Adjust the key to match the model field
        'MisleadingData': compare_data.get('MisleadingData', ''),  # Adjust the key to match the model field
        'Cost': compare_data.get('Cost', ''),
        'Transparency': compare_data.get('Transparency', ''),
        'Rating': compare_data.get('Rating', 0),
        'Suggestion': compare_data.get('Suggestion', ''),
        'WrongData': compare_data.get('WrongData', ''),  # No need to use json.dumps if it's already a string
        'omitted':  compare_data.get('omitted', ''),
        'ecommerce_specs': compare_data.get('ecommerce_specs', ''),  # No need to use json.dumps if it's already a string
        'official_specs': compare_data.get('official_specs', ''), 
         # No need to use json.dumps if it's already a string
    }

    

    return post_data
