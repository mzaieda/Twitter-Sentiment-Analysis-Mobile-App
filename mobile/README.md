## Setup
Make sure you have Flutter installed on your system. To make sure everything is set up you can run:

```
flutter doctor
```

This command will check that everything is ok and you're ready to use Flutter.

Move into the `mobile/` directory and get all the dependencies needed with:

```
flutter pub get
```

Create a file called `.env`, inside it write the following line:

```
API_URL=http://<URL>:8000/api/
```

Where the *URL* you need to insert is `10.0.2.2` if you are running the application inside the Android Studio Emulator. Otherwise if you want to build the apk for your smartphone put it there your *local IP address*.