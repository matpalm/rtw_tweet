#!/usr/bin/env ruby
require 'rubygems'
require 'json'
STDIN.each do |line|
	begin
		tweet = JSON.parse(line)
		created_at = tweet['created_at']
		next unless created_at
		created_at =~ / (\d\d):(\d\d):\d\d \+00/		
		puts ($1.to_i * 60 + $2.to_i) / 10 # 10min time bucket
	rescue
		# whatever
	end
end

