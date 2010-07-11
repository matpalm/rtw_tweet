#!/usr/bin/env ruby

raise "usage: filter_bb.rb n s e w" unless ARGV.length==4
N,S,E,W = ARGV.map(&:to_f)

STDIN.each do |line|
  lat,long = line.split("\t").map(&:to_f)
  next unless lat<N && lat>S && long<E && long>W 
  puts line
end

