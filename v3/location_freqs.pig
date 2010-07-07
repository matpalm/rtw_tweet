data = load 'json_stream.sample/*';
locations = stream data through `ruby extract_just_locations.rb` as (location:chararray);
lgroup = group locations by location;
lfreq = foreach lgroup { generate group, SIZE(locations) as size; }
non_uniq_lfreq = filter lfreq by size > 1;
lfreq2 = order non_uniq_lfreq by size;
store lfreq2 into 'location_freqs';
