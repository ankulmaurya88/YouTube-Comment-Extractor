from django.urls import path
from .views import WebScraping




from django.urls import path
from .views import IndexView, CommentFetchView

urlpatterns = [
    
    path('', IndexView.as_view(), name='index'),
    path('comments/', CommentFetchView.as_view(), name='get_video_comments'),
]
