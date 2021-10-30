#!/usr/bin/env ruby
# = csv_aqu_l2_add_analysis.rb

# d210113-EFX-Luc--gve_l2_data.csv
#
# col01 ;    col02 ;       col03 ; col04 ; col05 ; col06 ;       col07 ;    col08 ; col09 ; col10 ; col11 ; col12 ;    col13 ;    col14 ;    col15 ;       col16 ; 
#
# "provider";"vlan_number";"speed";"qos";"street";"house_number";"appendix";"room";"stack";"switch";"port";"cpe_brand";"cpe_type";"cpe_name";"cpe_mgmt_ip";"ntu_port"
# "Signet";"2153";"20,00";"0";"Esp";"112";"";"";"SW-AQ-ESP-AP2-01";"1";"1";"D-link";"DGS-3000-10TC";"CPE-AQ-GVE-07";"10.48.32.7";"1"
# "Pocos";"831";"50,00";"2";"Esp";"112";"";"";"SW-AQ-ESP-AP2-01";"1";"1";"D-link";"DGS-3000-10TC";"CPE-AQ-GVE-07";"10.48.32.7";"4"
# "Signet";"2198";"50,00";"0";"Esp";"112";"";"";"SW-AQ-ESP-AP2-01";"1";"1";"D-link";"DGS-3000-10TC";"CPE-AQ-GVE-07";"10.48.32.7";"3"
# "Signet";"2197";"5,00";"0";"Esp";"112";"";"";"SW-AQ-ESP-AP2-01";"1";"1";"D-link";"DGS-3000-10TC";"CPE-AQ-GVE-07";"10.48.32.7";"2"


# d210201-EFX-Teun--active_gve_vlans_01-02-2021.csv
#
# col01 ;    col02 ;       col03 ; col04 ; col05 ; col06 ;       col07 ;    col08 ; col09 ; col10 ; col11 ; col12 ;    col13 ;    col14 ;    col15 ;       col16 ; 
#
# SP,StartDate,Location,Company,Street,Zipcode,Housenumber,Extension,SPReference,Speed,VlanID,QoS,SLA
# A2B,23-09-2016,GVE-5652AM-7-C,Stickercompany - Dillenburgstraat,Dillenburgstraat,5652AM,7,C,A2B-21-9-2016,20,2000,2,NBD
# ACA,26-11-2015,GVE-5652AJ-4,Kusters Holding BV,Hurksestraat,5652AJ,4,,ACA-26-11-2015 VLAN ACA - Kusters - Kusters,100,2,2,BE
# ACA,26-11-2015,GVE-5651GK-31,Kusters Holding BV,Mispelhoefstraat,5651GK,31,,ACA-26-11-2015 VLAN ACA - Kusters - Kusters,100,2,2,BE
# ACA,26-11-2015,GVE-5652AB-38,ACA IT,Beemdstraat,5652AB,38,,ACA-26-11-2015 VLAN ACA - Kusters - Kusters,100,2,2,BE
# Bedrijvenpark Esp,07-05-2015,GVE-5633AA-Cam1,Bedrijvenpark ESP,Strijpsestraat,5616GL,51,,Bedrijvenpark ESP Camera,100,10,4,BE
# Bedrijvenpark Esp,07-05-2015,GVE-5633AA-Cam2,Bedrijvenpark ESP,Strijpsestraat,5616GL,51,,Bedrijvenpark ESP Camera,100,10,4,BE

$header_list = []
$header_hash = {}
$header_width = {}
csv_hash = {}
csv_list = []
while STDIN.gets
    line = $_.chomp
    # error: ./csv_aqu_l2_add_analysis.rb:15:in `split': invalid byte sequence in UTF-8 (ArgumentError)
    # https://www.rubyguides.com/2019/05/ruby-ascii-unicode/
    # file_string.encode("ASCII", "UTF-8", invalid: :replace, undef: :replace, replace: "")
    line.encode!("UTF-8", "iso-8859-1", invalid: :replace, undef: :replace, replace: "")
    col_list = line.split(';').map {|col| col.delete_prefix('"').delete_suffix('"') }
    #
    if $header_list.count >= 1
        # https://stackoverflow.com/questions/49891355/ruby-create-hash-with-keys-and-values-as-arrays
        csv_hash = Hash[$header_list.zip(col_list)] 
        #
        cpe_name = csv_hash["cpe_name"] || ""
        cpe_digits = cpe_name.scan(/\d+/).first || "0"
        cpe_number = cpe_digits.to_i
        csv_hash["cpe_number"] = cpe_number
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
        $header_list << "cpe_number"
        $header_list << "vlan_count"
        $header_list << "sp_count"
        $header_hash = Hash[$header_list.zip(col_list)] 
        col_width = col_list.map {|col| col.size }
        $header_width = Hash[$header_list.zip(col_width)] 
    end
    # col_list = line.split(';')
end

# require 'pp'
# PP.pp csv_list

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
csv_list.map! do |a_csv_hash|
    # if a_csv_hash.has_key?("vlan_count")
    #     a_csv_hash["vlan_count"] = 0
    # end
    # if a_csv_hash.has_key?("sp_count")
    #     a_csv_hash["sp_count"] = 0
    # end
    cpe_name = a_csv_hash["cpe_name"]
    cpe_list = select_hash_items_by_key_value(csv_list, "cpe_name", cpe_name)
    a_csv_hash["vlan_count"]    = cpe_list.size
    provider_list = select_scalar_items_by_key(cpe_list, "provider")
    if provider_list.size > 0
        a_csv_hash["sp_count"]      = provider_list.uniq.size
    else
        a_csv_hash["sp_count"]      = 0
    end
    # return hash to update in list:
    a_csv_hash
end
# $header_list << "vlan_count"
# $header_list << "sp_count"
# $header_width["vlan_count"] = "vlan_count".size
# $header_width["sp_count"] = "sp_count".size

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

# cpe_list = select_hash_items_by_key_value(csv_list, "cpe_name", "CPE-AQ-GVE-07")
# cpe_list.each do |a_csv_hash|
#     puts hash_to_csv_string(a_csv_hash)
# end

# require 'csv'
# # https://ruby-doc.org/stdlib-2.6.1/libdoc/csv/rdoc/CSV.html
# csv_string = ["CSV", "data"].to_csv   # to CSV
# csv_array  = "CSV,String".parse_csv   # from CSV
# #
# # CSV() method
# CSV             { |csv_out| csv_out << %w{my data here} }  # to $stdout
# CSV(csv = "")   { |csv_str| csv_str << %w{my data here} }  # to a String
# CSV($stderr)    { |csv_err| csv_err << %w{my data here} }  # to $stderr
# CSV($stdin)     { |csv_in|  csv_in.each { |row| p row } }  # from $stdin

# CSV($stdin, col_sep:"\n", row_sep:";") do |csv_in|  
# 	csv_in.each { |row| p row } 
# end

# require 'pp'
# require 'csv'
# CSV.foreach(ARGV[0], col_sep: ' ', row_sep: :auto, liberal_parsing: {double_quote_outside_quote: true} ) do |row|
#     pp row
# end

# https://stackoverflow.com/questions/56259806/how-to-fix-a-csv-read-error-with-a-semicolon-at-line-end
# CSV.foreach(ARGV[0],col_sep:" ", row_sep:";").to_a

# file_string = ""
# while STDIN.gets
#   file_string = file_string + $_
# end

# csv = CSV.new(file_string)

# csv.each do |row|
# 	puts row
# end
	
# CSV.foreach(file_string) do |row|
#   # some
# 	puts row
# end

# array_of_arrays = CSV.read("file.csv")

# CSV.open('file.csv', 'w') do |csv|
#   csv << ["row", "of", "CSV", "data"]
# end
