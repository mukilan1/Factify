from django.db import models

class ProductSearch(models.Model):
    name = models.CharField(max_length=100, blank=True, null=True)
    feel = models.CharField(max_length=100, blank=True, null=True)
    NotsimilarData = models.TextField(blank=True, null=True)  # Storing JSON data as a string
    MisleadingData = models.TextField(blank=True, null=True)  # Storing JSON data as a string
    Cost = models.TextField(blank=True, null=True)
    Transparency = models.CharField(max_length=100, blank=True, null=True)
    Rating = models.IntegerField(default=0)
    Suggestion = models.TextField(blank=True, null=True)
    WrongData = models.TextField(blank=True, null=True)  # Storing JSON data as a string
    CurrentDate = models.DateTimeField(auto_now_add=True)
    omitted = models.TextField(blank=True, null=True)
    ecommerce_specs = models.TextField(blank=True, null=True)
    official_specs = models.TextField(blank = True, null = True)

    def __str__(self):
        return self.name
    

class BlogModel(models.Model):
    title = models.CharField(max_length=100, blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    date = models.DateField(auto_now_add=True)

    def __str__(self):
        return self.title