from textblob import TextBlob
import pandas as pd
import numpy as np
import re


class TweetsAnalyzer():
    '''
    Class for analyzing tweets
    '''
    def __init__(self, tweets: list):
        '''
        Creates a dataframe from a list of tweets
        '''
        self.dataframe = pd.DataFrame(data=[tweet.text for tweet in tweets], columns=['tweets'])
        self.dataframe['dates'] = np.array([tweet.created_at for tweet in tweets])
        self.dataframe['likes'] = np.array([tweet.favorite_count for tweet in tweets])
        self.dataframe['retweets'] = np.array([tweet.retweet_count for tweet in tweets])
        self.dataframe['sentiment'] = np.array([self.get_sentiment(tweet) for tweet in self.dataframe['tweets']])
        self.dataframe.drop_duplicates(inplace=True)

    def clean_tweet(self, tweet: str) -> str:
        '''
        Cleans the tweet from unnecessary characters
        '''
        return ' '.join(re.sub('(@[A-Za-z0-9]+)|([^0-9A-Za-z \t])|(\w+:\/\/\S+)', ' ', tweet).split())

    def get_sentiment(self, tweet: str) -> int:
        '''
        Analyzes the tweet and returns:
        1 if it's positive,
        0 if it's neutral,
        -1 if it's negative
        '''
        analysis = TextBlob(self.clean_tweet(tweet))
        if analysis.sentiment.polarity > 0:
            return '1'
        elif analysis.sentiment.polarity == 0:
            return '0'
        else:
            return '-1'

    def get_analysis(self) -> dict:
        '''
        Returns a dictionary with the analysis of the tweets
        '''
        sentiment_count = self.dataframe['sentiment'].value_counts(normalize=True)
        return {
            'positives': sentiment_count.get('1', 0.0),
            'neutrals': sentiment_count.get('0', 0.0),
            'negatives': sentiment_count.get('-1', 0.0),
            'averageLikes': self.dataframe['likes'].mean(),
            'averageRetweets': self.dataframe['retweets'].mean(),
        }