create database ashutoshkumar;


-- TOTAL COMPLETED TRIPS
select count(*) as completed_trips
from trip_details
where end_ride = 1;
-- 983 trips have taken place

-- TOTAL TRIPS
select count(*) as total_trips from trips;
-- 983 trips have taken place

-- DATA CLEANING
-- check for duplciates. No duplicates found
select * from
(select *, row_number() over (partition by tripid) as rnk , count(tripid)
from trips) a
having rnk > 1;

-- TOTAL DRIVERS
select count(distinct driverid) as total_drivers
from trips;
-- 30 drivers are found

-- TOTAL EARNINGS
select sum(fare) as total_earnings
from trips;
-- 751343 Rs is the total earnings

-- TOTAL SEARCHES
select sum(searches) as total_searches
from trip_details;
-- 2161 searches

-- TOTAL SEARCHES WHICH GOT ESTIMATE
select sum(searches) as total_search_estimate
from trip_details
where searches_got_estimate = 1;
-- 1758 searches got estimate

-- TOTAL SEARCHES FOR QUOTES
select sum(searches_got_quotes) as total_search_quotes
from trip_details;
-- 1277 searches got quotes

-- TOTAL TRIPS CANCELLED BY DRIVERS
select count(*) - sum(driver_not_cancelled) as driver_cancellations
from trip_details;
-- 1021 trips cancelled by drivers

-- TOTAL OTP Entered
select sum(otp_entered)
from trip_details;
-- 983 OTP Entered

-- TOTAL END RIDE
select sum(end_ride) as total_end_ride
from trip_details;
-- 983 rides have ended

-- AVERAGE DISTANCE PER TRIP
select round(avg(distance),0) as avg_dist_trips
from trips;
-- 14 kgms is the avg distance trip

-- AVERAGE FARE PER TRIP
select round(avg(fare),0) as avg_fare
from trips;
-- Rs.764 is the average fare trip

-- TOTAL DISTANCE TRAVELLED
select sum(distance) as total_trip_distance
from trips;
-- 14148 kms is the total trip distance

-- FREQUENTLY USED PAYMENT METHOD
select p.id, p.method , count(*) as no_of_transactions
from payment p
join trips t
on p.id = t.faremethod
group by p.id
order by count(*) desc
limit 1;
-- credit card has the highest (262) no of transactions

-- highest single payment made through which payment method
select t.faremethod, max(fare) as maximum_fare, p.method
from trips t
join payment p 
on t.faremethod = p.id;
-- Highest single paid trip was made through credit card

-- Highest payments through methods
select sum(fare) as total_fare_amt, p.method as payment_method
from trips t
join 
payment p
on t.faremethod = p.id
group by p.id
order by sum(fare) desc
limit 1;
-- Rs.197941 is the highest fare amount through credit card

-- which two locations had the most trips
select * from
(select * , dense_rank() over (order by total_trips desc) as rnk from
(select loc_from,loc_to, count(distinct tripid) as total_trips
from trips
group by loc_from,loc_to
order by total_trips desc) b) c
where rnk = 1 ;
-- loc from 16 to 21 and 35 to 5 had the most number of trips i.e 5 

-- TOP 5 EARNING DRIVERS
select * from
(select * , dense_rank() over (order by total_fare desc) as rnk from
(select driverid, sum(fare) as total_fare
from trips
group by driverid
order by sum(fare) desc) a ) b
having rnk between 1 and 5;
-- Driver id 12,8,21,24 and 30 are the top 5 earning drivers

-- DURATION HAVING MOST TRIPS
select * from
(select * , rank() over(order by total_trips desc) as rnk from
(select duration, count(*) as total_trips
from trips
group by duration
order by total_trips desc)a) b
where rnk = 1;
-- Duration 1 had the most trips i.e 53

-- HIGHEST DRIVER CUSTOMER PAIRS
select * from
(select *, dense_rank() over(order by total_trips desc) as rnk from
(select driverid,custid, count(distinct tripid) as total_trips
from trips
group by driverid,custid
order by total_trips desc) a) b
where rnk = 1;
-- driver id 17 and cust id - total trips 4 
-- driver id 28 and cust id - total trips 4

-- SEARCH TO ESTIMATE RATE	
select sum(searches) as sum_searches, sum(searches_got_estimate) as sum_estimate, round(sum(searches_got_estimate)/ sum(searches)*100,2) as search_estimate_rate_pct
from trip_details;
-- 81.35%

-- ESTIMATE TO SEARCH FOR QUOTES RATE
select sum(searches_got_estimate) as search_estimate, sum(searches_for_quotes) as searches_quote, round(sum(searches_for_quotes)/sum(searches_got_estimate)*100,2) 
from trip_details; 
-- 82.76%

-- WHICH AREA GOT THE HIGHEST FARES
select loc_from from
(select *, rank() over (order by total_fare desc) as rnk from
(select loc_from, sum(fare) as total_fare 
from trips
group by loc_from
order by total_fare desc) a) b
where rnk = 1;
-- Loc_from = 6 i.e Bangalore South got the highest fares

-- WHICH AREA GOT THE HIGHEST DRIVER CANCELLATION
select * from
(select * , rank() over (order by cancellations desc) as rnk from
(select loc_from, count(*) - sum(driver_not_cancelled) as cancellations
from trip_details
group by loc_from
order by cancellations desc) a ) b
where rnk = 1;
-- loc_from is 1 i.e Mahadevpura 

-- WHICH AREA GOT THE HIGHEST CUSTOMER CANCELLATION
select * from
(select * , rank() over (order by cancellations desc) as rnk from
(select loc_from, count(*) - sum(customer_not_cancelled) as cancellations
from trip_details
group by loc_from
order by cancellations desc) a ) b
where rnk = 1;
-- loc_from is 4 i.e CV Raman Nagar

-- WHICH DURATION GOT THE HIGHEST FARES
select * from
(select * , rank() over (order by total_fare desc) as rnk from
(select duration, sum(fare) as total_fare
from trips
group by duration
order by total_fare desc) a ) b
where rnk = 1;
-- duration is 12-1 AM 

-- WHICH DURATION GOT THE HIGHEST NUMBER OF TRIPS
select * from
(select * , rank() over (order by total_trips desc) as rnk from
(select duration, count(distinct tripid) as total_trips
from trips
group by duration
order by total_trips desc) a ) b
where rnk = 1;
-- Duration 12 AM to 1 AM had the most number of trips i.e 53

