#mkdir json_stream
#cp twitter_streamed_files json_stream
set -x

rm -rf locations
hadoop jar $HADOOP_STREAMING_JAR -mapper extract_locations.rb -reducer /bin/cat -input json_stream -output locations 

rm -rf lat_lons
hadoop jar $HADOOP_STREAMING_JAR -mapper extract_lat_longs_from_locations.rb -reducer /bin/cat -input locations -output lat_lons

rm -rf x_y_points
hadoop jar $HADOOP_STREAMING_JAR -mapper lat_long_to_merc_and_bucket.rb -reducer /bin/cat -input lat_lons -output x_y_points -cmdenv BUCKET_SIZE=0.005

rm freqs min_max
pig -x local -f freqs.pig

#./heat_map.rb min_max freqs 0.005 heat_map.jpg

rm timeslices_freq.latlon
pig -x local -f timeslices_freq.latlon.pig
cat timeslices_freq.latlon | sort -n > t
mv t timeslices_freq.latlon

rm -rf timeslices_freq.all_
hadoop jar $HADOOP_STREAMING_JAR -mapper extract_created_at.rb -reducer 'uniq -c' -input json_stream -output timeslices_freq.all_
cat timeslices_freq.all_/part-00000 | perl -plne's/\s+(\d+) (\d+)/$2\t$1/' | sort -n > timeslices_freq.all

R --vanilla < timeslices_freq.graphs.r

rm aggregated_freqs mm_freqs
pig -x local -f aggregate_per_timeslice.pig
