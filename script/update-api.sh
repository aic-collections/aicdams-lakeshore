#!/bin/bash

curl -u citi:password -X POST\
 -F 'metadata[depositor]=awead'\
 -F 'content[intermediate]=@spec/fixtures/tardis2.png'\
 http://localhost:3000/api/update/233b76a6-193d-8deb-7346-593a3857f05e
