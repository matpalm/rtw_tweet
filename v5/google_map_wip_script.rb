#!/usr/bin/env ruby

SCALE_FACTOR = 1e3

def scaled val
  (val.to_f * SCALE_FACTOR).ceil / SCALE_FACTOR
end

def gLatLong(lat,long)
  "new GLatLng(#{lat},#{long})"
end

def close(a,b,x)
  ((a-b).abs - x).abs < 0.000001
end

# guessing this is an iphone lat/long 0.6 0.6 apart
def iphone_lat_long?(lat1,lat2,long1,long2)
  close(lat1,lat2,0.6) && close(long1,long2,0.6)
end

STDIN.each do |line|
  line =~ /Parameters.*bounding_box"=>"(.*?)"/
  lat_longs = $1
  next unless lat_longs
  lat1,lat2,long1,long2 = lat_longs.split(',').map{|v|scaled(v)}

#  printf "map.setCenter(new GLatLng(#{lat_mdpt},#{long_mdpt}), 9);\n"

  lat1,lat2 = lat2,lat1 if lat1 < lat2
  long1,long2 = long2,long1 if long1 < long2

  lat_mp, long_mp = (lat1+lat2)/2, (long1+long2)/2

# wishing the world WAS flat, the maths would be easier...

  puts "#{lat1} #{long1} #{lat2} #{long2}"

  if (iphone_lat_long?(lat1,lat2,long1,long2) && false)
    puts "in the pipe, six by six"
    printf "map.addOverlay(new GPolygon(["
    printf "#{gLatLong(lat_mp-0.3,long_mp-0.3)},"
    printf "#{gLatLong(lat_mp-0.3,long_mp+0.3)},"
    printf "#{gLatLong(lat_mp+0.3,long_mp+0.3)},"
    printf "#{gLatLong(lat_mp+0.3,long_mp-0.3)},"
    printf "#{gLatLong(lat_mp-0.3,long_mp-0.3)}"
    printf "], \"#ff0000\",2,1,\"#ff0000\",0.1));\n"   
  else    
    printf "map.addOverlay(new GPolygon(["
    printf "#{gLatLong(lat1,long1)},"
    printf "#{gLatLong(lat1,long2)},"
    printf "#{gLatLong(lat2,long2)},"
    printf "#{gLatLong(lat2,long1)},"
    printf "#{gLatLong(lat1,long1)}"
    printf "], \"#ff0000\",2,1,\"#ff0000\",0.1));\n"
  end

  2.times { puts }
end

