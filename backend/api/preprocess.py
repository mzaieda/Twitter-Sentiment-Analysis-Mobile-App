import pandas as pd
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
import joblib
import ast
from gensim.models import KeyedVectors

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

def wvContains(word, model):
    return word in model

def word2vec(word_dict, model):
    vector = np.zeros(int(200))
    freq_sum = 0
    for word, freq in word_dict.items():
        if wvContains(word, model):
            vector += model[word] * freq
            freq_sum += freq
        elif word.startswith('not') and wvContains(word[3:], model):
            vector += (model['not'] + model[word[3:]]) * freq
            freq_sum += 2 * freq
        else:
            #remove the last character until a valid word is found or there are only twwo characters left
            while len(word) > 2 and not wvContains(word[:-1], model):
                word = word[:-1]
            if wvContains(word, model):
                vector += model[word] * freq
                freq_sum += freq
    if freq_sum != 0:
        return (1/freq_sum) * vector
    else:
        return np.zeros(int(200))
    


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
    df['words'] = df['clean_words'].apply(word2Dict)
    df.drop(columns=['text', 'clean_text','segmented', 'stemmed', 'words_without_stop', 'clean_words'], inplace=True)

    # days_one_encoded = pd.get_dummies(df['day'])
    # print(days_one_encoded['Mon'])
    # hour_one_encoded = pd.get_dummies(df['hour'])
    # clean_df = df.join(days_one_encoded).join(hour_one_encoded)
    # clean_df.drop(columns=['day','hour'], inplace=True)
    columns = ['Fri', 'Mon', 'Sat', 'Sun', 'Thu', 'Tue', 'Wed', '00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23']

    # Create the DataFrame with one row and zeros
    data = {
            'Fri': [0], 'Mon': [0], 'Sat': [0], 'Sun': [0], 'Thu': [0], 'Tue': [0], 'Wed': [0],
            '00': [0], '01': [0], '02': [0], '03': [0], '04': [0], '05': [0], '06': [0], '07': [0],
            '08': [0], '09': [0], '10': [0], '11': [0], '12': [0], '13': [0], '14': [0], '15': [0],
            '16': [0], '17': [0], '18': [0], '19': [0], '20': [0], '21': [0], '22': [0], '23': [0]}

    clean_df = pd.DataFrame(data, columns=columns)
    clean_df[df['day']]=1
    clean_df[df['hour']]=1
    clean_df = df.join(clean_df)
    clean_df.drop(columns=['day','hour','month','year','min','sec','date'], inplace=True)
    print(clean_df)
    predpos = 0.8
    predneg = 0.2

    ##############
    # for col in clean_df.columns:
    #     if col!='words':
    #         clean_df[col] = clean_df[col].astype(np.int8)
    
    # clean_df['words'] = clean_df['words'].apply(lambda x: ast.literal_eval(x))
    

    model = KeyedVectors.load_word2vec_format(model_path, binary=False)
   
    df_c = clean_df.copy()
    df_c['vecWords'] = df_c['words'].apply(lambda x: word2vec(x, model))

    col = []
    for i in range(int(200)):
        col.append('v(' + str(i) + ')')

    temp = []
    for i in range(len(df_c)):
        temp.append(df_c['vecWords'][i])

    df_t = pd.DataFrame(temp, columns=col)

    df_c = df_c.join(df_t)
    df_c.drop(columns = ['words', 'vecWords'], inplace = True)

    X = df_c.iloc[:,1:]


    final_model = joblib.load("/Users/zaieda/Desktop/Twitter-Sentiment-Analysis-Mobile-App/backend/api/model.joblib")
    y_pred= final_model.predict(X)
    print(y_pred)
    return {'positives': predpos,
            'negatives': predneg,}