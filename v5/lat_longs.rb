#!/usr/bin/env ruby
class Float
  def valid_lat?
    self>-90 && self<90
  end
  def valid_long?
    self>-180 && self<180
  end
end

STDIN.each do |line|
  #begin
    line =~ /Parameters.*bounding_box"=>"(.*?)"/
    lat_longs = $1
    next unless lat_longs
    lat1,lat2,long1,long2 = lat_longs.split(',').map{|v| v.to_f}
    next unless lat1 && lat2 && long1 && long2
    next unless lat1.valid_lat? && lat2.valid_lat? && long1.valid_long? && long2.valid_long?
    next if lat1==lat2 || long1==long2
    lat1,lat2 = lat2,lat1 if lat1 < lat2
    long1,long2 = long2,long1 if long1 < long2
    puts [lat1,long1,lat2,long2].join("\t")
  #rescue Exception => e
  #  STDERR.puts "FAIL ON line=#{line}"
  #  STDERR.puts e.inspect
  #end
end

