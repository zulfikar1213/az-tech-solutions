from django.contrib import admin
from .models import Business, Service, ClientProfile

admin.site.register(Business)
admin.site.register(Service)
admin.site.register(ClientProfile)