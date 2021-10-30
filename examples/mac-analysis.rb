#!/usr/bin/env ruby
#= mac-analysis.rb
# usage: > cat d210620-1630-EFX-AQU-D-Link-MAC-Tables.txt | ./mac-analysis.rb > d210620-1630-EFX-AQU-D-Link-MAC-Tables.json

# SW-AQ-HUR-AP1-01:user#show fdb     
# Command: show fdb
#  Unicast MAC Address Aging Time  = 1260
#  VID  VLAN Name                        MAC Address       Port  Type    Status
#  ---- -------------------------------- ----------------- ----- ------- -------
#  1    default                          00-E0-FC-09-BC-F9 7:2   Dynamic Forward 
#  1    default                          0C-41-E9-C8-EE-E0 T1    Dynamic Forward 
#  1    default                          60-2E-20-1E-F0-7E 3:1   Dynamic Forward 

# SW-AQ-HUR-AP1-01:user#show vlan_translation 
# Command: show vlan_translation
# Port    CVID       SPVID      Action    Priority
# -----   --------   --------   -------   ---------
# 1:1     2196       2000       Add       2 
# 1:1     3200       3200       Replace   -
# 1:1     3202       3202       Replace   -
# 1:1     3547       2005       Add       5 
# 1:2     2047       2000       Add       2 
# 1:2     3200       3200       Replace   -


# https://stackoverflow.com/questions/26434923/parse-command-line-arguments-in-a-ruby-script
args = Hash[ ARGV.flat_map{|s| s.scan(/--?([^=\s]+)(?:=(\S+))?/) } ]
# called with -x=foo -h --jim=jam it returns {"x"=>"foo", "h"=>nil, "jim"=>"jam"} so you can do things like:
# puts args['jim'] if args.key?('h')
# #=> jam

require 'json'

# usage:
# > ./mac-analysis.rb --parse_showmac --infile_showmac=d210620-showmac.txt --infile_vlantrans=d210620-vlantrans.txt --outfile_macvlan=d210620-macvlan.json
#
if args.key?('parse_showmac') && args.key?('infile_showmac') && args.key?('infile_vlantrans') && args.key?('outfile_macvlan')
  infile_showmac = args['infile_showmac']
  infile_vlantrans = args['infile_vlantrans']
  outfile_macvlan = args['outfile_macvlan']
  # puts "cmd = parse_showmac"
  # puts "infile_showmac=#{infile_showmac}"
  # puts "infile_vlantrans=#{infile_vlantrans}"
  # puts "outfile_macvlan=#{outfile_macvlan}"
  # exit
  #
  mac_hash = {}
  mac_list = []
  port_hash = {}
  # port_hash = {
  #   switchport_hash: {
  #     switchport: "switch--port",
  #     svlan_hash: {
  #     }
  #   }
  # }
  qinq_hash = {}
  #
  # while STDIN.gets
  File.open(infile_showmac, 'r') do |file|
    while line = file.gets
      line = $_.chomp
      line.encode!("ASCII", "iso-8859-1", invalid: :replace, undef: :replace, replace: "")
      line.encode!("ASCII", "UTF-8",      invalid: :replace, undef: :replace, replace: "")
      #
      if matches = line.match(/(?<sname>[\w\d\-]+):user#show fdb/)
        sname = matches[:sname]
      end
      #
      if matches = line.match(/^\s+(?<vid>\d+)\s+(?<vname>[\w\d\-_]+)\s+(?<mac>[\w\d\-]+)\s+(?<port>[\w\d:]+)\s+(?<type>\w+)\s+Forward/)
        vid   = matches[:vid]
        vname = matches[:vname]
        mac   = matches[:mac]
        port  = matches[:port]
        type  = matches[:type]
        #
        if port != "T1" && port != "T2" && vid != "1" && vid != "440" && vid != "3199" && vid != "3202" && vid != "3203"
          mac_hash = {
            sname:  sname,
            vid:    vid,
            vname:  vname,
            mac:    mac,
            port:   port,
            type:   type,
          }
          #
          switchport = sname + "--" + port
          if !port_hash.has_key?(switchport)
            port_hash[switchport] = {}
          end
          if !port_hash[switchport].has_key?(vid)
            port_hash[switchport][vid] = { mac: [], cvlan: [] }
          end
          # mac_list << mac_hash
          port_hash[switchport][vid][:mac] << mac_hash
        end
        #
      end
    end #/ while line = file.gets
    #
    # mac_json = mac_list.to_json
    # mac_json = JSON.pretty_generate(mac_list)
    port_json = JSON.pretty_generate(port_hash)
    # print "#{mac_json}\n"
    # File.write(outfile_macvlan, mac_json)
    File.write(outfile_macvlan, port_json)
    #
  end #/ File.open(infile_showmac, 'r') do |file|
  #
  # - - - - - - - - - - 
  #
  File.open(infile_vlantrans, 'r') do |file|
    while line = file.gets
      line = $_.chomp
      line.encode!("ASCII", "iso-8859-1", invalid: :replace, undef: :replace, replace: "")
      line.encode!("ASCII", "UTF-8",      invalid: :replace, undef: :replace, replace: "")
      #
      if matches = line.match(/(?<sname>[\w\d\-]+):user#show vlan_translation/)
        sname = matches[:sname]
      end
      #
      if matches = line.match(/^\s*(?<port>[\w\d:]+)\s+(?<cvlan>[\d]+)\s+(?<svlan>[\d]+)\s+Add/)
        port  = matches[:port]
        cvlan = matches[:cvlan]
        svlan = matches[:svlan]
        #
        switchport = sname + "--" + port
        if !port_hash.has_key?(switchport)
          port_hash[switchport] = {}
        end
        if !port_hash[switchport].has_key?(svlan)
          port_hash[switchport][svlan] = { mac: [], cvlan: [] }
        end
        # mac_list << mac_hash
        port_hash[switchport][svlan][:cvlan] << cvlan
        #
        qinq = svlan + "--" + cvlan
        if !qinq_hash.has_key?(qinq)
          qinq_hash[qinq] = {}
        end
        if !qinq_hash[qinq].has_key?(switchport)
          qinq_hash[qinq][switchport] = { mac: port_hash[switchport][svlan][:mac] }
        end
        #
      end
    end #/ while line = file.gets
    #
    # mac_json = mac_list.to_json
    # mac_json = JSON.pretty_generate(mac_list)
    # port_json = JSON.pretty_generate(port_hash)
    port_json = JSON.pretty_generate({ port_hash: port_hash, qinq_hash: qinq_hash })
    # print "#{mac_json}\n"
    # File.write(outfile_macvlan, mac_json)
    File.write(outfile_macvlan, port_json)
    #
  end #/ File.open(infile_vlantrans, 'r') do |file|
  #
end #/ if args.key?('parse_showmac') && 

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
    line_array << "\"#{value}\""
  end
  line = line_array.join(";")
  # line.delete_suffix!(';')
  line
end

qinq_trans = {
  "A2B"                 => "2011",
  "ACA"                 => "2009",
  "Bedrijvenpark Esp"   => "20xx",
  "Claranet"            => "2005",
  "CrossNetworks"       => "2008",
  "DSD"                 => "2010",
  "DotXS"               => "20xx",
  "Global-E Datacenter" => "20xx",
  "Inphos"              => "20xx",
  "NDIX"                => "20xx",
  "Pocos"               => "2001",
  "Previder"            => "20xx",
  "Signet"              => "2000",
  "T-Mobile"            => "2004",
  "Town"                => "20xx",
  "Trined"              => "2006",
  "Weritech"            => "2007",
  #
  "Interconnect"        => "2003",
}

# usage:
# > ./mac-analysis.rb --add_countmac --infile_jsonmac=d210620-macvlan.json --infile_avl=AVL-010621.csv.loccode.csv --outfile_csv=d210620-AVL010621-countmac.csv
#
if args.key?('add_countmac') && args.key?('infile_jsonmac') && args.key?('infile_avl') && args.key?('outfile_csv')
  infile_jsonmac = args['infile_jsonmac']
  infile_avl = args['infile_avl']
  outfile_csv = args['outfile_csv']
  # puts "cmd = add_countmac"
  # puts "infile_jsonmac=#{infile_jsonmac}"
  # puts "infile_avl=#{infile_avl}"
  # puts "outfile_csv=#{outfile_csv}"
  # exit
  #
  port_json = File.read(infile_jsonmac)
  port_hash = JSON.parse(port_json)
  #
  header_line = ""
  $header_list = []
  $header_hash = {}
  csv_hash = {}
  csv_list = []
  #
  format_csv_semicolon = true    # if false then format_csv = 'comma'
  #
  File.open(infile_avl, 'r') do |file|
    while line = file.gets
      line = $_.chomp
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
        csv_hash = Hash[$header_list.zip(col_list)] 
        sp = csv_hash["SP"]
        svlan = qinq_trans[sp] || "20zz"
        cvlan = csv_hash["VlanID"].to_s || "1abc"
        svlan_cvlan = svlan + "--" + cvlan
        # puts "svlan_cvlan=#{svlan_cvlan}"
        csv_hash["svlan_cvlan"] = svlan_cvlan
        #
        # port_json = JSON.pretty_generate({ port_hash: port_hash, qinq_hash: qinq_hash })
        # qinq_hash[qinq][switchport] = { mac: port_hash[switchport][svlan][:mac] }
        if port_hash['qinq_hash'].has_key?(svlan_cvlan)
          switchport = port_hash['qinq_hash'][svlan_cvlan].keys.first
          csv_hash["switch_port"] = switchport
          csv_hash["mac_count"]   = port_hash['qinq_hash'][svlan_cvlan][switchport]["mac"].length
        else
          switchport = "unkown_switchport"
          csv_hash["switch_port"] = switchport
          csv_hash["mac_count"]   = 0
        end
        # puts "switchport=#{switchport}"
        #
        csv_list << csv_hash
      else
        $header_list = col_list
        $header_list << "svlan_cvlan"
        $header_list << "switch_port"
        $header_list << "mac_count"
        $header_hash = Hash[$header_list.zip(col_list)] 
      end
      #
    end #/ while line = file.gets
    #
  end #/ File.open(infile_avl, 'r') do |file|
  #
  file = File.new(outfile_csv, 'w')
  # puts hash_to_csv_string($header_hash)
  file.puts hash_to_csv_string($header_hash)
  csv_list.each do |a_csv_hash|
    # puts hash_to_csv_string(a_csv_hash)
    file.puts hash_to_csv_string(a_csv_hash)
  end
  file.close

#
end #/ if args.key?('add_countmac') && ..

#
