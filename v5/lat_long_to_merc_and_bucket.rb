#!/usr/bin/env ruby

ASPECT = 0.77539 # target map width / height
PI = 3.14159165358

raise "usage: ./lat_long_to_merc_and_bucket.rb BUCKET_SIZE(=0.005)" unless ARGV.length==1
MAP_BUCKET_SIZE = ARGV.first.to_f

STDIN.each do |line|
  line.chomp!
  freq,lat,lon = line.split("\t").map(&:to_f)

  begin
    # bucket time into a 10 min chunk of day
    #  time =~ / (\d\d):(\d\d):\d\d \+00/		
    #  time_slot = ($1.to_i * 60 + $2.to_i) / 10

    # convert to mercator
    x = (180 + lon) / 360
    lat = lat * PI / 180 # deg -> rad	
    y = Math.log(Math.tan((lat/2) + PI/4)) # mercator project
    y = ASPECT/2 - (y/(2*PI)) # rescale for map

    # allocate to buckets
    left = (x / MAP_BUCKET_SIZE).to_i * MAP_BUCKET_SIZE
    top = (y / MAP_BUCKET_SIZE).to_i * MAP_BUCKET_SIZE

    puts [freq,left,top].join "\t"
  rescue
    STDERR.puts "problem with [#{line}]"
  end

end

