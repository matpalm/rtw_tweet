#!/usr/bin/env ruby

WIDTH = 2048.0
HEIGHT = 1588.0
PI = 3.14159165358

STDIN.each do |line|
	lat,lon = line.split.collect{|n| n.to_f}
 
	x = ((WIDTH * (180 + lon) / 360) % WIDTH)

  lat = lat * PI / 180 # deg -> rad	
	y = Math.log(Math.tan((lat/2) + PI/4)) # mercator project
	y = HEIGHT/2 - (WIDTH*y/(2*PI)) # rescale for map

	puts "#{x}\t#{y}"
end

