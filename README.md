Getting Started
===============

Clone this repo:

    git clone git@github.com:iron-io/heroku_sinatra_example.git
    
Now cd into the directory:

    cd heroku_sinatra_example
    
Install required gems:

    sudo bundle install

Now create a heroku app for it (this assumes you're already [logged into heroku](http://devcenter.heroku.com/articles/quickstart)):

    heroku create --stack cedar
    
Ok, now we're ready to run on Heroku, but first we need to add the Iron.io Add-ons:

    heroku addons:add iron_worker:starter
    heroku addons:add iron_mq:rust

Grab your IronWorker project id and token from:

    heroku config

And put them in a file in this directory called `iron.json` in this format:

```javascript
{
  "project_id": "PROJECT_ID",
  "token": "TOKEN"
}
```

Upload the worker:

    iron_worker upload workers/TweetWorker


Now, open and fill configuration file named `config.json`:

```javascript
{
  // This section is optional, environment variables have higher priority
  "iron": {
    "project_id": "PROJECT_ID",
    "token": "TOKEN"
  },
  // Twitter API requires authorization since v1.1
  "twitter": {
    "consumer_key": "YOUR_CONSUMER_KEY",
    "consumer_secret": "YOUR_CONSUMER_SECRET",
    "oauth_token": "YOUR_OAUTH_TOKEN",
    "oauth_token_secret": "YOUR_OAUTH_TOKEN_SECRET"
  }
}
```

Then just push to heroku! 

    git push heroku master
    
Live Demo
=========

Here's a live running example of this app: http://evening-planet-3202.herokuapp.com/

Development
===========

To run in development, you need a token and project_id from your Iron.io account. Login at http://www.iron.io
to get it.

Then start this sinatra app using this command, replacing my_token and my_project_id with your credentials:

    IRON_IO_TOKEN=my_token IRON_IO_PROJECT_ID=my_project_id rackup -p 3000 config.ru


