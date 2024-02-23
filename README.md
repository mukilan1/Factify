# Dark Pattern Buster: E-Commerce Truth Enhancer  ![Factify Title](https://github.com/mukilan1/Factify/assets/74693526/38d90dfd-4bba-4670-9e43-80b65d02550f)


## Introduction

In the vast expanse of e-commerce, misleading product information is a significant challenge, leading to consumer distrust and dissatisfaction. To address this issue, our team developed the Dark Pattern Buster application for the 2023 Dark Pattern Buster Hackathon, focusing on the problem statement of misleading product information on e-commerce sites. This mobile application leverages advanced technologies to verify product information directly from e-commerce links and compares it with official specifications, ensuring transparency and trust.

## Features

- **Product Information Verification:** Users can copy and paste the link of a product page into the application. The backend, built with Django REST Framework, processes this link to fetch product details such as specifications, cost, and title.
- **Data Comparison:** Utilizing Selenium for web scraping, the application retrieves product information, which is then compared against official specifications fetched through the GPT and Bing APIs.
- **Results Analysis:** Leveraging the Chat GPT API, the application analyzes and compares both sets of data, highlighting discrepancies and verifying the accuracy of the e-commerce product information.
- **Built-in Chat Bot:** A user-friendly chatbot is available for instant queries and assistance within the app.
- **Search History:** Users can access a history of their searches and comparisons, enabling easy reference to previously viewed products.
- **Educational Content:** The application features a blog and awareness videos aimed at educating consumers about misleading practices and how to identify them.



## Technology Stack

- **Frontend:** Flutter for a seamless, cross-platform mobile user experience.
- **Backend:** Django REST Framework for efficient backend services and API management.
- **Database:** SQLite for lightweight, efficient data storage.
- **Web Scraping:** Selenium for automated web browsing to collect product information.
- **APIs:** Chat GPT API for data analysis and comparison; Bing API for fetching official product specifications.



![MobileTemp2](https://github.com/mukilan1/Factify/assets/74693526/1e6891dc-4879-43f5-a086-cef3ae84e434)

![fyNobg](https://github.com/mukilan1/Factify/assets/74693526/54e16c6b-185e-4c0b-9ee5-57a762c123ad)

## Installation

```sh
# Clone the repository
git clone https://github.com/mukilan1/Factify.git

# Navigate to the project directory

# Installation steps for frontend
flutter pub get

# Start the backend server
python manage.py runserver

# Run the Flutter application
flutter run


