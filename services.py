import re
from googleapiclient.discovery import build

class YouTubeCommentService:
    API_KEY = "AIzaSyDAQeAT-Xf7uynBhbVDH-ysXEufofCNJss"  # 🔐 Store this in env later

    def __init__(self, video_url):
        self.video_url = video_url

    def extract_video_id(self):
        match = re.search(r"(?:v=|/)([0-9A-Za-z_-]{11})", self.video_url)
        return match.group(1) if match else None

    def fetch_comments(self, video_id):
        youtube = build('youtube', 'v3', developerKey=self.API_KEY)

        comments = []
        next_page_token = None

        while True:
            response = youtube.commentThreads().list(
                part="snippet",
                videoId=video_id,
                textFormat="plainText",
                maxResults=100,
                pageToken=next_page_token
            ).execute()

            for item in response['items']:
                comment = item['snippet']['topLevelComment']['snippet']['textDisplay']
                comments.append(comment)

            next_page_token = response.get("nextPageToken")
            if not next_page_token:
                break

        return comments
