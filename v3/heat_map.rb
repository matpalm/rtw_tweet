#!/usr/bin/env ruby

require 'rubygems'
require 'RMagick'

class HeatMap

	MIN_RED, MAX_RED = 50, 255

	def initialize bucket_size
		@map_width = 682
		@canvas = Magick::Image.read('mercator.682.png').first
		@gc = Magick::Draw.new
		@bucket_size = bucket_size.to_f
	end

	def read_data_file min_max_file, input_data_file 
		max_freq, min_freq = File.open(min_max_file).read.chomp.split("\t").collect {|n| Math.log(n.to_i)}
		freq_diff = max_freq - min_freq
		File.open(input_data_file).each do |line|
			line =~ /\((.*),(.*)\)\t(.*)/
			x, y, freq = [$1,$2,$3].collect{|n| n.to_f}
			freq = Math.log(freq.to_f)
			freq = (freq - min_freq ) / freq_diff
			colour = (freq * (MAX_RED-MIN_RED)) + MIN_RED
			draw_square x, y, colour
		end
		self
	end

	def draw_square x, y, colour
		rgb_colour = sprintf("#%02x0000",colour)
		@gc.fill(rgb_colour)
		size = @map_width * @bucket_size
		x,y = x*@map_width, y*@map_width	
		@gc.rectangle(x,y, x+size, y+size)
	end

	def write_to file
		@gc.draw(@canvas)
		@canvas.write(file)
	end

end

raise "heapmap.rb MIN_MAX_FILE INPUT_DATA_FILE BUCKET_SIZE OUTPUT_JPG " unless ARGV.length==4
MIN_MAX_FILE, INPUT_DATA_FILE, BUCKET_SIZE, OUTPUT_JPG = ARGV
HeatMap.new(BUCKET_SIZE).read_data_file(MIN_MAX_FILE, INPUT_DATA_FILE).write_to(OUTPUT_JPG)
