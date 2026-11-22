from django.http import JsonResponse
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from .models import Booking, Service

class ServiceListView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        data = list(Service.objects.values())
        return JsonResponse(data, safe=False)

class BookingListView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        services_map = {s.id: s.name for s in Service.objects.all()}
        bookings = list(Booking.objects.values())
        for b in bookings:
            service_id = b.get('service_id')
            service_name = services_map.get(service_id, 'Service')
            b['service_name'] = service_name
            b['service'] = service_name
        return JsonResponse(bookings, safe=False)

class BookingCreateView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        data = request.data
        booking = Booking.objects.create(
            customer_name=data.get('customer_name', ''),
            customer_phone=data.get('customer_phone', ''),
            note=data.get('note', ''),
            status=data.get('status', 'new'),
            service_id=data.get('service_id'),
        )
        return JsonResponse({'id': booking.id, 'status': 'created'}, safe=False)

class BookingStatusUpdateView(APIView):
    permission_classes = [IsAuthenticated]

    def update_status(self, request, booking_id):
        try:
            booking = Booking.objects.get(id=booking_id)
        except Booking.DoesNotExist:
            return JsonResponse({'error': 'not found'}, status=404)
        new_status = request.data.get('status', '')
        if new_status in ['new', 'accepted', 'done']:
            booking.status = new_status
            booking.save()
            return JsonResponse({'id': booking.id, 'status': booking.status}, safe=False)
        return JsonResponse({'error': 'invalid status'}, status=400)

    def patch(self, request, booking_id):
        return self.update_status(request, booking_id)

    def post(self, request, booking_id):
        return self.update_status(request, booking_id)