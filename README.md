# Art Institute of Chicago

[![Build Status](https://travis-ci.org/aic-collections/aicdams-lakeshore.svg?branch=master)](https://travis-ci.org/aic-collections/aicdams-lakeshore)

## Lakeshore

## Local Testing

To prepare the development environment, ensure that all of Sufia's requirements are met, then:

    git clone https://github.com/aic-collections/aicdams-lakeshore
    cd aicdams-lakeshore
    bundle install
    bundle exec rake db:migrate
    bundle exec rake aic:jetty:prep
    bundle exec rake aic:jetty:solr_config
    bundle exec rake jetty:start
    
To register all the namespaces with Fedora, with Fedora running

    bundle exec rake fedora:config

To run the test suite

    bundle exec rspec spec

## Deployment

### Development Server

A cloned repo is deployed directly to the development server and run in development mode, i.e. not the
usual way Capistrano is used.

    bundle exec cap dev repo:clone
    bundle exec cap dev repo:config

### Test Server

Deployed via Capistrano in the normal fashion:

    bundle exec cap test deploy

### Passenger

Passenger is installed and deployed the same for all environments:

    bundle exec cap dev passenger:install
    bundle exec cap dev passenger:config
