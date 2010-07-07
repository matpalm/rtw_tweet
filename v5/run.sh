set -x

# dump lat longs from data
head -n100 just_bb_lines_2 > to_process
TOTAL_LINES=`cat to_process | wc -l`
let SPLIT_SIZE=$TOTAL_LINES/4
split -l $SPLIT_SIZE to_process

exit 0

# extract lat longs, filter only those looking like iphone screen sized ones and emit centres
cat xaa | ./lat_longs.rb | ./iphone_centres.rb | sort > xaa.lat_long_pair &
cat xab | ./lat_longs.rb | ./iphone_centres.rb | sort > xab.lat_long_pair &
cat xac | ./lat_longs.rb | ./iphone_centres.rb | sort > xac.lat_long_pair &
cat xad | ./lat_longs.rb | ./iphone_centres.rb | sort > xad.lat_long_pair &
wait

# collate output
cat xa[abcd].lat_long_pair | sort -m | uniq -c | tabify_uniq_out.rb > freq_lat_long

# merc projection and bucketing
TOTAL_LINES=`cat freq_lat_long | wc -l`
let SPLIT_SIZE=$TOTAL_LINES/4
split -l $SPLIT_SIZE freq_lat_long
cat freq_lat_long | ./lat_long_to_merc_and_bucket.rb 0.005 > freq_lat_bucket_long_bucket

#collapse lat long buckets together
rm freq_lat_bucket_long_bucket.flatten
pig -x local -p input=freq_lat_bucket_long_bucket -p output=freq_lat_bucket_long_bucket.flatten flatten_freq_lat_long.pig

# make the map
./heat_map.rb freq_lat_bucket_long_bucket.flatten 0.005 test.jpg

