#!/usr/bin/env ruby
# = geocode-bureaus.rb

# bureaus.parsed.json
#
# {
#   "level": 1,
#   "naam": "Stembureaus in Amersfoort 2021",
#   "lijst": [
#   {
#     "level": 2,
#     "naam": "Besloten stembureaus",
#     "lijst": [
#       {
#         "level": 3,
#         "naam": "",
#         "lijst": [
#           {
#             "level": 4,
#             "naam": "St Pieters en Bloklands Gasthuis, locatie Davidshof",
#             "adres": "Achter Davidshof 1, 3811 BD Amersfoort",
#             "locatie": "",
#             "openingstijd": "08:00 tot 10:30",
#             "aantal_bureaus": 1,
#             "toegankelijk_mindervaliden": true
#           },
# . . .

# curl-cat "https://maps.googleapis.com/maps/api/geocode/json?address=Achter+Davidshof+1,+3811+BD+Amersfoort&key=MY_KEY"

# Achter+Davidshof+1,+3811+BD+Amersfoort.json
#
# {
#   "results" : [
#      {
#         "address_components" : [
#            {
#               "long_name" : "1",
#               "short_name" : "1",
#               "types" : [ "street_number" ]
#            },
#            {
#               "long_name" : "Achter Davidshof",
#               "short_name" : "Achter Davidshof",
#               "types" : [ "route" ]
#            },
#            {
#               "long_name" : "Stadskern",
#               "short_name" : "Stadskern",
#               "types" : [ "political", "sublocality", "sublocality_level_1" ]
#            },
#            {
#               "long_name" : "Amersfoort",
#               "short_name" : "Amersfoort",
#               "types" : [ "locality", "political" ]
#            },
#            {
#               "long_name" : "Amersfoort",
#               "short_name" : "Amersfoort",
#               "types" : [ "administrative_area_level_2", "political" ]
#            },
#            {
#               "long_name" : "Utrecht",
#               "short_name" : "UT",
#               "types" : [ "administrative_area_level_1", "political" ]
#            },
#            {
#               "long_name" : "Netherlands",
#               "short_name" : "NL",
#               "types" : [ "country", "political" ]
#            },
#            {
#               "long_name" : "3811 BD",
#               "short_name" : "3811 BD",
#               "types" : [ "postal_code" ]
#            }
#         ],
#         "formatted_address" : "Achter Davidshof 1, 3811 BD Amersfoort, Netherlands",
#         "geometry" : {
#            "location" : {
#               "lat" : 52.1576799,
#               "lng" : 5.3847631
#            },
#            "location_type" : "ROOFTOP",
#            "viewport" : {
#               "northeast" : {
#                  "lat" : 52.1590288802915,
#                  "lng" : 5.386112080291502
#               },
#               "southwest" : {
#                  "lat" : 52.1563309197085,
#                  "lng" : 5.383414119708497
#               }
#            }
#         },
#         "place_id" : "ChIJ5-TfmKFGxkcRwHq_hmNEwtg",
#         "plus_code" : {
#            "compound_code" : "595M+3W Amersfoort, Netherlands",
#            "global_code" : "9F47595M+3W"
#         },
#         "types" : [ "street_address" ]
#      }
#   ],
#   "status" : "OK"
# }

require 'json'

key_file = "google_api_key_jdg_1.json"
key_json = File.read(key_file)
key_hash = JSON.parse(key_json)
key_api = key_hash["key"]
# puts "key_api=\"#{key_api}\""

bureaus_file = "bureaus.parsed.json"
bureaus_json = File.read(bureaus_file)
bureaus_hash = JSON.parse(bureaus_json)

# https://stackoverflow.com/questions/21465994/curl-command-equivalent-in-ruby
# https://github.com/taf2/curb
# Curb - Libcurl bindings for Ruby Build Status
# Curb (probably CUrl-RuBy or something) provides Ruby-language bindings for the libcurl(3), a fully-featured client-side URL transfer library. cURL and libcurl live at http://curl.haxx.se/ .
# Curb is a work-in-progress, and currently only supports libcurl's easy and multi modes.
# https://curl.se/
# apt install libcurl4 libcurl4-openssl-dev
# gem install curb

require 'curb'

def geocode_google (url)
  response_curb = Curl::Easy.perform(url)
  response_json = response_curb.body_str
  response_hash = JSON.parse(response_json)
  response_lat = response_hash.dig( "results", 0, "geometry", "location", "lat")
  response_lng = response_hash.dig( "results", 0, "geometry", "location", "lng")
  geoloc_string = "#{response_lat}, #{response_lng}"
  geoloc_string
end

# response_curb = Curl::Easy.perform("https://maps.googleapis.com/maps/api/geocode/json?address=Achter+Davidshof+1,+3811+BD+Amersfoort&key=#{bureaus_api}")
# response_json = response_curb.body_str
# response_hash = JSON.parse(response_json)
# response_lat = response_hash.dig( "results", 0, "geometry", "location", "lat")
# response_lng = response_hash.dig( "results", 0, "geometry", "location", "lng")
# puts "lat, lng = #{response_lat}, #{response_lng}"
# > ./geocode-bureaus.rb 
# lat, lng = 52.1576799, 5.3847631

# cannot write back ..
# bureaus_hash.dig( "lijst" ).each { |level1_item|
#   level1_item.dig( "lijst" ).each { |level2_item| 
#     level2_item.dig( "lijst" ).each { |level3_item| 
#     }
#   }
# }

level1_lijst = bureaus_hash["lijst"]
for level1_index in (0...level1_lijst.length)
  level1_item = level1_lijst[level1_index]
  level1_naam = level1_item["naam"]
  #
  level2_lijst = level1_lijst[level1_index]["lijst"]
  for level2_index in (0...level2_lijst.length)
    level2_item = level2_lijst[level2_index]
    level2_naam = level2_item["naam"]
    #
    level3_lijst = level2_lijst[level2_index]["lijst"]
    for level3_index in (0...level3_lijst.length)
      level3_item = level3_lijst[level3_index]
      #
      adres = level3_item["adres"]
      # puts "#{level1_naam} , #{level2_naam}, #{adres} "
      #
      adres_formatted = CGI.escape(adres)
      # puts "adres = #{adres_formatted} "
      url_string = "https://maps.googleapis.com/maps/api/geocode/json?address=#{adres_formatted}&key=#{key_api}"
      geoloc_string = geocode_google(url_string)
      # puts "#{adres_formatted} => #{geoloc_string} "
      #
      # level3_item["locatie"] = geoloc_string
      bureaus_hash["lijst"][level1_index]["lijst"][level2_index]["lijst"][level3_index]["locatie"] = geoloc_string
      #
      # break
      sleep(0.1) # half a second
      #
    end
  end
end

# bureaus_geocoded_json = JSON.generate(bureaus_hash)
bureaus_geocoded_json = JSON.pretty_generate(bureaus_hash)
bureaus_geocoded_file = "bureaus.geocoded.json"
File.write(bureaus_geocoded_file, bureaus_geocoded_json)

# adres_formatted = "Achter+Davidshof+1,+3811+BD+Amersfoort"
# url_string = "https://maps.googleapis.com/maps/api/geocode/json?address=#{adres_formatted}&key=#{key_api}"
# geoloc_string = geocode_google(url_string)
# puts "#{adres_formatted} => #{geoloc_string}"

#