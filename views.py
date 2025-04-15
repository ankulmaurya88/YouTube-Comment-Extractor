

# Create your views here.


from django.shortcuts import render
from django.views import View

class WebScraping(View):
    def get(self, request):
        return render(request, 'home.html')
    

from django.views import View
from django.shortcuts import render
from .services import YouTubeCommentService

class IndexView(View):
    def get(self, request):
        return render(request, 'page/index.html')

class CommentFetchView(View):
    def post(self, request):
        video_url = request.POST.get('video_url')
        yt_service = YouTubeCommentService(video_url)
        video_id = yt_service.extract_video_id()

        if video_id:
            comments = yt_service.fetch_comments(video_id)
            return render(request, 'page/comments.html', {
                'comments': comments,
                'video_url': video_url
            })

        return render(request, 'page/index.html', {
            'error': 'Invalid YouTube URL.'
        })

    def get(self, request):
        return render(request, 'page/index.html')

