# Twitter-Sentiment-Analysis-Mobile-App
A sentiment analysis mobile app built with Flutter (front-end) and Django (back-end).

It allows you to search for a phrase and shows you the sentiment of the tweets that match the given query.

## Demo
<img src="assets/TwitterSentimentAnalysisDemo.gif" alt="App demo" height="400"/>

## Setup
Here's how you can configure the [back-end](backend/README.md) and the [front-end](mobile/README.md).

**Note**: The app has been tested on an Android Studio emulator and Android smartphone, if you want to run it on iOS you may need to make some changes.

### Android Emulator
Move into the `backend/` directory with your terminal and type the following command:

```
python manage.py runserver
```

Start the Android Studio emulator and then move into the `mobile/` folder with your terminal and type:

```
flutter run
```

After the process is done, the app should automatically open on the emulator.

### Android Smartphone
Move into the `mobile/` directory and run the following command:

```
flutter build apk
```

This command will start the building process of the apk. Once it has finished, you'll have your apk inside `mobile/build/app/outputs/apk/release` in a file called `app-release.apk`.
Now you can just download this file on your smartphone and install the app.
When you want to use it make sure to have your server running with:

```
python manage.py runserver 0.0.0.0:8000
```

## Disclaimer
This app does **not** give a comprehensive view about the sentiment of the Twitter users, in fact it just analyses a very small portion of tweets.

The app has meant to be for educational purposes only, you can clone/fork/change it as you wish and practise with it.

**Do not** use it if you need accurate analysis of the sentiment.