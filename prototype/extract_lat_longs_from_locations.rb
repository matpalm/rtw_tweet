#!/usr/bin/env ruby
LOC_TAG = ARGV.first=='iphone' ? 'iPhone' : '\u00dcT'
STDIN.each do |line|
	line =~ /#{LOC_TAG}: ([-.\d+]*,[-.\d+]*)/;
	next unless $1	
	puts $1.sub ',', "\t"
end
