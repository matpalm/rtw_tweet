#!/usr/bin/env ruby
STDIN.each do |line|
  lat1,long1, lat2,long2 = line.split("\t").map(&:to_f)
  lat_mp, long_mp = (lat1+lat2)/2, (long1+long2)/2
  puts "#{lat_mp}\t#{long_mp}"
end

