#!/usr/bin/env ruby
# NOTE: can also use 'jq', sudo apt install jq
require 'json'
in_json = ""
while STDIN.gets
  in_json = in_json + $_
end
in_hash = JSON.parse(in_json)
puts JSON.pretty_generate(in_hash)
#
