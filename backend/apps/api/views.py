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
