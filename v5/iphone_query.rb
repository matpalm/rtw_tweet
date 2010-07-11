#!/usr/bin/env ruby

def close(a,b,x)
  ((a-b).abs - x).abs < 0.000001
end

# guessing this is an iphone lat/long 0.6 0.6 apart
def iphone_lat_long?(lat1,long1, lat2,long2)
  close(lat1,lat2,0.6) && close(long1,long2,0.6)
end

STDIN.each do |line|
  lat1,long1, lat2,long2 = line.split("\t").map(&:to_f)
  next unless iphone_lat_long?(lat1,long1,lat2,long2)
  puts line
end

