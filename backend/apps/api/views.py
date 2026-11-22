from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from apps.businesses.models import Business, Service, Booking
from apps.api.serializers import BusinessSerializer

class MyBusinessView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        business = request.user.client_profile.business
        serializer = BusinessSerializer(business)
        return Response(serializer.data)

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

class BookingView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        business = request.user.client_profile.business
        service_id = request.data.get('service_id')
        customer_name = request.data.get('customer_name', '')
        customer_phone = request.data.get('customer_phone', '')
        note = request.data.get('note', '')

        try:
            service = Service.objects.get(id=service_id, business=business)
        except Service.DoesNotExist:
            return Response({'error': 'Service not found'}, status=404)

        booking = Booking.objects.create(
            business=business,
            service=service,
            customer_name=customer_name,
            customer_phone=customer_phone,
            note=note,
        )

        return Response({
            'id': booking.id,
            'customer_name': booking.customer_name,
            'service': booking.service.name,
            'message': 'Booking created!',
        }, status=201)