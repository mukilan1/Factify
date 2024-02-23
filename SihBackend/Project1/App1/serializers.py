from rest_framework import serializers
from .models import ProductSearch, BlogModel

class ProductSearchSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductSearch
        fields = '__all__'

class LinkProcessSerializer(serializers.Serializer):
    link = serializers.CharField(max_length=2000)

class ChatBotSerializer(serializers.Serializer):
    User = serializers.CharField(max_length=2000)

class BlogSerializers(serializers.ModelSerializer):
    class Meta:
        model = BlogModel
        fields = '__all__'