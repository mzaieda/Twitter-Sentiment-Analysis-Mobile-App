from django.http import JsonResponse



def get_analysis(request, query):
    if request.method != 'GET':
        return JsonResponse({
            'error': 'GET request required'
        }, status=405)

    # try:
    #     NUM_OF_TWEETS = 50
    #     client = TwitterClient()
    #     analyzer = TweetsAnalyzer(client.get_tweets(query, NUM_OF_TWEETS))
    # except tweepy.RateLimitError:
    #     return JsonResponse({
    #         'error': 'Twitter API rate limit exceeded.'
    #     }, status=500)
    # except tweepy.TweepError:
    #     return JsonResponse({
    #         'error': 'Error during the authentication with the Twitter API'
    #     }, status=500)
    
    analysis = {'positives': 0.0,
                'neutrals': 1.0,
                'negatives': 0.0,
                'averageLikes': 0.0,
                'averageRetweets': 0.0,}
    return JsonResponse(analysis, status=200)
