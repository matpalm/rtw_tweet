pts = load 'x_y_points/part-00000' as (timeslice:int, x:float, y:float);    
pts2 = group pts by (timeslice,x,y);
pts3 = foreach pts2 generate group as ts_x_y, COUNT(pts) as freq ;
pts4 = foreach pts3 generate ts_x_y.timeslice, ts_x_y.x, ts_x_y.y, freq;
pts5 = order pts4 by timeslice;
store pts5 into 'aggregated_freqs';


