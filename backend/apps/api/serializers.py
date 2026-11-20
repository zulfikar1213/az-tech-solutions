from rest_framework import serializers
from apps.businesses.models import Business, Service

class ServiceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Service
        fields = ['id', 'name', 'price', 'description', 'is_active']

class BusinessSerializer(serializers.ModelSerializer):
    services = ServiceSerializer(many=True, read_only=True)

    class Meta:
        model = Business
        fields = ['id', 'name', 'sector', 'city', 'phone', 'services']