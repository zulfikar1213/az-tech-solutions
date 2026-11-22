from django.contrib import admin
from .models import Business, Service, ClientProfile, Booking

@admin.register(Business)
class BusinessAdmin(admin.ModelAdmin):
    list_display = ("name", "sector", "city", "phone")

@admin.register(Service)
class ServiceAdmin(admin.ModelAdmin):
    list_display = ("business", "name", "price", "is_active")
    list_filter = ("business", "is_active")

@admin.register(ClientProfile)
class ClientProfileAdmin(admin.ModelAdmin):
    list_display = ("user", "business")

@admin.register(Booking)
class BookingAdmin(admin.ModelAdmin):
    list_display = ("customer_name", "customer_phone", "service", "status", "created_at")
    list_filter = ("service", "status")