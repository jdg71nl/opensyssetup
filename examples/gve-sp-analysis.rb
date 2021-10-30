#!/usr/bin/env ruby
# = csv_aqu_l2_add_analysis.rb

# gve_l2_data--13-01-2021.csv
#
# col01 ;    col02 ;       col03 ; col04 ; col05 ; col06 ;       col07 ;    col08 ; col09 ; col10 ; col11 ; col12 ;    col13 ;    col14 ;    col15 ;       col16 ; 
#
# "provider";"vlan_number";"speed";"qos";"street";"house_number";"appendix";"room";"stack";"switch";"port";"cpe_brand";"cpe_type";"cpe_name";"cpe_mgmt_ip";"ntu_port"
# "Signet";"2153";"20,00";"0";"Esp";"112";"";"";"SW-AQ-ESP-AP2-01";"1";"1";"D-link";"DGS-3000-10TC";"CPE-AQ-GVE-07";"10.48.32.7";"1"
# "Pocos";"831";"50,00";"2";"Esp";"112";"";"";"SW-AQ-ESP-AP2-01";"1";"1";"D-link";"DGS-3000-10TC";"CPE-AQ-GVE-07";"10.48.32.7";"4" 
# "Signet";"2198";"50,00";"0";"Esp";"112";"";"";"SW-AQ-ESP-AP2-01";"1";"1";"D-link";"DGS-3000-10TC";"CPE-AQ-GVE-07";"10.48.32.7";"3"
# "Signet";"2197";"5,00";"0";"Esp";"112";"";"";"SW-AQ-ESP-AP2-01";"1";"1";"D-link";"DGS-3000-10TC";"CPE-AQ-GVE-07";"10.48.32.7";"2"
# ~ provider
# + cpe_name_count
# + vlan_number_count

# active_gve_vlans_01-02-2021.csv
#
# ,StartDate,Location,Company,Street,Zipcode,Housenumber,Extension,SPReference,Speed,VlanID,QoS,SLA
# A2B,23-09-2016,GVE-5652AM-7-C,Stickercompany - Dillenburgstraat,Dillenburgstraat,5652AM,7,C,A2B-21-9-2016,20,2000,2,NBD
# ACA,26-11-2015,GVE-5652AJ-4,Kusters Holding BV,Hurksestraat,5652AJ,4,,ACA-26-11-2015 VLAN ACA - Kusters - Kusters,100,2,2,BE
# ACA,26-11-2015,GVE-5651GK-31,Kusters Holding BV,Mispelhoefstraat,5651GK,31,,ACA-26-11-2015 VLAN ACA - Kusters - Kusters,100,2,2,BE
# ACA,26-11-2015,GVE-5652AB-38,ACA IT,Beemdstraat,5652AB,38,,ACA-26-11-2015 VLAN ACA - Kusters - Kusters,100,2,2,BE
# Bedrijvenpark Esp,07-05-2015,GVE-5633AA-Cam1,Bedrijvenpark ESP,Strijpsestraat,5616GL,51,,Bedrijvenpark ESP Camera,100,10,4,BE
# Bedrijvenpark Esp,07-05-2015,GVE-5633AA-Cam2,Bedrijvenpark ESP,Strijpsestraat,5616GL,51,,Bedrijvenpark ESP Camera,100,10,4,BE
# ~ SP
# + Location_count
# + VlanID_count

$header_line = ""
$header_list = []
$header_hash = {}
# $header_width = {}
csv_hash = {}
csv_list = []
$is_layer2_not_activevlans = true

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
    $is_layer2_not_activevlans = format_csv_semicolon
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
        # cpe_name = csv_hash["cpe_name"] || ""
        # cpe_digits = cpe_name.scan(/\d+/).first || "0"
        # cpe_number = cpe_digits.to_i
        # csv_hash["cpe_number"] = cpe_number
        #
        csv_list << csv_hash
        # $header_list.each do |key|
        #     value = csv_hash[key] || ""
        #     size_value = value.size
        #     # $header_width[key] = Math.max $header_width[key], size_value
        #     if size_value > $header_width[key]
        #         $header_width[key] = size_value
        #     end
        # end
    else
        $header_list = col_list
        $header_hash = Hash[$header_list.zip(col_list)] 
        # col_width = col_list.map {|col| col.size }
        # $header_width = Hash[$header_list.zip(col_width)] 
    end
    # col_list = line.split(';')
end

# require 'pp'
# PP.pp csv_list

# ------+++------
# add computed keys: vlan_count, sp_count
#
def select_hash_items_by_key_value(input_list, select_key, select_value)
    # return_list = input_list.map do |my_hash|
    #     value = my_hash[select_key] || ""
    #     if value == select_value
    #         # return hash (so select hash)
    #         my_hash
    #     end
    # end
    return_list = []
    input_list.each do |my_hash|
        value = my_hash[select_key] || ""
        if value == select_value
            return_list << my_hash
        end
    end
    return_list
end
#
# ------+++------
def select_scalar_items_by_key(input_list, select_key)
    return_list = []
    input_list.each do |my_hash|
        if my_hash.is_a?(Hash)
            value = my_hash[select_key] || ""
            if value != ""
                return_list << value
            end
        end
    end
    return_list
end
#
# csv_list.map! do |a_csv_hash|
#     # if a_csv_hash.has_key?("vlan_count")
#     #     a_csv_hash["vlan_count"] = 0
#     # end
#     # if a_csv_hash.has_key?("sp_count")
#     #     a_csv_hash["sp_count"] = 0
#     # end
#     cpe_name = a_csv_hash["cpe_name"]
#     cpe_list = select_hash_items_by_key_value(csv_list, "cpe_name", cpe_name)
#     a_csv_hash["vlan_count"]    = cpe_list.size
#     provider_list = select_scalar_items_by_key(cpe_list, "provider")
#     if provider_list.size > 0
#         a_csv_hash["sp_count"]      = provider_list.uniq.size
#     else
#         a_csv_hash["sp_count"]      = 0
#     end
#     # return hash to update in list:
#     a_csv_hash
# end
# $header_list << "vlan_count"
# $header_list << "sp_count"
# $header_width["vlan_count"] = "vlan_count".size
# $header_width["sp_count"] = "sp_count".size

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
        # space = $header_width[key] - value.size + 1
        # space_string = " " * (space>1?space:1)
        # line_array << "\"#{value}\"" + space_string
        line_array << "\"#{value}\""
    end
    line = line_array.join(";")
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

# ------+++------
sp_hash = {}
csv_list.each do |a_csv_hash|
  #
  if $is_layer2_not_activevlans
    sp_name     = a_csv_hash["provider"]
    cust_name   = a_csv_hash["cpe_name"]
    vlan_id     = a_csv_hash["vlan_number"]
  else
    sp_name     = a_csv_hash["SP"]
    cust_name   = a_csv_hash["Location"]
    vlan_id     = a_csv_hash["VlanID"]
  end
  #
  if !sp_hash.keys.include?(sp_name)
    sp_hash[sp_name] = {}
    sp_hash[sp_name]["cust_name"] = []
    sp_hash[sp_name]["vlan_id"] = []
  end
  #
  if !sp_hash[sp_name]["cust_name"].include?(cust_name)
    sp_hash[sp_name]["cust_name"] << cust_name
  end
  if !sp_hash[sp_name]["vlan_id"].include?(vlan_id)
    sp_hash[sp_name]["vlan_id"] << vlan_id
  end
  #
end
# ------+++------

# require 'json'
# puts sp_hash.to_json

# ------+++------
count_header_list = ["provider", "cpe_count", "vlan_count", "vlanid_min", "vlanid_max"]
count_header = Hash[count_header_list.zip(count_header_list)] 
count_list = []
sp_hash.keys.sort.each do |sp_name|
  cust_name_count         = sp_hash[sp_name]["cust_name"].size
  vlan_id_count           = sp_hash[sp_name]["vlan_id"].size
  #vlanid_min, vlanid_max  = sp_hash[sp_name]["vlan_id"].minmax
  vlanid_min              = sp_hash[sp_name]["vlan_id"].min_by { |x| x.to_i }
  vlanid_max              = sp_hash[sp_name]["vlan_id"].max_by { |x| x.to_i }
  #
  # puts "SP=\"#{sp_name}\": cust_count=#{cust_name_count}, vlan_count=#{vlan_id_count} "
  count_list << {"provider" => sp_name, "cpe_count" => cust_name_count, "vlan_count" => vlan_id_count, "vlanid_min" => vlanid_min, "vlanid_max" => vlanid_max }
end

# ------+++------
puts hash_to_csv_string(count_header_list, count_header)
#
count_list.each do |a_hash|
    puts hash_to_csv_string(count_header_list, a_hash)
end

# ------+++------
#