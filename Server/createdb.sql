DROP TABLE IF EXISTS passenger CASCADE;
DROP TABLE IF EXISTS credit_card CASCADE;
DROP TABLE IF EXISTS booking CASCADE;
DROP TABLE IF EXISTS airport CASCADE;
DROP TABLE IF EXISTS ticket CASCADE;
DROP TABLE IF EXISTS aircraft CASCADE;
DROP TABLE IF EXISTS flight CASCADE;
DROP TABLE IF EXISTS pilot CASCADE;
DROP TABLE IF EXISTS standby CASCADE;
DROP TABLE IF EXISTS cargo CASCADE;
DROP TABLE IF EXISTS discount CASCADE;

CREATE TABLE passenger(
  id SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  date_of_birth TIMESTAMP NOT NULL
);

CREATE TABLE credit_card(
  card_number NUMERIC(16,0) PRIMARY KEY,
  name_on_card TEXT NOT NULL,
  expiration_month INTEGER NOT NULL,
  expiration_year INTEGER NOT NULL
);

CREATE TABLE discount(
  discount_code VARCHAR PRIMARY KEY,
  amount NUMERIC(7,2) NOT NULL
);

CREATE TABLE booking(
  book_ref TEXT PRIMARY KEY,
  card_number NUMERIC(16,0) REFERENCES credit_card(card_number) NOT NULL,
  discount_code VARCHAR REFERENCES discount(discount_code),
  amount NUMERIC(7,2) NOT NULL,
  contact_email TEXT NOT NULL,
  contact_phone_number NUMERIC(10,0) NOT NULL,
  booking_date TIMESTAMP NOT NULL
);

CREATE TABLE aircraft(
  aircraft_code CHAR(3) PRIMARY KEY,
  model CHAR(25) NOT NULL,
  range INTEGER NOT NULL,
  economy_capacity INTEGER NOT NULL,
  economy_plus_capacity INTEGER NOT NULL,
  business_capacity INTEGER NOT NULL
);

CREATE TABLE airport(
  airport_code CHAR(3) PRIMARY KEY,
  airport_name CHAR(50) NOT NULL,
  city CHAR(20) NOT NULL,
  coordinates POINT,
  timezone TEXT
);

CREATE TABLE flight(
  id INTEGER PRIMARY KEY,
  aircraft_code CHAR(3) REFERENCES aircraft(aircraft_code) NOT NULL,
  boarding_time TIMESTAMP NOT NULL,
  departure_airport CHAR(3) REFERENCES airport(airport_code) NOT NULL,
  departure_gate INTEGER NOT NULL,
  scheduled_departure TIMESTAMP NOT NULL,
  arrival_airport CHAR(3) REFERENCES airport(airport_code) NOT NULL,
  arrival_gate INTEGER NOT NULL,
  scheduled_arrival TIMESTAMP NOT NULL,
  flight_status CHAR VARYING(20) NOT NULL,
  economy_booked INTEGER NOT NULL,
  economy_available INTEGER NOT NULL,
  economy_plus_booked INTEGER NOT NULL,
  economy_plus_available INTEGER NOT NULL,
  business_booked INTEGER NOT NULL,
  business_available INTEGER NOT NULL,
  meal BOOLEAN NOT NULL,
  movie BOOLEAN NOT NULL
  CONSTRAINT flight_check CHECK ((scheduled_arrival > scheduled_departure))
  CONSTRAINT boarding_check CHECK ((scheduled_departure > boarding_time))
);

CREATE TABLE ticket(
  id SERIAL PRIMARY KEY,
  book_ref TEXT REFERENCES booking(book_ref) NOT NULL,
  flight_id INTEGER REFERENCES flight(id) NOT NULL,
  passenger_id SERIAL REFERENCES passenger(id) NOT NULL,
  fare_condition CHAR VARYING(20) NOT NULL,
  boarding_no SERIAL NOT NULL,
  check_in_time TIMESTAMP
);

CREATE TABLE pilot(
  id SERIAL PRIMARY KEY,
  flight_id INTEGER REFERENCES flight(id) NOT NULL,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL
);

CREATE TABLE standby(
  flight_id INTEGER REFERENCES flight(id) NOT NULL,
  position SERIAL PRIMARY KEY,
  passenger_id INTEGER REFERENCES passenger(id) NOT NULL
);

CREATE TABLE cargo(
  stock_keeping_no SERIAL PRIMARY KEY,
  flight_id INTEGER REFERENCES flight(id) NOT NULL,
  passenger_id INTEGER REFERENCES passenger(id) NOT NULL
);



/** airport **/
INSERT INTO airport
VALUES (
  'ATL',
  'Hartsfield-Jackson Atlanta International Airport',
  'Atlanta',
  '(33.64,-84.43)',
  'GMT -5:00'
);

INSERT INTO airport
VALUES (
  'LAX',
  'Los Angeles International Airport',
  'Los Angeles',
  '(33.94,-118.41)',
  'GMT -8:00'
);

INSERT INTO airport
VALUES (
  'ORD',
  'Chicago O`Hare International Airport',
  'Chicago',
  '(41.98,-87.90)',
  'GMT -6:00'
);

INSERT INTO airport
VALUES (
  'DFW',
  'Dallas/Fort Worth International Airport',
  'Dallas',
  '(32.90,-97.04)',
  'GMT -6:00'
);

INSERT INTO airport
VALUES (
  'DEN',
  'Denver International Airport',
  'Denver',
  '(39.86,-104.67)',
  'GMT -7:00'
);

INSERT INTO airport
VALUES (
  'JFK',
  'John F Kennedy International Airport',
  'New York',
  '(40.64,-73.78)',
  'GMT -5:00'
);

INSERT INTO airport
VALUES (
  'SFO',
  'San Francisco International Airport',
  'San Francisco',
  '(37.62,-122.38)',
  'GMT -8:00'
);

INSERT INTO airport
VALUES (
  'SEA',
  'Seattle Tacoma International Airport',
  'Seattle',
  '(47.45,-122.31)',
  'GMT -8:00'
);

INSERT INTO airport
VALUES (
  'LAS',
  'McCarran International Airport',
  'Las Vegas',
  '(36.08,-115.15)',
  'GMT -8:00'
);

INSERT INTO airport
VALUES (
  'MCO',
  'Orlando International Airport',
  'Orlando',
  '(28.43,-81.31)',
  'GMT -5:00'
);

/** aircraft **/
INSERT INTO aircraft
VALUES (
  '310',
  'Airbus A310',
  5002,
  100,
  100,
  100
);

INSERT INTO aircraft
VALUES (
  '318',
  'Airbus A318',
  3542,
  50,
  50,
  50
);

INSERT INTO aircraft
VALUES (
  '319',
  'Airbus A319',
  4287,
  50,
  50,
  50
);

INSERT INTO aircraft
VALUES (
  '321',
  'Airbus A321',
  3697,
  50,
  50,
  50
);

INSERT INTO aircraft
VALUES (
  '330',
  'Airbus A330',
  11750,
  100,
  100,
  100
);

INSERT INTO aircraft
VALUES (
  '340',
  'Airbus A340',
  7900,
  100,
  100,
  100
);

INSERT INTO aircraft
VALUES (
  '342',
  'Airbus A340-200',
  12400,
  100,
  100,
  100
);

INSERT INTO aircraft
VALUES (
  '343',
  'Airbus A340-300',
  13500,
  100,
  100,
  100
);

INSERT INTO aircraft
VALUES (
  '345',
  'Airbus A340-500',
  16670,
  100,
  100,
  100
);

INSERT INTO aircraft
VALUES (
  '346',
  'Airbus A340-600',
  14450,
  100,
  100,
  100
);

/**flight**/
INSERT INTO flight
VALUES (
'1000',
'318',
'2020-12-10 10:30:00',
'ATL',
87,
'2020-12-10 11:00:00',
'DFW',
29,
'2020-12-10 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1000',
'Noah',
'Harris'
);


INSERT INTO flight
VALUES (
'1001',
'343',
'2020-12-10 11:30:00',
'DFW',
102,
'2020-12-10 12:00:00',
'LAX',
77,
'2020-12-10 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1001',
'Mason',
'Garcia'
);


INSERT INTO flight
VALUES (
'1002',
'343',
'2020-12-10 06:30:00',
'LAX',
64,
'2020-12-10 07:00:00',
'JFK',
29,
'2020-12-10 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1002',
'James',
'Brown'
);


INSERT INTO flight
VALUES (
'1003',
'340',
'2020-12-10 08:30:00',
'DFW',
60,
'2020-12-10 09:00:00',
'LAS',
33,
'2020-12-10 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1003',
'James',
'Davis'
);


INSERT INTO flight
VALUES (
'1004',
'345',
'2020-12-10 10:30:00',
'JFK',
109,
'2020-12-10 11:00:00',
'LAS',
40,
'2020-12-10 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1004',
'James',
'Garcia'
);


INSERT INTO flight
VALUES (
'1005',
'346',
'2020-12-10 11:30:00',
'ATL',
27,
'2020-12-10 12:00:00',
'ORD',
7,
'2020-12-10 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1005',
'Ethan',
'Anderson'
);


INSERT INTO flight
VALUES (
'1006',
'340',
'2020-12-10 12:30:00',
'DEN',
81,
'2020-12-10 13:00:00',
'ORD',
69,
'2020-12-10 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1006',
'Alex',
'Davis'
);


INSERT INTO flight
VALUES (
'1007',
'345',
'2020-12-10 11:30:00',
'ORD',
83,
'2020-12-10 12:00:00',
'MCO',
33,
'2020-12-10 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1007',
'John',
'Anderson'
);


INSERT INTO flight
VALUES (
'1008',
'318',
'2020-12-10 12:30:00',
'ATL',
16,
'2020-12-10 13:00:00',
'DFW',
48,
'2020-12-10 16:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1008',
'Michael',
'Brown'
);


INSERT INTO flight
VALUES (
'1009',
'340',
'2020-12-10 03:30:00',
'SEA',
99,
'2020-12-10 04:00:00',
'LAS',
73,
'2020-12-10 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1009',
'Mason',
'Smith'
);


INSERT INTO flight
VALUES (
'1010',
'330',
'2020-12-10 08:30:00',
'LAX',
77,
'2020-12-10 09:00:00',
'ATL',
55,
'2020-12-10 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1010',
'Alex',
'Brown'
);


INSERT INTO flight
VALUES (
'1011',
'318',
'2020-12-10 08:30:00',
'ORD',
10,
'2020-12-10 09:00:00',
'DFW',
86,
'2020-12-10 12:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1011',
'John',
'Davis'
);


INSERT INTO flight
VALUES (
'1012',
'310',
'2020-12-10 12:30:00',
'JFK',
12,
'2020-12-10 13:00:00',
'DFW',
28,
'2020-12-10 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1012',
'Liam',
'Anderson'
);


INSERT INTO flight
VALUES (
'1013',
'342',
'2020-12-10 06:30:00',
'JFK',
39,
'2020-12-10 07:00:00',
'ATL',
35,
'2020-12-10 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1013',
'Michael',
'Anderson'
);


INSERT INTO flight
VALUES (
'1014',
'345',
'2020-12-10 06:30:00',
'ORD',
70,
'2020-12-10 07:00:00',
'JFK',
84,
'2020-12-10 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1014',
'Jacob',
'Smith'
);


INSERT INTO flight
VALUES (
'1015',
'318',
'2020-12-10 04:30:00',
'ORD',
52,
'2020-12-10 05:00:00',
'LAX',
37,
'2020-12-10 07:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1015',
'Jacob',
'Garcia'
);


INSERT INTO flight
VALUES (
'1016',
'310',
'2020-12-10 08:30:00',
'SFO',
47,
'2020-12-10 09:00:00',
'ORD',
4,
'2020-12-10 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1016',
'Noah',
'Davis'
);


INSERT INTO flight
VALUES (
'1017',
'310',
'2020-12-10 07:30:00',
'SFO',
93,
'2020-12-10 08:00:00',
'ORD',
23,
'2020-12-10 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1017',
'Michael',
'Lee'
);


INSERT INTO flight
VALUES (
'1018',
'319',
'2020-12-10 08:30:00',
'MCO',
92,
'2020-12-10 09:00:00',
'ATL',
39,
'2020-12-10 12:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1018',
'Jacob',
'Thomas'
);


INSERT INTO flight
VALUES (
'1019',
'340',
'2020-12-10 10:30:00',
'LAS',
8,
'2020-12-10 11:00:00',
'ORD',
15,
'2020-12-10 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1019',
'James',
'Smith'
);


INSERT INTO flight
VALUES (
'1020',
'318',
'2020-12-10 09:30:00',
'DFW',
60,
'2020-12-10 10:00:00',
'JFK',
66,
'2020-12-10 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1020',
'Jacob',
'Miller'
);


INSERT INTO flight
VALUES (
'1021',
'318',
'2020-12-10 05:30:00',
'SFO',
73,
'2020-12-10 06:00:00',
'ORD',
63,
'2020-12-10 08:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1021',
'Mason',
'Davis'
);


INSERT INTO flight
VALUES (
'1022',
'318',
'2020-12-10 06:30:00',
'SEA',
65,
'2020-12-10 07:00:00',
'DEN',
68,
'2020-12-10 10:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1022',
'Noah',
'Wang'
);


INSERT INTO flight
VALUES (
'1023',
'330',
'2020-12-10 09:30:00',
'LAX',
46,
'2020-12-10 10:00:00',
'DFW',
28,
'2020-12-10 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1023',
'Liam',
'Smith'
);


INSERT INTO flight
VALUES (
'1024',
'330',
'2020-12-10 11:30:00',
'LAS',
60,
'2020-12-10 12:00:00',
'ORD',
11,
'2020-12-10 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1024',
'Ethan',
'Wang'
);


INSERT INTO flight
VALUES (
'1025',
'343',
'2020-12-10 06:30:00',
'DEN',
30,
'2020-12-10 07:00:00',
'ORD',
103,
'2020-12-10 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1025',
'Ethan',
'Lee'
);


INSERT INTO flight
VALUES (
'1026',
'346',
'2020-12-10 08:30:00',
'DFW',
92,
'2020-12-10 09:00:00',
'LAS',
25,
'2020-12-10 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1026',
'Noah',
'Brown'
);


INSERT INTO flight
VALUES (
'1027',
'319',
'2020-12-10 10:30:00',
'MCO',
16,
'2020-12-10 11:00:00',
'LAS',
29,
'2020-12-10 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1027',
'John',
'Thomas'
);


INSERT INTO flight
VALUES (
'1028',
'340',
'2020-12-10 08:30:00',
'ATL',
48,
'2020-12-10 09:00:00',
'ORD',
103,
'2020-12-10 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1028',
'William',
'Davis'
);


INSERT INTO flight
VALUES (
'1029',
'310',
'2020-12-10 05:30:00',
'JFK',
76,
'2020-12-10 06:00:00',
'ORD',
15,
'2020-12-10 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1029',
'Ethan',
'Wang'
);


INSERT INTO flight
VALUES (
'1030',
'330',
'2020-12-10 11:30:00',
'DEN',
49,
'2020-12-10 12:00:00',
'ORD',
22,
'2020-12-10 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1030',
'Ethan',
'Miller'
);


INSERT INTO flight
VALUES (
'1031',
'342',
'2020-12-10 10:30:00',
'LAS',
43,
'2020-12-10 11:00:00',
'SEA',
6,
'2020-12-10 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1031',
'William',
'Garcia'
);


INSERT INTO flight
VALUES (
'1032',
'319',
'2020-12-10 09:30:00',
'LAX',
71,
'2020-12-10 10:00:00',
'LAS',
108,
'2020-12-10 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1032',
'James',
'Lee'
);


INSERT INTO flight
VALUES (
'1033',
'346',
'2020-12-10 06:30:00',
'MCO',
67,
'2020-12-10 07:00:00',
'JFK',
8,
'2020-12-10 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1033',
'Alex',
'Brown'
);


INSERT INTO flight
VALUES (
'1034',
'343',
'2020-12-10 06:30:00',
'ATL',
31,
'2020-12-10 07:00:00',
'SEA',
4,
'2020-12-10 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1034',
'Liam',
'Lee'
);


INSERT INTO flight
VALUES (
'1035',
'346',
'2020-12-10 03:30:00',
'LAS',
16,
'2020-12-10 04:00:00',
'SEA',
93,
'2020-12-10 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1035',
'William',
'Davis'
);


INSERT INTO flight
VALUES (
'1036',
'310',
'2020-12-10 07:30:00',
'DEN',
5,
'2020-12-10 08:00:00',
'ATL',
68,
'2020-12-10 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1036',
'Alex',
'Wang'
);


INSERT INTO flight
VALUES (
'1037',
'342',
'2020-12-10 04:30:00',
'LAS',
91,
'2020-12-10 05:00:00',
'LAX',
63,
'2020-12-10 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1037',
'John',
'Wang'
);


INSERT INTO flight
VALUES (
'1038',
'321',
'2020-12-10 04:30:00',
'DEN',
36,
'2020-12-10 05:00:00',
'LAX',
106,
'2020-12-10 07:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1038',
'Liam',
'Brown'
);


INSERT INTO flight
VALUES (
'1039',
'310',
'2020-12-10 07:30:00',
'DFW',
25,
'2020-12-10 08:00:00',
'DEN',
96,
'2020-12-10 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1039',
'James',
'Brown'
);


INSERT INTO flight
VALUES (
'1040',
'340',
'2020-12-10 09:30:00',
'LAS',
57,
'2020-12-10 10:00:00',
'ORD',
104,
'2020-12-10 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1040',
'Alex',
'Thomas'
);


INSERT INTO flight
VALUES (
'1041',
'345',
'2020-12-10 03:30:00',
'LAX',
52,
'2020-12-10 04:00:00',
'SFO',
69,
'2020-12-10 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1041',
'Noah',
'Wang'
);


INSERT INTO flight
VALUES (
'1042',
'342',
'2020-12-10 04:30:00',
'DEN',
111,
'2020-12-10 05:00:00',
'JFK',
6,
'2020-12-10 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1042',
'Jacob',
'Brown'
);


INSERT INTO flight
VALUES (
'1043',
'319',
'2020-12-10 12:30:00',
'SFO',
32,
'2020-12-10 13:00:00',
'JFK',
5,
'2020-12-10 16:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1043',
'William',
'Wang'
);


INSERT INTO flight
VALUES (
'1044',
'310',
'2020-12-10 05:30:00',
'SEA',
63,
'2020-12-10 06:00:00',
'DFW',
39,
'2020-12-10 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1044',
'John',
'Wang'
);


INSERT INTO flight
VALUES (
'1045',
'330',
'2020-12-10 10:30:00',
'LAS',
84,
'2020-12-10 11:00:00',
'MCO',
21,
'2020-12-10 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1045',
'Mason',
'Brown'
);


INSERT INTO flight
VALUES (
'1046',
'343',
'2020-12-10 10:30:00',
'JFK',
99,
'2020-12-10 11:00:00',
'LAX',
93,
'2020-12-10 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1046',
'John',
'Garcia'
);


INSERT INTO flight
VALUES (
'1047',
'310',
'2020-12-10 12:30:00',
'JFK',
107,
'2020-12-10 13:00:00',
'ATL',
70,
'2020-12-10 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1047',
'Michael',
'Thomas'
);


INSERT INTO flight
VALUES (
'1048',
'346',
'2020-12-10 04:30:00',
'SFO',
96,
'2020-12-10 05:00:00',
'LAS',
32,
'2020-12-10 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1048',
'Michael',
'Brown'
);


INSERT INTO flight
VALUES (
'1049',
'342',
'2020-12-10 10:30:00',
'JFK',
76,
'2020-12-10 11:00:00',
'SFO',
98,
'2020-12-10 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1049',
'Jacob',
'Davis'
);


INSERT INTO flight
VALUES (
'1050',
'321',
'2020-12-10 04:30:00',
'LAX',
3,
'2020-12-10 05:00:00',
'ORD',
70,
'2020-12-10 07:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1050',
'James',
'Garcia'
);


INSERT INTO flight
VALUES (
'1051',
'319',
'2020-12-11 10:30:00',
'LAS',
81,
'2020-12-11 11:00:00',
'DEN',
9,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1051',
'Noah',
'Wang'
);


INSERT INTO flight
VALUES (
'1052',
'318',
'2020-12-11 03:30:00',
'ORD',
39,
'2020-12-11 04:00:00',
'ATL',
2,
'2020-12-11 06:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1052',
'Ethan',
'Harris'
);


INSERT INTO flight
VALUES (
'1053',
'342',
'2020-12-11 07:30:00',
'DFW',
70,
'2020-12-11 08:00:00',
'LAS',
110,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1053',
'Alex',
'Smith'
);


INSERT INTO flight
VALUES (
'1054',
'310',
'2020-12-11 08:30:00',
'JFK',
98,
'2020-12-11 09:00:00',
'LAS',
29,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1054',
'John',
'Brown'
);


INSERT INTO flight
VALUES (
'1055',
'321',
'2020-12-11 10:30:00',
'SFO',
93,
'2020-12-11 11:00:00',
'SEA',
87,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1055',
'Alex',
'Brown'
);


INSERT INTO flight
VALUES (
'1056',
'342',
'2020-12-11 04:30:00',
'ORD',
77,
'2020-12-11 05:00:00',
'DEN',
63,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1056',
'John',
'Brown'
);


INSERT INTO flight
VALUES (
'1057',
'346',
'2020-12-11 06:30:00',
'ORD',
96,
'2020-12-11 07:00:00',
'DEN',
50,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1057',
'Ethan',
'Brown'
);


INSERT INTO flight
VALUES (
'1058',
'318',
'2020-12-11 03:30:00',
'SEA',
43,
'2020-12-11 04:00:00',
'SFO',
10,
'2020-12-11 06:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1058',
'John',
'Smith'
);


INSERT INTO flight
VALUES (
'1059',
'310',
'2020-12-11 03:30:00',
'DEN',
56,
'2020-12-11 04:00:00',
'SFO',
58,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1059',
'James',
'Smith'
);


INSERT INTO flight
VALUES (
'1060',
'342',
'2020-12-11 06:30:00',
'LAS',
101,
'2020-12-11 07:00:00',
'ATL',
26,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1060',
'Michael',
'Brown'
);


INSERT INTO flight
VALUES (
'1061',
'330',
'2020-12-11 11:30:00',
'SFO',
12,
'2020-12-11 12:00:00',
'ATL',
109,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1061',
'Noah',
'Harris'
);


INSERT INTO flight
VALUES (
'1062',
'342',
'2020-12-11 09:30:00',
'SFO',
57,
'2020-12-11 10:00:00',
'ATL',
64,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1062',
'Mason',
'Smith'
);


INSERT INTO flight
VALUES (
'1063',
'310',
'2020-12-11 06:30:00',
'LAS',
33,
'2020-12-11 07:00:00',
'DFW',
13,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1063',
'William',
'Miller'
);


INSERT INTO flight
VALUES (
'1064',
'342',
'2020-12-11 07:30:00',
'ORD',
14,
'2020-12-11 08:00:00',
'LAS',
66,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1064',
'Michael',
'Thomas'
);


INSERT INTO flight
VALUES (
'1065',
'342',
'2020-12-11 11:30:00',
'DFW',
47,
'2020-12-11 12:00:00',
'LAX',
73,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1065',
'Ethan',
'Thomas'
);


INSERT INTO flight
VALUES (
'1066',
'340',
'2020-12-11 03:30:00',
'SEA',
20,
'2020-12-11 04:00:00',
'SFO',
36,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1066',
'Liam',
'Anderson'
);


INSERT INTO flight
VALUES (
'1067',
'346',
'2020-12-11 06:30:00',
'SEA',
13,
'2020-12-11 07:00:00',
'DEN',
7,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1067',
'James',
'Brown'
);


INSERT INTO flight
VALUES (
'1068',
'310',
'2020-12-11 05:30:00',
'LAX',
92,
'2020-12-11 06:00:00',
'JFK',
83,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1068',
'John',
'Thomas'
);


INSERT INTO flight
VALUES (
'1069',
'343',
'2020-12-11 08:30:00',
'MCO',
2,
'2020-12-11 09:00:00',
'ORD',
48,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1069',
'Michael',
'Brown'
);


INSERT INTO flight
VALUES (
'1070',
'321',
'2020-12-11 04:30:00',
'DFW',
78,
'2020-12-11 05:00:00',
'SFO',
43,
'2020-12-11 07:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1070',
'Michael',
'Wang'
);


INSERT INTO flight
VALUES (
'1071',
'345',
'2020-12-11 06:30:00',
'MCO',
25,
'2020-12-11 07:00:00',
'ORD',
83,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1071',
'Ethan',
'Davis'
);


INSERT INTO flight
VALUES (
'1072',
'346',
'2020-12-11 09:30:00',
'ORD',
74,
'2020-12-11 10:00:00',
'JFK',
106,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1072',
'Noah',
'Thomas'
);


INSERT INTO flight
VALUES (
'1073',
'310',
'2020-12-11 12:30:00',
'DFW',
110,
'2020-12-11 13:00:00',
'DEN',
51,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1073',
'Michael',
'Thomas'
);


INSERT INTO flight
VALUES (
'1074',
'310',
'2020-12-11 06:30:00',
'DEN',
94,
'2020-12-11 07:00:00',
'JFK',
85,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1074',
'John',
'Anderson'
);


INSERT INTO flight
VALUES (
'1075',
'321',
'2020-12-11 05:30:00',
'ORD',
105,
'2020-12-11 06:00:00',
'DFW',
110,
'2020-12-11 08:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1075',
'Michael',
'Brown'
);


INSERT INTO flight
VALUES (
'1076',
'321',
'2020-12-11 10:30:00',
'LAX',
99,
'2020-12-11 11:00:00',
'ATL',
46,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1076',
'William',
'Harris'
);


INSERT INTO flight
VALUES (
'1077',
'318',
'2020-12-11 12:30:00',
'DEN',
92,
'2020-12-11 13:00:00',
'LAS',
97,
'2020-12-11 16:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1077',
'James',
'Harris'
);


INSERT INTO flight
VALUES (
'1078',
'346',
'2020-12-11 03:30:00',
'DFW',
46,
'2020-12-11 04:00:00',
'MCO',
54,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1078',
'Liam',
'Thomas'
);


INSERT INTO flight
VALUES (
'1079',
'310',
'2020-12-11 05:30:00',
'ATL',
2,
'2020-12-11 06:00:00',
'MCO',
4,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1079',
'John',
'Davis'
);


INSERT INTO flight
VALUES (
'1080',
'345',
'2020-12-11 10:30:00',
'JFK',
64,
'2020-12-11 11:00:00',
'DEN',
83,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1080',
'Noah',
'Lee'
);


INSERT INTO flight
VALUES (
'1081',
'346',
'2020-12-11 07:30:00',
'MCO',
10,
'2020-12-11 08:00:00',
'ATL',
13,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1081',
'Liam',
'Harris'
);


INSERT INTO flight
VALUES (
'1082',
'318',
'2020-12-11 09:30:00',
'DEN',
26,
'2020-12-11 10:00:00',
'SEA',
74,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1082',
'Michael',
'Garcia'
);


INSERT INTO flight
VALUES (
'1083',
'330',
'2020-12-11 07:30:00',
'MCO',
94,
'2020-12-11 08:00:00',
'DEN',
81,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1083',
'John',
'Davis'
);


INSERT INTO flight
VALUES (
'1084',
'330',
'2020-12-11 04:30:00',
'SEA',
56,
'2020-12-11 05:00:00',
'ATL',
4,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1084',
'Noah',
'Brown'
);


INSERT INTO flight
VALUES (
'1085',
'318',
'2020-12-11 07:30:00',
'JFK',
70,
'2020-12-11 08:00:00',
'ORD',
44,
'2020-12-11 10:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1085',
'Liam',
'Davis'
);


INSERT INTO flight
VALUES (
'1086',
'318',
'2020-12-11 05:30:00',
'DEN',
84,
'2020-12-11 06:00:00',
'SFO',
53,
'2020-12-11 08:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1086',
'Liam',
'Garcia'
);


INSERT INTO flight
VALUES (
'1087',
'343',
'2020-12-11 04:30:00',
'LAS',
13,
'2020-12-11 05:00:00',
'ATL',
95,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1087',
'William',
'Lee'
);


INSERT INTO flight
VALUES (
'1088',
'340',
'2020-12-11 07:30:00',
'DFW',
18,
'2020-12-11 08:00:00',
'LAS',
80,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1088',
'Ethan',
'Miller'
);


INSERT INTO flight
VALUES (
'1089',
'340',
'2020-12-11 12:30:00',
'JFK',
38,
'2020-12-11 13:00:00',
'MCO',
99,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1089',
'Noah',
'Davis'
);


INSERT INTO flight
VALUES (
'1090',
'342',
'2020-12-11 11:30:00',
'DEN',
80,
'2020-12-11 12:00:00',
'DFW',
84,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1090',
'Alex',
'Lee'
);


INSERT INTO flight
VALUES (
'1091',
'342',
'2020-12-11 09:30:00',
'ATL',
17,
'2020-12-11 10:00:00',
'ORD',
4,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1091',
'Liam',
'Davis'
);


INSERT INTO flight
VALUES (
'1092',
'342',
'2020-12-11 03:30:00',
'MCO',
64,
'2020-12-11 04:00:00',
'JFK',
110,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1092',
'Alex',
'Smith'
);


INSERT INTO flight
VALUES (
'1093',
'346',
'2020-12-11 05:30:00',
'SEA',
18,
'2020-12-11 06:00:00',
'LAS',
3,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1093',
'Liam',
'Wang'
);


INSERT INTO flight
VALUES (
'1094',
'319',
'2020-12-11 11:30:00',
'DFW',
35,
'2020-12-11 12:00:00',
'JFK',
25,
'2020-12-11 15:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1094',
'Noah',
'Harris'
);


INSERT INTO flight
VALUES (
'1095',
'330',
'2020-12-11 12:30:00',
'JFK',
8,
'2020-12-11 13:00:00',
'DEN',
45,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1095',
'John',
'Smith'
);


INSERT INTO flight
VALUES (
'1096',
'310',
'2020-12-11 11:30:00',
'SEA',
86,
'2020-12-11 12:00:00',
'LAS',
2,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1096',
'Liam',
'Smith'
);


INSERT INTO flight
VALUES (
'1097',
'345',
'2020-12-11 07:30:00',
'LAX',
20,
'2020-12-11 08:00:00',
'SEA',
18,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1097',
'Jacob',
'Thomas'
);


INSERT INTO flight
VALUES (
'1098',
'321',
'2020-12-11 12:30:00',
'SFO',
16,
'2020-12-11 13:00:00',
'LAS',
95,
'2020-12-11 16:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1098',
'William',
'Miller'
);


INSERT INTO flight
VALUES (
'1099',
'343',
'2020-12-11 03:30:00',
'LAX',
68,
'2020-12-11 04:00:00',
'SEA',
57,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1099',
'William',
'Anderson'
);


INSERT INTO flight
VALUES (
'1100',
'330',
'2020-12-11 07:30:00',
'MCO',
8,
'2020-12-11 08:00:00',
'LAX',
25,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1100',
'Michael',
'Brown'
);


INSERT INTO flight
VALUES (
'1101',
'342',
'2020-12-11 03:30:00',
'SEA',
1,
'2020-12-11 04:00:00',
'DEN',
9,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1101',
'John',
'Miller'
);


INSERT INTO flight
VALUES (
'1102',
'342',
'2020-12-11 08:30:00',
'ORD',
10,
'2020-12-11 09:00:00',
'DFW',
13,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1102',
'Alex',
'Harris'
);


INSERT INTO flight
VALUES (
'1103',
'340',
'2020-12-11 07:30:00',
'ATL',
48,
'2020-12-11 08:00:00',
'LAS',
34,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1103',
'John',
'Davis'
);


INSERT INTO flight
VALUES (
'1104',
'318',
'2020-12-11 11:30:00',
'SFO',
44,
'2020-12-11 12:00:00',
'MCO',
39,
'2020-12-11 15:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1104',
'Liam',
'Anderson'
);


INSERT INTO flight
VALUES (
'1105',
'343',
'2020-12-11 10:30:00',
'ATL',
30,
'2020-12-11 11:00:00',
'JFK',
43,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1105',
'John',
'Harris'
);


INSERT INTO flight
VALUES (
'1106',
'343',
'2020-12-11 08:30:00',
'SEA',
34,
'2020-12-11 09:00:00',
'DFW',
95,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1106',
'Noah',
'Wang'
);


INSERT INTO flight
VALUES (
'1107',
'345',
'2020-12-11 10:30:00',
'LAX',
40,
'2020-12-11 11:00:00',
'DEN',
51,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1107',
'Michael',
'Thomas'
);


INSERT INTO flight
VALUES (
'1108',
'343',
'2020-12-11 07:30:00',
'MCO',
2,
'2020-12-11 08:00:00',
'ATL',
62,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1108',
'John',
'Lee'
);


INSERT INTO flight
VALUES (
'1109',
'330',
'2020-12-11 06:30:00',
'DFW',
8,
'2020-12-11 07:00:00',
'ATL',
94,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1109',
'Liam',
'Brown'
);


INSERT INTO flight
VALUES (
'1110',
'319',
'2020-12-11 06:30:00',
'LAX',
15,
'2020-12-11 07:00:00',
'DFW',
87,
'2020-12-11 10:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1110',
'James',
'Harris'
);


INSERT INTO flight
VALUES (
'1111',
'319',
'2020-12-11 09:30:00',
'MCO',
31,
'2020-12-11 10:00:00',
'DEN',
75,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1111',
'William',
'Thomas'
);


INSERT INTO flight
VALUES (
'1112',
'342',
'2020-12-11 04:30:00',
'LAS',
6,
'2020-12-11 05:00:00',
'SEA',
78,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1112',
'Michael',
'Lee'
);


INSERT INTO flight
VALUES (
'1113',
'346',
'2020-12-11 08:30:00',
'ORD',
85,
'2020-12-11 09:00:00',
'SFO',
68,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1113',
'Liam',
'Wang'
);


INSERT INTO flight
VALUES (
'1114',
'310',
'2020-12-11 12:30:00',
'ORD',
65,
'2020-12-11 13:00:00',
'DFW',
52,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1114',
'Michael',
'Brown'
);


INSERT INTO flight
VALUES (
'1115',
'330',
'2020-12-11 07:30:00',
'SEA',
46,
'2020-12-11 08:00:00',
'JFK',
27,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1115',
'Ethan',
'Brown'
);


INSERT INTO flight
VALUES (
'1116',
'321',
'2020-12-11 03:30:00',
'SFO',
59,
'2020-12-11 04:00:00',
'JFK',
28,
'2020-12-11 06:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1116',
'James',
'Brown'
);


INSERT INTO flight
VALUES (
'1117',
'318',
'2020-12-11 10:30:00',
'DFW',
91,
'2020-12-11 11:00:00',
'JFK',
84,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1117',
'James',
'Harris'
);


INSERT INTO flight
VALUES (
'1118',
'319',
'2020-12-11 12:30:00',
'LAS',
46,
'2020-12-11 13:00:00',
'ORD',
67,
'2020-12-11 16:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1118',
'William',
'Garcia'
);


INSERT INTO flight
VALUES (
'1119',
'318',
'2020-12-11 04:30:00',
'SFO',
103,
'2020-12-11 05:00:00',
'ORD',
64,
'2020-12-11 07:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1119',
'Noah',
'Miller'
);


INSERT INTO flight
VALUES (
'1120',
'330',
'2020-12-11 06:30:00',
'ATL',
32,
'2020-12-11 07:00:00',
'DEN',
94,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1120',
'Alex',
'Harris'
);


INSERT INTO flight
VALUES (
'1121',
'340',
'2020-12-11 08:30:00',
'SFO',
86,
'2020-12-11 09:00:00',
'ATL',
13,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1121',
'James',
'Smith'
);


INSERT INTO flight
VALUES (
'1122',
'343',
'2020-12-11 12:30:00',
'SFO',
99,
'2020-12-11 13:00:00',
'JFK',
96,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1122',
'Michael',
'Lee'
);


INSERT INTO flight
VALUES (
'1123',
'321',
'2020-12-11 07:30:00',
'SEA',
57,
'2020-12-11 08:00:00',
'SFO',
75,
'2020-12-11 10:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1123',
'Michael',
'Garcia'
);


INSERT INTO flight
VALUES (
'1124',
'321',
'2020-12-11 09:30:00',
'SEA',
86,
'2020-12-11 10:00:00',
'ATL',
77,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1124',
'Michael',
'Garcia'
);


INSERT INTO flight
VALUES (
'1125',
'346',
'2020-12-11 05:30:00',
'DFW',
73,
'2020-12-11 06:00:00',
'JFK',
111,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1125',
'Alex',
'Smith'
);


INSERT INTO flight
VALUES (
'1126',
'330',
'2020-12-11 11:30:00',
'MCO',
110,
'2020-12-11 12:00:00',
'LAX',
20,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1126',
'Liam',
'Davis'
);


INSERT INTO flight
VALUES (
'1127',
'310',
'2020-12-11 08:30:00',
'DEN',
80,
'2020-12-11 09:00:00',
'LAX',
74,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1127',
'Jacob',
'Wang'
);


INSERT INTO flight
VALUES (
'1128',
'310',
'2020-12-11 05:30:00',
'DFW',
87,
'2020-12-11 06:00:00',
'ATL',
30,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1128',
'John',
'Brown'
);


INSERT INTO flight
VALUES (
'1129',
'345',
'2020-12-11 12:30:00',
'LAX',
102,
'2020-12-11 13:00:00',
'DFW',
104,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1129',
'William',
'Brown'
);


INSERT INTO flight
VALUES (
'1130',
'330',
'2020-12-11 06:30:00',
'LAS',
59,
'2020-12-11 07:00:00',
'JFK',
92,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1130',
'William',
'Anderson'
);


INSERT INTO flight
VALUES (
'1131',
'342',
'2020-12-11 06:30:00',
'SEA',
17,
'2020-12-11 07:00:00',
'LAS',
79,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1131',
'Alex',
'Davis'
);


INSERT INTO flight
VALUES (
'1132',
'319',
'2020-12-11 10:30:00',
'ORD',
84,
'2020-12-11 11:00:00',
'DFW',
99,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1132',
'Mason',
'Lee'
);


INSERT INTO flight
VALUES (
'1133',
'321',
'2020-12-11 09:30:00',
'JFK',
46,
'2020-12-11 10:00:00',
'MCO',
62,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1133',
'Noah',
'Harris'
);


INSERT INTO flight
VALUES (
'1134',
'343',
'2020-12-11 09:30:00',
'DFW',
28,
'2020-12-11 10:00:00',
'ORD',
18,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1134',
'John',
'Anderson'
);


INSERT INTO flight
VALUES (
'1135',
'321',
'2020-12-11 07:30:00',
'DFW',
100,
'2020-12-11 08:00:00',
'LAS',
84,
'2020-12-11 10:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1135',
'Jacob',
'Harris'
);


INSERT INTO flight
VALUES (
'1136',
'321',
'2020-12-11 04:30:00',
'ATL',
46,
'2020-12-11 05:00:00',
'MCO',
9,
'2020-12-11 07:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1136',
'Ethan',
'Garcia'
);


INSERT INTO flight
VALUES (
'1137',
'342',
'2020-12-11 03:30:00',
'SFO',
71,
'2020-12-11 04:00:00',
'ATL',
83,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1137',
'James',
'Brown'
);


INSERT INTO flight
VALUES (
'1138',
'330',
'2020-12-11 03:30:00',
'DEN',
67,
'2020-12-11 04:00:00',
'MCO',
30,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1138',
'Ethan',
'Davis'
);


INSERT INTO flight
VALUES (
'1139',
'340',
'2020-12-11 04:30:00',
'SFO',
22,
'2020-12-11 05:00:00',
'ORD',
53,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1139',
'Ethan',
'Anderson'
);


INSERT INTO flight
VALUES (
'1140',
'330',
'2020-12-11 07:30:00',
'JFK',
9,
'2020-12-11 08:00:00',
'ATL',
81,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1140',
'Liam',
'Smith'
);


INSERT INTO flight
VALUES (
'1141',
'319',
'2020-12-11 06:30:00',
'ATL',
1,
'2020-12-11 07:00:00',
'LAX',
38,
'2020-12-11 10:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1141',
'William',
'Thomas'
);


INSERT INTO flight
VALUES (
'1142',
'346',
'2020-12-11 06:30:00',
'DFW',
21,
'2020-12-11 07:00:00',
'MCO',
108,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1142',
'Jacob',
'Lee'
);


INSERT INTO flight
VALUES (
'1143',
'342',
'2020-12-11 04:30:00',
'ATL',
40,
'2020-12-11 05:00:00',
'SFO',
53,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1143',
'Alex',
'Brown'
);


INSERT INTO flight
VALUES (
'1144',
'318',
'2020-12-11 06:30:00',
'MCO',
94,
'2020-12-11 07:00:00',
'DEN',
59,
'2020-12-11 10:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1144',
'Michael',
'Anderson'
);


INSERT INTO flight
VALUES (
'1145',
'342',
'2020-12-11 04:30:00',
'LAX',
79,
'2020-12-11 05:00:00',
'DEN',
39,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1145',
'Jacob',
'Wang'
);


INSERT INTO flight
VALUES (
'1146',
'319',
'2020-12-11 11:30:00',
'LAX',
86,
'2020-12-11 12:00:00',
'JFK',
90,
'2020-12-11 15:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1146',
'John',
'Davis'
);


INSERT INTO flight
VALUES (
'1147',
'342',
'2020-12-11 07:30:00',
'JFK',
82,
'2020-12-11 08:00:00',
'ATL',
11,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1147',
'Alex',
'Smith'
);


INSERT INTO flight
VALUES (
'1148',
'346',
'2020-12-11 04:30:00',
'LAX',
38,
'2020-12-11 05:00:00',
'MCO',
50,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1148',
'Mason',
'Miller'
);


INSERT INTO flight
VALUES (
'1149',
'318',
'2020-12-11 04:30:00',
'DEN',
72,
'2020-12-11 05:00:00',
'LAX',
45,
'2020-12-11 07:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1149',
'Noah',
'Davis'
);


INSERT INTO flight
VALUES (
'1150',
'345',
'2020-12-11 09:30:00',
'ORD',
68,
'2020-12-11 10:00:00',
'SFO',
18,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1150',
'Michael',
'Thomas'
);


INSERT INTO flight
VALUES (
'1151',
'342',
'2020-12-11 06:30:00',
'LAX',
66,
'2020-12-11 07:00:00',
'SFO',
27,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1151',
'Michael',
'Garcia'
);


INSERT INTO flight
VALUES (
'1152',
'340',
'2020-12-11 03:30:00',
'DFW',
87,
'2020-12-11 04:00:00',
'SFO',
22,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1152',
'Liam',
'Harris'
);


INSERT INTO flight
VALUES (
'1153',
'321',
'2020-12-11 12:30:00',
'MCO',
32,
'2020-12-11 13:00:00',
'DEN',
40,
'2020-12-11 16:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1153',
'Jacob',
'Smith'
);


INSERT INTO flight
VALUES (
'1154',
'318',
'2020-12-11 09:30:00',
'MCO',
92,
'2020-12-11 10:00:00',
'ORD',
68,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1154',
'Michael',
'Davis'
);


INSERT INTO flight
VALUES (
'1155',
'342',
'2020-12-11 06:30:00',
'SEA',
32,
'2020-12-11 07:00:00',
'JFK',
107,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1155',
'John',
'Brown'
);


INSERT INTO flight
VALUES (
'1156',
'319',
'2020-12-11 10:30:00',
'DFW',
75,
'2020-12-11 11:00:00',
'ORD',
55,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1156',
'Jacob',
'Anderson'
);


INSERT INTO flight
VALUES (
'1157',
'318',
'2020-12-11 03:30:00',
'ATL',
66,
'2020-12-11 04:00:00',
'SFO',
45,
'2020-12-11 06:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1157',
'Liam',
'Brown'
);


INSERT INTO flight
VALUES (
'1158',
'318',
'2020-12-11 08:30:00',
'SFO',
9,
'2020-12-11 09:00:00',
'MCO',
16,
'2020-12-11 12:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1158',
'James',
'Wang'
);


INSERT INTO flight
VALUES (
'1159',
'342',
'2020-12-11 03:30:00',
'SFO',
24,
'2020-12-11 04:00:00',
'MCO',
50,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1159',
'Michael',
'Wang'
);


INSERT INTO flight
VALUES (
'1160',
'340',
'2020-12-11 09:30:00',
'DFW',
8,
'2020-12-11 10:00:00',
'ORD',
86,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1160',
'James',
'Wang'
);


INSERT INTO flight
VALUES (
'1161',
'340',
'2020-12-11 09:30:00',
'LAS',
102,
'2020-12-11 10:00:00',
'JFK',
79,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1161',
'Ethan',
'Harris'
);


INSERT INTO flight
VALUES (
'1162',
'319',
'2020-12-11 11:30:00',
'JFK',
43,
'2020-12-11 12:00:00',
'ATL',
9,
'2020-12-11 15:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1162',
'Alex',
'Harris'
);


INSERT INTO flight
VALUES (
'1163',
'340',
'2020-12-11 09:30:00',
'SEA',
53,
'2020-12-11 10:00:00',
'JFK',
49,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1163',
'James',
'Anderson'
);


INSERT INTO flight
VALUES (
'1164',
'318',
'2020-12-11 11:30:00',
'DEN',
5,
'2020-12-11 12:00:00',
'JFK',
75,
'2020-12-11 15:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1164',
'James',
'Davis'
);


INSERT INTO flight
VALUES (
'1165',
'330',
'2020-12-11 05:30:00',
'ORD',
3,
'2020-12-11 06:00:00',
'DFW',
88,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1165',
'James',
'Lee'
);


INSERT INTO flight
VALUES (
'1166',
'310',
'2020-12-11 05:30:00',
'JFK',
108,
'2020-12-11 06:00:00',
'DFW',
71,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1166',
'James',
'Lee'
);


INSERT INTO flight
VALUES (
'1167',
'342',
'2020-12-11 10:30:00',
'LAS',
109,
'2020-12-11 11:00:00',
'SEA',
100,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1167',
'John',
'Lee'
);


INSERT INTO flight
VALUES (
'1168',
'318',
'2020-12-11 07:30:00',
'LAS',
85,
'2020-12-11 08:00:00',
'ATL',
102,
'2020-12-11 10:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1168',
'Liam',
'Brown'
);


INSERT INTO flight
VALUES (
'1169',
'346',
'2020-12-11 05:30:00',
'SEA',
96,
'2020-12-11 06:00:00',
'LAS',
71,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1169',
'Jacob',
'Anderson'
);


INSERT INTO flight
VALUES (
'1170',
'345',
'2020-12-11 04:30:00',
'DFW',
2,
'2020-12-11 05:00:00',
'LAS',
49,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1170',
'Ethan',
'Miller'
);


INSERT INTO flight
VALUES (
'1171',
'340',
'2020-12-11 04:30:00',
'LAX',
57,
'2020-12-11 05:00:00',
'ATL',
15,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1171',
'Mason',
'Lee'
);


INSERT INTO flight
VALUES (
'1172',
'318',
'2020-12-11 10:30:00',
'JFK',
58,
'2020-12-11 11:00:00',
'ATL',
44,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1172',
'Michael',
'Lee'
);


INSERT INTO flight
VALUES (
'1173',
'345',
'2020-12-11 10:30:00',
'DFW',
4,
'2020-12-11 11:00:00',
'DEN',
15,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1173',
'James',
'Garcia'
);


INSERT INTO flight
VALUES (
'1174',
'319',
'2020-12-11 10:30:00',
'ORD',
98,
'2020-12-11 11:00:00',
'DFW',
72,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1174',
'Alex',
'Harris'
);


INSERT INTO flight
VALUES (
'1175',
'346',
'2020-12-11 03:30:00',
'LAX',
108,
'2020-12-11 04:00:00',
'DFW',
98,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1175',
'Jacob',
'Brown'
);


INSERT INTO flight
VALUES (
'1176',
'310',
'2020-12-11 10:30:00',
'SFO',
63,
'2020-12-11 11:00:00',
'ATL',
10,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1176',
'Michael',
'Davis'
);


INSERT INTO flight
VALUES (
'1177',
'310',
'2020-12-11 11:30:00',
'ORD',
79,
'2020-12-11 12:00:00',
'SFO',
56,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1177',
'Ethan',
'Brown'
);


INSERT INTO flight
VALUES (
'1178',
'310',
'2020-12-11 03:30:00',
'MCO',
99,
'2020-12-11 04:00:00',
'SEA',
71,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1178',
'Jacob',
'Harris'
);


INSERT INTO flight
VALUES (
'1179',
'319',
'2020-12-11 07:30:00',
'DEN',
36,
'2020-12-11 08:00:00',
'LAS',
81,
'2020-12-11 10:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1179',
'James',
'Davis'
);


INSERT INTO flight
VALUES (
'1180',
'319',
'2020-12-11 05:30:00',
'MCO',
11,
'2020-12-11 06:00:00',
'SFO',
93,
'2020-12-11 08:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1180',
'Ethan',
'Brown'
);


INSERT INTO flight
VALUES (
'1181',
'345',
'2020-12-11 06:30:00',
'SEA',
98,
'2020-12-11 07:00:00',
'DFW',
22,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1181',
'Jacob',
'Thomas'
);


INSERT INTO flight
VALUES (
'1182',
'321',
'2020-12-11 12:30:00',
'MCO',
38,
'2020-12-11 13:00:00',
'SFO',
92,
'2020-12-11 16:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1182',
'Ethan',
'Wang'
);


INSERT INTO flight
VALUES (
'1183',
'345',
'2020-12-11 06:30:00',
'ATL',
56,
'2020-12-11 07:00:00',
'LAX',
106,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1183',
'William',
'Lee'
);


INSERT INTO flight
VALUES (
'1184',
'346',
'2020-12-11 03:30:00',
'SFO',
88,
'2020-12-11 04:00:00',
'LAS',
29,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1184',
'Michael',
'Harris'
);


INSERT INTO flight
VALUES (
'1185',
'346',
'2020-12-11 11:30:00',
'SFO',
88,
'2020-12-11 12:00:00',
'JFK',
77,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1185',
'Mason',
'Davis'
);


INSERT INTO flight
VALUES (
'1186',
'318',
'2020-12-11 10:30:00',
'LAS',
12,
'2020-12-11 11:00:00',
'DFW',
102,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1186',
'Liam',
'Brown'
);


INSERT INTO flight
VALUES (
'1187',
'345',
'2020-12-11 05:30:00',
'SFO',
64,
'2020-12-11 06:00:00',
'LAX',
9,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1187',
'Michael',
'Thomas'
);


INSERT INTO flight
VALUES (
'1188',
'321',
'2020-12-11 05:30:00',
'JFK',
43,
'2020-12-11 06:00:00',
'SEA',
12,
'2020-12-11 08:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1188',
'Alex',
'Davis'
);


INSERT INTO flight
VALUES (
'1189',
'340',
'2020-12-11 11:30:00',
'MCO',
100,
'2020-12-11 12:00:00',
'SEA',
101,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1189',
'Ethan',
'Miller'
);


INSERT INTO flight
VALUES (
'1190',
'330',
'2020-12-11 04:30:00',
'LAX',
31,
'2020-12-11 05:00:00',
'ATL',
96,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1190',
'Michael',
'Anderson'
);


INSERT INTO flight
VALUES (
'1191',
'342',
'2020-12-11 09:30:00',
'MCO',
73,
'2020-12-11 10:00:00',
'LAS',
89,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1191',
'Ethan',
'Davis'
);


INSERT INTO flight
VALUES (
'1192',
'346',
'2020-12-11 05:30:00',
'DEN',
5,
'2020-12-11 06:00:00',
'LAS',
85,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1192',
'Michael',
'Miller'
);


INSERT INTO flight
VALUES (
'1193',
'321',
'2020-12-11 04:30:00',
'SFO',
99,
'2020-12-11 05:00:00',
'ATL',
18,
'2020-12-11 07:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1193',
'Jacob',
'Anderson'
);


INSERT INTO flight
VALUES (
'1194',
'342',
'2020-12-11 05:30:00',
'SFO',
67,
'2020-12-11 06:00:00',
'MCO',
14,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1194',
'Jacob',
'Harris'
);


INSERT INTO flight
VALUES (
'1195',
'310',
'2020-12-11 05:30:00',
'JFK',
45,
'2020-12-11 06:00:00',
'MCO',
3,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1195',
'Jacob',
'Brown'
);


INSERT INTO flight
VALUES (
'1196',
'345',
'2020-12-11 05:30:00',
'JFK',
52,
'2020-12-11 06:00:00',
'MCO',
91,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1196',
'Jacob',
'Smith'
);


INSERT INTO flight
VALUES (
'1197',
'343',
'2020-12-11 12:30:00',
'SFO',
22,
'2020-12-11 13:00:00',
'LAS',
24,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1197',
'Mason',
'Anderson'
);


INSERT INTO flight
VALUES (
'1198',
'321',
'2020-12-11 10:30:00',
'DEN',
49,
'2020-12-11 11:00:00',
'SFO',
24,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1198',
'Liam',
'Garcia'
);


INSERT INTO flight
VALUES (
'1199',
'319',
'2020-12-11 05:30:00',
'SEA',
100,
'2020-12-11 06:00:00',
'MCO',
75,
'2020-12-11 08:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1199',
'Liam',
'Davis'
);


INSERT INTO flight
VALUES (
'1200',
'346',
'2020-12-11 11:30:00',
'SFO',
15,
'2020-12-11 12:00:00',
'MCO',
14,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1200',
'Liam',
'Wang'
);


INSERT INTO flight
VALUES (
'1201',
'342',
'2020-12-11 07:30:00',
'ATL',
11,
'2020-12-11 08:00:00',
'JFK',
87,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1201',
'William',
'Miller'
);


INSERT INTO flight
VALUES (
'1202',
'319',
'2020-12-11 05:30:00',
'LAX',
59,
'2020-12-11 06:00:00',
'SEA',
106,
'2020-12-11 08:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1202',
'Mason',
'Garcia'
);


INSERT INTO flight
VALUES (
'1203',
'346',
'2020-12-11 03:30:00',
'SFO',
67,
'2020-12-11 04:00:00',
'DFW',
5,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1203',
'Jacob',
'Smith'
);


INSERT INTO flight
VALUES (
'1204',
'318',
'2020-12-11 03:30:00',
'SFO',
58,
'2020-12-11 04:00:00',
'LAS',
20,
'2020-12-11 06:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1204',
'James',
'Harris'
);


INSERT INTO flight
VALUES (
'1205',
'343',
'2020-12-11 08:30:00',
'LAS',
67,
'2020-12-11 09:00:00',
'ORD',
77,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1205',
'Jacob',
'Smith'
);


INSERT INTO flight
VALUES (
'1206',
'342',
'2020-12-11 07:30:00',
'JFK',
85,
'2020-12-11 08:00:00',
'LAS',
36,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1206',
'Alex',
'Lee'
);


INSERT INTO flight
VALUES (
'1207',
'342',
'2020-12-11 03:30:00',
'DEN',
53,
'2020-12-11 04:00:00',
'ATL',
47,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1207',
'Jacob',
'Harris'
);


INSERT INTO flight
VALUES (
'1208',
'346',
'2020-12-11 05:30:00',
'SEA',
82,
'2020-12-11 06:00:00',
'DEN',
63,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1208',
'Alex',
'Garcia'
);


INSERT INTO flight
VALUES (
'1209',
'330',
'2020-12-11 06:30:00',
'ATL',
47,
'2020-12-11 07:00:00',
'LAS',
64,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1209',
'Noah',
'Harris'
);


INSERT INTO flight
VALUES (
'1210',
'321',
'2020-12-11 06:30:00',
'JFK',
27,
'2020-12-11 07:00:00',
'ORD',
105,
'2020-12-11 10:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1210',
'Ethan',
'Miller'
);


INSERT INTO flight
VALUES (
'1211',
'330',
'2020-12-11 03:30:00',
'SEA',
100,
'2020-12-11 04:00:00',
'LAX',
66,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1211',
'Alex',
'Brown'
);


INSERT INTO flight
VALUES (
'1212',
'340',
'2020-12-11 08:30:00',
'DEN',
76,
'2020-12-11 09:00:00',
'JFK',
92,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1212',
'James',
'Davis'
);


INSERT INTO flight
VALUES (
'1213',
'319',
'2020-12-11 03:30:00',
'ATL',
76,
'2020-12-11 04:00:00',
'LAX',
52,
'2020-12-11 06:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1213',
'James',
'Brown'
);


INSERT INTO flight
VALUES (
'1214',
'345',
'2020-12-11 08:30:00',
'LAS',
15,
'2020-12-11 09:00:00',
'SEA',
50,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1214',
'Jacob',
'Miller'
);


INSERT INTO flight
VALUES (
'1215',
'319',
'2020-12-11 12:30:00',
'ORD',
4,
'2020-12-11 13:00:00',
'SEA',
31,
'2020-12-11 16:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1215',
'James',
'Brown'
);


INSERT INTO flight
VALUES (
'1216',
'330',
'2020-12-11 05:30:00',
'ATL',
104,
'2020-12-11 06:00:00',
'LAS',
45,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1216',
'Alex',
'Garcia'
);


INSERT INTO flight
VALUES (
'1217',
'342',
'2020-12-11 04:30:00',
'ATL',
41,
'2020-12-11 05:00:00',
'DEN',
67,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1217',
'Jacob',
'Brown'
);


INSERT INTO flight
VALUES (
'1218',
'330',
'2020-12-11 04:30:00',
'DFW',
26,
'2020-12-11 05:00:00',
'ATL',
88,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1218',
'Alex',
'Smith'
);


INSERT INTO flight
VALUES (
'1219',
'345',
'2020-12-11 12:30:00',
'ORD',
92,
'2020-12-11 13:00:00',
'DEN',
91,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1219',
'William',
'Brown'
);


INSERT INTO flight
VALUES (
'1220',
'330',
'2020-12-11 04:30:00',
'SEA',
90,
'2020-12-11 05:00:00',
'ORD',
31,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1220',
'John',
'Davis'
);


INSERT INTO flight
VALUES (
'1221',
'340',
'2020-12-11 03:30:00',
'LAX',
40,
'2020-12-11 04:00:00',
'DFW',
13,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1221',
'Jacob',
'Wang'
);


INSERT INTO flight
VALUES (
'1222',
'318',
'2020-12-11 07:30:00',
'MCO',
15,
'2020-12-11 08:00:00',
'DEN',
68,
'2020-12-11 10:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1222',
'Jacob',
'Thomas'
);


INSERT INTO flight
VALUES (
'1223',
'342',
'2020-12-11 06:30:00',
'LAX',
89,
'2020-12-11 07:00:00',
'ORD',
108,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1223',
'Noah',
'Lee'
);


INSERT INTO flight
VALUES (
'1224',
'345',
'2020-12-11 09:30:00',
'LAS',
8,
'2020-12-11 10:00:00',
'JFK',
68,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1224',
'Ethan',
'Harris'
);


INSERT INTO flight
VALUES (
'1225',
'318',
'2020-12-11 10:30:00',
'ORD',
97,
'2020-12-11 11:00:00',
'LAX',
73,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1225',
'Alex',
'Smith'
);


INSERT INTO flight
VALUES (
'1226',
'318',
'2020-12-11 05:30:00',
'SFO',
23,
'2020-12-11 06:00:00',
'JFK',
83,
'2020-12-11 08:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1226',
'Mason',
'Wang'
);


INSERT INTO flight
VALUES (
'1227',
'340',
'2020-12-11 09:30:00',
'SFO',
38,
'2020-12-11 10:00:00',
'DEN',
40,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1227',
'Alex',
'Garcia'
);


INSERT INTO flight
VALUES (
'1228',
'321',
'2020-12-11 03:30:00',
'DEN',
73,
'2020-12-11 04:00:00',
'LAX',
61,
'2020-12-11 06:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1228',
'William',
'Lee'
);


INSERT INTO flight
VALUES (
'1229',
'340',
'2020-12-11 12:30:00',
'SFO',
85,
'2020-12-11 13:00:00',
'MCO',
105,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1229',
'Ethan',
'Smith'
);


INSERT INTO flight
VALUES (
'1230',
'319',
'2020-12-11 04:30:00',
'DEN',
106,
'2020-12-11 05:00:00',
'DFW',
35,
'2020-12-11 07:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1230',
'Mason',
'Miller'
);


INSERT INTO flight
VALUES (
'1231',
'330',
'2020-12-11 04:30:00',
'JFK',
74,
'2020-12-11 05:00:00',
'LAS',
36,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1231',
'Mason',
'Garcia'
);


INSERT INTO flight
VALUES (
'1232',
'340',
'2020-12-11 10:30:00',
'JFK',
33,
'2020-12-11 11:00:00',
'ORD',
63,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1232',
'Ethan',
'Harris'
);


INSERT INTO flight
VALUES (
'1233',
'340',
'2020-12-11 06:30:00',
'ORD',
24,
'2020-12-11 07:00:00',
'ATL',
59,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1233',
'John',
'Davis'
);


INSERT INTO flight
VALUES (
'1234',
'345',
'2020-12-11 06:30:00',
'SFO',
68,
'2020-12-11 07:00:00',
'JFK',
65,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1234',
'William',
'Davis'
);


INSERT INTO flight
VALUES (
'1235',
'346',
'2020-12-11 03:30:00',
'SEA',
88,
'2020-12-11 04:00:00',
'LAS',
20,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1235',
'John',
'Anderson'
);


INSERT INTO flight
VALUES (
'1236',
'321',
'2020-12-11 12:30:00',
'DFW',
63,
'2020-12-11 13:00:00',
'LAX',
46,
'2020-12-11 16:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1236',
'Michael',
'Thomas'
);


INSERT INTO flight
VALUES (
'1237',
'343',
'2020-12-11 07:30:00',
'SEA',
78,
'2020-12-11 08:00:00',
'DFW',
46,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1237',
'John',
'Thomas'
);


INSERT INTO flight
VALUES (
'1238',
'340',
'2020-12-11 10:30:00',
'JFK',
62,
'2020-12-11 11:00:00',
'DEN',
62,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1238',
'Liam',
'Miller'
);


INSERT INTO flight
VALUES (
'1239',
'342',
'2020-12-11 09:30:00',
'SEA',
101,
'2020-12-11 10:00:00',
'JFK',
5,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1239',
'Alex',
'Anderson'
);


INSERT INTO flight
VALUES (
'1240',
'321',
'2020-12-11 09:30:00',
'SFO',
109,
'2020-12-11 10:00:00',
'LAX',
69,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1240',
'John',
'Garcia'
);


INSERT INTO flight
VALUES (
'1241',
'310',
'2020-12-11 04:30:00',
'DEN',
107,
'2020-12-11 05:00:00',
'DFW',
3,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1241',
'Jacob',
'Smith'
);


INSERT INTO flight
VALUES (
'1242',
'319',
'2020-12-11 12:30:00',
'DFW',
93,
'2020-12-11 13:00:00',
'LAX',
13,
'2020-12-11 16:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1242',
'Jacob',
'Miller'
);


INSERT INTO flight
VALUES (
'1243',
'343',
'2020-12-11 07:30:00',
'MCO',
73,
'2020-12-11 08:00:00',
'SFO',
22,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1243',
'William',
'Anderson'
);


INSERT INTO flight
VALUES (
'1244',
'330',
'2020-12-11 07:30:00',
'ATL',
25,
'2020-12-11 08:00:00',
'SFO',
109,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1244',
'Michael',
'Lee'
);


INSERT INTO flight
VALUES (
'1245',
'340',
'2020-12-11 04:30:00',
'JFK',
2,
'2020-12-11 05:00:00',
'DEN',
110,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1245',
'Jacob',
'Anderson'
);


INSERT INTO flight
VALUES (
'1246',
'342',
'2020-12-11 11:30:00',
'ATL',
66,
'2020-12-11 12:00:00',
'SFO',
32,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1246',
'Liam',
'Brown'
);


INSERT INTO flight
VALUES (
'1247',
'330',
'2020-12-11 04:30:00',
'ORD',
63,
'2020-12-11 05:00:00',
'SEA',
41,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1247',
'James',
'Davis'
);


INSERT INTO flight
VALUES (
'1248',
'318',
'2020-12-11 10:30:00',
'SFO',
67,
'2020-12-11 11:00:00',
'JFK',
36,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1248',
'Liam',
'Lee'
);


INSERT INTO flight
VALUES (
'1249',
'346',
'2020-12-11 04:30:00',
'DFW',
71,
'2020-12-11 05:00:00',
'JFK',
76,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1249',
'Alex',
'Smith'
);


INSERT INTO flight
VALUES (
'1250',
'346',
'2020-12-11 10:30:00',
'SEA',
73,
'2020-12-11 11:00:00',
'MCO',
22,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1250',
'Alex',
'Davis'
);


INSERT INTO flight
VALUES (
'1251',
'330',
'2020-12-11 03:30:00',
'LAX',
12,
'2020-12-11 04:00:00',
'JFK',
9,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1251',
'William',
'Smith'
);


INSERT INTO flight
VALUES (
'1252',
'340',
'2020-12-11 12:30:00',
'DEN',
8,
'2020-12-11 13:00:00',
'SEA',
51,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1252',
'Noah',
'Lee'
);


INSERT INTO flight
VALUES (
'1253',
'345',
'2020-12-11 06:30:00',
'LAS',
74,
'2020-12-11 07:00:00',
'LAX',
82,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1253',
'Alex',
'Davis'
);


INSERT INTO flight
VALUES (
'1254',
'321',
'2020-12-11 08:30:00',
'JFK',
67,
'2020-12-11 09:00:00',
'SEA',
60,
'2020-12-11 12:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1254',
'William',
'Davis'
);


INSERT INTO flight
VALUES (
'1255',
'340',
'2020-12-11 11:30:00',
'LAX',
7,
'2020-12-11 12:00:00',
'LAS',
35,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1255',
'Michael',
'Lee'
);


INSERT INTO flight
VALUES (
'1256',
'330',
'2020-12-11 06:30:00',
'MCO',
96,
'2020-12-11 07:00:00',
'SEA',
4,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1256',
'William',
'Davis'
);


INSERT INTO flight
VALUES (
'1257',
'330',
'2020-12-11 11:30:00',
'SFO',
55,
'2020-12-11 12:00:00',
'LAX',
25,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1257',
'William',
'Anderson'
);


INSERT INTO flight
VALUES (
'1258',
'321',
'2020-12-11 12:30:00',
'LAS',
79,
'2020-12-11 13:00:00',
'SEA',
24,
'2020-12-11 16:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1258',
'Mason',
'Anderson'
);


INSERT INTO flight
VALUES (
'1259',
'318',
'2020-12-11 03:30:00',
'LAX',
14,
'2020-12-11 04:00:00',
'JFK',
83,
'2020-12-11 06:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1259',
'Liam',
'Wang'
);


INSERT INTO flight
VALUES (
'1260',
'310',
'2020-12-11 03:30:00',
'DFW',
57,
'2020-12-11 04:00:00',
'JFK',
15,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1260',
'Alex',
'Brown'
);


INSERT INTO flight
VALUES (
'1261',
'340',
'2020-12-11 12:30:00',
'SFO',
47,
'2020-12-11 13:00:00',
'MCO',
69,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1261',
'Michael',
'Lee'
);


INSERT INTO flight
VALUES (
'1262',
'345',
'2020-12-11 08:30:00',
'LAX',
65,
'2020-12-11 09:00:00',
'DFW',
8,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1262',
'Noah',
'Anderson'
);


INSERT INTO flight
VALUES (
'1263',
'345',
'2020-12-11 11:30:00',
'LAX',
65,
'2020-12-11 12:00:00',
'LAS',
44,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1263',
'Ethan',
'Miller'
);


INSERT INTO flight
VALUES (
'1264',
'318',
'2020-12-11 07:30:00',
'LAX',
104,
'2020-12-11 08:00:00',
'DEN',
96,
'2020-12-11 10:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1264',
'James',
'Brown'
);


INSERT INTO flight
VALUES (
'1265',
'342',
'2020-12-11 05:30:00',
'DEN',
30,
'2020-12-11 06:00:00',
'LAX',
104,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1265',
'James',
'Wang'
);


INSERT INTO flight
VALUES (
'1266',
'346',
'2020-12-11 11:30:00',
'LAX',
49,
'2020-12-11 12:00:00',
'MCO',
36,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1266',
'Michael',
'Harris'
);


INSERT INTO flight
VALUES (
'1267',
'340',
'2020-12-11 12:30:00',
'SFO',
46,
'2020-12-11 13:00:00',
'LAX',
32,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1267',
'Noah',
'Lee'
);


INSERT INTO flight
VALUES (
'1268',
'345',
'2020-12-11 04:30:00',
'SEA',
106,
'2020-12-11 05:00:00',
'JFK',
29,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1268',
'Noah',
'Garcia'
);


INSERT INTO flight
VALUES (
'1269',
'346',
'2020-12-11 08:30:00',
'LAX',
47,
'2020-12-11 09:00:00',
'DEN',
22,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1269',
'Mason',
'Thomas'
);


INSERT INTO flight
VALUES (
'1270',
'319',
'2020-12-11 04:30:00',
'DFW',
25,
'2020-12-11 05:00:00',
'DEN',
9,
'2020-12-11 07:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1270',
'John',
'Smith'
);


INSERT INTO flight
VALUES (
'1271',
'343',
'2020-12-11 09:30:00',
'LAX',
88,
'2020-12-11 10:00:00',
'DEN',
12,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1271',
'Alex',
'Wang'
);


INSERT INTO flight
VALUES (
'1272',
'346',
'2020-12-11 06:30:00',
'ATL',
102,
'2020-12-11 07:00:00',
'LAX',
70,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1272',
'Mason',
'Garcia'
);


INSERT INTO flight
VALUES (
'1273',
'321',
'2020-12-11 04:30:00',
'ATL',
103,
'2020-12-11 05:00:00',
'MCO',
34,
'2020-12-11 07:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1273',
'James',
'Davis'
);


INSERT INTO flight
VALUES (
'1274',
'319',
'2020-12-11 03:30:00',
'DEN',
35,
'2020-12-11 04:00:00',
'ORD',
72,
'2020-12-11 06:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1274',
'Ethan',
'Miller'
);


INSERT INTO flight
VALUES (
'1275',
'342',
'2020-12-11 05:30:00',
'LAX',
69,
'2020-12-11 06:00:00',
'ATL',
47,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1275',
'Jacob',
'Garcia'
);


INSERT INTO flight
VALUES (
'1276',
'330',
'2020-12-11 03:30:00',
'DFW',
48,
'2020-12-11 04:00:00',
'DEN',
31,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1276',
'Jacob',
'Thomas'
);


INSERT INTO flight
VALUES (
'1277',
'340',
'2020-12-11 08:30:00',
'LAS',
70,
'2020-12-11 09:00:00',
'ORD',
71,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1277',
'Ethan',
'Brown'
);


INSERT INTO flight
VALUES (
'1278',
'330',
'2020-12-11 09:30:00',
'MCO',
47,
'2020-12-11 10:00:00',
'LAS',
45,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1278',
'Ethan',
'Anderson'
);


INSERT INTO flight
VALUES (
'1279',
'310',
'2020-12-11 08:30:00',
'JFK',
32,
'2020-12-11 09:00:00',
'SFO',
71,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1279',
'James',
'Thomas'
);


INSERT INTO flight
VALUES (
'1280',
'310',
'2020-12-11 09:30:00',
'MCO',
81,
'2020-12-11 10:00:00',
'DEN',
31,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1280',
'Mason',
'Wang'
);


INSERT INTO flight
VALUES (
'1281',
'321',
'2020-12-11 08:30:00',
'ORD',
39,
'2020-12-11 09:00:00',
'DEN',
90,
'2020-12-11 12:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1281',
'Alex',
'Miller'
);


INSERT INTO flight
VALUES (
'1282',
'340',
'2020-12-11 11:30:00',
'SFO',
69,
'2020-12-11 12:00:00',
'JFK',
24,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1282',
'William',
'Anderson'
);


INSERT INTO flight
VALUES (
'1283',
'330',
'2020-12-11 12:30:00',
'ATL',
80,
'2020-12-11 13:00:00',
'LAX',
104,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1283',
'James',
'Brown'
);


INSERT INTO flight
VALUES (
'1284',
'318',
'2020-12-11 04:30:00',
'SFO',
50,
'2020-12-11 05:00:00',
'DFW',
25,
'2020-12-11 07:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1284',
'James',
'Anderson'
);


INSERT INTO flight
VALUES (
'1285',
'321',
'2020-12-11 08:30:00',
'DFW',
110,
'2020-12-11 09:00:00',
'SFO',
83,
'2020-12-11 12:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1285',
'William',
'Miller'
);


INSERT INTO flight
VALUES (
'1286',
'330',
'2020-12-11 08:30:00',
'LAS',
101,
'2020-12-11 09:00:00',
'ORD',
110,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1286',
'Liam',
'Davis'
);


INSERT INTO flight
VALUES (
'1287',
'318',
'2020-12-11 06:30:00',
'MCO',
52,
'2020-12-11 07:00:00',
'DEN',
76,
'2020-12-11 10:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1287',
'Michael',
'Wang'
);


INSERT INTO flight
VALUES (
'1288',
'345',
'2020-12-11 05:30:00',
'JFK',
20,
'2020-12-11 06:00:00',
'ORD',
75,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1288',
'Mason',
'Davis'
);


INSERT INTO flight
VALUES (
'1289',
'340',
'2020-12-11 07:30:00',
'DFW',
101,
'2020-12-11 08:00:00',
'LAS',
100,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1289',
'John',
'Smith'
);


INSERT INTO flight
VALUES (
'1290',
'342',
'2020-12-11 04:30:00',
'DEN',
12,
'2020-12-11 05:00:00',
'MCO',
59,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1290',
'Michael',
'Miller'
);


INSERT INTO flight
VALUES (
'1291',
'342',
'2020-12-11 12:30:00',
'DEN',
84,
'2020-12-11 13:00:00',
'LAX',
82,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1291',
'Alex',
'Davis'
);


INSERT INTO flight
VALUES (
'1292',
'343',
'2020-12-11 09:30:00',
'LAS',
46,
'2020-12-11 10:00:00',
'DEN',
28,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1292',
'Mason',
'Garcia'
);


INSERT INTO flight
VALUES (
'1293',
'319',
'2020-12-11 10:30:00',
'ORD',
7,
'2020-12-11 11:00:00',
'LAS',
27,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1293',
'James',
'Davis'
);


INSERT INTO flight
VALUES (
'1294',
'330',
'2020-12-11 03:30:00',
'LAX',
55,
'2020-12-11 04:00:00',
'SFO',
86,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1294',
'Liam',
'Garcia'
);


INSERT INTO flight
VALUES (
'1295',
'310',
'2020-12-11 04:30:00',
'MCO',
10,
'2020-12-11 05:00:00',
'SEA',
57,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1295',
'William',
'Brown'
);


INSERT INTO flight
VALUES (
'1296',
'345',
'2020-12-11 08:30:00',
'ATL',
13,
'2020-12-11 09:00:00',
'ORD',
23,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1296',
'John',
'Smith'
);


INSERT INTO flight
VALUES (
'1297',
'340',
'2020-12-11 12:30:00',
'MCO',
102,
'2020-12-11 13:00:00',
'SEA',
78,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1297',
'Noah',
'Anderson'
);


INSERT INTO flight
VALUES (
'1298',
'345',
'2020-12-11 07:30:00',
'LAS',
40,
'2020-12-11 08:00:00',
'ATL',
98,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1298',
'Ethan',
'Brown'
);


INSERT INTO flight
VALUES (
'1299',
'345',
'2020-12-11 05:30:00',
'MCO',
9,
'2020-12-11 06:00:00',
'SEA',
92,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1299',
'Noah',
'Garcia'
);


INSERT INTO flight
VALUES (
'1300',
'319',
'2020-12-11 05:30:00',
'SEA',
37,
'2020-12-11 06:00:00',
'DFW',
111,
'2020-12-11 08:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1300',
'Michael',
'Thomas'
);


INSERT INTO flight
VALUES (
'1301',
'310',
'2020-12-11 05:30:00',
'SEA',
44,
'2020-12-11 06:00:00',
'ORD',
79,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1301',
'Jacob',
'Harris'
);


INSERT INTO flight
VALUES (
'1302',
'319',
'2020-12-11 04:30:00',
'SEA',
85,
'2020-12-11 05:00:00',
'JFK',
107,
'2020-12-11 07:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1302',
'Liam',
'Brown'
);


INSERT INTO flight
VALUES (
'1303',
'321',
'2020-12-11 09:30:00',
'ORD',
31,
'2020-12-11 10:00:00',
'MCO',
9,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1303',
'Ethan',
'Lee'
);


INSERT INTO flight
VALUES (
'1304',
'340',
'2020-12-11 03:30:00',
'ATL',
4,
'2020-12-11 04:00:00',
'LAX',
15,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1304',
'Jacob',
'Wang'
);


INSERT INTO flight
VALUES (
'1305',
'319',
'2020-12-11 11:30:00',
'ORD',
95,
'2020-12-11 12:00:00',
'SFO',
110,
'2020-12-11 15:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1305',
'James',
'Thomas'
);


INSERT INTO flight
VALUES (
'1306',
'310',
'2020-12-11 07:30:00',
'JFK',
60,
'2020-12-11 08:00:00',
'LAS',
30,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1306',
'Alex',
'Brown'
);


INSERT INTO flight
VALUES (
'1307',
'340',
'2020-12-11 06:30:00',
'MCO',
62,
'2020-12-11 07:00:00',
'ATL',
24,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1307',
'John',
'Harris'
);


INSERT INTO flight
VALUES (
'1308',
'318',
'2020-12-11 03:30:00',
'MCO',
9,
'2020-12-11 04:00:00',
'JFK',
82,
'2020-12-11 06:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1308',
'Liam',
'Garcia'
);


INSERT INTO flight
VALUES (
'1309',
'318',
'2020-12-11 07:30:00',
'LAX',
36,
'2020-12-11 08:00:00',
'SEA',
46,
'2020-12-11 10:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1309',
'Noah',
'Anderson'
);


INSERT INTO flight
VALUES (
'1310',
'342',
'2020-12-11 07:30:00',
'JFK',
34,
'2020-12-11 08:00:00',
'ORD',
2,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1310',
'John',
'Davis'
);


INSERT INTO flight
VALUES (
'1311',
'310',
'2020-12-11 11:30:00',
'LAX',
25,
'2020-12-11 12:00:00',
'ATL',
55,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1311',
'Ethan',
'Anderson'
);


INSERT INTO flight
VALUES (
'1312',
'343',
'2020-12-11 03:30:00',
'LAX',
64,
'2020-12-11 04:00:00',
'JFK',
6,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1312',
'Alex',
'Brown'
);


INSERT INTO flight
VALUES (
'1313',
'330',
'2020-12-11 11:30:00',
'MCO',
31,
'2020-12-11 12:00:00',
'LAX',
87,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1313',
'Noah',
'Davis'
);


INSERT INTO flight
VALUES (
'1314',
'321',
'2020-12-11 05:30:00',
'LAS',
66,
'2020-12-11 06:00:00',
'DFW',
8,
'2020-12-11 08:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1314',
'Noah',
'Thomas'
);


INSERT INTO flight
VALUES (
'1315',
'342',
'2020-12-11 11:30:00',
'SFO',
76,
'2020-12-11 12:00:00',
'LAS',
16,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1315',
'Michael',
'Smith'
);


INSERT INTO flight
VALUES (
'1316',
'321',
'2020-12-11 11:30:00',
'ATL',
73,
'2020-12-11 12:00:00',
'DEN',
105,
'2020-12-11 15:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1316',
'Jacob',
'Davis'
);


INSERT INTO flight
VALUES (
'1317',
'318',
'2020-12-11 07:30:00',
'ATL',
84,
'2020-12-11 08:00:00',
'ORD',
15,
'2020-12-11 10:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1317',
'Mason',
'Harris'
);


INSERT INTO flight
VALUES (
'1318',
'345',
'2020-12-11 04:30:00',
'DFW',
4,
'2020-12-11 05:00:00',
'ORD',
39,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1318',
'Alex',
'Garcia'
);


INSERT INTO flight
VALUES (
'1319',
'346',
'2020-12-11 04:30:00',
'DFW',
43,
'2020-12-11 05:00:00',
'ORD',
16,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1319',
'Jacob',
'Wang'
);


INSERT INTO flight
VALUES (
'1320',
'345',
'2020-12-11 09:30:00',
'LAX',
54,
'2020-12-11 10:00:00',
'JFK',
92,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1320',
'Jacob',
'Davis'
);


INSERT INTO flight
VALUES (
'1321',
'330',
'2020-12-11 11:30:00',
'ATL',
104,
'2020-12-11 12:00:00',
'SEA',
20,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1321',
'Alex',
'Miller'
);


INSERT INTO flight
VALUES (
'1322',
'343',
'2020-12-11 04:30:00',
'SEA',
17,
'2020-12-11 05:00:00',
'LAS',
77,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1322',
'James',
'Miller'
);


INSERT INTO flight
VALUES (
'1323',
'318',
'2020-12-11 10:30:00',
'LAS',
96,
'2020-12-11 11:00:00',
'SEA',
57,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1323',
'James',
'Lee'
);


INSERT INTO flight
VALUES (
'1324',
'345',
'2020-12-11 04:30:00',
'ORD',
21,
'2020-12-11 05:00:00',
'JFK',
104,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1324',
'William',
'Wang'
);


INSERT INTO flight
VALUES (
'1325',
'321',
'2020-12-11 10:30:00',
'ATL',
56,
'2020-12-11 11:00:00',
'DEN',
38,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1325',
'John',
'Lee'
);


INSERT INTO flight
VALUES (
'1326',
'342',
'2020-12-11 03:30:00',
'MCO',
67,
'2020-12-11 04:00:00',
'LAS',
44,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1326',
'Michael',
'Davis'
);


INSERT INTO flight
VALUES (
'1327',
'345',
'2020-12-11 04:30:00',
'SEA',
111,
'2020-12-11 05:00:00',
'LAX',
29,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1327',
'Mason',
'Harris'
);


INSERT INTO flight
VALUES (
'1328',
'310',
'2020-12-11 03:30:00',
'ATL',
106,
'2020-12-11 04:00:00',
'DFW',
13,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1328',
'Jacob',
'Smith'
);


INSERT INTO flight
VALUES (
'1329',
'310',
'2020-12-11 05:30:00',
'ATL',
38,
'2020-12-11 06:00:00',
'LAS',
83,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1329',
'William',
'Wang'
);


INSERT INTO flight
VALUES (
'1330',
'340',
'2020-12-11 07:30:00',
'DFW',
106,
'2020-12-11 08:00:00',
'MCO',
72,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1330',
'Noah',
'Brown'
);


INSERT INTO flight
VALUES (
'1331',
'345',
'2020-12-11 08:30:00',
'LAX',
89,
'2020-12-11 09:00:00',
'ATL',
105,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1331',
'Liam',
'Harris'
);


INSERT INTO flight
VALUES (
'1332',
'310',
'2020-12-11 05:30:00',
'JFK',
63,
'2020-12-11 06:00:00',
'ORD',
94,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1332',
'Mason',
'Brown'
);


INSERT INTO flight
VALUES (
'1333',
'346',
'2020-12-11 08:30:00',
'ATL',
60,
'2020-12-11 09:00:00',
'SEA',
57,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1333',
'Noah',
'Smith'
);


INSERT INTO flight
VALUES (
'1334',
'318',
'2020-12-11 05:30:00',
'MCO',
110,
'2020-12-11 06:00:00',
'SEA',
53,
'2020-12-11 08:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1334',
'William',
'Anderson'
);


INSERT INTO flight
VALUES (
'1335',
'346',
'2020-12-11 09:30:00',
'SEA',
85,
'2020-12-11 10:00:00',
'SFO',
36,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1335',
'Jacob',
'Smith'
);


INSERT INTO flight
VALUES (
'1336',
'343',
'2020-12-11 04:30:00',
'DFW',
75,
'2020-12-11 05:00:00',
'DEN',
17,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1336',
'Liam',
'Garcia'
);


INSERT INTO flight
VALUES (
'1337',
'345',
'2020-12-11 10:30:00',
'LAS',
57,
'2020-12-11 11:00:00',
'ORD',
32,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1337',
'Alex',
'Harris'
);


INSERT INTO flight
VALUES (
'1338',
'343',
'2020-12-11 07:30:00',
'SFO',
32,
'2020-12-11 08:00:00',
'ATL',
13,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1338',
'Alex',
'Garcia'
);


INSERT INTO flight
VALUES (
'1339',
'346',
'2020-12-11 10:30:00',
'LAX',
2,
'2020-12-11 11:00:00',
'SEA',
27,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1339',
'Jacob',
'Brown'
);


INSERT INTO flight
VALUES (
'1340',
'340',
'2020-12-11 12:30:00',
'JFK',
41,
'2020-12-11 13:00:00',
'LAS',
21,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1340',
'Ethan',
'Lee'
);


INSERT INTO flight
VALUES (
'1341',
'343',
'2020-12-11 09:30:00',
'MCO',
54,
'2020-12-11 10:00:00',
'LAS',
61,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1341',
'Mason',
'Harris'
);


INSERT INTO flight
VALUES (
'1342',
'319',
'2020-12-11 10:30:00',
'ATL',
38,
'2020-12-11 11:00:00',
'SEA',
42,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1342',
'Noah',
'Anderson'
);


INSERT INTO flight
VALUES (
'1343',
'330',
'2020-12-11 07:30:00',
'ORD',
72,
'2020-12-11 08:00:00',
'MCO',
56,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1343',
'William',
'Brown'
);


INSERT INTO flight
VALUES (
'1344',
'343',
'2020-12-11 05:30:00',
'MCO',
20,
'2020-12-11 06:00:00',
'LAX',
62,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1344',
'Michael',
'Thomas'
);


INSERT INTO flight
VALUES (
'1345',
'330',
'2020-12-11 11:30:00',
'MCO',
59,
'2020-12-11 12:00:00',
'LAS',
89,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1345',
'Michael',
'Lee'
);


INSERT INTO flight
VALUES (
'1346',
'318',
'2020-12-11 06:30:00',
'JFK',
41,
'2020-12-11 07:00:00',
'MCO',
42,
'2020-12-11 10:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1346',
'Mason',
'Harris'
);


INSERT INTO flight
VALUES (
'1347',
'310',
'2020-12-11 03:30:00',
'DFW',
100,
'2020-12-11 04:00:00',
'LAS',
46,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1347',
'William',
'Smith'
);


INSERT INTO flight
VALUES (
'1348',
'346',
'2020-12-11 06:30:00',
'MCO',
16,
'2020-12-11 07:00:00',
'LAX',
25,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1348',
'Noah',
'Davis'
);


INSERT INTO flight
VALUES (
'1349',
'345',
'2020-12-11 10:30:00',
'ATL',
98,
'2020-12-11 11:00:00',
'SFO',
100,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1349',
'Ethan',
'Brown'
);


INSERT INTO flight
VALUES (
'1350',
'343',
'2020-12-11 09:30:00',
'JFK',
103,
'2020-12-11 10:00:00',
'SEA',
31,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1350',
'John',
'Miller'
);


INSERT INTO flight
VALUES (
'1351',
'342',
'2020-12-11 08:30:00',
'ORD',
52,
'2020-12-11 09:00:00',
'LAS',
85,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1351',
'Noah',
'Miller'
);


INSERT INTO flight
VALUES (
'1352',
'340',
'2020-12-11 04:30:00',
'SEA',
84,
'2020-12-11 05:00:00',
'DFW',
14,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1352',
'Alex',
'Wang'
);


INSERT INTO flight
VALUES (
'1353',
'340',
'2020-12-11 11:30:00',
'MCO',
98,
'2020-12-11 12:00:00',
'SEA',
19,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1353',
'Mason',
'Smith'
);


INSERT INTO flight
VALUES (
'1354',
'310',
'2020-12-11 07:30:00',
'DEN',
35,
'2020-12-11 08:00:00',
'ATL',
18,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1354',
'Ethan',
'Smith'
);


INSERT INTO flight
VALUES (
'1355',
'318',
'2020-12-11 04:30:00',
'LAS',
60,
'2020-12-11 05:00:00',
'LAX',
110,
'2020-12-11 07:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1355',
'Ethan',
'Garcia'
);


INSERT INTO flight
VALUES (
'1356',
'343',
'2020-12-11 05:30:00',
'LAX',
60,
'2020-12-11 06:00:00',
'DFW',
89,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1356',
'James',
'Garcia'
);


INSERT INTO flight
VALUES (
'1357',
'318',
'2020-12-11 05:30:00',
'LAS',
94,
'2020-12-11 06:00:00',
'ATL',
74,
'2020-12-11 08:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1357',
'Michael',
'Miller'
);


INSERT INTO flight
VALUES (
'1358',
'346',
'2020-12-11 07:30:00',
'MCO',
86,
'2020-12-11 08:00:00',
'JFK',
109,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1358',
'Alex',
'Davis'
);


INSERT INTO flight
VALUES (
'1359',
'345',
'2020-12-11 04:30:00',
'SFO',
10,
'2020-12-11 05:00:00',
'MCO',
59,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1359',
'Noah',
'Wang'
);


INSERT INTO flight
VALUES (
'1360',
'330',
'2020-12-11 10:30:00',
'SEA',
56,
'2020-12-11 11:00:00',
'MCO',
90,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1360',
'Mason',
'Wang'
);


INSERT INTO flight
VALUES (
'1361',
'340',
'2020-12-11 11:30:00',
'MCO',
51,
'2020-12-11 12:00:00',
'SFO',
98,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1361',
'Liam',
'Brown'
);


INSERT INTO flight
VALUES (
'1362',
'343',
'2020-12-11 12:30:00',
'ATL',
17,
'2020-12-11 13:00:00',
'LAX',
78,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1362',
'Liam',
'Wang'
);


INSERT INTO flight
VALUES (
'1363',
'330',
'2020-12-11 03:30:00',
'LAS',
80,
'2020-12-11 04:00:00',
'MCO',
40,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1363',
'John',
'Thomas'
);


INSERT INTO flight
VALUES (
'1364',
'340',
'2020-12-11 07:30:00',
'DEN',
94,
'2020-12-11 08:00:00',
'JFK',
44,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1364',
'Ethan',
'Davis'
);


INSERT INTO flight
VALUES (
'1365',
'345',
'2020-12-11 10:30:00',
'DFW',
47,
'2020-12-11 11:00:00',
'ORD',
77,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1365',
'Noah',
'Brown'
);


INSERT INTO flight
VALUES (
'1366',
'310',
'2020-12-11 09:30:00',
'SEA',
33,
'2020-12-11 10:00:00',
'ORD',
59,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1366',
'Liam',
'Smith'
);


INSERT INTO flight
VALUES (
'1367',
'321',
'2020-12-11 10:30:00',
'SFO',
14,
'2020-12-11 11:00:00',
'ATL',
25,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1367',
'James',
'Harris'
);


INSERT INTO flight
VALUES (
'1368',
'310',
'2020-12-11 05:30:00',
'LAX',
76,
'2020-12-11 06:00:00',
'MCO',
85,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1368',
'John',
'Anderson'
);


INSERT INTO flight
VALUES (
'1369',
'319',
'2020-12-11 10:30:00',
'MCO',
16,
'2020-12-11 11:00:00',
'LAS',
55,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1369',
'James',
'Davis'
);


INSERT INTO flight
VALUES (
'1370',
'318',
'2020-12-11 03:30:00',
'SFO',
109,
'2020-12-11 04:00:00',
'LAX',
53,
'2020-12-11 06:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1370',
'James',
'Thomas'
);


INSERT INTO flight
VALUES (
'1371',
'330',
'2020-12-11 07:30:00',
'ATL',
83,
'2020-12-11 08:00:00',
'JFK',
67,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1371',
'Alex',
'Thomas'
);


INSERT INTO flight
VALUES (
'1372',
'318',
'2020-12-11 12:30:00',
'DFW',
10,
'2020-12-11 13:00:00',
'DEN',
50,
'2020-12-11 16:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1372',
'William',
'Davis'
);


INSERT INTO flight
VALUES (
'1373',
'346',
'2020-12-11 12:30:00',
'DFW',
75,
'2020-12-11 13:00:00',
'SFO',
75,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1373',
'William',
'Brown'
);


INSERT INTO flight
VALUES (
'1374',
'321',
'2020-12-11 04:30:00',
'DFW',
98,
'2020-12-11 05:00:00',
'JFK',
7,
'2020-12-11 07:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1374',
'James',
'Smith'
);


INSERT INTO flight
VALUES (
'1375',
'346',
'2020-12-11 04:30:00',
'JFK',
48,
'2020-12-11 05:00:00',
'LAS',
4,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1375',
'Mason',
'Miller'
);


INSERT INTO flight
VALUES (
'1376',
'330',
'2020-12-11 10:30:00',
'LAS',
71,
'2020-12-11 11:00:00',
'SEA',
26,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1376',
'William',
'Miller'
);


INSERT INTO flight
VALUES (
'1377',
'319',
'2020-12-11 10:30:00',
'ATL',
65,
'2020-12-11 11:00:00',
'ORD',
64,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1377',
'Noah',
'Thomas'
);


INSERT INTO flight
VALUES (
'1378',
'343',
'2020-12-11 11:30:00',
'LAS',
111,
'2020-12-11 12:00:00',
'SFO',
100,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1378',
'Ethan',
'Davis'
);


INSERT INTO flight
VALUES (
'1379',
'318',
'2020-12-11 04:30:00',
'MCO',
32,
'2020-12-11 05:00:00',
'DEN',
97,
'2020-12-11 07:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1379',
'William',
'Thomas'
);


INSERT INTO flight
VALUES (
'1380',
'343',
'2020-12-11 12:30:00',
'SEA',
88,
'2020-12-11 13:00:00',
'ATL',
32,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1380',
'Liam',
'Davis'
);


INSERT INTO flight
VALUES (
'1381',
'345',
'2020-12-11 05:30:00',
'JFK',
95,
'2020-12-11 06:00:00',
'ORD',
27,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1381',
'James',
'Smith'
);


INSERT INTO flight
VALUES (
'1382',
'330',
'2020-12-11 11:30:00',
'JFK',
52,
'2020-12-11 12:00:00',
'LAX',
42,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1382',
'James',
'Smith'
);


INSERT INTO flight
VALUES (
'1383',
'342',
'2020-12-11 10:30:00',
'DEN',
59,
'2020-12-11 11:00:00',
'MCO',
82,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1383',
'John',
'Garcia'
);


INSERT INTO flight
VALUES (
'1384',
'310',
'2020-12-11 11:30:00',
'SFO',
70,
'2020-12-11 12:00:00',
'DEN',
105,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1384',
'Jacob',
'Smith'
);


INSERT INTO flight
VALUES (
'1385',
'340',
'2020-12-11 12:30:00',
'ORD',
40,
'2020-12-11 13:00:00',
'MCO',
87,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1385',
'Michael',
'Brown'
);


INSERT INTO flight
VALUES (
'1386',
'310',
'2020-12-11 12:30:00',
'LAX',
36,
'2020-12-11 13:00:00',
'DFW',
47,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1386',
'Ethan',
'Thomas'
);


INSERT INTO flight
VALUES (
'1387',
'321',
'2020-12-11 11:30:00',
'MCO',
34,
'2020-12-11 12:00:00',
'LAS',
66,
'2020-12-11 15:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1387',
'Noah',
'Garcia'
);


INSERT INTO flight
VALUES (
'1388',
'343',
'2020-12-11 11:30:00',
'ORD',
96,
'2020-12-11 12:00:00',
'LAS',
40,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1388',
'William',
'Anderson'
);


INSERT INTO flight
VALUES (
'1389',
'319',
'2020-12-11 03:30:00',
'MCO',
72,
'2020-12-11 04:00:00',
'SFO',
93,
'2020-12-11 06:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1389',
'John',
'Harris'
);


INSERT INTO flight
VALUES (
'1390',
'319',
'2020-12-11 05:30:00',
'SFO',
26,
'2020-12-11 06:00:00',
'ATL',
69,
'2020-12-11 08:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1390',
'William',
'Davis'
);


INSERT INTO flight
VALUES (
'1391',
'330',
'2020-12-11 04:30:00',
'ATL',
105,
'2020-12-11 05:00:00',
'LAX',
31,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1391',
'Michael',
'Smith'
);


INSERT INTO flight
VALUES (
'1392',
'318',
'2020-12-11 08:30:00',
'SEA',
99,
'2020-12-11 09:00:00',
'LAS',
15,
'2020-12-11 12:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1392',
'James',
'Garcia'
);


INSERT INTO flight
VALUES (
'1393',
'340',
'2020-12-11 11:30:00',
'SEA',
103,
'2020-12-11 12:00:00',
'SFO',
89,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1393',
'Jacob',
'Thomas'
);


INSERT INTO flight
VALUES (
'1394',
'340',
'2020-12-11 04:30:00',
'SFO',
43,
'2020-12-11 05:00:00',
'SEA',
31,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1394',
'Liam',
'Thomas'
);


INSERT INTO flight
VALUES (
'1395',
'319',
'2020-12-11 09:30:00',
'LAS',
26,
'2020-12-11 10:00:00',
'SEA',
41,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1395',
'Liam',
'Thomas'
);


INSERT INTO flight
VALUES (
'1396',
'346',
'2020-12-11 10:30:00',
'MCO',
18,
'2020-12-11 11:00:00',
'DEN',
19,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1396',
'James',
'Thomas'
);


INSERT INTO flight
VALUES (
'1397',
'346',
'2020-12-11 12:30:00',
'ORD',
95,
'2020-12-11 13:00:00',
'LAS',
7,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1397',
'Jacob',
'Anderson'
);


INSERT INTO flight
VALUES (
'1398',
'342',
'2020-12-11 11:30:00',
'ORD',
99,
'2020-12-11 12:00:00',
'MCO',
71,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1398',
'Jacob',
'Garcia'
);


INSERT INTO flight
VALUES (
'1399',
'345',
'2020-12-11 11:30:00',
'DFW',
22,
'2020-12-11 12:00:00',
'SEA',
79,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1399',
'Michael',
'Smith'
);


INSERT INTO flight
VALUES (
'1400',
'321',
'2020-12-11 11:30:00',
'SFO',
18,
'2020-12-11 12:00:00',
'LAX',
106,
'2020-12-11 15:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1400',
'James',
'Smith'
);


INSERT INTO flight
VALUES (
'1401',
'345',
'2020-12-11 11:30:00',
'SFO',
89,
'2020-12-11 12:00:00',
'ATL',
74,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1401',
'James',
'Brown'
);


INSERT INTO flight
VALUES (
'1402',
'343',
'2020-12-11 05:30:00',
'JFK',
36,
'2020-12-11 06:00:00',
'ORD',
81,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1402',
'Mason',
'Garcia'
);


INSERT INTO flight
VALUES (
'1403',
'346',
'2020-12-11 08:30:00',
'ORD',
44,
'2020-12-11 09:00:00',
'DEN',
86,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1403',
'Michael',
'Thomas'
);


INSERT INTO flight
VALUES (
'1404',
'330',
'2020-12-11 03:30:00',
'ORD',
81,
'2020-12-11 04:00:00',
'MCO',
18,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1404',
'Alex',
'Brown'
);


INSERT INTO flight
VALUES (
'1405',
'318',
'2020-12-11 05:30:00',
'DFW',
75,
'2020-12-11 06:00:00',
'JFK',
73,
'2020-12-11 08:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1405',
'Ethan',
'Anderson'
);


INSERT INTO flight
VALUES (
'1406',
'342',
'2020-12-11 03:30:00',
'SFO',
22,
'2020-12-11 04:00:00',
'MCO',
25,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1406',
'Liam',
'Wang'
);


INSERT INTO flight
VALUES (
'1407',
'330',
'2020-12-11 12:30:00',
'LAS',
110,
'2020-12-11 13:00:00',
'SEA',
39,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1407',
'Jacob',
'Lee'
);


INSERT INTO flight
VALUES (
'1408',
'340',
'2020-12-11 07:30:00',
'ORD',
55,
'2020-12-11 08:00:00',
'LAS',
5,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1408',
'Alex',
'Thomas'
);


INSERT INTO flight
VALUES (
'1409',
'330',
'2020-12-11 09:30:00',
'ATL',
1,
'2020-12-11 10:00:00',
'LAS',
76,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1409',
'John',
'Smith'
);


INSERT INTO flight
VALUES (
'1410',
'342',
'2020-12-11 07:30:00',
'LAX',
28,
'2020-12-11 08:00:00',
'SFO',
22,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1410',
'Ethan',
'Wang'
);


INSERT INTO flight
VALUES (
'1411',
'321',
'2020-12-11 12:30:00',
'SEA',
47,
'2020-12-11 13:00:00',
'LAS',
68,
'2020-12-11 16:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1411',
'John',
'Harris'
);


INSERT INTO flight
VALUES (
'1412',
'319',
'2020-12-11 08:30:00',
'JFK',
72,
'2020-12-11 09:00:00',
'DFW',
65,
'2020-12-11 12:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1412',
'William',
'Wang'
);


INSERT INTO flight
VALUES (
'1413',
'340',
'2020-12-11 05:30:00',
'MCO',
71,
'2020-12-11 06:00:00',
'SFO',
35,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1413',
'Alex',
'Wang'
);


INSERT INTO flight
VALUES (
'1414',
'318',
'2020-12-11 09:30:00',
'SEA',
77,
'2020-12-11 10:00:00',
'LAX',
19,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1414',
'Liam',
'Wang'
);


INSERT INTO flight
VALUES (
'1415',
'346',
'2020-12-11 10:30:00',
'DFW',
62,
'2020-12-11 11:00:00',
'ATL',
61,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1415',
'Michael',
'Miller'
);


INSERT INTO flight
VALUES (
'1416',
'318',
'2020-12-11 05:30:00',
'SEA',
89,
'2020-12-11 06:00:00',
'SFO',
4,
'2020-12-11 08:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1416',
'James',
'Miller'
);


INSERT INTO flight
VALUES (
'1417',
'310',
'2020-12-11 04:30:00',
'LAX',
62,
'2020-12-11 05:00:00',
'MCO',
45,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1417',
'Alex',
'Miller'
);


INSERT INTO flight
VALUES (
'1418',
'342',
'2020-12-11 05:30:00',
'LAX',
106,
'2020-12-11 06:00:00',
'LAS',
23,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1418',
'Mason',
'Davis'
);


INSERT INTO flight
VALUES (
'1419',
'321',
'2020-12-11 08:30:00',
'MCO',
20,
'2020-12-11 09:00:00',
'DFW',
39,
'2020-12-11 12:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1419',
'James',
'Anderson'
);


INSERT INTO flight
VALUES (
'1420',
'343',
'2020-12-11 04:30:00',
'LAX',
99,
'2020-12-11 05:00:00',
'ATL',
23,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1420',
'Michael',
'Smith'
);


INSERT INTO flight
VALUES (
'1421',
'319',
'2020-12-11 10:30:00',
'DFW',
82,
'2020-12-11 11:00:00',
'SFO',
77,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1421',
'Mason',
'Garcia'
);


INSERT INTO flight
VALUES (
'1422',
'330',
'2020-12-11 05:30:00',
'JFK',
25,
'2020-12-11 06:00:00',
'DFW',
18,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1422',
'John',
'Brown'
);


INSERT INTO flight
VALUES (
'1423',
'340',
'2020-12-11 07:30:00',
'ORD',
14,
'2020-12-11 08:00:00',
'DFW',
73,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1423',
'Jacob',
'Thomas'
);


INSERT INTO flight
VALUES (
'1424',
'310',
'2020-12-11 09:30:00',
'JFK',
26,
'2020-12-11 10:00:00',
'ATL',
41,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1424',
'William',
'Smith'
);


INSERT INTO flight
VALUES (
'1425',
'342',
'2020-12-11 05:30:00',
'SFO',
52,
'2020-12-11 06:00:00',
'JFK',
65,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1425',
'William',
'Harris'
);


INSERT INTO flight
VALUES (
'1426',
'342',
'2020-12-11 12:30:00',
'ORD',
65,
'2020-12-11 13:00:00',
'ATL',
80,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1426',
'James',
'Thomas'
);


INSERT INTO flight
VALUES (
'1427',
'345',
'2020-12-11 12:30:00',
'SFO',
25,
'2020-12-11 13:00:00',
'DFW',
2,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1427',
'Alex',
'Brown'
);


INSERT INTO flight
VALUES (
'1428',
'346',
'2020-12-11 05:30:00',
'MCO',
30,
'2020-12-11 06:00:00',
'SFO',
48,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1428',
'Jacob',
'Smith'
);


INSERT INTO flight
VALUES (
'1429',
'310',
'2020-12-11 12:30:00',
'ORD',
13,
'2020-12-11 13:00:00',
'ATL',
60,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1429',
'Liam',
'Wang'
);


INSERT INTO flight
VALUES (
'1430',
'330',
'2020-12-11 03:30:00',
'DFW',
26,
'2020-12-11 04:00:00',
'JFK',
85,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1430',
'Michael',
'Brown'
);


INSERT INTO flight
VALUES (
'1431',
'310',
'2020-12-11 07:30:00',
'LAS',
39,
'2020-12-11 08:00:00',
'SEA',
105,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1431',
'James',
'Thomas'
);


INSERT INTO flight
VALUES (
'1432',
'310',
'2020-12-11 05:30:00',
'DEN',
100,
'2020-12-11 06:00:00',
'DFW',
13,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1432',
'Liam',
'Anderson'
);


INSERT INTO flight
VALUES (
'1433',
'346',
'2020-12-11 04:30:00',
'LAX',
98,
'2020-12-11 05:00:00',
'ATL',
100,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1433',
'Liam',
'Harris'
);


INSERT INTO flight
VALUES (
'1434',
'318',
'2020-12-11 10:30:00',
'DEN',
1,
'2020-12-11 11:00:00',
'SFO',
29,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1434',
'Liam',
'Thomas'
);


INSERT INTO flight
VALUES (
'1435',
'342',
'2020-12-11 08:30:00',
'SEA',
32,
'2020-12-11 09:00:00',
'JFK',
21,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1435',
'William',
'Harris'
);


INSERT INTO flight
VALUES (
'1436',
'321',
'2020-12-11 10:30:00',
'SEA',
82,
'2020-12-11 11:00:00',
'MCO',
14,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1436',
'Mason',
'Wang'
);


INSERT INTO flight
VALUES (
'1437',
'340',
'2020-12-11 07:30:00',
'SEA',
79,
'2020-12-11 08:00:00',
'LAX',
74,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1437',
'Liam',
'Lee'
);


INSERT INTO flight
VALUES (
'1438',
'321',
'2020-12-11 12:30:00',
'MCO',
56,
'2020-12-11 13:00:00',
'LAX',
32,
'2020-12-11 16:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1438',
'Liam',
'Harris'
);


INSERT INTO flight
VALUES (
'1439',
'318',
'2020-12-11 07:30:00',
'LAS',
2,
'2020-12-11 08:00:00',
'DEN',
100,
'2020-12-11 10:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1439',
'James',
'Brown'
);


INSERT INTO flight
VALUES (
'1440',
'321',
'2020-12-11 09:30:00',
'DEN',
64,
'2020-12-11 10:00:00',
'LAX',
91,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1440',
'James',
'Wang'
);


INSERT INTO flight
VALUES (
'1441',
'345',
'2020-12-11 09:30:00',
'LAX',
87,
'2020-12-11 10:00:00',
'DFW',
10,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1441',
'Liam',
'Davis'
);


INSERT INTO flight
VALUES (
'1442',
'318',
'2020-12-11 08:30:00',
'DFW',
3,
'2020-12-11 09:00:00',
'LAX',
52,
'2020-12-11 12:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1442',
'Noah',
'Wang'
);


INSERT INTO flight
VALUES (
'1443',
'310',
'2020-12-11 10:30:00',
'SFO',
37,
'2020-12-11 11:00:00',
'ATL',
85,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1443',
'William',
'Smith'
);


INSERT INTO flight
VALUES (
'1444',
'321',
'2020-12-11 09:30:00',
'ATL',
103,
'2020-12-11 10:00:00',
'MCO',
2,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1444',
'James',
'Miller'
);


INSERT INTO flight
VALUES (
'1445',
'321',
'2020-12-11 04:30:00',
'LAX',
52,
'2020-12-11 05:00:00',
'ORD',
32,
'2020-12-11 07:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1445',
'Mason',
'Brown'
);


INSERT INTO flight
VALUES (
'1446',
'346',
'2020-12-11 07:30:00',
'ATL',
91,
'2020-12-11 08:00:00',
'MCO',
35,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1446',
'John',
'Garcia'
);


INSERT INTO flight
VALUES (
'1447',
'330',
'2020-12-11 08:30:00',
'SEA',
40,
'2020-12-11 09:00:00',
'ORD',
54,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1447',
'John',
'Thomas'
);


INSERT INTO flight
VALUES (
'1448',
'342',
'2020-12-11 12:30:00',
'SFO',
15,
'2020-12-11 13:00:00',
'DEN',
25,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1448',
'Liam',
'Davis'
);


INSERT INTO flight
VALUES (
'1449',
'321',
'2020-12-11 07:30:00',
'MCO',
42,
'2020-12-11 08:00:00',
'ORD',
3,
'2020-12-11 10:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1449',
'Alex',
'Harris'
);


INSERT INTO flight
VALUES (
'1450',
'319',
'2020-12-11 09:30:00',
'SFO',
69,
'2020-12-11 10:00:00',
'DFW',
97,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1450',
'Ethan',
'Thomas'
);


INSERT INTO flight
VALUES (
'1451',
'340',
'2020-12-11 06:30:00',
'ATL',
61,
'2020-12-11 07:00:00',
'JFK',
27,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1451',
'Jacob',
'Thomas'
);


INSERT INTO flight
VALUES (
'1452',
'346',
'2020-12-11 09:30:00',
'LAX',
96,
'2020-12-11 10:00:00',
'MCO',
50,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1452',
'Liam',
'Smith'
);


INSERT INTO flight
VALUES (
'1453',
'342',
'2020-12-11 12:30:00',
'DEN',
67,
'2020-12-11 13:00:00',
'ORD',
34,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1453',
'Mason',
'Miller'
);


INSERT INTO flight
VALUES (
'1454',
'321',
'2020-12-11 10:30:00',
'DEN',
4,
'2020-12-11 11:00:00',
'JFK',
66,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1454',
'Mason',
'Miller'
);


INSERT INTO flight
VALUES (
'1455',
'310',
'2020-12-11 06:30:00',
'DFW',
24,
'2020-12-11 07:00:00',
'JFK',
65,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1455',
'James',
'Brown'
);


INSERT INTO flight
VALUES (
'1456',
'321',
'2020-12-11 03:30:00',
'SFO',
105,
'2020-12-11 04:00:00',
'ORD',
74,
'2020-12-11 06:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1456',
'Alex',
'Anderson'
);


INSERT INTO flight
VALUES (
'1457',
'321',
'2020-12-11 07:30:00',
'SEA',
89,
'2020-12-11 08:00:00',
'JFK',
43,
'2020-12-11 10:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1457',
'Mason',
'Thomas'
);


INSERT INTO flight
VALUES (
'1458',
'319',
'2020-12-11 03:30:00',
'DEN',
33,
'2020-12-11 04:00:00',
'DFW',
56,
'2020-12-11 06:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1458',
'Ethan',
'Davis'
);


INSERT INTO flight
VALUES (
'1459',
'342',
'2020-12-11 12:30:00',
'SFO',
109,
'2020-12-11 13:00:00',
'LAS',
87,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1459',
'Mason',
'Anderson'
);


INSERT INTO flight
VALUES (
'1460',
'343',
'2020-12-11 12:30:00',
'ORD',
107,
'2020-12-11 13:00:00',
'SEA',
42,
'2020-12-11 16:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1460',
'Michael',
'Davis'
);


INSERT INTO flight
VALUES (
'1461',
'318',
'2020-12-11 06:30:00',
'SEA',
101,
'2020-12-11 07:00:00',
'SFO',
73,
'2020-12-11 10:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1461',
'Jacob',
'Thomas'
);


INSERT INTO flight
VALUES (
'1462',
'330',
'2020-12-11 04:30:00',
'MCO',
103,
'2020-12-11 05:00:00',
'SFO',
80,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1462',
'John',
'Garcia'
);


INSERT INTO flight
VALUES (
'1463',
'342',
'2020-12-11 05:30:00',
'ORD',
36,
'2020-12-11 06:00:00',
'LAX',
70,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1463',
'William',
'Thomas'
);


INSERT INTO flight
VALUES (
'1464',
'310',
'2020-12-11 03:30:00',
'ATL',
66,
'2020-12-11 04:00:00',
'LAS',
14,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1464',
'William',
'Miller'
);


INSERT INTO flight
VALUES (
'1465',
'318',
'2020-12-11 08:30:00',
'SEA',
19,
'2020-12-11 09:00:00',
'LAS',
68,
'2020-12-11 12:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1465',
'Noah',
'Lee'
);


INSERT INTO flight
VALUES (
'1466',
'318',
'2020-12-11 11:30:00',
'ATL',
30,
'2020-12-11 12:00:00',
'LAX',
47,
'2020-12-11 15:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1466',
'William',
'Lee'
);


INSERT INTO flight
VALUES (
'1467',
'318',
'2020-12-11 05:30:00',
'ATL',
25,
'2020-12-11 06:00:00',
'ORD',
85,
'2020-12-11 08:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1467',
'Liam',
'Smith'
);


INSERT INTO flight
VALUES (
'1468',
'345',
'2020-12-11 10:30:00',
'MCO',
79,
'2020-12-11 11:00:00',
'DEN',
39,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1468',
'Liam',
'Thomas'
);


INSERT INTO flight
VALUES (
'1469',
'318',
'2020-12-11 09:30:00',
'JFK',
96,
'2020-12-11 10:00:00',
'ATL',
104,
'2020-12-11 13:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1469',
'James',
'Brown'
);


INSERT INTO flight
VALUES (
'1470',
'310',
'2020-12-11 06:30:00',
'SEA',
6,
'2020-12-11 07:00:00',
'DFW',
28,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1470',
'Jacob',
'Lee'
);


INSERT INTO flight
VALUES (
'1471',
'343',
'2020-12-11 11:30:00',
'DEN',
90,
'2020-12-11 12:00:00',
'DFW',
94,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1471',
'John',
'Anderson'
);


INSERT INTO flight
VALUES (
'1472',
'340',
'2020-12-11 08:30:00',
'ORD',
78,
'2020-12-11 09:00:00',
'ATL',
84,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1472',
'Mason',
'Smith'
);


INSERT INTO flight
VALUES (
'1473',
'342',
'2020-12-11 06:30:00',
'LAS',
21,
'2020-12-11 07:00:00',
'LAX',
78,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1473',
'Mason',
'Brown'
);


INSERT INTO flight
VALUES (
'1474',
'345',
'2020-12-11 10:30:00',
'SFO',
72,
'2020-12-11 11:00:00',
'DFW',
9,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1474',
'Mason',
'Anderson'
);


INSERT INTO flight
VALUES (
'1475',
'318',
'2020-12-11 05:30:00',
'JFK',
61,
'2020-12-11 06:00:00',
'ORD',
41,
'2020-12-11 08:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1475',
'Mason',
'Garcia'
);


INSERT INTO flight
VALUES (
'1476',
'310',
'2020-12-11 07:30:00',
'SFO',
52,
'2020-12-11 08:00:00',
'SEA',
67,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1476',
'Ethan',
'Wang'
);


INSERT INTO flight
VALUES (
'1477',
'330',
'2020-12-11 04:30:00',
'DEN',
40,
'2020-12-11 05:00:00',
'MCO',
33,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1477',
'William',
'Miller'
);


INSERT INTO flight
VALUES (
'1478',
'343',
'2020-12-11 03:30:00',
'SFO',
87,
'2020-12-11 04:00:00',
'ATL',
76,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1478',
'Jacob',
'Thomas'
);


INSERT INTO flight
VALUES (
'1479',
'319',
'2020-12-11 03:30:00',
'LAS',
3,
'2020-12-11 04:00:00',
'DFW',
1,
'2020-12-11 06:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1479',
'Noah',
'Brown'
);


INSERT INTO flight
VALUES (
'1480',
'310',
'2020-12-11 09:30:00',
'JFK',
99,
'2020-12-11 10:00:00',
'MCO',
47,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1480',
'Michael',
'Harris'
);


INSERT INTO flight
VALUES (
'1481',
'346',
'2020-12-11 04:30:00',
'LAX',
58,
'2020-12-11 05:00:00',
'ATL',
92,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1481',
'John',
'Smith'
);


INSERT INTO flight
VALUES (
'1482',
'318',
'2020-12-11 07:30:00',
'DEN',
10,
'2020-12-11 08:00:00',
'JFK',
14,
'2020-12-11 10:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1482',
'John',
'Harris'
);


INSERT INTO flight
VALUES (
'1483',
'310',
'2020-12-11 03:30:00',
'MCO',
90,
'2020-12-11 04:00:00',
'DFW',
40,
'2020-12-11 06:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1483',
'Michael',
'Wang'
);


INSERT INTO flight
VALUES (
'1484',
'330',
'2020-12-11 08:30:00',
'LAX',
37,
'2020-12-11 09:00:00',
'LAS',
90,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1484',
'Alex',
'Davis'
);


INSERT INTO flight
VALUES (
'1485',
'318',
'2020-12-11 08:30:00',
'LAX',
17,
'2020-12-11 09:00:00',
'JFK',
70,
'2020-12-11 12:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1485',
'James',
'Smith'
);


INSERT INTO flight
VALUES (
'1486',
'330',
'2020-12-11 05:30:00',
'JFK',
47,
'2020-12-11 06:00:00',
'SEA',
60,
'2020-12-11 08:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1486',
'Mason',
'Smith'
);


INSERT INTO flight
VALUES (
'1487',
'319',
'2020-12-11 07:30:00',
'SFO',
6,
'2020-12-11 08:00:00',
'DFW',
76,
'2020-12-11 10:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1487',
'Jacob',
'Davis'
);


INSERT INTO flight
VALUES (
'1488',
'318',
'2020-12-11 03:30:00',
'MCO',
52,
'2020-12-11 04:00:00',
'SEA',
109,
'2020-12-11 06:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1488',
'Mason',
'Harris'
);


INSERT INTO flight
VALUES (
'1489',
'346',
'2020-12-11 10:30:00',
'LAS',
7,
'2020-12-11 11:00:00',
'SEA',
50,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1489',
'Mason',
'Garcia'
);


INSERT INTO flight
VALUES (
'1490',
'310',
'2020-12-11 09:30:00',
'LAX',
37,
'2020-12-11 10:00:00',
'ORD',
67,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1490',
'John',
'Harris'
);


INSERT INTO flight
VALUES (
'1491',
'330',
'2020-12-11 07:30:00',
'JFK',
72,
'2020-12-11 08:00:00',
'MCO',
23,
'2020-12-11 10:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1491',
'Mason',
'Garcia'
);


INSERT INTO flight
VALUES (
'1492',
'319',
'2020-12-11 04:30:00',
'DEN',
78,
'2020-12-11 05:00:00',
'JFK',
107,
'2020-12-11 07:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1492',
'William',
'Miller'
);


INSERT INTO flight
VALUES (
'1493',
'330',
'2020-12-11 11:30:00',
'DEN',
3,
'2020-12-11 12:00:00',
'LAS',
17,
'2020-12-11 15:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1493',
'Jacob',
'Harris'
);


INSERT INTO flight
VALUES (
'1494',
'330',
'2020-12-11 09:30:00',
'LAX',
76,
'2020-12-11 10:00:00',
'LAS',
79,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1494',
'James',
'Wang'
);


INSERT INTO flight
VALUES (
'1495',
'346',
'2020-12-11 09:30:00',
'DFW',
16,
'2020-12-11 10:00:00',
'DEN',
87,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1495',
'Mason',
'Harris'
);


INSERT INTO flight
VALUES (
'1496',
'330',
'2020-12-11 10:30:00',
'JFK',
11,
'2020-12-11 11:00:00',
'LAX',
96,
'2020-12-11 13:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1496',
'Alex',
'Harris'
);


INSERT INTO flight
VALUES (
'1497',
'310',
'2020-12-11 04:30:00',
'SFO',
68,
'2020-12-11 05:00:00',
'LAX',
8,
'2020-12-11 07:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1497',
'Alex',
'Garcia'
);


INSERT INTO flight
VALUES (
'1498',
'342',
'2020-12-11 08:30:00',
'JFK',
68,
'2020-12-11 09:00:00',
'SFO',
110,
'2020-12-11 12:00:00',
'Scheduled',
0,
100,
0,
100,
0,
100,
TRUE,
TRUE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1498',
'William',
'Thomas'
);


INSERT INTO flight
VALUES (
'1499',
'318',
'2020-12-11 12:30:00',
'MCO',
100,
'2020-12-11 13:00:00',
'JFK',
28,
'2020-12-11 16:00:00',
'Scheduled',
0,
50,
0,
50,
0,
50,
FALSE,
FALSE
);


INSERT INTO pilot (flight_id, first_name, last_name)
VALUES (
'1499',
'Noah',
'Brown'
);


