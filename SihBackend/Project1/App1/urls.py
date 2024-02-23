from django.urls import path, include
from .views import ProductSearchViewSet
from rest_framework.routers import DefaultRouter
from .views import ProcessDataView
from .views import ChatBotResponse
from .views import BlogView

router = DefaultRouter()
router.register('productsearch', ProductSearchViewSet)
router.register('blogview', BlogView)

urlpatterns = [
    path('', include(router.urls)),
    path('process/', ProcessDataView.as_view(), name='process'),
    path('chatbot/', ChatBotResponse.as_view(), name='chatbot'),    
]


