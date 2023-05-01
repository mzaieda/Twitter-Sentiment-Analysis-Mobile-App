from django.http import JsonResponse
import pytz
import datetime
from api.preprocess import *

def get_datetime():
    # get the current datetime in UTC
    now_utc = datetime.datetime.utcnow()

    # create a timezone object for Pacific Time (PT)
    pt = pytz.timezone('US/Pacific')

    # convert the datetime to Pacific Time
    now_pt = now_utc.replace(tzinfo=pytz.utc).astimezone(pt)

    # format the datetime string
    now_str = now_pt.strftime('%a %b %d %H:%M:%S %Z %Y')

    df = pd.DataFrame(columns=['date'])
    df['date'] = [now_str]

    # splitting date into day, month, hour and year and adding them as features
    df['day'] = df['date'].apply(lambda x: x[0:3])
    df['month'] = df['date'].apply(lambda x: x[4:7])
    df['hour'] = df['date'].apply(lambda x: x[11:13])
    df['year'] = df['date'].apply(lambda x: x[24:])
    df['min'] = df['date'].apply(lambda x: x[14:16])
    df['sec'] = df['date'].apply(lambda x: x[17:19])

    return df

def get_analysis(request, query):
    if request.method != 'GET':
        return JsonResponse({
            'error': 'GET request required'
        }, status=405)
    
    df = get_datetime()
    analysis = preprocess(query, df)

    
    return JsonResponse(analysis, status=200)
