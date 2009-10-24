#!/usr/bin/env ruby
STDIN.each do |line|
	time,lat_lon = line.split "\t"
	lat_lon =~ /([-.\d+]+),([-.\d+]+)/; # look for lat longs
	next unless $1 and $2	
	lat,lon = $1.to_f,$2.to_f
	# those crazy kids will put ANYTHING in these days...
	next if lat <= -90 || lat >= 90   
	next if lon <= -180 || lon >= 180 
	next if lat == 0 && lon == 0
	puts [time, lat, lon].join "\t"
end
