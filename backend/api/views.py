from django.http import JsonResponse
import joblib


def get_analysis(request, query):
    if request.method != 'GET':
        return JsonResponse({
            'error': 'GET request required'
        }, status=405)
    
    analysis = {'positives': 0.7,
                'negatives': 0.3,}
    return JsonResponse(analysis, status=200)
