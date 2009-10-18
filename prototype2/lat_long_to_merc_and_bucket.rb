#!/usr/bin/env ruby

ASPECT = 0.77539 # target map width / height
PI = 3.14159165358

BUCKET_SIZE = 0.01


STDIN.each do |line|
	lat,lon = line.split.collect{|n| n.to_f}
		
	# those crazy kids will put ANYTHING in these days...
	next if lat < -90 || lat > 90  
	next if lon < -180 || lat > 180 

	# convert to mercator
	x = (180 + lon) / 360
  lat = lat * PI / 180 # deg -> rad	
	y = Math.log(Math.tan((lat/2) + PI/4)) # mercator project
	y = ASPECT/2 - (y/(2*PI)) # rescale for map

	# allocate to buckets
	left = (x / BUCKET_SIZE).to_i * BUCKET_SIZE
	top = (y / BUCKET_SIZE).to_i * BUCKET_SIZE

	puts "#{left}\t#{top}"
end

