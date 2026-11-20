from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from apps.businesses.models import Business
from apps.api.serializers import BusinessSerializer

class MyBusinessView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        business = request.user.client_profile.business
        serializer = BusinessSerializer(business)
        return Response(serializer.data)

# Create your views here.
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from apps.businesses.models import Service

class ChatView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        message = request.data.get('message', '').lower()
        business = request.user.client_profile.business
        services = Service.objects.filter(business=business, is_active=True)
        for service in services:
            if service.name.lower() in message:
                return Response({'reply': f"{service.name} costs ${service.price}"})
        if 'price' in message or 'cost' in message or 'سعر' in message:
            lines = [f"{s.name}: ${s.price}" for s in services]
            return Response({'reply': 'Our prices:\n' + '\n'.join(lines)})
        if 'hello' in message or 'hi' in message or 'مرحبا' in message:
            return Response({'reply': f"Hello! Welcome to {business.name}. Ask me about prices!"})
        return Response({'reply': 'Ask me about a service price, for example: How much are Banners?'})