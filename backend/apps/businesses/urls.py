from django.urls import path
from .views import ServiceListView, BookingListView, BookingCreateView, BookingStatusUpdateView

urlpatterns = [
    path('api/services', ServiceListView.as_view()),
    path('api/bookings', BookingListView.as_view()),
    path('api/booking', BookingCreateView.as_view()),
    path('api/bookings/<int:booking_id>/status', BookingStatusUpdateView.as_view()),
]