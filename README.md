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

    bundle exec rake rspec

