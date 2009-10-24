#!/usr/bin/env ruby
require 'heat_map'
raise "usage: heat_maps.rb input_file bucket_size output_dir" unless ARGV.length==3
INPUT_FILE, BUCKET_SIZE, OUTPUT_DIR = ARGV
#raise "no dir #{OUTPUT_DIR}" unless Dir.exists? OUTPUT_DIR
BUCKET_SIZE = BUCKET_SIZE.to_f

heatmap = HeatMap.new(BUCKET_SIZE)
current_timeslice = nil
File.open(INPUT_FILE).each do |line|
	line =~ /(.*?)\t(.*?)\t(.*?)\t(.*)/
	timeslice, x, y, freq = $1,$2.to_f,$3.to_f,$4.to_f
#	puts "timeslice=[#{$1}] x=[#{$2}] y=[#{$3}] freq=[#{$4}]" 
#	puts "timeslice=#{timeslice} x=#{x} y=#{y} freq=#{freq}" 
	if timeslice != current_timeslice && !current_timeslice.nil?
		puts "new map current_timeslice=#{current_timeslice}"
		fork { 
			heatmap.rescale_and_write_to "#{OUTPUT_DIR}/#{sprintf("%04d",current_timeslice)}.jpg" 
			exit 0
		}
#		heatmap.rescale_and_write_to "#{OUTPUT_DIR}/#{sprintf("%04d",current_timeslice)}.jpg" 
		heatmap = HeatMap.new(BUCKET_SIZE)
	end
	heatmap.new_data_point x, y, freq
	current_timeslice = timeslice
end
heatmap.rescale_and_write_to "#{OUTPUT_DIR}/#{sprintf("%04d",current_timeslice)}.jpg"

