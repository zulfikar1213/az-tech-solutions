from django.urls import path
from apps.api.views import MyBusinessView, ChatView, BookingView

urlpatterns = [
    path('my-business', MyBusinessView.as_view()),
    path('chat', ChatView.as_view()),
    path('booking', BookingView.as_view()),
]