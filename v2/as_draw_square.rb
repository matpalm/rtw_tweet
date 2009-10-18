#!/usr/bin/env ruby

raise "as_draw_square.rb MIN_FREQ MAX_FREQ" unless ARGV.length==2
min_freq, max_freq = ARGV.collect { |n| Math.log10(n.to_i) }
freq_diff = max_freq - min_freq

min_red, max_red = 100, 255
red_diff = max_red - min_red

iter=0
STDIN.each do |line|
	line =~ /\((.*),(.*)\)\t(.*)/
	x,y,freq = $1,$2,$3.to_f
	freq = Math.log10(freq)

	# rescale freq to 0 -> 1
	freq = (freq - min_freq ) / freq_diff

	# calc colour by projecting to red scale
	colour = (freq * red_diff) + min_red

	printf "ds(%0.02f,%0.02f,\"%02x\");",x,y,colour
	iter+=1
	puts "\n" if iter%8==0
end
puts "\n"
