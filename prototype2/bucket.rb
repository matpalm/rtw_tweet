#!/usr/bin/env ruby

BUCKET_SIZE = 0.01

# given x/y output location of left / top / pixel size
STDIN.each do |line|
	line =~ /(.*)\t(.*)/
	left = ($1.to_f / BUCKET_SIZE).to_i * BUCKET_SIZE
	top = ($2.to_f / BUCKET_SIZE).to_i * BUCKET_SIZE
	puts "#{left}\t#{top}"
end
