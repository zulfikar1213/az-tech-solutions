from django.contrib import admin
from django.urls import path, include
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from apps.businesses.views import ServiceListView, BookingListView, BookingStatusUpdateView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('apps.api.urls')),
    path('api/token/', TokenObtainPairView.as_view()),
    path('api/token/refresh/', TokenRefreshView.as_view()),
    path('api/services', ServiceListView.as_view()),
    path('api/bookings', BookingListView.as_view()),
    path('api/bookings/<int:booking_id>/status', BookingStatusUpdateView.as_view()),
]