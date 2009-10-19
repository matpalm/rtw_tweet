#!/usr/bin/env ruby
require 'rubygems'
require 'json'
STDIN.each do |line|
	next unless line =~ /"location"/
	next if line =~ /"location":null/
	next if line =~ /"location":""/
	begin
		tweet = JSON.parse(line)
		puts "#{tweet['created_at']}\t#{tweet['user']['location']}\n"
	rescue
		# whatever
	end
end

