drop schema if exists THY_IZBAN;

create schema THY_IZBAN;
use THY_IZBAN;

create table citizen (
Fname varchar(20),
Lname varchar(20),
E_mail varchar(30),
Tc char(11) primary key
);

create table turkiye_card(
Card_id char(9) primary key,
balance float,
type varchar(20),
Owner_id char(11) not null,
constraint turkiye_card_owner foreign key (owner_id) references citizen (TC)
);

create table travel_history(
Travel_code int primary key,
Card_id char(9),
trip_id char(4) not null,
leg_no int not null,
start_date timestamp not null,
end_date timestamp not null,
price float,
type varchar(20),
constraint travel_historyFK foreign key (Card_id) references turkiye_card (card_id)
);

create table travel_history_with_ticket (
Travel_code int,
ticket_id int unique,
Card_id char(9),
trip_id char(4) not null,
leg_no int not null,
start_date timestamp not null,
end_date timestamp not null,
price float,
seat_no char(4),
package varchar(20),
Lname varchar(20),
Type varchar(20),
constraint ticketPK primary key (Travel_code,ticket_id),
constraint travel_history_ticketFK foreign key (Card_id) references turkiye_card (card_id)
);

create table travel_history_without_ticket (
Travel_code int primary key,
trip_id char(4) not null,
leg_no int not null,
start_date timestamp not null,
end_date timestamp not null,
price float,
Card_id char(9),
constraint travel_history_without_ticketFK foreign key (Card_id) references turkiye_card (card_id)
);

create table trip (
type varchar(30),
destination varchar(80),
Id char(8) primary key,
operator varchar(30),
weekdays varchar(21)
);

create table leg (
Trip_id char(8),
leg_no int,
scheduled_departure_station_name varchar(50),
scheduled_departure_station_country varchar(50),
scheduled_arrival_station_name varchar(50),
scheduled_arrival_station_country varchar(50),
constraint leg_PK primary key (Trip_id,leg_no),
constraint leg_FK foreign key (trip_id) references trip(id)
);

create table leg_instance(
Trip_id char(8),
leg_no int,
start_date timestamp,
end_date timestamp,
departure_station_name varchar(50),
departure_station_country varchar(50),
arrival_station_name varchar(50),
arrival_station_country varchar(50),
Assigned_vehicle_model varchar(11),
constraint leg_instancePK primary key (trip_id,leg_no,start_date,end_date),
constraint leg_instanceFK foreign key (trip_id,leg_no) references leg (trip_id,leg_no)
);

create table station(
Name varchar(30),
country varchar(30),
city varchar(30),
adress varchar(80),
type varchar(20),
transfer varchar(30),
constraint station_PK primary key (name,country)
);

create table izban_station_fee(
Name varchar(30),
country varchar(30),
card_type varchar(20),
price float,
constraint fee_PK primary key (name,country,card_type,price),
constraint station_feeFK foreign key (name,country) references station(name,country)
);

create table izban_bus_transport_list(
Name varchar(30),
country varchar(30),
bus_number int,
constraint bus_PK primary key (name,country,bus_number),
constraint bus_PK foreign key (name,country) references station(name,country)
);

create table vehicle (
Model varchar(30) primary key,
company varchar(30),
max_capacity int,
type varchar(15)
);

create table seat (
Trip_id char(4),
leg_no int,
start_date timestamp,
end_date timestamp,
seat_no varchar(4),
type varchar(20),
cabin varchar(20),
window_side bool,
constraint seat_PK primary key (Trip_id,leg_no,start_date ,end_date ,seat_no),
foreign key seat_fk (trip_id,leg_no,start_date,end_date) references leg_instance (trip_id,leg_no,start_date,end_date)

);

create table flight_package(
Name varchar(20) primary key,
Cabin_baggage int,
baggage_allowance int,
meal_type varchar(20),
seat_selection bool,
type varchar(30)
);

create table offered_packages_for_flight(
package_name varchar(20),
trip_id char(4),
constraint PK primary key (package_name,trip_id),
constraint fk foreign key (package_name) references flight_package (name),
constraint fk2 foreign key (trip_id) references trip(ID)
);

alter table travel_history 
add constraint history_leg_FK foreign key (trip_id,leg_no,start_date,end_date) references leg_instance(trip_id,leg_no,start_date,end_date);

alter table travel_history_without_ticket 
add constraint history_no_ticket_leg_FK foreign key (trip_id,leg_no,start_date,end_date) references leg_instance(trip_id,leg_no,start_date,end_date);

alter table travel_history_with_ticket
add constraint ticket_history_packageFK foreign key (package) references flight_package (name);

alter table travel_history_with_ticket 
add constraint ticket_history_legFK foreign key (trip_id,leg_no,start_date,end_date) references leg_instance(trip_id,leg_no,start_date,end_date);

alter table travel_history_with_ticket
add constraint ticket_history_seatFK foreign key (trip_id,leg_no,start_date,end_date,seat_no) references seat(trip_id,leg_no,start_date,end_date,seat_no);

alter table leg_instance
add constraint leg_instance_vehicleFK foreign key (Assigned_vehicle_model) references vehicle(model);

alter table leg_instance
add constraint leg_instance_arrival_stationFK foreign key (arrival_station_name,arrival_station_country) references station(name,country);
 
alter table leg_instance
add constraint leg_instance_departure_stationFK foreign key (departure_station_name,departure_station_country) references station(name,country);
 
alter table leg
add constraint leg_scheduled_arrival_stationFK foreign key (scheduled_arrival_station_name,scheduled_arrival_station_country) references station(name,country);
 
alter table leg
add constraint leg_scheduled_departure_stationFK foreign key (scheduled_departure_station_name,scheduled_departure_station_country) references station(name,country);
 




