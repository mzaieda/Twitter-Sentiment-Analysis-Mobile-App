import tweepy
from decouple import config


class TwitterClient():
    '''
    Twitter Client class
    '''
    # Twitter API's keys and tokens
    API_KEY = config('API_KEY')
    API_SECRET_KEY = config('API_SECRET_KEY')
    ACCESS_TOKEN = config('ACCESS_TOKEN')
    ACCESS_TOKEN_SECRET = config('ACCESS_TOKEN_SECRET')

    def __init__(self):
        self.auth = tweepy.OAuthHandler(self.API_KEY, self.API_SECRET_KEY)
        self.auth.set_access_token(self.ACCESS_TOKEN, self.ACCESS_TOKEN_SECRET)
        self.api = tweepy.API(self.auth)

    def get_tweets(self, query: str, num: int) -> list:
        '''
        Returns a list of tweets matching the given query
        '''
        return list(tweepy.Cursor(self.api.search, q=query, lang='en').items(num))