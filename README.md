Getting Started
===============

First you need a token and project_id from your Iron.io account. Login at http://www.iron.io
to get it.

To run in development, run:

    IRON_WORKER_TOKEN=my_token IRON_WORKER_PROJECT_ID=my_project_id rackup -p 3000 config.ru

To run on heroku:

    heroku addons:add iron_worker
    heroku addons:add iron_mq

Then just push to heroku! 

    git push heroku master
    
Live Demo
=========

Here's a live running example of this app: http://evening-planet-3202.herokuapp.com/
