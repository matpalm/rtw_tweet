#!/usr/bin/env bash
set -x

BUCKET_SIZE=0.001

# dump lat longs from data
cat $1 > to_process
TOTAL_LINES=`cat to_process | wc -l`
let SPLIT_SIZE=$TOTAL_LINES/4
split -l $SPLIT_SIZE to_process

# extract lat longs, filter only those looking like iphone screen sized ones and emit centres
cat xaa | ./lat_longs.rb | ./iphone_query.rb | ./centres.rb | sort > xaa.lat_long_pair &
cat xab | ./lat_longs.rb | ./iphone_query.rb | ./centres.rb | sort > xab.lat_long_pair &
cat xac | ./lat_longs.rb | ./iphone_query.rb | ./centres.rb | sort > xac.lat_long_pair &
cat xad | ./lat_longs.rb | ./iphone_query.rb | ./centres.rb | sort > xad.lat_long_pair &
wait

# collate output
cat xa[abcd].lat_long_pair | sort -m | uniq -c | tabify_uniq_out.rb > freq_lat_long

# merc projection and bucketing
cat freq_lat_long | ./lat_long_to_merc_and_bucket.rb $BUCKET_SIZE > freq_lat_bucket_long_bucket

#collapse lat long buckets together
rm freq_lat_bucket_long_bucket.flatten
pig -x local -p input=freq_lat_bucket_long_bucket -p output=freq_lat_bucket_long_bucket.flatten flatten_freq_lat_long.pig

# make the map
./heat_map.rb freq_lat_bucket_long_bucket.flatten $BUCKET_SIZE test.$1.jpg

