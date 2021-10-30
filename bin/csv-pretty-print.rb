#!/usr/bin/env ruby
# = csv-pretty-print.rb

# gve_l2_data--13-01-2021.csv
#
# "provider";"vlan_number";"speed";"qos";"street";"house_number";"appendix";"room";"stack";"switch";"port";"cpe_brand";"cpe_type";"cpe_name";"cpe_mgmt_ip";"ntu_port"
# "Signet";"2153";"20,00";"0";"Esp";"112";"";"";"SW-AQ-ESP-AP2-01";"1";"1";"D-link";"DGS-3000-10TC";"CPE-AQ-GVE-07";"10.48.32.7";"1"
# "Pocos";"831";"50,00";"2";"Esp";"112";"";"";"SW-AQ-ESP-AP2-01";"1";"1";"D-link";"DGS-3000-10TC";"CPE-AQ-GVE-07";"10.48.32.7";"4" 

# active_gve_vlans_01-02-2021.csv
#
# SP,StartDate,Location,Company,Street,Zipcode,Housenumber,Extension,SPReference,Speed,VlanID,QoS,SLA
# A2B,23-09-2016,GVE-5652AM-7-C,Stickercompany - Dillenburgstraat,Dillenburgstraat,5652AM,7,C,A2B-21-9-2016,20,2000,2,NBD
# ACA,26-11-2015,GVE-5652AJ-4,Kusters Holding BV,Hurksestraat,5652AJ,4,,ACA-26-11-2015 VLAN ACA - Kusters - Kusters,100,2,2,BE

$header_line = ""
$header_list = []
$header_hash = {}
$header_width = {}
csv_hash = {}
csv_list = []
# $is_layer2_not_activevlans = true

# ------+++------
while STDIN.gets
    line = $_.chomp
    # error: ./csv_aqu_l2_add_analysis.rb:15:in `split': invalid byte sequence in UTF-8 (ArgumentError)
    # https://www.rubyguides.com/2019/05/ruby-ascii-unicode/
    # file_string.encode("ASCII", "UTF-8", invalid: :replace, undef: :replace, replace: "")
    line.encode!("ASCII", "iso-8859-1", invalid: :replace, undef: :replace, replace: "")
    line.encode!("ASCII", "UTF-8",      invalid: :replace, undef: :replace, replace: "")
    #
    if $header_line == ""
      $header_line = line
      if $header_line.match(/";"/)
        format_csv_semicolon = true
      else
        format_csv_semicolon = false
      end
    end
    # $is_layer2_not_activevlans = format_csv_semicolon
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
        $header_hash = Hash[$header_list.zip(col_list)] 
        col_width = col_list.map {|col| col.size }
        $header_width = Hash[$header_list.zip(col_width)] 
    end
    # col_list = line.split(';')
end

# ------+++------
def hash_to_csv_string(a_key_list, a_csv_hash)
    if !a_csv_hash.is_a?(Hash) 
        return ""
    end
    line = ""
    line_array = []
    # $header_list.each do |key|
    a_key_list.each do |key|
        value = a_csv_hash[key] || ""
        # line = line + "\"#{value}\";"
        if value.is_a?(Integer) 
            value = value.to_s
        end
        space = $header_width[key] - value.size + 1
        space_string = " " * (space>1?space:1)
        # line_array << "\"#{value}\""
        # line_array << "\"#{value}\"" + space_string
        line_array << " #{value} " + space_string
    end
    # line = line_array.join(";")
    line = "|" + line_array.join("|") + "|"
    # line.delete_suffix!(';')
    line
end
#
# puts hash_to_csv_string($header_hash)
# # puts hash_to_csv_string($header_width)
# #
# csv_list.each do |a_csv_hash|
#     puts hash_to_csv_string(a_csv_hash)
# end


puts hash_to_csv_string($header_list, $header_hash)
#
# csv_list = csv_list.sort_by { |a_hash| a_hash["VlanID"].to_i }
# csv_list = csv_list.sort_by { |a_hash| a_hash["SP"] }
#
csv_list = csv_list.sort { |a,b|
  ( a["SP"] == b["SP"] ? a["VlanID"].to_i <=> b["VlanID"].to_i : a["SP"] <=> b["SP"] )
}
#
csv_list.each do |a_hash|
  #
  puts hash_to_csv_string($header_list, a_hash)
  #
end

# ------+++------
#