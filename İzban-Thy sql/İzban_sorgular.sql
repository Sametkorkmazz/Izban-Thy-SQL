select distinct le_dpt.start_date as Biniş_saati,le_dpt.start_date + interval (le_arr.leg_no - le_dpt.leg_no )* 5 minute as İniş_saati,le_dpt.departure_station_name as Biniş_istasyonu
,le_arr.arrival_station_name as İniş_istasyonu,tr.type as yolculuk_tipi
from leg_instance le_dpt , leg_instance le_arr, trip tr, leg
where le_dpt.departure_station_name = 'Bayraklı' and le_arr.arrival_station_name = 'Belevi' and le_dpt.Trip_id = leg.trip_id and le_dpt.leg_no = leg.leg_no and leg.trip_id = tr.id 
and hour(le_dpt.start_date) between 12 and 12;
select l.trip_id,l.leg_no,l.scheduled_departure_station_name kalkış_yeri,l.scheduled_arrival_station_name varış_yeri from leg; 