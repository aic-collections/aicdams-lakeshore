#!/bin/bash
URL="fedoraAdmin:fedoraAdmin@localhost:8983"
curl -isS -X PUT "http://${URL}/fedora/rest/config" > /dev/null
curl -sS -X PATCH -H "Content-Type: application/sparql-update" --data-binary "@script/body.rdf" "http://${URL}/fedora/rest/config" > /dev/null
curl -sS -X GET "http://${URL}/fedora/rest/config" | grep "@prefix"
curl -sS -X DELETE "http://${URL}/fedora/rest/config" > /dev/null
curl -sS -X DELETE "http://${URL}/fedora/rest/config/fcr:tombstone" > /dev/null
exit 0;