# -----------------------------ANSWERS ----------------------------


# ANSWER -1  -------------> (Total Trips)

select count(tripid) Total_trips from trips_details;  # ---> These are all trips, whether completed or searched or not started, i.e., everything


# ANSWER -2  -------------> (Total Drivers)

select count(distinct(driverid)) Total_Drivers from trips ;


# ANSWER -3  -------------> (Total Earnings)

select sum(fare) Total_Earnings from trips;

# ANSWER -4  -------------> (Total Completed Trips)

select count(distinct(tripid)) from trips; # --> these are only successful trips table




# ANSWER -5  -------------> (Total Searches)

select sum(searches) Total_searches from trips_details;


# ANSWER -6  -------------> (Total Seacheds which got estimate)

select sum(searches_got_estimate) from trips_details;

# ANSWER -7  -------------> (Total Searches for quotes)

select sum(searches_for_quotes) from trips_details;


# ANSWER -8  -------------> (Total Trips cancelled by drivers)

SELECT count(*)-sum(driver_not_cancelled) from trips_details;

#    		OR       


SELECT 	count(driver_not_cancelled) from trips_details where driver_not_cancelled=0;




# ANSWER -9  -------------> (Total OTP Entered)

select sum(otp_entered) Total_OTPS from trips_details;


# ANSWER -10  -------------> (Total End Ride)

select sum(end_ride) End_Ride from trips_details;	


# ANSWER -11  -------------> (Average Distance Per Ride)

select avg(distance) Avg_Ride from trips;



# ANSWER -12  -------------> (Avearge Fare Per Trip)

select avg(fare) Avarage_Fare from trips;


# ANSWER -13  -------------> (Distance Travelled )

select sum(distance) Total_Distance_Travelled from trips;



# ANSWER -14  -------------> (Most Used Payment Method)


select  p.method from  
(select faremethod,count(distinct tripid)  cnt from trips group by faremethod order by cnt desc limit 1) a join payment p on a.faremethod=p.id;


# ANSWER - 15  -------------> (Highest payment was made through which instrument?)

select p.method from 
(select faremethod,fare from trips order by fare desc limit 1) a join payment p on a.faremethod=p.id;

# To see the total highest payment made and by which method from entire data :-

select faremethod, sum(fare) total_fare from trips group by faremethod order by total_fare desc limit 1;

# ANSWER - 16  -------------> (Which 2 locations had the most trips?)

select * from
(select *, dense_rank() over(order by trips desc) rnk from 
(select loc_from,loc_to,count(distinct tripid) trips from trips group by loc_from,loc_to order by trips desc)c) a where rnk=1; 

# NOTE -- we could also use the sub-query here and take limit 2 for finding the most 2 trips locations.




# ANSWER - 16  -------------> (Top 5 earning drivers)

(select driverid,sum(fare) fare from trips group by driverid order by fare desc) limit 5;


#     OR 

select * from 
(select *, dense_rank() over (order by fare desc) rnk from 
(select driverid,sum(fare) fare from trips group by driverid order by fare desc) a ) b where rnk<=5;




# ANSWER - 17  -------------> (Which duration had more trips)

select * from 
(select duration,count(distinct tripid) cnt from trips group by duration order by cnt desc) a join duration d on a.duration=d.id limit 1;


# ANSWER - 18  -------------> (Which driver customer pair had more orders?)

select * from 
(select a.*,dense_rank() over(order by cnt desc) rnk from
(select driverid,custid,count(distinct tripid) cnt from trips group by driverid,custid) a) b where rnk=1;


# ANSWER - 19  -------------> (Search to estimate rate)

select (sum(searches_got_estimate)/sum(searches))*100 as Percentage from trips_details;


# ANSWER - 20  -------------> (Estimate to search for quote rates)

select * from trips_details;

select (sum(searches_for_quotes)/sum(searches_got_estimate))*100 from trips_details;


# ANSWER - 20  -------------> (Quote acceptance rate)

select * from trips_details;

select concat(round((sum(searches_got_quotes)/sum(searches_for_quotes)*100),2),'%') from trips_details;


# ANSWER - 21  -------------> (quotes to booking rate)

select (sum(customer_not_cancelled)/sum(searches_got_quotes))*100 from trips_details; 

# ANSWER - 22  -------------> (Which area got highest booking in which duration)

select * from 
(select a.*,dense_rank() over(partition by duration order by cnt desc) rnk from
(select duration,loc_from,count(distinct tripid) cnt from trips group by duration,loc_from) a) b where rnk=1 ;



# ANSWER - 23  -------------> (Which area got highest fares,cancellation,trips)

select * from trips;


# PART - 1 -->
select loc_from, sum(fare) total_fare from trips group by loc_from order by total_fare desc limit 1;

# PART - 2 --> Trips cancelled by drivers 


select loc_from,count(driver_not_cancelled) cnt from trips_details  where driver_not_cancelled=0 group by loc_from order by cnt desc limit 1;

# OR ------->

select loc_from,count(*)-sum(driver_not_cancelled) cnt from trips_details group by loc_from order by cnt desc limit 1;

#  -------------------------


# For trips cancelled by customers :-

select loc_from,count(*)-sum(customer_not_cancelled) cnt from trips_details group by loc_from order by cnt desc limit 1;


# ANSWER - 24  -------------> (Which duration got the highest trips and fares)

select * from trips;

# PART - 1 ---> Duration having the highet trips :-

select duration,count(distinct tripid) cnt from trips group by duration order by cnt desc limit 1;

# PART - 2 ---> Duration having the highest fares :-  

select duration, sum(fare) fare from trips group by duration order by fare desc limit 1;