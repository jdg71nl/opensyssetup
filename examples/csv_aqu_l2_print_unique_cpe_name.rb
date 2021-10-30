#!/usr/bin/env ruby
# = csv_aqu_l2_print_unique_cpe_name.rb

$header_list = []
$header_hash = {}
$header_width = {}
csv_hash = {}
csv_list = []
cpe_name_list = []
while STDIN.gets
    line = $_.chomp
    line.encode!("UTF-8", "iso-8859-1", invalid: :replace, undef: :replace, replace: "")
    col_list = line.split(';').map {|col| col.delete_prefix('"').delete_suffix('"') }
    if $header_list.count >= 1
        # https://stackoverflow.com/questions/49891355/ruby-create-hash-with-keys-and-values-as-arrays
        csv_hash = Hash[$header_list.zip(col_list)] 
        #
        cpe_name = csv_hash["cpe_name"] || ""
        if !cpe_name_list.include?(cpe_name)
            cpe_name_list << cpe_name
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
        end
    else
        $header_list = col_list
        # $header_list << "vlan_count"
        # $header_list << "sp_count"
        $header_hash = Hash[$header_list.zip(col_list)] 
        col_width = col_list.map {|col| col.size }
        $header_width = Hash[$header_list.zip(col_width)] 
    end
end

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

#
