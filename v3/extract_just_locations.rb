#!/usr/bin/env ruby
require 'rubygems'
require 'json'
STDIN.each do |line|
	next unless line =~ /"location"/
	next if line =~ /"location":null/
	next if line =~ /"location":""/
	begin
		tweet = JSON.parse(line)
		puts tweet['user']['location'].downcase
	rescue
		# whatever
	end
end

