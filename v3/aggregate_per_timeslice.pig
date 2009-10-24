pts = load 'x_y_points/part-00000' as (timeslice:int, x:float, y:float);    
pts2 = group pts by (timeslice,x,y);
pts3 = foreach pts2 generate $0, COUNT($1) ;
pts4 = foreach pts3 generate $0.$0, $0.$1, $0.$2, $1 as freq;
pts5 = order pts4 by timeslice;
store pts5 into 'aggregated_freqs';

mm_freq = foreach pts4 generate timeslice, freq; 
mm_freq2 = group mm_freq by timeslice;
mm_freq3 = foreach mm_freq2 { generate group, MIN(mm_freq.freq) as min, MAX(mm_freq.freq) as max; }
store mm_freq3 into 'mm_freqs';
