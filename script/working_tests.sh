#!/bin/bash
# Run working tests for the Sufia 7 update
bundle exec rspec\
  spec/models\
  spec/controllers\
  spec/jobs\
  spec/forms\
  spec/lib
