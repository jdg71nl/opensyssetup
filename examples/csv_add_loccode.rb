#!/usr/bin/env ruby
#= csv_add_loccode.rb
#= before: gve_addresses_create_loccode.rb

# - - -
# - huidige lijst importfiles, with append: -DDMMYY :
# 1. AVL = Active-VLANs
# 2. LAY = Layer2-Data (NTU-port, POP-port)
# 3. DOM = DOM Fiber Power of SW[pop].PT[acc]
# 4. ADR = Adressenlijst

# d210113-EFX-Luc--gve_l2_data.csv   --   new is:   "cpe_brand";"cpe_type"
# = LAY-130121
# "provider";"vlan_number";"speed";"qos";"street";"house_number";"appendix";"room";"stack";"switch";"port";"cpe_brand";"cpe_type";"cpe_name";"cpe_mgmt_ip";"ntu_port"
# "Signet";"2153";"20,00";"0";"Esp";"112";"";"";"SW-AQ-ESP-AP2-01";"1";"1";"D-link";"DGS-3000-10TC";"CPE-AQ-GVE-07";"10.48.32.7";"1"
# "Pocos";"831";"50,00";"2";"Esp";"112";"";"";"SW-AQ-ESP-AP2-01";"1";"1";"D-link";"DGS-3000-10TC";"CPE-AQ-GVE-07";"10.48.32.7";"4"
# "Signet";"2198";"50,00";"0";"Esp";"112";"";"";"SW-AQ-ESP-AP2-01";"1";"1";"D-link";"DGS-3000-10TC";"CPE-AQ-GVE-07";"10.48.32.7";"3"

# d210201-EFX-Teun--active_gve_vlans_01-02-2021.csv
# = AVL-010221
# SP,StartDate,Location,Company,Street,Zipcode,Housenumber,Extension,SPReference,Speed,VlanID,QoS,SLA
# A2B,23-09-2016,GVE-5652AM-7-C,Stickercompany - Dillenburgstraat,Dillenburgstraat,5652AM,7,C,A2B-21-9-2016,20,2000,2,NBD
# ACA,26-11-2015,GVE-5652AJ-4,Kusters Holding BV,Hurksestraat,5652AJ,4,,ACA-26-11-2015 VLAN ACA - Kusters - Kusters,100,2,2,BE
# ACA,26-11-2015,GVE-5651GK-31,Kusters Holding BV,Mispelhoefstraat,5651GK,31,,ACA-26-11-2015 VLAN ACA - Kusters - Kusters,100,2,2,BE

# gve_addresses.csv
# = ADR-210421
# "street";"house_number";"appendix";"room";"city";"zip"
# "Limburglaan";"51";"";"";"Eindhoven";"5616HR"
# "Hooge Zijde";"7";\N;\N;"Eindhoven";"5626DC"
# "Hoppenkuil";"27";"";"";"Eindhoven";"5626DD"
# "Hoppenkuil";"27";"A";"";"Eindhoven";"5626DD"

# - - -
# from: geocode-bureaus.rb
#
# curl-cat "https://maps.googleapis.com/maps/api/geocode/json?address=Achter+Davidshof+1,+3811+BD+Amersfoort&key=MY_KEY"
#
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
#
# https://maps.googleapis.com/maps/api/geocode/json?address=Het+Labyrinth+21,+Amersfoort&key=MY_KEY
# {
#   "results" : [
#      {
#         "address_components" : [
#           ...
#            {
#               "long_name" : "3823 DS",
#               "short_name" : "3823 DS",
#               "types" : [ "postal_code" ]
#            }
#         ],
#         "formatted_address" : "Het Labyrinth 21, 3823 DS Amersfoort, Netherlands",
#         ...
#         "plus_code" : {
#            "compound_code" : "59PR+X3 Amersfoort, Netherlands",
#            "global_code" : "9F4759PR+X3"
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
#
zipcache_file = "zip_cache.json"
zipcache_hash = {}
if File.exists?(zipcache_file)
  zipcache_json = File.read(zipcache_file)
  zipcache_hash = JSON.parse(zipcache_json)
end
#
# https://stackoverflow.com/questions/21465994/curl-command-equivalent-in-ruby
# https://github.com/taf2/curb
# Curb - Libcurl bindings for Ruby Build Status
# Curb (probably CUrl-RuBy or something) provides Ruby-language bindings for the libcurl(3), a fully-featured client-side URL transfer library. cURL and libcurl live at http://curl.haxx.se/ .
# Curb is a work-in-progress, and currently only supports libcurl's easy and multi modes.
# https://curl.se/
# apt install libcurl4 libcurl4-openssl-dev
# gem install curb
# on Mac: sudo gem install curb
#
require 'curb'
def geocode_google (url)
  response_curb = Curl::Easy.perform(url)
  response_json = response_curb.body_str
  response_hash = JSON.parse(response_json)
  # response_lat = response_hash.dig( "results", 0, "geometry", "location", "lat")
  # response_lng = response_hash.dig( "results", 0, "geometry", "location", "lng")
  address_components = response_hash.dig( "results", 0, "address_components")
  postal_code = ""
  if address_components.is_a?(Array)
    address_components.each do |compo|
      if compo.dig("types", 0) =="postal_code"
        postal_code = compo.dig("short_name")
        break
      end
    end
  end
  zip_string = postal_code.gsub(/\s+/, '').upcase
  zip_string
end
#
# adres = "Het Laybrinth 21, Amersfoort, Netherlands"
# puts "# adres=\"#{adres}\""
# adres_formatted = CGI.escape(adres)
# url_string = "https://maps.googleapis.com/maps/api/geocode/json?address=#{adres_formatted}&key=#{key_api}"
# # puts "# url_string=\"#{url_string}\""
# zip_string = geocode_google(url_string)
# puts "# zip_string=\"#{zip_string}\""
# exit
#
# - - -

def generate_loc_code(zip, house_number, appendix, room)
  #
  # replacements = {
  #   '_'   => '.', 
  #   ' '   => '.',
  #   '\\'  => '', 
  # }
  # appendix_conv = appendix.gsub(Regexp.union(replacements.keys), replacements)
  # room_conv     = room.gsub(Regexp.union(replacements.keys), replacements)
  #
  def sconv(in_str)
    out_str = in_str.gsub(/\\/, '').gsub(/[^A-Za-z0-9]/, '.')
    out_str
  end
  #
  loc_code = sconv(zip) + "-" + sconv(house_number)
  appendix = sconv(appendix)
  if appendix != ""
    loc_code = loc_code + "-appx:" + appendix.upcase
  end
  room = sconv(room)
  if room != ""
    loc_code = loc_code + "-room:" + room.upcase # .downcase
  end
  loc_code  # return value
end

$header_list = []
$header_hash = {}
$header_width = {}
csv_hash = {}
csv_list = []
format_csv_semicolon = true    # if false then format_csv = 'comma'
header_line = ""
while STDIN.gets
    line = $_.chomp
    #
    # error: ./csv_aqu_l2_add_analysis.rb:15:in `split': invalid byte sequence in UTF-8 (ArgumentError)
    # https://www.rubyguides.com/2019/05/ruby-ascii-unicode/
    # file_string.encode("ASCII", "UTF-8", invalid: :replace, undef: :replace, replace: "")
    # line.encode!("UTF-8", "iso-8859-1", invalid: :replace, undef: :replace, replace: "")
    line.encode!("ASCII", "iso-8859-1", invalid: :replace, undef: :replace, replace: "")
    line.encode!("ASCII", "UTF-8",      invalid: :replace, undef: :replace, replace: "")
    #
    if header_line == ""
      header_line = line
      if header_line.match(/";"/)
        format_csv_semicolon = true
      else
        format_csv_semicolon = false
      end
    end
    #
    if format_csv_semicolon
      col_list = line.split(';').map {|col| col.delete_prefix('"').delete_suffix('"') }
    else 
      col_list = line.split(',')
    end
    #
    if $header_list.count >= 1
        # https://stackoverflow.com/questions/49891355/ruby-create-hash-with-keys-and-values-as-arrays
        csv_hash = Hash[$header_list.zip(col_list)] 
        #
        # loc_code:
        loc_code = ""
        if csv_hash.has_key?("zip") 
          loc_code = generate_loc_code(
            csv_hash["zip"],
            csv_hash["house_number"],
            csv_hash["appendix"],
            csv_hash["room"],
          )
        end
        if csv_hash.has_key?("Zipcode") 
          loc_code = generate_loc_code(
            csv_hash["Zipcode"],
            csv_hash["Housenumber"],
            csv_hash["Extension"],
            "",
          )
        end
        if loc_code == "" && 
            csv_hash.has_key?("street") && 
            csv_hash.has_key?("house_number") && 
            csv_hash.has_key?("appendix") && 
            csv_hash.has_key?("room") 
          #
          # adres = "Het Laybrinth 21, Amersfoort, Netherlands"
          adres = csv_hash["street"] + " " + csv_hash["house_number"] + ", Eindhoven, Netherlands"
          STDERR.puts "# adres=\"#{adres}\""
          if zipcache_hash.has_key?(adres) 
            zip_string = zipcache_hash[adres]
            STDERR.puts "# from CACHE >> zip_string=\"#{zip_string}\""
          else
            adres_formatted = CGI.escape(adres)
            url_string = "https://maps.googleapis.com/maps/api/geocode/json?address=#{adres_formatted}&key=#{key_api}"
            # puts "# url_string=\"#{url_string}\""
            zip_string = geocode_google(url_string)
            # save in cache:
            zipcache_hash[adres] = zip_string
            STDERR.puts "# from Geocode@Google >> zip_string=\"#{zip_string}\""
          end
          #
          loc_code = generate_loc_code(
            zip_string,
            csv_hash["house_number"],
            csv_hash["appendix"],
            csv_hash["room"],
          )
        end
        csv_hash["loc_code"] = loc_code
        #
        csv_list << csv_hash
        $header_list.each do |key|
            value = csv_hash[key] || ""
            size_value = value.size
            # $header_width[key] = Math.max $header_width[key], size_value
            if size_value > $header_width[key]
                $header_width[key] = size_value
            end
        end
    else
        $header_list = col_list
        #
        # loc_code:
        $header_list << "loc_code"
        #
        $header_hash = Hash[$header_list.zip(col_list)] 
        col_width = col_list.map {|col| col.size }
        $header_width = Hash[$header_list.zip(col_width)] 
    end
    # col_list = line.split(';')
end

# require 'pp'
# PP.pp csv_list

def hash_to_csv_string(a_csv_hash)
    if !a_csv_hash.is_a?(Hash) 
        return ""
    end
    line = ""
    line_array = []
    $header_list.each do |key|
        value = a_csv_hash[key] || ""
        # line = line + "\"#{value}\";"
        if value.is_a?(Integer) 
            value = value.to_s
        end
        space = $header_width[key] - value.size + 1
        space_string = " " * (space>1?space:1)
        # line_array << "\"#{value}\"" + space_string
        line_array << "\"#{value}\""
    end
    line = line_array.join(";")
    # line.delete_suffix!(';')
    line
end

puts hash_to_csv_string($header_hash)
# puts hash_to_csv_string($header_width)

csv_list.each do |a_csv_hash|
    puts hash_to_csv_string(a_csv_hash)
end

zipcache_json = zipcache_hash.to_json
File.write(zipcache_file, zipcache_json)

#
