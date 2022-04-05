#!/usr/bin/python
# NOTE: can also use 'jq', sudo apt install jq

# alternative to:
# echo "{ \"var\": \"value\" }" | python -mjson.tool

import sys
buffer = ""
while True:
	line = sys.stdin.readline().rstrip('\n')
	if not line:
		break
	else:
		buffer += line
#print buffer

import json
json_input = buffer
json_parsed = json.loads(json_input)
json_format = json.dumps(json_parsed, indent=2)
print json_format


