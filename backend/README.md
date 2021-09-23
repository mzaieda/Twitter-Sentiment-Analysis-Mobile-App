## Setup
**NOTE**: The following setup process shows how to configure the server for a local network, if you want to host it elsewhere it won't be sufficient and you need to make changes accordingly.

First of all you need a [*Twitter Developer Account*](https://developer.twitter.com/en/docs/twitter-api/getting-started/getting-access-to-the-twitter-api). After finishing the registration process, you will have to create a project and an app inside the Developer Platform.

Once your request has been approved you'll have access to the *API Key*, *API Key Secret*, *Bearer Token*, *Access Token*, *Access Token Secret*. You need to save these credentials.

Make sure you have Python installed on your system and consider using a virtual environment for the project.

Move into the `backend/` directory, from now on I will consider that you are located inside this folder.

With your terminal download all the modules needed with the command:

```
pip install -r requirements.txt
```

Generate a *Django Secret Key* with this line:

```
python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
```

Create a `.env` file and write inside it the following line:

```
API_KEY=<YOUR API KEY>
API_SECRET_KEY=<YOUR API SECRET KEY>
BEARER_TOKEN=<YOUR BEARER TOKEN>
ACCESS_TOKEN=<YOUR ACCESS TOKEN>
ACCESS_TOKEN_SECRET=<YOUR ACCESS TOKEN SECRET>
DJANGO_SECRET_KEY=<YOUR DJANGO SECRET KEY>
```

## Run
To run your server it is sufficient to use the following command if you just need it for your local machine (e.g. if you want to use it for your Android Emulator):

```
python manage.py runserver
```

Or if you want to use it on your local network (e.g. for your smartphone):

```
python manage.py runserver 0.0.0.0:8000
```

In this case, be sure that your firewall doesn't block any incoming package.