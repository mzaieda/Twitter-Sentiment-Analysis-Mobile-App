import datetime
import pandas as pd
import pytz
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import nltk
import re
import contractions
import unidecode
from nltk.corpus import wordnet
from nltk.stem import WordNetLemmatizer
from string import ascii_lowercase
from nltk.probability import FreqDist

# Function to expand contractions in each text
def expand_contractions(text):
    contractions.add('isnt', 'is not')
    contractions.add('arent', 'are not')
    contractions.add('doesnt', 'does not')
    contractions.add('dont', 'do not')
    contractions.add('didnt', 'did not')
    contractions.add('cant', 'can not')
    contractions.add('couldnt', 'could not')
    contractions.add('hadnt', 'had not')
    contractions.add('hasnt', 'has not')
    contractions.add('havenot', 'have not')
    contractions.add('shouldnt', 'should not')
    contractions.add('wasnt', 'was not')
    contractions.add('werent', 'were not')
    contractions.add('wont', 'will not')
    contractions.add('wouldnt', 'would not')
    contractions.add('cannot', 'can not')
    contractions.add('can\'t', 'can not')
    contractions.add( "can't've", "can not have")
    return contractions.fix(text)

def clean_text(text):
    text = re.sub(' +', ' ', text) # substitute any number of space with one space only
    text = unidecode.unidecode(text) # transliterates any unicode string into the closest possible representation in ascii text.
    text = text.strip().lower() # remove spaces from begining and end and lower the text
    text = re.sub(r'@[A-Za-z0-9]+', '', text) # Remove mentions
    text = re.sub(r'https?:\/\/\S+', '', text) # Remove hyperlinks
    text = re.sub(r'www.[^ ]+', '', text)
    text = re.sub('[\t\n]', ' ', text) # remove newlines and tabs
    text = re.sub(r'#', '', text) # Remove hashtags
    text = re.sub(r'[^A-Za-z0-9\s]', '', text) # Remove special characters
    text = text.lower() # Convert to lowercase
    return text

def get_wordnet_position(word): 
    tag = nltk.pos_tag([word])[0][1][0].upper()
    tag_dict = {"J": wordnet.ADJ,
                "N": wordnet.NOUN,
                "V": wordnet.VERB,
                "R": wordnet.ADV}

    return tag_dict.get(tag, wordnet.NOUN)

def get_wordnet_pos(word): 
    tag = nltk.pos_tag([word])[0][1][0].upper()
    tag_dict = {"J": wordnet.ADJ,
                "N": wordnet.NOUN,
                "V": wordnet.VERB,
                "R": wordnet.ADV}

    return tag_dict.get(tag, wordnet.NOUN)

def stemmerHelper(words):
    stemmer = WordNetLemmatizer()
    l = []
    for w in words:
        l.append(stemmer.lemmatize(w , get_wordnet_position(w)))
    return l

def lemmatizerHelper(words):
    lemmatizer = WordNetLemmatizer()
    l = []
    for w in words:
        l.append(lemmatizer.lemmatize(w , get_wordnet_pos(w)))
    return l

def word2Dict(words):
    freq= dict()
    for word in words:
        if word in freq:
            freq[word] +=1
        else:
            freq[word] = 1
    return freq

def preprocess(tweet, df):
    df['text'] = tweet
    df['text'] = df['text'].apply(expand_contractions)
    df['clean_text'] = df['text'].apply(lambda x: clean_text(x))
    df['segmented'] = df['clean_text'].apply(lambda x: x.split()) 

    nltk.download('averaged_perceptron_tagger')
    nltk.download('wordnet') 
    nltk.download('omw-1.4')
    nltk.download('stopwords')

    df['stemmed'] = df['segmented'].apply(lemmatizerHelper)

    stop_words = set(nltk.corpus.stopwords.words('english'))
    excluded_words = set(("not", "no"))
    stop_words_ = stop_words.difference(excluded_words)

    for c in ascii_lowercase:
        stop_words_.add(c)

    df['words_without_stop'] = df['stemmed'].apply(lambda words: [word for word in words if word not in stop_words_])

    df['clean_words'] = df['words_without_stop'].apply(lambda x: np.nan if len(x) == 0 else x)
    print(df['clean_words'])
    df['words'] = df['clean_words'].apply(word2Dict)
    df.drop(columns=['text', 'clean_text','segmented', 'stemmed', 'words_without_stop', 'clean_words'], inplace=True)

    days_one_encoded = pd.get_dummies(df['day'])
    hour_one_encoded = pd.get_dummies(df['hour'])
    clean_df = df.join(days_one_encoded).join(hour_one_encoded)
    clean_df.drop(columns=['day','hour'], inplace=True)

    return {'positives': 0.0,
                'neutrals': 1.0,
                'negatives': 0.0,
                'averageLikes': 0.0,
                'averageRetweets': 0.0,}