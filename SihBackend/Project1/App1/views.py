from rest_framework import viewsets
from .models import ProductSearch, BlogModel
from .serializers import ProductSearchSerializer, BlogSerializers
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import status
from . import FinalData
from django.utils import timezone
from django.http import JsonResponse
from . import ChatBot
import json

class ProductSearchViewSet(viewsets.ModelViewSet):
    queryset = ProductSearch.objects.all()
    serializer_class = ProductSearchSerializer

class BlogView(viewsets.ModelViewSet):
    queryset = BlogModel.objects.all()
    serializer_class = BlogSerializers

class ProcessDataView(APIView):
    def post(self, request, format=None):
        # Extract "link" from the incoming data
        link = request.data.get("link", "")

        if not link:
            return Response({"error": "Link not provided"}, status=status.HTTP_400_BAD_REQUEST)

        # Process the link with your custom function
        processed_data = FinalData.CompareData(link)

        # Check if all fields are '_error_'
        if all(value == '_error_' for value in processed_data.values()):
            return Response({"error": "Error processing data"}, status=status.HTTP_400_BAD_REQUEST)

        # Create a new ProductSearch instance with the processed data
        product_search = ProductSearch(
            name=processed_data.get('name', ''),  # Add the 'name' field
            feel=processed_data.get('feel', ''),
            NotsimilarData=processed_data.get('NotsimilarData', ''),
            MisleadingData=processed_data.get('MisleadingData', ''),
            Cost=processed_data.get('Cost', ''),
            Transparency=processed_data.get('Transparency', ''),
            Rating=processed_data.get('Rating', 0),
            Suggestion=processed_data.get('Suggestion', ''),
            WrongData=processed_data.get('WrongData', ''),
            CurrentDate=timezone.now(),
            omitted = processed_data.get('omitted', ''),
            ecommerce_specs = processed_data.get('ecommerce_specs', ''),
            official_specs = processed_data.get('official_specs', ''),

)


        # Save the new instance to the database
        product_search.save()

        # Return the response
        return Response(processed_data, status=status.HTTP_200_OK)
    

class ChatBotResponse(APIView):
    def post(self, request, format=None):
        # Extract "User" from the incoming data
        User = request.data.get("User", "")

        if not User:
            return Response({"error": "Chat not provided"}, status=status.HTTP_400_BAD_REQUEST)

        # Process the user input with your custom ChatBot function
        processed_data = ChatBot.ChatBot(User)

        # Ensure processed_data is a string
        if not isinstance(processed_data, str):
            processed_data = str(processed_data)

        # Directly return the response as a JSON object
        response_data = {"User": processed_data}
        
        return Response(response_data, status=status.HTTP_200_OK)
    

