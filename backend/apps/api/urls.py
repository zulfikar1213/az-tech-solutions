from django.urls import path
from apps.api.views import MyBusinessView

urlpatterns = [
    path('my-business', MyBusinessView.as_view()),
]