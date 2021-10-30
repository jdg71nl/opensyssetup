#!/usr/bin/env ruby
require 'json'
in_json = ""
while STDIN.gets
  in_json = in_json + $_
end
in_hash = JSON.parse(in_json)
puts JSON.pretty_generate(in_hash)
#
