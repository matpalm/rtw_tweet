pts = load 'x_y_points/part-00000' as (time_slice:int, x:float, y:float);
buckets = group pts by (x,y); 
freq = foreach buckets { generate group, SIZE(pts) as size; }
store freq into 'freqs';
freqs = group freq all;
min_max = foreach freqs { generate MAX(freq.size) as max, MIN(freq.size) as min; };
store min_max into 'min_max';

