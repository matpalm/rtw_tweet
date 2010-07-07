#!/usr/bin/env ruby

require 'rubygems'
require 'RMagick'

class HeatMap

	LOG_RESCALE = true
	MIN_RED, MAX_RED = 0, 255

	def initialize bucket_size
		@map_width = 682
		@canvas = Magick::Image.read("mercator.#{@map_width}.png").first
		@gc = Magick::Draw.new
		@bucket_size = bucket_size.to_f
		@data = []
	end

	def read_data_file input_data_file 
		File.open(input_data_file).each do |line|
			line =~ /\((.*),(.*)\)\t(.*)/
			x, y, freq = [$1,$2,$3].collect{|n| n.to_f}
			new_data_point x,y,freq
		end
		self
	end

	def new_data_point x, y, freq
#		puts "x,y,f = #{[x,y,freq].inspect}"
		freq = Math.log(freq.to_f) if LOG_RESCALE
		@data << [x, y, freq]
		@min_freq = freq if @min_freq.nil? || freq < @min_freq 			
		@max_freq = freq if @max_freq.nil? || freq > @max_freq			
	end

	def rescale_and_write_to file
		@freq_diff = @max_freq - @min_freq
		@data.each do |data|
			x,y,freq = data
			freq = (freq - @min_freq ) / @freq_diff
			colour = (freq * (MAX_RED-MIN_RED)) + MIN_RED
			draw_square x, y, colour
		end
		@gc.draw(@canvas)
		@canvas.write(file)
	end

	def draw_square x, y, colour
		rgb_colour = sprintf("#%02x0000",colour)
		@gc.fill(rgb_colour)
		size = @map_width * @bucket_size
		x,y = x*@map_width, y*@map_width	
		@gc.rectangle(x,y, x+size, y+size)
	end

end

=begin
# made to be run from heat_maps.rb
raise "heapmap.rb INPUT_DATA_FILE BUCKET_SIZE OUTPUT_JPG " unless ARGV.length==3
INPUT_DATA_FILE, BUCKET_SIZE, OUTPUT_JPG = ARGV
HeatMap.new(BUCKET_SIZE).read_data_file(INPUT_DATA_FILE).rescale_and_write_to(OUTPUT_JPG)
=end
