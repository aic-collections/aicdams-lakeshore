# Art Institute of Chicago

[![Build Status](https://travis-ci.org/aic-collections/aicdams-lakeshore.svg?branch=master)](https://travis-ci.org/aic-collections/aicdams-lakeshore)

## Lakeshore

## Local Testing

    git clone https://github.com/aic-collections/aicdams-lakeshore
    cd aicdams-lakeshore
    bundle install
    bundle exec rake db:migrate
    bundle exec rake jetty:config
    bundle exec rspec
