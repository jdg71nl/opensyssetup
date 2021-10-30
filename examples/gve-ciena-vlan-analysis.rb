#!/usr/bin/env ruby
# = gve-ciena-vlan-analysis.rb

# > cat d210527-1242-EFX-Ciena-DGL-config.grep.txt | egrep UPL_1055VS_1
# sub-port add sub-port LAG=AGG_aQuestora-UPL_1055VS_1 class-element 100 vtag-stack 2000
# sub-port add sub-port LAG=AGG_aQuestora-UPL_1055VS_1 class-element 101 vtag-stack 2001
# virtual-switch interface attach sub-port LAG=AGG_aQuestora-UPL_1055VS_1 vs 1055VS02

sp_hash = {}

# ------+++------
while STDIN.gets
    line = $_.chomp
    # puts "line=\"#{line}\""
    #
    subport = ""
    vlanid  = 0
    vsname  = ""
    m = line.match /sub-port add sub-port (?<subport>[\w\-_=]+) .*? vtag-stack (?<vlanid>\d+)/
    if m
      subport = m[:subport]
      vlanid  = m[:vlanid].to_i
      vsname  = ""
    end
    m = line.match /virtual-switch interface attach sub-port (?<subport>[\w\-_=]+) vs (?<vsname>\w+)/
    if m
      subport = m[:subport]
      vlanid  = 0
      vsname  = m[:vsname]
    end
    if subport != "" && !sp_hash.keys.include?(subport)
      # puts "subport=\"#{subport}\""
      sp_hash[subport] = {}
      sp_hash[subport]["vsname"] = []
      sp_hash[subport]["vlanid"] = []
    end
    #
    if vsname != "" && !sp_hash[subport]["vsname"].include?(vsname)
      sp_hash[subport]["vsname"] << vsname
    end
    if vlanid != 0 && !sp_hash[subport]["vlanid"].include?(vlanid)
      sp_hash[subport]["vlanid"] << vlanid
    end
    #
end

count_header_list = ["subport", "vsname", "vlanid"]
count_header = Hash[count_header_list.zip(count_header_list)] 
count_list = []
sp_hash.keys.sort.each do |subport|
  # puts "subport=\"#{subport}\""
  vsname_list = sp_hash[subport]["vsname"]
  vsname_list.sort.each do |vsname|
    vlan_list = sp_hash[subport]["vlanid"]
    vlan_list.sort.each do |vlanid|
      count_list << {"subport" => subport, "vsname" => vsname, "vlanid" => vlanid }
    end
  end
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
puts hash_to_csv_string(count_header_list, count_header)
#
count_list.each do |a_hash|
    puts hash_to_csv_string(count_header_list, a_hash)
end
