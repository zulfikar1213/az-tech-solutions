from django.urls import path
from apps.api.views import MyBusinessView, ChatView

urlpatterns = [
    path('my-business', MyBusinessView.as_view()),
    path('chat', ChatView.as_view()),
]