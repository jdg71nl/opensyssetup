#!/usr/bin/env ruby
# = parse.rb

# bureaus.txt
#
# # https://www.amersfoort.nl/bestuur-en-organisatie/to-3/stembureaus-in-amersfoort-1.htm
# naam: Stembureaus in Amersfoort 2021
# - Stembureaus woensdag 17 maart
# -- Binnenstad
# --- Gemeentehuis, Stadhuisplein 1 (2 bureaus)
# --- Sint Joriskerk, Groenmarkt 15 (4 bureaus)
# --- Nieuw-Apostolische kerk, Utrechtseweg 73*
# - Besloten stembureaus
# --- St Pieters en Bloklands Gasthuis, locatie Davidshof (08:00 tot 10:30 uur): Achter Davidshof 1, 3811 BD Amersfoort
# --- Zon en Schild (12:00 tot 13:30 uur): Utrechtseweg 266, 3818 EW Amersfoort

# result.json (desired):
#
# {
#   naam : "Stembureaus in Amersfoort 2021",
#   lijst : [
#     {
#       naam : "Stembureaus woensdag 17 maart",
#       lijst : [
#         {
#           naam : "Binnenstad",
#           lijst : [
#             {
#               naam : "Gemeentehuis",
#               adres : "Stadhuisplein 1, 3811 LM Amersfoort",
#               locatie : "52.156798771747624, 5.384317377843873",
#               openingstijd : "07:30 tot 21:00",   # De openbare stembureaus zijn geopend van 07:30 tot 21:00 uur.
#               aantal_bureaus : 1,
#               toegankelijk_mindervaliden : false    # Een * betekent dat het stembureau niet toegankelijk is voor mindervaliden.
#             }
#           ]
#         }
#       ]
#     }
#   ]
# }

$main_struct = {}
$main_struct["level"] = 1
$main_struct["naam"] = ""
$main_struct["lijst"] = []

$level1_struct = {}
$level2_struct = {}

PATTERN_COMMENT = /^#/
PATTERN_NAAM = /^naam: (?<sub>.*)$/
PATTERN_LEVEL1 = /^- (?<sub>.*)$/
PATTERN_LEVEL2 = /^-- (?<sub>.*)$/
PATTERN_LEVEL3 = /^--- (?<sub>.*)$/
PATTERN_VALIDEN = /\*/
PATTERN_BUREAUS = /\((?<bureaus>\d+) bureaus\)/   # (4 bureaus)
PATTERN_TIJD = /\((?<tijd>.*) uur\)/   # (08:00 tot 10:30 uur)
PATTERN_ADRES = /:/
PATTERN_ADRES_COMMA = /,/

while STDIN.gets
  line = $_.chomp
  line.encode!("ASCII", "iso-8859-1", invalid: :replace, undef: :replace, replace: "")
  line.encode!("ASCII", "UTF-8",      invalid: :replace, undef: :replace, replace: "")
  #
  # next if line.match(/^#/)
  next if line =~ PATTERN_COMMENT
  #
  if matches = line.match(PATTERN_NAAM)
    $main_struct["naam"] = matches[:sub]
    # $level1_struct = {}
    # $level2_struct = {}
    next
  end
  # - - - + - - -  - - - + - - -  - - - + - - -  - - - + - - -  
  if matches = line.match(PATTERN_LEVEL1)
    #
    if $level2_struct != {}
      $level1_struct["lijst"].push $level2_struct
    end
    if $level1_struct != {}
      $main_struct["lijst"].push $level1_struct
    end
    #
    $level1_struct = {}
    $level1_struct["level"] = 2
    $level1_struct["naam"] = matches[:sub]
    $level1_struct["lijst"] = []
    $level2_struct = {}
    #
    next
  end
  # - - - + - - -  - - - + - - -  - - - + - - -  - - - + - - -  
  if matches = line.match(PATTERN_LEVEL2)
    #
    if $level2_struct != {}
      $level1_struct["lijst"].push $level2_struct
    end
    #
    $level2_struct = {}
    $level2_struct["level"] = 3
    $level2_struct["naam"] = matches[:sub]
    $level2_struct["lijst"] = []
    next
  end
  # - - - + - - -  - - - + - - -  - - - + - - -  - - - + - - -  
  if matches = line.match(PATTERN_LEVEL3)
    sub_line = matches[:sub]
    #
    # check if L3 has no L2 ..
    if $level2_struct == {}   
      $level2_struct["level"] = 3
      $level2_struct["naam"] = ""
      $level2_struct["lijst"] = []
    end
    #
    # defaults:
    level3_struct = {}
    level3_struct["level"] = 4
    level3_struct["naam"] = ""
    level3_struct["adres"] = ""
    level3_struct["locatie"] = ""
    level3_struct["openingstijd"] = "07:30 tot 21:00"
    level3_struct["aantal_bureaus"] = 1
    level3_struct["toegankelijk_mindervaliden"] = true
    #
    if sub_line =~ PATTERN_VALIDEN
      level3_struct["toegankelijk_mindervaliden"] = false
      sub_line.gsub!(PATTERN_VALIDEN, "")
    end
    #
    if matches = sub_line.match(PATTERN_BUREAUS) 
      level3_struct["aantal_bureaus"] = matches[:bureaus].to_i
      sub_line.gsub!(PATTERN_BUREAUS, "")
    end
    #
    if matches = sub_line.match(PATTERN_TIJD) 
      level3_struct["openingstijd"] = matches[:tijd]
      sub_line.gsub!(PATTERN_TIJD, "")
    end
    #
    if sub_line.match(PATTERN_ADRES)
      string_lijst = sub_line.split(':')
      level3_struct["naam"]   = string_lijst[0].strip
      level3_struct["adres"]  = string_lijst[1].strip
    else
      if sub_line.match(PATTERN_ADRES_COMMA)
        string_lijst = sub_line.split(',')
        level3_struct["naam"]   = string_lijst[0].strip
        level3_struct["adres"]  = string_lijst[1].strip + ", Amersfoort"
      end
    end
    #
    # if !$level2_struct.keys.include?("lijst")
    #   $level2_struct["lijst"] = []
    # end
    #
    $level2_struct["lijst"].push level3_struct
    #
  end
  # - - - + - - -  - - - + - - -  - - - + - - -  - - - + - - -  
end
#
# flush
if $level2_struct != {}
  $level1_struct["lijst"].push $level2_struct
end
if $level1_struct != {}
  $main_struct["lijst"].push $level1_struct
end
#

require 'json'
# puts $main_struct.to_json
puts JSON.pretty_generate($main_struct)

#