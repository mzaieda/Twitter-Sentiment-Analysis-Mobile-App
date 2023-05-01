from django.http import JsonResponse
import joblib


def get_analysis(request, query):
    if request.method != 'GET':
        return JsonResponse({
            'error': 'GET request required'
        }, status=405)
    
    analysis = {'positives': 0.0,
                'neutrals': 0.5,
                'negatives': 0.3,
                'averageLikes': 0.0,
                'averageRetweets': 0.0,}
    return JsonResponse(analysis, status=200)
