DROP TABLE IF EXISTS passenger CASCADE;
DROP TABLE IF EXISTS credit_card CASCADE;
DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS airport CASCADE;
DROP TABLE IF EXISTS ticket CASCADE;
DROP TABLE IF EXISTS aircraft CASCADE;
DROP TABLE IF EXISTS flight CASCADE;

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

CREATE TABLE transactions(
  id SERIAL PRIMARY KEY,
  card_number NUMERIC(16,0) REFERENCES credit_card(card_number) NOT NULL,
  voucher VARCHAR,
  amount NUMERIC(7,2) NOT NULL,
  contact_email TEXT NOT NULL,
  contact_phone_number NUMERIC(10,0) NOT NULL
);

CREATE TABLE aircraft(
  aircraft_code CHAR(3) PRIMARY KEY,
  model CHAR(25) NOT NULL,
  "range" INTEGER NOT NULL,
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
  id SERIAL PRIMARY KEY,
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
  transaction_id SERIAL REFERENCES transactions(id) NOT NULL,
  flight_id SERIAL REFERENCES flight(id) NOT NULL,
  standby_flight_id SERIAL REFERENCES flight(id),
  passenger_id SERIAL REFERENCES passenger(id) NOT NULL,
  fare_condition CHAR VARYING(10) NOT NULL,
  baggage_claim_number SERIAL NOT NULL,
  boarding_no SERIAL NOT NULL
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

/** flight **/
INSERT INTO flight
VALUES (
'1000',
'342',
'2020-12-10 09:00:00',
'SEA',
109,
'2020-12-10 10:00:00',
'ORD',
89,
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


INSERT INTO flight
VALUES (
'1001',
'342',
'2020-12-10 09:00:00',
'DEN',
97,
'2020-12-10 10:00:00',
'LAX',
53,
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


INSERT INTO flight
VALUES (
'1002',
'318',
'2020-12-10 09:00:00',
'LAS',
45,
'2020-12-10 10:00:00',
'MCO',
45,
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


INSERT INTO flight
VALUES (
'1003',
'345',
'2020-12-10 09:00:00',
'SFO',
38,
'2020-12-10 10:00:00',
'ATL',
57,
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


INSERT INTO flight
VALUES (
'1004',
'340',
'2020-12-10 09:00:00',
'LAS',
102,
'2020-12-10 10:00:00',
'JFK',
33,
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


INSERT INTO flight
VALUES (
'1005',
'321',
'2020-12-10 09:00:00',
'ATL',
70,
'2020-12-10 10:00:00',
'MCO',
87,
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


INSERT INTO flight
VALUES (
'1006',
'345',
'2020-12-10 09:00:00',
'ORD',
75,
'2020-12-10 10:00:00',
'DFW',
66,
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


INSERT INTO flight
VALUES (
'1007',
'343',
'2020-12-10 09:00:00',
'ATL',
61,
'2020-12-10 10:00:00',
'ORD',
35,
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


INSERT INTO flight
VALUES (
'1008',
'346',
'2020-12-10 09:00:00',
'SFO',
42,
'2020-12-10 10:00:00',
'ORD',
9,
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


INSERT INTO flight
VALUES (
'1009',
'346',
'2020-12-10 09:00:00',
'LAS',
42,
'2020-12-10 10:00:00',
'JFK',
34,
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


INSERT INTO flight
VALUES (
'1010',
'321',
'2020-12-10 09:00:00',
'LAS',
84,
'2020-12-10 10:00:00',
'DEN',
61,
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


INSERT INTO flight
VALUES (
'1011',
'343',
'2020-12-10 09:00:00',
'SEA',
61,
'2020-12-10 10:00:00',
'DFW',
23,
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


INSERT INTO flight
VALUES (
'1012',
'330',
'2020-12-10 09:00:00',
'DFW',
25,
'2020-12-10 10:00:00',
'SEA',
20,
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


INSERT INTO flight
VALUES (
'1013',
'319',
'2020-12-10 09:00:00',
'SFO',
50,
'2020-12-10 10:00:00',
'LAX',
69,
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


INSERT INTO flight
VALUES (
'1014',
'342',
'2020-12-10 09:00:00',
'DFW',
98,
'2020-12-10 10:00:00',
'LAS',
78,
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


INSERT INTO flight
VALUES (
'1015',
'340',
'2020-12-10 09:00:00',
'MCO',
20,
'2020-12-10 10:00:00',
'DFW',
96,
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


INSERT INTO flight
VALUES (
'1016',
'310',
'2020-12-10 09:00:00',
'SEA',
91,
'2020-12-10 10:00:00',
'SFO',
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


INSERT INTO flight
VALUES (
'1017',
'319',
'2020-12-10 09:00:00',
'JFK',
18,
'2020-12-10 10:00:00',
'DFW',
98,
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


INSERT INTO flight
VALUES (
'1018',
'346',
'2020-12-10 09:00:00',
'MCO',
16,
'2020-12-10 10:00:00',
'DFW',
62,
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


INSERT INTO flight
VALUES (
'1019',
'342',
'2020-12-10 09:00:00',
'LAX',
108,
'2020-12-10 10:00:00',
'ATL',
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


INSERT INTO flight
VALUES (
'1020',
'330',
'2020-12-10 09:00:00',
'LAX',
79,
'2020-12-10 10:00:00',
'JFK',
12,
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


INSERT INTO flight
VALUES (
'1021',
'321',
'2020-12-10 09:00:00',
'SEA',
70,
'2020-12-10 10:00:00',
'LAS',
30,
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


INSERT INTO flight
VALUES (
'1022',
'310',
'2020-12-10 09:00:00',
'JFK',
33,
'2020-12-10 10:00:00',
'DEN',
18,
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


INSERT INTO flight
VALUES (
'1023',
'345',
'2020-12-10 09:00:00',
'LAS',
64,
'2020-12-10 10:00:00',
'SEA',
27,
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


INSERT INTO flight
VALUES (
'1024',
'318',
'2020-12-10 09:00:00',
'ORD',
49,
'2020-12-10 10:00:00',
'ATL',
16,
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


INSERT INTO flight
VALUES (
'1025',
'318',
'2020-12-10 09:00:00',
'MCO',
38,
'2020-12-10 10:00:00',
'ATL',
8,
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


INSERT INTO flight
VALUES (
'1026',
'343',
'2020-12-10 09:00:00',
'DEN',
14,
'2020-12-10 10:00:00',
'LAX',
1,
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


INSERT INTO flight
VALUES (
'1027',
'343',
'2020-12-10 09:00:00',
'ATL',
69,
'2020-12-10 10:00:00',
'DFW',
52,
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


INSERT INTO flight
VALUES (
'1028',
'310',
'2020-12-10 09:00:00',
'LAS',
77,
'2020-12-10 10:00:00',
'DEN',
23,
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


INSERT INTO flight
VALUES (
'1029',
'321',
'2020-12-10 09:00:00',
'JFK',
111,
'2020-12-10 10:00:00',
'ATL',
57,
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


INSERT INTO flight
VALUES (
'1030',
'321',
'2020-12-10 09:00:00',
'MCO',
55,
'2020-12-10 10:00:00',
'LAS',
43,
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


INSERT INTO flight
VALUES (
'1031',
'321',
'2020-12-10 09:00:00',
'ORD',
17,
'2020-12-10 10:00:00',
'LAS',
70,
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


INSERT INTO flight
VALUES (
'1032',
'346',
'2020-12-10 09:00:00',
'SFO',
12,
'2020-12-10 10:00:00',
'SEA',
99,
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


INSERT INTO flight
VALUES (
'1033',
'319',
'2020-12-10 09:00:00',
'ORD',
19,
'2020-12-10 10:00:00',
'DFW',
89,
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


INSERT INTO flight
VALUES (
'1034',
'340',
'2020-12-10 09:00:00',
'SEA',
19,
'2020-12-10 10:00:00',
'MCO',
36,
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


INSERT INTO flight
VALUES (
'1035',
'310',
'2020-12-10 09:00:00',
'ORD',
74,
'2020-12-10 10:00:00',
'JFK',
3,
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


INSERT INTO flight
VALUES (
'1036',
'346',
'2020-12-10 09:00:00',
'LAS',
4,
'2020-12-10 10:00:00',
'SFO',
87,
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


INSERT INTO flight
VALUES (
'1037',
'340',
'2020-12-10 09:00:00',
'MCO',
65,
'2020-12-10 10:00:00',
'ORD',
85,
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


INSERT INTO flight
VALUES (
'1038',
'340',
'2020-12-10 09:00:00',
'JFK',
70,
'2020-12-10 10:00:00',
'LAS',
27,
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


INSERT INTO flight
VALUES (
'1039',
'345',
'2020-12-10 09:00:00',
'MCO',
108,
'2020-12-10 10:00:00',
'DEN',
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


INSERT INTO flight
VALUES (
'1040',
'340',
'2020-12-10 09:00:00',
'DFW',
53,
'2020-12-10 10:00:00',
'LAS',
7,
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


INSERT INTO flight
VALUES (
'1041',
'321',
'2020-12-10 09:00:00',
'SEA',
8,
'2020-12-10 10:00:00',
'ATL',
89,
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


INSERT INTO flight
VALUES (
'1042',
'343',
'2020-12-10 09:00:00',
'DEN',
9,
'2020-12-10 10:00:00',
'JFK',
53,
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


INSERT INTO flight
VALUES (
'1043',
'321',
'2020-12-10 09:00:00',
'JFK',
110,
'2020-12-10 10:00:00',
'ORD',
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


INSERT INTO flight
VALUES (
'1044',
'330',
'2020-12-10 09:00:00',
'LAS',
9,
'2020-12-10 10:00:00',
'DFW',
35,
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


INSERT INTO flight
VALUES (
'1045',
'345',
'2020-12-10 09:00:00',
'LAX',
68,
'2020-12-10 10:00:00',
'SEA',
4,
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


INSERT INTO flight
VALUES (
'1046',
'340',
'2020-12-10 09:00:00',
'LAX',
42,
'2020-12-10 10:00:00',
'JFK',
75,
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


INSERT INTO flight
VALUES (
'1047',
'321',
'2020-12-10 09:00:00',
'MCO',
6,
'2020-12-10 10:00:00',
'DFW',
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


INSERT INTO flight
VALUES (
'1048',
'330',
'2020-12-10 09:00:00',
'MCO',
1,
'2020-12-10 10:00:00',
'ATL',
41,
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


INSERT INTO flight
VALUES (
'1049',
'318',
'2020-12-10 09:00:00',
'ORD',
91,
'2020-12-10 10:00:00',
'SFO',
87,
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


INSERT INTO flight
VALUES (
'1050',
'318',
'2020-12-10 09:00:00',
'ORD',
15,
'2020-12-10 10:00:00',
'ATL',
90,
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


INSERT INTO flight
VALUES (
'1051',
'343',
'2020-12-11 09:00:00',
'MCO',
30,
'2020-12-11 10:00:00',
'ATL',
99,
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


INSERT INTO flight
VALUES (
'1052',
'318',
'2020-12-11 09:00:00',
'LAS',
43,
'2020-12-11 10:00:00',
'JFK',
4,
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


INSERT INTO flight
VALUES (
'1053',
'330',
'2020-12-11 09:00:00',
'LAX',
56,
'2020-12-11 10:00:00',
'SFO',
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


INSERT INTO flight
VALUES (
'1054',
'340',
'2020-12-11 09:00:00',
'DEN',
20,
'2020-12-11 10:00:00',
'JFK',
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


INSERT INTO flight
VALUES (
'1055',
'321',
'2020-12-11 09:00:00',
'ORD',
26,
'2020-12-11 10:00:00',
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


INSERT INTO flight
VALUES (
'1056',
'343',
'2020-12-11 09:00:00',
'ATL',
2,
'2020-12-11 10:00:00',
'ORD',
80,
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


INSERT INTO flight
VALUES (
'1057',
'330',
'2020-12-11 09:00:00',
'ORD',
48,
'2020-12-11 10:00:00',
'ATL',
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


INSERT INTO flight
VALUES (
'1058',
'342',
'2020-12-11 09:00:00',
'ORD',
111,
'2020-12-11 10:00:00',
'JFK',
69,
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


INSERT INTO flight
VALUES (
'1059',
'318',
'2020-12-11 09:00:00',
'SEA',
55,
'2020-12-11 10:00:00',
'DFW',
35,
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


INSERT INTO flight
VALUES (
'1060',
'310',
'2020-12-11 09:00:00',
'MCO',
81,
'2020-12-11 10:00:00',
'DEN',
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


INSERT INTO flight
VALUES (
'1061',
'342',
'2020-12-11 09:00:00',
'DFW',
4,
'2020-12-11 10:00:00',
'ATL',
17,
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


INSERT INTO flight
VALUES (
'1062',
'346',
'2020-12-11 09:00:00',
'ORD',
110,
'2020-12-11 10:00:00',
'JFK',
78,
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


INSERT INTO flight
VALUES (
'1063',
'321',
'2020-12-11 09:00:00',
'DFW',
36,
'2020-12-11 10:00:00',
'DEN',
12,
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


INSERT INTO flight
VALUES (
'1064',
'321',
'2020-12-11 09:00:00',
'ATL',
19,
'2020-12-11 10:00:00',
'MCO',
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


INSERT INTO flight
VALUES (
'1065',
'330',
'2020-12-11 09:00:00',
'LAS',
55,
'2020-12-11 10:00:00',
'DEN',
38,
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


INSERT INTO flight
VALUES (
'1066',
'330',
'2020-12-11 09:00:00',
'DEN',
77,
'2020-12-11 10:00:00',
'ORD',
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


INSERT INTO flight
VALUES (
'1067',
'330',
'2020-12-11 09:00:00',
'MCO',
92,
'2020-12-11 10:00:00',
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


INSERT INTO flight
VALUES (
'1068',
'321',
'2020-12-11 09:00:00',
'JFK',
61,
'2020-12-11 10:00:00',
'SFO',
76,
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


INSERT INTO flight
VALUES (
'1069',
'343',
'2020-12-11 09:00:00',
'MCO',
39,
'2020-12-11 10:00:00',
'LAS',
17,
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


INSERT INTO flight
VALUES (
'1070',
'318',
'2020-12-11 09:00:00',
'LAS',
6,
'2020-12-11 10:00:00',
'SFO',
109,
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


INSERT INTO flight
VALUES (
'1071',
'346',
'2020-12-11 09:00:00',
'SFO',
108,
'2020-12-11 10:00:00',
'SEA',
1,
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


INSERT INTO flight
VALUES (
'1072',
'310',
'2020-12-11 09:00:00',
'DFW',
98,
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


INSERT INTO flight
VALUES (
'1073',
'343',
'2020-12-11 09:00:00',
'ORD',
108,
'2020-12-11 10:00:00',
'DFW',
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


INSERT INTO flight
VALUES (
'1074',
'340',
'2020-12-11 09:00:00',
'DFW',
86,
'2020-12-11 10:00:00',
'ATL',
108,
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


INSERT INTO flight
VALUES (
'1075',
'318',
'2020-12-11 09:00:00',
'DEN',
68,
'2020-12-11 10:00:00',
'ORD',
98,
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


INSERT INTO flight
VALUES (
'1076',
'321',
'2020-12-11 09:00:00',
'ORD',
63,
'2020-12-11 10:00:00',
'ATL',
88,
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


INSERT INTO flight
VALUES (
'1077',
'343',
'2020-12-11 09:00:00',
'JFK',
48,
'2020-12-11 10:00:00',
'LAS',
108,
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


INSERT INTO flight
VALUES (
'1078',
'340',
'2020-12-11 09:00:00',
'LAX',
69,
'2020-12-11 10:00:00',
'SFO',
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


INSERT INTO flight
VALUES (
'1079',
'345',
'2020-12-11 09:00:00',
'ATL',
98,
'2020-12-11 10:00:00',
'LAX',
17,
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


INSERT INTO flight
VALUES (
'1080',
'318',
'2020-12-11 09:00:00',
'MCO',
57,
'2020-12-11 10:00:00',
'SFO',
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


INSERT INTO flight
VALUES (
'1081',
'342',
'2020-12-11 09:00:00',
'LAS',
90,
'2020-12-11 10:00:00',
'ATL',
55,
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


INSERT INTO flight
VALUES (
'1082',
'330',
'2020-12-11 09:00:00',
'LAS',
50,
'2020-12-11 10:00:00',
'DFW',
46,
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


INSERT INTO flight
VALUES (
'1083',
'340',
'2020-12-11 09:00:00',
'DEN',
88,
'2020-12-11 10:00:00',
'LAX',
107,
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


INSERT INTO flight
VALUES (
'1084',
'343',
'2020-12-11 09:00:00',
'SFO',
84,
'2020-12-11 10:00:00',
'ATL',
111,
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


INSERT INTO flight
VALUES (
'1085',
'342',
'2020-12-11 09:00:00',
'SFO',
97,
'2020-12-11 10:00:00',
'LAX',
110,
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


INSERT INTO flight
VALUES (
'1086',
'310',
'2020-12-11 09:00:00',
'SEA',
96,
'2020-12-11 10:00:00',
'DFW',
111,
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


INSERT INTO flight
VALUES (
'1087',
'310',
'2020-12-11 09:00:00',
'LAX',
68,
'2020-12-11 10:00:00',
'SFO',
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


INSERT INTO flight
VALUES (
'1088',
'346',
'2020-12-11 09:00:00',
'DEN',
53,
'2020-12-11 10:00:00',
'JFK',
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


INSERT INTO flight
VALUES (
'1089',
'330',
'2020-12-11 09:00:00',
'JFK',
8,
'2020-12-11 10:00:00',
'ORD',
88,
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


INSERT INTO flight
VALUES (
'1090',
'340',
'2020-12-11 09:00:00',
'LAS',
104,
'2020-12-11 10:00:00',
'JFK',
42,
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


INSERT INTO flight
VALUES (
'1091',
'318',
'2020-12-11 09:00:00',
'LAX',
54,
'2020-12-11 10:00:00',
'DEN',
32,
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


INSERT INTO flight
VALUES (
'1092',
'330',
'2020-12-11 09:00:00',
'SEA',
60,
'2020-12-11 10:00:00',
'DFW',
16,
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


INSERT INTO flight
VALUES (
'1093',
'345',
'2020-12-11 09:00:00',
'LAS',
55,
'2020-12-11 10:00:00',
'ORD',
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


INSERT INTO flight
VALUES (
'1094',
'318',
'2020-12-11 09:00:00',
'DEN',
3,
'2020-12-11 10:00:00',
'DFW',
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


INSERT INTO flight
VALUES (
'1095',
'346',
'2020-12-11 09:00:00',
'ATL',
41,
'2020-12-11 10:00:00',
'LAX',
11,
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


INSERT INTO flight
VALUES (
'1096',
'318',
'2020-12-11 09:00:00',
'LAS',
39,
'2020-12-11 10:00:00',
'SEA',
65,
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


INSERT INTO flight
VALUES (
'1097',
'342',
'2020-12-11 09:00:00',
'DEN',
104,
'2020-12-11 10:00:00',
'LAS',
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


INSERT INTO flight
VALUES (
'1098',
'342',
'2020-12-11 09:00:00',
'MCO',
56,
'2020-12-11 10:00:00',
'ATL',
52,
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


INSERT INTO flight
VALUES (
'1099',
'345',
'2020-12-11 09:00:00',
'SEA',
109,
'2020-12-11 10:00:00',
'SFO',
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


INSERT INTO flight
VALUES (
'1100',
'346',
'2020-12-11 09:00:00',
'JFK',
83,
'2020-12-11 10:00:00',
'SEA',
17,
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


INSERT INTO flight
VALUES (
'1101',
'346',
'2020-12-11 09:00:00',
'DFW',
13,
'2020-12-11 10:00:00',
'LAX',
93,
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


INSERT INTO flight
VALUES (
'1102',
'342',
'2020-12-11 09:00:00',
'SFO',
93,
'2020-12-11 10:00:00',
'LAX',
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


INSERT INTO flight
VALUES (
'1103',
'345',
'2020-12-11 09:00:00',
'SEA',
8,
'2020-12-11 10:00:00',
'MCO',
105,
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


INSERT INTO flight
VALUES (
'1104',
'319',
'2020-12-11 09:00:00',
'LAX',
94,
'2020-12-11 10:00:00',
'ORD',
39,
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


INSERT INTO flight
VALUES (
'1105',
'345',
'2020-12-11 09:00:00',
'SEA',
64,
'2020-12-11 10:00:00',
'ORD',
111,
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


INSERT INTO flight
VALUES (
'1106',
'318',
'2020-12-11 09:00:00',
'MCO',
14,
'2020-12-11 10:00:00',
'ORD',
50,
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


INSERT INTO flight
VALUES (
'1107',
'330',
'2020-12-11 09:00:00',
'DFW',
76,
'2020-12-11 10:00:00',
'ATL',
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


INSERT INTO flight
VALUES (
'1108',
'318',
'2020-12-11 09:00:00',
'DFW',
48,
'2020-12-11 10:00:00',
'ATL',
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


INSERT INTO flight
VALUES (
'1109',
'330',
'2020-12-11 09:00:00',
'MCO',
38,
'2020-12-11 10:00:00',
'LAS',
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


INSERT INTO flight
VALUES (
'1110',
'345',
'2020-12-11 09:00:00',
'DEN',
79,
'2020-12-11 10:00:00',
'JFK',
107,
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


INSERT INTO flight
VALUES (
'1111',
'319',
'2020-12-11 09:00:00',
'DEN',
24,
'2020-12-11 10:00:00',
'ORD',
106,
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


INSERT INTO flight
VALUES (
'1112',
'340',
'2020-12-11 09:00:00',
'DEN',
89,
'2020-12-11 10:00:00',
'SEA',
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


INSERT INTO flight
VALUES (
'1113',
'342',
'2020-12-11 09:00:00',
'ORD',
55,
'2020-12-11 10:00:00',
'LAX',
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


INSERT INTO flight
VALUES (
'1114',
'342',
'2020-12-11 09:00:00',
'LAS',
104,
'2020-12-11 10:00:00',
'DFW',
42,
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


INSERT INTO flight
VALUES (
'1115',
'345',
'2020-12-11 09:00:00',
'DFW',
86,
'2020-12-11 10:00:00',
'MCO',
101,
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


INSERT INTO flight
VALUES (
'1116',
'310',
'2020-12-11 09:00:00',
'SEA',
105,
'2020-12-11 10:00:00',
'JFK',
25,
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


INSERT INTO flight
VALUES (
'1117',
'345',
'2020-12-11 09:00:00',
'DFW',
95,
'2020-12-11 10:00:00',
'LAX',
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


INSERT INTO flight
VALUES (
'1118',
'340',
'2020-12-11 09:00:00',
'LAS',
80,
'2020-12-11 10:00:00',
'ORD',
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


INSERT INTO flight
VALUES (
'1119',
'342',
'2020-12-11 09:00:00',
'ATL',
110,
'2020-12-11 10:00:00',
'DEN',
102,
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


INSERT INTO flight
VALUES (
'1120',
'343',
'2020-12-11 09:00:00',
'SEA',
81,
'2020-12-11 10:00:00',
'SFO',
69,
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


INSERT INTO flight
VALUES (
'1121',
'345',
'2020-12-11 09:00:00',
'LAS',
93,
'2020-12-11 10:00:00',
'DFW',
44,
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


INSERT INTO flight
VALUES (
'1122',
'346',
'2020-12-11 09:00:00',
'ORD',
21,
'2020-12-11 10:00:00',
'JFK',
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


INSERT INTO flight
VALUES (
'1123',
'343',
'2020-12-11 09:00:00',
'LAS',
106,
'2020-12-11 10:00:00',
'SFO',
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


INSERT INTO flight
VALUES (
'1124',
'318',
'2020-12-11 09:00:00',
'JFK',
36,
'2020-12-11 10:00:00',
'LAS',
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


INSERT INTO flight
VALUES (
'1125',
'330',
'2020-12-11 09:00:00',
'DEN',
11,
'2020-12-11 10:00:00',
'SFO',
56,
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


INSERT INTO flight
VALUES (
'1126',
'346',
'2020-12-11 09:00:00',
'ATL',
57,
'2020-12-11 10:00:00',
'LAX',
54,
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


INSERT INTO flight
VALUES (
'1127',
'330',
'2020-12-11 09:00:00',
'SEA',
62,
'2020-12-11 10:00:00',
'SFO',
2,
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


INSERT INTO flight
VALUES (
'1128',
'346',
'2020-12-11 09:00:00',
'JFK',
85,
'2020-12-11 10:00:00',
'SFO',
97,
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


INSERT INTO flight
VALUES (
'1129',
'343',
'2020-12-11 09:00:00',
'DFW',
26,
'2020-12-11 10:00:00',
'JFK',
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


INSERT INTO flight
VALUES (
'1130',
'330',
'2020-12-11 09:00:00',
'LAX',
6,
'2020-12-11 10:00:00',
'LAS',
109,
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


INSERT INTO flight
VALUES (
'1131',
'330',
'2020-12-11 09:00:00',
'ORD',
82,
'2020-12-11 10:00:00',
'MCO',
48,
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


INSERT INTO flight
VALUES (
'1132',
'343',
'2020-12-11 09:00:00',
'DFW',
44,
'2020-12-11 10:00:00',
'ATL',
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


INSERT INTO flight
VALUES (
'1133',
'330',
'2020-12-11 09:00:00',
'LAS',
35,
'2020-12-11 10:00:00',
'ATL',
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


INSERT INTO flight
VALUES (
'1134',
'321',
'2020-12-11 09:00:00',
'DFW',
89,
'2020-12-11 10:00:00',
'MCO',
26,
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


INSERT INTO flight
VALUES (
'1135',
'345',
'2020-12-11 09:00:00',
'DFW',
10,
'2020-12-11 10:00:00',
'DEN',
44,
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


INSERT INTO flight
VALUES (
'1136',
'319',
'2020-12-11 09:00:00',
'DEN',
41,
'2020-12-11 10:00:00',
'ATL',
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


INSERT INTO flight
VALUES (
'1137',
'330',
'2020-12-11 09:00:00',
'DFW',
61,
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


INSERT INTO flight
VALUES (
'1138',
'340',
'2020-12-11 09:00:00',
'LAS',
110,
'2020-12-11 10:00:00',
'MCO',
95,
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


INSERT INTO flight
VALUES (
'1139',
'321',
'2020-12-11 09:00:00',
'JFK',
16,
'2020-12-11 10:00:00',
'DEN',
50,
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


INSERT INTO flight
VALUES (
'1140',
'318',
'2020-12-11 09:00:00',
'JFK',
85,
'2020-12-11 10:00:00',
'DEN',
10,
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


INSERT INTO flight
VALUES (
'1141',
'319',
'2020-12-11 09:00:00',
'ORD',
105,
'2020-12-11 10:00:00',
'LAX',
82,
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


INSERT INTO flight
VALUES (
'1142',
'342',
'2020-12-11 09:00:00',
'JFK',
10,
'2020-12-11 10:00:00',
'DEN',
6,
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


INSERT INTO flight
VALUES (
'1143',
'346',
'2020-12-11 09:00:00',
'MCO',
49,
'2020-12-11 10:00:00',
'LAS',
73,
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


INSERT INTO flight
VALUES (
'1144',
'346',
'2020-12-11 09:00:00',
'SEA',
49,
'2020-12-11 10:00:00',
'DFW',
98,
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


INSERT INTO flight
VALUES (
'1145',
'345',
'2020-12-11 09:00:00',
'ATL',
110,
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


INSERT INTO flight
VALUES (
'1146',
'318',
'2020-12-11 09:00:00',
'SEA',
106,
'2020-12-11 10:00:00',
'MCO',
54,
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


INSERT INTO flight
VALUES (
'1147',
'330',
'2020-12-11 09:00:00',
'DFW',
55,
'2020-12-11 10:00:00',
'LAS',
53,
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


INSERT INTO flight
VALUES (
'1148',
'340',
'2020-12-11 09:00:00',
'LAX',
29,
'2020-12-11 10:00:00',
'ATL',
20,
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


INSERT INTO flight
VALUES (
'1149',
'330',
'2020-12-11 09:00:00',
'SEA',
13,
'2020-12-11 10:00:00',
'MCO',
25,
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


INSERT INTO flight
VALUES (
'1150',
'345',
'2020-12-11 09:00:00',
'MCO',
4,
'2020-12-11 10:00:00',
'DFW',
13,
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


INSERT INTO flight
VALUES (
'1151',
'330',
'2020-12-11 09:00:00',
'SEA',
100,
'2020-12-11 10:00:00',
'ATL',
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


INSERT INTO flight
VALUES (
'1152',
'343',
'2020-12-11 09:00:00',
'SEA',
96,
'2020-12-11 10:00:00',
'JFK',
44,
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


INSERT INTO flight
VALUES (
'1153',
'346',
'2020-12-11 09:00:00',
'LAX',
71,
'2020-12-11 10:00:00',
'SEA',
35,
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


INSERT INTO flight
VALUES (
'1154',
'342',
'2020-12-11 09:00:00',
'JFK',
46,
'2020-12-11 10:00:00',
'ORD',
13,
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


INSERT INTO flight
VALUES (
'1155',
'310',
'2020-12-11 09:00:00',
'DFW',
16,
'2020-12-11 10:00:00',
'ORD',
21,
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


INSERT INTO flight
VALUES (
'1156',
'343',
'2020-12-11 09:00:00',
'DEN',
14,
'2020-12-11 10:00:00',
'SFO',
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


INSERT INTO flight
VALUES (
'1157',
'321',
'2020-12-11 09:00:00',
'SEA',
55,
'2020-12-11 10:00:00',
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


INSERT INTO flight
VALUES (
'1158',
'346',
'2020-12-11 09:00:00',
'LAX',
20,
'2020-12-11 10:00:00',
'ATL',
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


INSERT INTO flight
VALUES (
'1159',
'340',
'2020-12-11 09:00:00',
'MCO',
79,
'2020-12-11 10:00:00',
'LAS',
21,
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


INSERT INTO flight
VALUES (
'1160',
'342',
'2020-12-11 09:00:00',
'DFW',
98,
'2020-12-11 10:00:00',
'JFK',
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


INSERT INTO flight
VALUES (
'1161',
'310',
'2020-12-11 09:00:00',
'LAS',
5,
'2020-12-11 10:00:00',
'ORD',
17,
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


INSERT INTO flight
VALUES (
'1162',
'345',
'2020-12-11 09:00:00',
'JFK',
78,
'2020-12-11 10:00:00',
'LAS',
69,
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


INSERT INTO flight
VALUES (
'1163',
'319',
'2020-12-11 09:00:00',
'MCO',
6,
'2020-12-11 10:00:00',
'JFK',
4,
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


INSERT INTO flight
VALUES (
'1164',
'321',
'2020-12-11 09:00:00',
'ATL',
82,
'2020-12-11 10:00:00',
'SEA',
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


INSERT INTO flight
VALUES (
'1165',
'330',
'2020-12-11 09:00:00',
'LAS',
38,
'2020-12-11 10:00:00',
'MCO',
94,
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


INSERT INTO flight
VALUES (
'1166',
'342',
'2020-12-11 09:00:00',
'DEN',
67,
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


INSERT INTO flight
VALUES (
'1167',
'343',
'2020-12-11 09:00:00',
'SEA',
36,
'2020-12-11 10:00:00',
'ATL',
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


INSERT INTO flight
VALUES (
'1168',
'343',
'2020-12-11 09:00:00',
'LAS',
92,
'2020-12-11 10:00:00',
'DFW',
94,
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


INSERT INTO flight
VALUES (
'1169',
'330',
'2020-12-11 09:00:00',
'DFW',
27,
'2020-12-11 10:00:00',
'LAS',
7,
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


INSERT INTO flight
VALUES (
'1170',
'345',
'2020-12-11 09:00:00',
'DFW',
72,
'2020-12-11 10:00:00',
'ORD',
25,
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


INSERT INTO flight
VALUES (
'1171',
'342',
'2020-12-11 09:00:00',
'LAX',
104,
'2020-12-11 10:00:00',
'SFO',
16,
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


INSERT INTO flight
VALUES (
'1172',
'343',
'2020-12-11 09:00:00',
'LAX',
61,
'2020-12-11 10:00:00',
'JFK',
1,
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


INSERT INTO flight
VALUES (
'1173',
'343',
'2020-12-11 09:00:00',
'SEA',
32,
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


INSERT INTO flight
VALUES (
'1174',
'342',
'2020-12-11 09:00:00',
'ORD',
102,
'2020-12-11 10:00:00',
'JFK',
109,
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


INSERT INTO flight
VALUES (
'1175',
'346',
'2020-12-11 09:00:00',
'SEA',
74,
'2020-12-11 10:00:00',
'LAS',
52,
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


INSERT INTO flight
VALUES (
'1176',
'345',
'2020-12-11 09:00:00',
'JFK',
17,
'2020-12-11 10:00:00',
'ATL',
29,
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


INSERT INTO flight
VALUES (
'1177',
'321',
'2020-12-11 09:00:00',
'LAS',
25,
'2020-12-11 10:00:00',
'DEN',
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


INSERT INTO flight
VALUES (
'1178',
'310',
'2020-12-11 09:00:00',
'ATL',
57,
'2020-12-11 10:00:00',
'DEN',
109,
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


INSERT INTO flight
VALUES (
'1179',
'319',
'2020-12-11 09:00:00',
'JFK',
13,
'2020-12-11 10:00:00',
'DEN',
92,
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


INSERT INTO flight
VALUES (
'1180',
'346',
'2020-12-11 09:00:00',
'DFW',
101,
'2020-12-11 10:00:00',
'SEA',
98,
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


INSERT INTO flight
VALUES (
'1181',
'321',
'2020-12-11 09:00:00',
'SFO',
54,
'2020-12-11 10:00:00',
'MCO',
88,
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


INSERT INTO flight
VALUES (
'1182',
'343',
'2020-12-11 09:00:00',
'ORD',
45,
'2020-12-11 10:00:00',
'LAX',
65,
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


INSERT INTO flight
VALUES (
'1183',
'345',
'2020-12-11 09:00:00',
'MCO',
65,
'2020-12-11 10:00:00',
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


INSERT INTO flight
VALUES (
'1184',
'342',
'2020-12-11 09:00:00',
'LAS',
16,
'2020-12-11 10:00:00',
'SEA',
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


INSERT INTO flight
VALUES (
'1185',
'342',
'2020-12-11 09:00:00',
'LAX',
84,
'2020-12-11 10:00:00',
'JFK',
35,
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


INSERT INTO flight
VALUES (
'1186',
'321',
'2020-12-11 09:00:00',
'MCO',
46,
'2020-12-11 10:00:00',
'LAX',
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


INSERT INTO flight
VALUES (
'1187',
'342',
'2020-12-11 09:00:00',
'ORD',
61,
'2020-12-11 10:00:00',
'DEN',
55,
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


INSERT INTO flight
VALUES (
'1188',
'318',
'2020-12-11 09:00:00',
'MCO',
33,
'2020-12-11 10:00:00',
'SFO',
40,
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


INSERT INTO flight
VALUES (
'1189',
'330',
'2020-12-11 09:00:00',
'JFK',
106,
'2020-12-11 10:00:00',
'DEN',
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


INSERT INTO flight
VALUES (
'1190',
'330',
'2020-12-11 09:00:00',
'JFK',
102,
'2020-12-11 10:00:00',
'MCO',
35,
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


INSERT INTO flight
VALUES (
'1191',
'340',
'2020-12-11 09:00:00',
'LAS',
111,
'2020-12-11 10:00:00',
'SFO',
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


INSERT INTO flight
VALUES (
'1192',
'346',
'2020-12-11 09:00:00',
'ATL',
3,
'2020-12-11 10:00:00',
'ORD',
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


INSERT INTO flight
VALUES (
'1193',
'318',
'2020-12-11 09:00:00',
'ORD',
71,
'2020-12-11 10:00:00',
'DFW',
65,
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


INSERT INTO flight
VALUES (
'1194',
'310',
'2020-12-11 09:00:00',
'JFK',
2,
'2020-12-11 10:00:00',
'DFW',
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


INSERT INTO flight
VALUES (
'1195',
'310',
'2020-12-11 09:00:00',
'MCO',
26,
'2020-12-11 10:00:00',
'DEN',
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


INSERT INTO flight
VALUES (
'1196',
'330',
'2020-12-11 09:00:00',
'SFO',
103,
'2020-12-11 10:00:00',
'JFK',
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


INSERT INTO flight
VALUES (
'1197',
'319',
'2020-12-11 09:00:00',
'SFO',
27,
'2020-12-11 10:00:00',
'SEA',
53,
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


INSERT INTO flight
VALUES (
'1198',
'310',
'2020-12-11 09:00:00',
'LAX',
102,
'2020-12-11 10:00:00',
'JFK',
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


INSERT INTO flight
VALUES (
'1199',
'340',
'2020-12-11 09:00:00',
'ATL',
76,
'2020-12-11 10:00:00',
'LAX',
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


INSERT INTO flight
VALUES (
'1200',
'321',
'2020-12-11 09:00:00',
'DFW',
56,
'2020-12-11 10:00:00',
'ATL',
70,
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


INSERT INTO flight
VALUES (
'1201',
'340',
'2020-12-11 09:00:00',
'SFO',
84,
'2020-12-11 10:00:00',
'SEA',
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


INSERT INTO flight
VALUES (
'1202',
'345',
'2020-12-11 09:00:00',
'LAX',
24,
'2020-12-11 10:00:00',
'ATL',
80,
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


INSERT INTO flight
VALUES (
'1203',
'330',
'2020-12-11 09:00:00',
'DFW',
96,
'2020-12-11 10:00:00',
'LAS',
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


INSERT INTO flight
VALUES (
'1204',
'330',
'2020-12-11 09:00:00',
'LAS',
60,
'2020-12-11 10:00:00',
'DFW',
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


INSERT INTO flight
VALUES (
'1205',
'319',
'2020-12-11 09:00:00',
'JFK',
68,
'2020-12-11 10:00:00',
'SFO',
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


INSERT INTO flight
VALUES (
'1206',
'343',
'2020-12-11 09:00:00',
'DFW',
24,
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


INSERT INTO flight
VALUES (
'1207',
'345',
'2020-12-11 09:00:00',
'LAS',
78,
'2020-12-11 10:00:00',
'DFW',
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


INSERT INTO flight
VALUES (
'1208',
'310',
'2020-12-11 09:00:00',
'DFW',
97,
'2020-12-11 10:00:00',
'LAS',
33,
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


INSERT INTO flight
VALUES (
'1209',
'310',
'2020-12-11 09:00:00',
'LAS',
35,
'2020-12-11 10:00:00',
'SEA',
29,
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


INSERT INTO flight
VALUES (
'1210',
'342',
'2020-12-11 09:00:00',
'DFW',
97,
'2020-12-11 10:00:00',
'LAX',
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


INSERT INTO flight
VALUES (
'1211',
'310',
'2020-12-11 09:00:00',
'ORD',
62,
'2020-12-11 10:00:00',
'LAS',
65,
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


INSERT INTO flight
VALUES (
'1212',
'346',
'2020-12-11 09:00:00',
'MCO',
2,
'2020-12-11 10:00:00',
'SFO',
58,
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


INSERT INTO flight
VALUES (
'1213',
'346',
'2020-12-11 09:00:00',
'LAX',
75,
'2020-12-11 10:00:00',
'ATL',
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


INSERT INTO flight
VALUES (
'1214',
'321',
'2020-12-11 09:00:00',
'ATL',
90,
'2020-12-11 10:00:00',
'MCO',
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


INSERT INTO flight
VALUES (
'1215',
'345',
'2020-12-11 09:00:00',
'DFW',
11,
'2020-12-11 10:00:00',
'JFK',
78,
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


INSERT INTO flight
VALUES (
'1216',
'345',
'2020-12-11 09:00:00',
'LAS',
82,
'2020-12-11 10:00:00',
'SEA',
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


INSERT INTO flight
VALUES (
'1217',
'318',
'2020-12-11 09:00:00',
'SEA',
34,
'2020-12-11 10:00:00',
'DFW',
59,
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


INSERT INTO flight
VALUES (
'1218',
'342',
'2020-12-11 09:00:00',
'LAS',
41,
'2020-12-11 10:00:00',
'ORD',
93,
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


INSERT INTO flight
VALUES (
'1219',
'319',
'2020-12-11 09:00:00',
'DFW',
96,
'2020-12-11 10:00:00',
'JFK',
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


INSERT INTO flight
VALUES (
'1220',
'319',
'2020-12-11 09:00:00',
'LAX',
44,
'2020-12-11 10:00:00',
'ORD',
96,
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


INSERT INTO flight
VALUES (
'1221',
'310',
'2020-12-11 09:00:00',
'SFO',
98,
'2020-12-11 10:00:00',
'MCO',
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


INSERT INTO flight
VALUES (
'1222',
'318',
'2020-12-11 09:00:00',
'LAS',
109,
'2020-12-11 10:00:00',
'DFW',
51,
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


INSERT INTO flight
VALUES (
'1223',
'346',
'2020-12-11 09:00:00',
'JFK',
3,
'2020-12-11 10:00:00',
'SFO',
37,
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


INSERT INTO flight
VALUES (
'1224',
'310',
'2020-12-11 09:00:00',
'ATL',
60,
'2020-12-11 10:00:00',
'DFW',
72,
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


INSERT INTO flight
VALUES (
'1225',
'321',
'2020-12-11 09:00:00',
'LAX',
62,
'2020-12-11 10:00:00',
'DFW',
63,
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


INSERT INTO flight
VALUES (
'1226',
'319',
'2020-12-11 09:00:00',
'DEN',
24,
'2020-12-11 10:00:00',
'ORD',
1,
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


INSERT INTO flight
VALUES (
'1227',
'346',
'2020-12-11 09:00:00',
'SFO',
8,
'2020-12-11 10:00:00',
'DEN',
94,
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


INSERT INTO flight
VALUES (
'1228',
'343',
'2020-12-11 09:00:00',
'LAX',
1,
'2020-12-11 10:00:00',
'ORD',
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


INSERT INTO flight
VALUES (
'1229',
'310',
'2020-12-11 09:00:00',
'JFK',
95,
'2020-12-11 10:00:00',
'ATL',
46,
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


INSERT INTO flight
VALUES (
'1230',
'318',
'2020-12-11 09:00:00',
'SFO',
76,
'2020-12-11 10:00:00',
'ATL',
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


INSERT INTO flight
VALUES (
'1231',
'319',
'2020-12-11 09:00:00',
'LAS',
48,
'2020-12-11 10:00:00',
'DEN',
16,
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


INSERT INTO flight
VALUES (
'1232',
'345',
'2020-12-11 09:00:00',
'LAS',
74,
'2020-12-11 10:00:00',
'LAX',
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


INSERT INTO flight
VALUES (
'1233',
'310',
'2020-12-11 09:00:00',
'LAS',
4,
'2020-12-11 10:00:00',
'ATL',
73,
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


INSERT INTO flight
VALUES (
'1234',
'342',
'2020-12-11 09:00:00',
'SEA',
101,
'2020-12-11 10:00:00',
'LAS',
99,
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


INSERT INTO flight
VALUES (
'1235',
'342',
'2020-12-11 09:00:00',
'JFK',
99,
'2020-12-11 10:00:00',
'SFO',
37,
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


INSERT INTO flight
VALUES (
'1236',
'319',
'2020-12-11 09:00:00',
'DFW',
24,
'2020-12-11 10:00:00',
'ORD',
6,
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


INSERT INTO flight
VALUES (
'1237',
'318',
'2020-12-11 09:00:00',
'SFO',
77,
'2020-12-11 10:00:00',
'DEN',
109,
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


INSERT INTO flight
VALUES (
'1238',
'319',
'2020-12-11 09:00:00',
'MCO',
81,
'2020-12-11 10:00:00',
'SEA',
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


INSERT INTO flight
VALUES (
'1239',
'319',
'2020-12-11 09:00:00',
'SEA',
64,
'2020-12-11 10:00:00',
'LAS',
6,
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


INSERT INTO flight
VALUES (
'1240',
'318',
'2020-12-11 09:00:00',
'DFW',
106,
'2020-12-11 10:00:00',
'JFK',
8,
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


INSERT INTO flight
VALUES (
'1241',
'346',
'2020-12-11 09:00:00',
'MCO',
68,
'2020-12-11 10:00:00',
'SFO',
65,
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


INSERT INTO flight
VALUES (
'1242',
'319',
'2020-12-11 09:00:00',
'SFO',
6,
'2020-12-11 10:00:00',
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


INSERT INTO flight
VALUES (
'1243',
'340',
'2020-12-11 09:00:00',
'MCO',
28,
'2020-12-11 10:00:00',
'DFW',
104,
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


INSERT INTO flight
VALUES (
'1244',
'330',
'2020-12-11 09:00:00',
'JFK',
92,
'2020-12-11 10:00:00',
'SFO',
24,
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


INSERT INTO flight
VALUES (
'1245',
'346',
'2020-12-11 09:00:00',
'LAX',
16,
'2020-12-11 10:00:00',
'DEN',
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


INSERT INTO flight
VALUES (
'1246',
'318',
'2020-12-11 09:00:00',
'DFW',
52,
'2020-12-11 10:00:00',
'LAX',
108,
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


INSERT INTO flight
VALUES (
'1247',
'319',
'2020-12-11 09:00:00',
'SFO',
108,
'2020-12-11 10:00:00',
'ORD',
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


INSERT INTO flight
VALUES (
'1248',
'319',
'2020-12-11 09:00:00',
'SEA',
60,
'2020-12-11 10:00:00',
'SFO',
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


INSERT INTO flight
VALUES (
'1249',
'340',
'2020-12-11 09:00:00',
'LAS',
9,
'2020-12-11 10:00:00',
'ATL',
71,
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


INSERT INTO flight
VALUES (
'1250',
'321',
'2020-12-11 09:00:00',
'JFK',
47,
'2020-12-11 10:00:00',
'ATL',
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


INSERT INTO flight
VALUES (
'1251',
'346',
'2020-12-11 09:00:00',
'SEA',
111,
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


INSERT INTO flight
VALUES (
'1252',
'346',
'2020-12-11 09:00:00',
'SFO',
26,
'2020-12-11 10:00:00',
'DFW',
54,
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


INSERT INTO flight
VALUES (
'1253',
'346',
'2020-12-11 09:00:00',
'LAS',
20,
'2020-12-11 10:00:00',
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


INSERT INTO flight
VALUES (
'1254',
'310',
'2020-12-11 09:00:00',
'SFO',
82,
'2020-12-11 10:00:00',
'MCO',
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


INSERT INTO flight
VALUES (
'1255',
'343',
'2020-12-11 09:00:00',
'MCO',
34,
'2020-12-11 10:00:00',
'LAS',
103,
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


INSERT INTO flight
VALUES (
'1256',
'321',
'2020-12-11 09:00:00',
'MCO',
108,
'2020-12-11 10:00:00',
'DEN',
88,
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


INSERT INTO flight
VALUES (
'1257',
'318',
'2020-12-11 09:00:00',
'SEA',
67,
'2020-12-11 10:00:00',
'JFK',
95,
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


INSERT INTO flight
VALUES (
'1258',
'343',
'2020-12-11 09:00:00',
'DEN',
35,
'2020-12-11 10:00:00',
'ATL',
91,
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


INSERT INTO flight
VALUES (
'1259',
'342',
'2020-12-11 09:00:00',
'LAX',
88,
'2020-12-11 10:00:00',
'DFW',
109,
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


INSERT INTO flight
VALUES (
'1260',
'310',
'2020-12-11 09:00:00',
'MCO',
101,
'2020-12-11 10:00:00',
'LAS',
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


INSERT INTO flight
VALUES (
'1261',
'330',
'2020-12-11 09:00:00',
'MCO',
55,
'2020-12-11 10:00:00',
'DFW',
104,
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


INSERT INTO flight
VALUES (
'1262',
'321',
'2020-12-11 09:00:00',
'LAS',
98,
'2020-12-11 10:00:00',
'ORD',
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


INSERT INTO flight
VALUES (
'1263',
'346',
'2020-12-11 09:00:00',
'LAX',
5,
'2020-12-11 10:00:00',
'SEA',
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


INSERT INTO flight
VALUES (
'1264',
'330',
'2020-12-11 09:00:00',
'SFO',
58,
'2020-12-11 10:00:00',
'ATL',
17,
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


INSERT INTO flight
VALUES (
'1265',
'310',
'2020-12-11 09:00:00',
'SFO',
62,
'2020-12-11 10:00:00',
'LAS',
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


INSERT INTO flight
VALUES (
'1266',
'330',
'2020-12-11 09:00:00',
'JFK',
83,
'2020-12-11 10:00:00',
'MCO',
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


INSERT INTO flight
VALUES (
'1267',
'319',
'2020-12-11 09:00:00',
'SEA',
70,
'2020-12-11 10:00:00',
'LAX',
8,
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


INSERT INTO flight
VALUES (
'1268',
'319',
'2020-12-11 09:00:00',
'LAX',
79,
'2020-12-11 10:00:00',
'ORD',
47,
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


INSERT INTO flight
VALUES (
'1269',
'310',
'2020-12-11 09:00:00',
'ORD',
4,
'2020-12-11 10:00:00',
'SEA',
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


INSERT INTO flight
VALUES (
'1270',
'319',
'2020-12-11 09:00:00',
'ATL',
4,
'2020-12-11 10:00:00',
'JFK',
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


INSERT INTO flight
VALUES (
'1271',
'318',
'2020-12-11 09:00:00',
'LAX',
69,
'2020-12-11 10:00:00',
'MCO',
16,
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


INSERT INTO flight
VALUES (
'1272',
'319',
'2020-12-11 09:00:00',
'MCO',
54,
'2020-12-11 10:00:00',
'JFK',
45,
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


INSERT INTO flight
VALUES (
'1273',
'340',
'2020-12-11 09:00:00',
'LAS',
65,
'2020-12-11 10:00:00',
'MCO',
103,
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


INSERT INTO flight
VALUES (
'1274',
'340',
'2020-12-11 09:00:00',
'SFO',
80,
'2020-12-11 10:00:00',
'JFK',
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


INSERT INTO flight
VALUES (
'1275',
'319',
'2020-12-11 09:00:00',
'ATL',
44,
'2020-12-11 10:00:00',
'SEA',
103,
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


INSERT INTO flight
VALUES (
'1276',
'321',
'2020-12-11 09:00:00',
'SFO',
81,
'2020-12-11 10:00:00',
'DFW',
110,
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


INSERT INTO flight
VALUES (
'1277',
'321',
'2020-12-11 09:00:00',
'JFK',
63,
'2020-12-11 10:00:00',
'DEN',
6,
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


INSERT INTO flight
VALUES (
'1278',
'310',
'2020-12-11 09:00:00',
'DFW',
50,
'2020-12-11 10:00:00',
'DEN',
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


INSERT INTO flight
VALUES (
'1279',
'340',
'2020-12-11 09:00:00',
'ORD',
27,
'2020-12-11 10:00:00',
'LAS',
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


INSERT INTO flight
VALUES (
'1280',
'345',
'2020-12-11 09:00:00',
'LAX',
100,
'2020-12-11 10:00:00',
'JFK',
65,
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


INSERT INTO flight
VALUES (
'1281',
'310',
'2020-12-11 09:00:00',
'ATL',
85,
'2020-12-11 10:00:00',
'ORD',
25,
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


INSERT INTO flight
VALUES (
'1282',
'321',
'2020-12-11 09:00:00',
'SEA',
47,
'2020-12-11 10:00:00',
'LAX',
1,
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


INSERT INTO flight
VALUES (
'1283',
'310',
'2020-12-11 09:00:00',
'LAX',
38,
'2020-12-11 10:00:00',
'JFK',
30,
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


INSERT INTO flight
VALUES (
'1284',
'342',
'2020-12-11 09:00:00',
'ORD',
26,
'2020-12-11 10:00:00',
'SFO',
23,
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


INSERT INTO flight
VALUES (
'1285',
'321',
'2020-12-11 09:00:00',
'LAX',
2,
'2020-12-11 10:00:00',
'ATL',
105,
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


INSERT INTO flight
VALUES (
'1286',
'318',
'2020-12-11 09:00:00',
'JFK',
8,
'2020-12-11 10:00:00',
'MCO',
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


INSERT INTO flight
VALUES (
'1287',
'346',
'2020-12-11 09:00:00',
'DEN',
59,
'2020-12-11 10:00:00',
'JFK',
42,
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


INSERT INTO flight
VALUES (
'1288',
'330',
'2020-12-11 09:00:00',
'ATL',
57,
'2020-12-11 10:00:00',
'LAS',
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


INSERT INTO flight
VALUES (
'1289',
'343',
'2020-12-11 09:00:00',
'SEA',
103,
'2020-12-11 10:00:00',
'DFW',
73,
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


INSERT INTO flight
VALUES (
'1290',
'345',
'2020-12-11 09:00:00',
'DEN',
92,
'2020-12-11 10:00:00',
'SEA',
95,
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


INSERT INTO flight
VALUES (
'1291',
'330',
'2020-12-11 09:00:00',
'SFO',
68,
'2020-12-11 10:00:00',
'LAX',
98,
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


INSERT INTO flight
VALUES (
'1292',
'343',
'2020-12-11 09:00:00',
'MCO',
83,
'2020-12-11 10:00:00',
'ATL',
104,
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


INSERT INTO flight
VALUES (
'1293',
'330',
'2020-12-11 09:00:00',
'SFO',
96,
'2020-12-11 10:00:00',
'DFW',
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


INSERT INTO flight
VALUES (
'1294',
'342',
'2020-12-11 09:00:00',
'JFK',
73,
'2020-12-11 10:00:00',
'SFO',
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


INSERT INTO flight
VALUES (
'1295',
'310',
'2020-12-11 09:00:00',
'DFW',
64,
'2020-12-11 10:00:00',
'MCO',
107,
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


INSERT INTO flight
VALUES (
'1296',
'321',
'2020-12-11 09:00:00',
'SEA',
48,
'2020-12-11 10:00:00',
'SFO',
12,
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


INSERT INTO flight
VALUES (
'1297',
'346',
'2020-12-11 09:00:00',
'ATL',
71,
'2020-12-11 10:00:00',
'ORD',
94,
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


INSERT INTO flight
VALUES (
'1298',
'346',
'2020-12-11 09:00:00',
'LAS',
20,
'2020-12-11 10:00:00',
'JFK',
52,
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


INSERT INTO flight
VALUES (
'1299',
'343',
'2020-12-11 09:00:00',
'DFW',
88,
'2020-12-11 10:00:00',
'LAX',
34,
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


INSERT INTO flight
VALUES (
'1300',
'345',
'2020-12-11 09:00:00',
'LAS',
62,
'2020-12-11 10:00:00',
'SEA',
55,
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


INSERT INTO flight
VALUES (
'1301',
'342',
'2020-12-11 09:00:00',
'LAX',
88,
'2020-12-11 10:00:00',
'JFK',
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


INSERT INTO flight
VALUES (
'1302',
'346',
'2020-12-11 09:00:00',
'LAS',
57,
'2020-12-11 10:00:00',
'DEN',
29,
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


INSERT INTO flight
VALUES (
'1303',
'346',
'2020-12-11 09:00:00',
'LAS',
90,
'2020-12-11 10:00:00',
'SFO',
69,
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


INSERT INTO flight
VALUES (
'1304',
'346',
'2020-12-11 09:00:00',
'LAS',
83,
'2020-12-11 10:00:00',
'LAX',
56,
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


INSERT INTO flight
VALUES (
'1305',
'343',
'2020-12-11 09:00:00',
'ATL',
4,
'2020-12-11 10:00:00',
'SEA',
57,
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


INSERT INTO flight
VALUES (
'1306',
'340',
'2020-12-11 09:00:00',
'ORD',
63,
'2020-12-11 10:00:00',
'DFW',
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


INSERT INTO flight
VALUES (
'1307',
'330',
'2020-12-11 09:00:00',
'JFK',
12,
'2020-12-11 10:00:00',
'ATL',
74,
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


INSERT INTO flight
VALUES (
'1308',
'345',
'2020-12-11 09:00:00',
'MCO',
49,
'2020-12-11 10:00:00',
'SEA',
84,
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


INSERT INTO flight
VALUES (
'1309',
'318',
'2020-12-11 09:00:00',
'LAS',
11,
'2020-12-11 10:00:00',
'SEA',
21,
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


INSERT INTO flight
VALUES (
'1310',
'343',
'2020-12-11 09:00:00',
'ATL',
59,
'2020-12-11 10:00:00',
'SEA',
38,
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


INSERT INTO flight
VALUES (
'1311',
'342',
'2020-12-11 09:00:00',
'SEA',
37,
'2020-12-11 10:00:00',
'JFK',
80,
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


INSERT INTO flight
VALUES (
'1312',
'319',
'2020-12-11 09:00:00',
'DEN',
26,
'2020-12-11 10:00:00',
'ATL',
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


INSERT INTO flight
VALUES (
'1313',
'342',
'2020-12-11 09:00:00',
'JFK',
89,
'2020-12-11 10:00:00',
'DEN',
101,
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


INSERT INTO flight
VALUES (
'1314',
'318',
'2020-12-11 09:00:00',
'DFW',
109,
'2020-12-11 10:00:00',
'ORD',
90,
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


INSERT INTO flight
VALUES (
'1315',
'318',
'2020-12-11 09:00:00',
'SFO',
47,
'2020-12-11 10:00:00',
'DFW',
48,
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


INSERT INTO flight
VALUES (
'1316',
'321',
'2020-12-11 09:00:00',
'ATL',
7,
'2020-12-11 10:00:00',
'SEA',
15,
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


INSERT INTO flight
VALUES (
'1317',
'330',
'2020-12-11 09:00:00',
'LAX',
20,
'2020-12-11 10:00:00',
'MCO',
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


INSERT INTO flight
VALUES (
'1318',
'345',
'2020-12-11 09:00:00',
'SFO',
4,
'2020-12-11 10:00:00',
'SEA',
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


INSERT INTO flight
VALUES (
'1319',
'345',
'2020-12-11 09:00:00',
'MCO',
30,
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


INSERT INTO flight
VALUES (
'1320',
'345',
'2020-12-11 09:00:00',
'MCO',
61,
'2020-12-11 10:00:00',
'LAX',
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


INSERT INTO flight
VALUES (
'1321',
'343',
'2020-12-11 09:00:00',
'DEN',
67,
'2020-12-11 10:00:00',
'ORD',
30,
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


INSERT INTO flight
VALUES (
'1322',
'330',
'2020-12-11 09:00:00',
'MCO',
31,
'2020-12-11 10:00:00',
'ATL',
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


INSERT INTO flight
VALUES (
'1323',
'346',
'2020-12-11 09:00:00',
'DFW',
88,
'2020-12-11 10:00:00',
'ATL',
38,
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


INSERT INTO flight
VALUES (
'1324',
'346',
'2020-12-11 09:00:00',
'SFO',
31,
'2020-12-11 10:00:00',
'DFW',
56,
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


INSERT INTO flight
VALUES (
'1325',
'343',
'2020-12-11 09:00:00',
'LAX',
61,
'2020-12-11 10:00:00',
'DEN',
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


INSERT INTO flight
VALUES (
'1326',
'321',
'2020-12-11 09:00:00',
'SEA',
20,
'2020-12-11 10:00:00',
'ORD',
13,
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


INSERT INTO flight
VALUES (
'1327',
'318',
'2020-12-11 09:00:00',
'LAX',
87,
'2020-12-11 10:00:00',
'JFK',
96,
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


INSERT INTO flight
VALUES (
'1328',
'318',
'2020-12-11 09:00:00',
'LAX',
27,
'2020-12-11 10:00:00',
'ORD',
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


INSERT INTO flight
VALUES (
'1329',
'346',
'2020-12-11 09:00:00',
'DEN',
9,
'2020-12-11 10:00:00',
'LAX',
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


INSERT INTO flight
VALUES (
'1330',
'343',
'2020-12-11 09:00:00',
'JFK',
12,
'2020-12-11 10:00:00',
'SEA',
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


INSERT INTO flight
VALUES (
'1331',
'342',
'2020-12-11 09:00:00',
'ORD',
61,
'2020-12-11 10:00:00',
'JFK',
55,
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


INSERT INTO flight
VALUES (
'1332',
'321',
'2020-12-11 09:00:00',
'LAS',
48,
'2020-12-11 10:00:00',
'MCO',
100,
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


INSERT INTO flight
VALUES (
'1333',
'342',
'2020-12-11 09:00:00',
'ATL',
51,
'2020-12-11 10:00:00',
'SFO',
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


INSERT INTO flight
VALUES (
'1334',
'319',
'2020-12-11 09:00:00',
'DFW',
70,
'2020-12-11 10:00:00',
'DEN',
18,
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


INSERT INTO flight
VALUES (
'1335',
'345',
'2020-12-11 09:00:00',
'LAX',
40,
'2020-12-11 10:00:00',
'ORD',
94,
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


INSERT INTO flight
VALUES (
'1336',
'346',
'2020-12-11 09:00:00',
'SFO',
16,
'2020-12-11 10:00:00',
'LAS',
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


INSERT INTO flight
VALUES (
'1337',
'346',
'2020-12-11 09:00:00',
'ORD',
83,
'2020-12-11 10:00:00',
'LAX',
24,
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


INSERT INTO flight
VALUES (
'1338',
'340',
'2020-12-11 09:00:00',
'JFK',
37,
'2020-12-11 10:00:00',
'DEN',
11,
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


INSERT INTO flight
VALUES (
'1339',
'319',
'2020-12-11 09:00:00',
'DEN',
46,
'2020-12-11 10:00:00',
'SFO',
101,
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


INSERT INTO flight
VALUES (
'1340',
'340',
'2020-12-11 09:00:00',
'SFO',
18,
'2020-12-11 10:00:00',
'JFK',
25,
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


INSERT INTO flight
VALUES (
'1341',
'321',
'2020-12-11 09:00:00',
'LAS',
88,
'2020-12-11 10:00:00',
'LAX',
31,
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


INSERT INTO flight
VALUES (
'1342',
'343',
'2020-12-11 09:00:00',
'LAS',
9,
'2020-12-11 10:00:00',
'ATL',
29,
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


INSERT INTO flight
VALUES (
'1343',
'346',
'2020-12-11 09:00:00',
'JFK',
33,
'2020-12-11 10:00:00',
'DFW',
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


INSERT INTO flight
VALUES (
'1344',
'310',
'2020-12-11 09:00:00',
'LAX',
61,
'2020-12-11 10:00:00',
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


INSERT INTO flight
VALUES (
'1345',
'346',
'2020-12-11 09:00:00',
'ATL',
61,
'2020-12-11 10:00:00',
'SFO',
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


INSERT INTO flight
VALUES (
'1346',
'342',
'2020-12-11 09:00:00',
'LAX',
55,
'2020-12-11 10:00:00',
'ATL',
111,
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


INSERT INTO flight
VALUES (
'1347',
'346',
'2020-12-11 09:00:00',
'JFK',
65,
'2020-12-11 10:00:00',
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


INSERT INTO flight
VALUES (
'1348',
'310',
'2020-12-11 09:00:00',
'SEA',
107,
'2020-12-11 10:00:00',
'ATL',
48,
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


INSERT INTO flight
VALUES (
'1349',
'319',
'2020-12-11 09:00:00',
'LAS',
55,
'2020-12-11 10:00:00',
'DFW',
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


INSERT INTO flight
VALUES (
'1350',
'310',
'2020-12-11 09:00:00',
'MCO',
73,
'2020-12-11 10:00:00',
'ATL',
71,
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


INSERT INTO flight
VALUES (
'1351',
'343',
'2020-12-11 09:00:00',
'SEA',
78,
'2020-12-11 10:00:00',
'DEN',
91,
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


INSERT INTO flight
VALUES (
'1352',
'330',
'2020-12-11 09:00:00',
'SEA',
36,
'2020-12-11 10:00:00',
'ORD',
78,
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


INSERT INTO flight
VALUES (
'1353',
'319',
'2020-12-11 09:00:00',
'SFO',
31,
'2020-12-11 10:00:00',
'LAS',
10,
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


INSERT INTO flight
VALUES (
'1354',
'318',
'2020-12-11 09:00:00',
'JFK',
47,
'2020-12-11 10:00:00',
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


INSERT INTO flight
VALUES (
'1355',
'345',
'2020-12-11 09:00:00',
'SEA',
90,
'2020-12-11 10:00:00',
'LAS',
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


INSERT INTO flight
VALUES (
'1356',
'330',
'2020-12-11 09:00:00',
'JFK',
7,
'2020-12-11 10:00:00',
'DFW',
16,
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


INSERT INTO flight
VALUES (
'1357',
'330',
'2020-12-11 09:00:00',
'LAS',
68,
'2020-12-11 10:00:00',
'JFK',
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


INSERT INTO flight
VALUES (
'1358',
'340',
'2020-12-11 09:00:00',
'SFO',
31,
'2020-12-11 10:00:00',
'ORD',
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


INSERT INTO flight
VALUES (
'1359',
'340',
'2020-12-11 09:00:00',
'SEA',
88,
'2020-12-11 10:00:00',
'ORD',
37,
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


INSERT INTO flight
VALUES (
'1360',
'345',
'2020-12-11 09:00:00',
'SEA',
26,
'2020-12-11 10:00:00',
'DEN',
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


INSERT INTO flight
VALUES (
'1361',
'318',
'2020-12-11 09:00:00',
'SFO',
85,
'2020-12-11 10:00:00',
'DFW',
26,
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


INSERT INTO flight
VALUES (
'1362',
'318',
'2020-12-11 09:00:00',
'SFO',
30,
'2020-12-11 10:00:00',
'ORD',
10,
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


INSERT INTO flight
VALUES (
'1363',
'330',
'2020-12-11 09:00:00',
'MCO',
93,
'2020-12-11 10:00:00',
'ATL',
99,
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


INSERT INTO flight
VALUES (
'1364',
'321',
'2020-12-11 09:00:00',
'MCO',
70,
'2020-12-11 10:00:00',
'ORD',
28,
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


INSERT INTO flight
VALUES (
'1365',
'345',
'2020-12-11 09:00:00',
'ATL',
36,
'2020-12-11 10:00:00',
'MCO',
23,
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


INSERT INTO flight
VALUES (
'1366',
'321',
'2020-12-11 09:00:00',
'DEN',
19,
'2020-12-11 10:00:00',
'LAX',
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


INSERT INTO flight
VALUES (
'1367',
'342',
'2020-12-11 09:00:00',
'SEA',
45,
'2020-12-11 10:00:00',
'ATL',
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


INSERT INTO flight
VALUES (
'1368',
'319',
'2020-12-11 09:00:00',
'ATL',
105,
'2020-12-11 10:00:00',
'DEN',
40,
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


INSERT INTO flight
VALUES (
'1369',
'319',
'2020-12-11 09:00:00',
'LAS',
105,
'2020-12-11 10:00:00',
'JFK',
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


INSERT INTO flight
VALUES (
'1370',
'319',
'2020-12-11 09:00:00',
'ATL',
35,
'2020-12-11 10:00:00',
'MCO',
4,
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


INSERT INTO flight
VALUES (
'1371',
'321',
'2020-12-11 09:00:00',
'ORD',
3,
'2020-12-11 10:00:00',
'ATL',
60,
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


INSERT INTO flight
VALUES (
'1372',
'321',
'2020-12-11 09:00:00',
'JFK',
100,
'2020-12-11 10:00:00',
'LAS',
32,
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


INSERT INTO flight
VALUES (
'1373',
'321',
'2020-12-11 09:00:00',
'SEA',
48,
'2020-12-11 10:00:00',
'SFO',
20,
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


INSERT INTO flight
VALUES (
'1374',
'340',
'2020-12-11 09:00:00',
'SFO',
100,
'2020-12-11 10:00:00',
'DFW',
56,
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


INSERT INTO flight
VALUES (
'1375',
'342',
'2020-12-11 09:00:00',
'LAS',
36,
'2020-12-11 10:00:00',
'ATL',
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


INSERT INTO flight
VALUES (
'1376',
'340',
'2020-12-11 09:00:00',
'ORD',
83,
'2020-12-11 10:00:00',
'JFK',
108,
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


INSERT INTO flight
VALUES (
'1377',
'330',
'2020-12-11 09:00:00',
'MCO',
57,
'2020-12-11 10:00:00',
'ORD',
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


INSERT INTO flight
VALUES (
'1378',
'343',
'2020-12-11 09:00:00',
'SEA',
67,
'2020-12-11 10:00:00',
'MCO',
88,
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


INSERT INTO flight
VALUES (
'1379',
'340',
'2020-12-11 09:00:00',
'ORD',
73,
'2020-12-11 10:00:00',
'LAS',
33,
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


INSERT INTO flight
VALUES (
'1380',
'330',
'2020-12-11 09:00:00',
'SEA',
14,
'2020-12-11 10:00:00',
'DEN',
55,
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


INSERT INTO flight
VALUES (
'1381',
'330',
'2020-12-11 09:00:00',
'LAS',
101,
'2020-12-11 10:00:00',
'DEN',
97,
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


INSERT INTO flight
VALUES (
'1382',
'310',
'2020-12-11 09:00:00',
'SFO',
90,
'2020-12-11 10:00:00',
'SEA',
37,
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


INSERT INTO flight
VALUES (
'1383',
'340',
'2020-12-11 09:00:00',
'LAX',
15,
'2020-12-11 10:00:00',
'LAS',
54,
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


INSERT INTO flight
VALUES (
'1384',
'319',
'2020-12-11 09:00:00',
'LAS',
64,
'2020-12-11 10:00:00',
'SFO',
80,
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


INSERT INTO flight
VALUES (
'1385',
'330',
'2020-12-11 09:00:00',
'DEN',
33,
'2020-12-11 10:00:00',
'DFW',
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


INSERT INTO flight
VALUES (
'1386',
'345',
'2020-12-11 09:00:00',
'LAX',
107,
'2020-12-11 10:00:00',
'DEN',
6,
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


INSERT INTO flight
VALUES (
'1387',
'321',
'2020-12-11 09:00:00',
'ORD',
60,
'2020-12-11 10:00:00',
'LAS',
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


INSERT INTO flight
VALUES (
'1388',
'321',
'2020-12-11 09:00:00',
'LAS',
111,
'2020-12-11 10:00:00',
'LAX',
83,
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


INSERT INTO flight
VALUES (
'1389',
'319',
'2020-12-11 09:00:00',
'MCO',
90,
'2020-12-11 10:00:00',
'SFO',
13,
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


INSERT INTO flight
VALUES (
'1390',
'346',
'2020-12-11 09:00:00',
'MCO',
49,
'2020-12-11 10:00:00',
'DEN',
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


INSERT INTO flight
VALUES (
'1391',
'310',
'2020-12-11 09:00:00',
'ORD',
80,
'2020-12-11 10:00:00',
'DFW',
23,
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


INSERT INTO flight
VALUES (
'1392',
'342',
'2020-12-11 09:00:00',
'DFW',
19,
'2020-12-11 10:00:00',
'MCO',
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


INSERT INTO flight
VALUES (
'1393',
'321',
'2020-12-11 09:00:00',
'DEN',
77,
'2020-12-11 10:00:00',
'ORD',
20,
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


INSERT INTO flight
VALUES (
'1394',
'310',
'2020-12-11 09:00:00',
'SEA',
93,
'2020-12-11 10:00:00',
'ATL',
84,
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


INSERT INTO flight
VALUES (
'1395',
'343',
'2020-12-11 09:00:00',
'ORD',
96,
'2020-12-11 10:00:00',
'SFO',
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


INSERT INTO flight
VALUES (
'1396',
'321',
'2020-12-11 09:00:00',
'SFO',
58,
'2020-12-11 10:00:00',
'DEN',
67,
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


INSERT INTO flight
VALUES (
'1397',
'340',
'2020-12-11 09:00:00',
'ATL',
79,
'2020-12-11 10:00:00',
'JFK',
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


INSERT INTO flight
VALUES (
'1398',
'330',
'2020-12-11 09:00:00',
'LAX',
40,
'2020-12-11 10:00:00',
'DEN',
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


INSERT INTO flight
VALUES (
'1399',
'310',
'2020-12-11 09:00:00',
'LAX',
4,
'2020-12-11 10:00:00',
'LAS',
8,
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


INSERT INTO flight
VALUES (
'1400',
'330',
'2020-12-11 09:00:00',
'MCO',
55,
'2020-12-11 10:00:00',
'ORD',
84,
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


INSERT INTO flight
VALUES (
'1401',
'345',
'2020-12-11 09:00:00',
'LAX',
29,
'2020-12-11 10:00:00',
'SEA',
94,
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


INSERT INTO flight
VALUES (
'1402',
'330',
'2020-12-11 09:00:00',
'DFW',
21,
'2020-12-11 10:00:00',
'ATL',
11,
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


INSERT INTO flight
VALUES (
'1403',
'318',
'2020-12-11 09:00:00',
'DFW',
2,
'2020-12-11 10:00:00',
'DEN',
11,
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


INSERT INTO flight
VALUES (
'1404',
'346',
'2020-12-11 09:00:00',
'ORD',
108,
'2020-12-11 10:00:00',
'LAX',
74,
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


INSERT INTO flight
VALUES (
'1405',
'330',
'2020-12-11 09:00:00',
'SFO',
98,
'2020-12-11 10:00:00',
'DFW',
60,
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


INSERT INTO flight
VALUES (
'1406',
'318',
'2020-12-11 09:00:00',
'LAX',
64,
'2020-12-11 10:00:00',
'ATL',
90,
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


INSERT INTO flight
VALUES (
'1407',
'342',
'2020-12-11 09:00:00',
'LAS',
85,
'2020-12-11 10:00:00',
'ATL',
13,
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


INSERT INTO flight
VALUES (
'1408',
'310',
'2020-12-11 09:00:00',
'ORD',
71,
'2020-12-11 10:00:00',
'JFK',
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


INSERT INTO flight
VALUES (
'1409',
'340',
'2020-12-11 09:00:00',
'DFW',
18,
'2020-12-11 10:00:00',
'JFK',
54,
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


INSERT INTO flight
VALUES (
'1410',
'340',
'2020-12-11 09:00:00',
'JFK',
7,
'2020-12-11 10:00:00',
'LAX',
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


INSERT INTO flight
VALUES (
'1411',
'346',
'2020-12-11 09:00:00',
'SFO',
108,
'2020-12-11 10:00:00',
'MCO',
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


INSERT INTO flight
VALUES (
'1412',
'342',
'2020-12-11 09:00:00',
'SEA',
19,
'2020-12-11 10:00:00',
'DFW',
53,
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


INSERT INTO flight
VALUES (
'1413',
'340',
'2020-12-11 09:00:00',
'ORD',
22,
'2020-12-11 10:00:00',
'DEN',
33,
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


INSERT INTO flight
VALUES (
'1414',
'345',
'2020-12-11 09:00:00',
'JFK',
62,
'2020-12-11 10:00:00',
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


INSERT INTO flight
VALUES (
'1415',
'330',
'2020-12-11 09:00:00',
'SEA',
63,
'2020-12-11 10:00:00',
'JFK',
8,
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


INSERT INTO flight
VALUES (
'1416',
'340',
'2020-12-11 09:00:00',
'DFW',
101,
'2020-12-11 10:00:00',
'SFO',
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


INSERT INTO flight
VALUES (
'1417',
'346',
'2020-12-11 09:00:00',
'ATL',
29,
'2020-12-11 10:00:00',
'DEN',
34,
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


INSERT INTO flight
VALUES (
'1418',
'319',
'2020-12-11 09:00:00',
'JFK',
7,
'2020-12-11 10:00:00',
'SFO',
11,
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


INSERT INTO flight
VALUES (
'1419',
'345',
'2020-12-11 09:00:00',
'LAX',
17,
'2020-12-11 10:00:00',
'DEN',
97,
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


INSERT INTO flight
VALUES (
'1420',
'343',
'2020-12-11 09:00:00',
'DFW',
40,
'2020-12-11 10:00:00',
'DEN',
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


INSERT INTO flight
VALUES (
'1421',
'340',
'2020-12-11 09:00:00',
'DEN',
32,
'2020-12-11 10:00:00',
'SFO',
55,
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


INSERT INTO flight
VALUES (
'1422',
'318',
'2020-12-11 09:00:00',
'DEN',
2,
'2020-12-11 10:00:00',
'DFW',
82,
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


INSERT INTO flight
VALUES (
'1423',
'345',
'2020-12-11 09:00:00',
'ORD',
36,
'2020-12-11 10:00:00',
'DFW',
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


INSERT INTO flight
VALUES (
'1424',
'345',
'2020-12-11 09:00:00',
'DEN',
20,
'2020-12-11 10:00:00',
'DFW',
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


INSERT INTO flight
VALUES (
'1425',
'318',
'2020-12-11 09:00:00',
'MCO',
97,
'2020-12-11 10:00:00',
'LAX',
8,
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


INSERT INTO flight
VALUES (
'1426',
'346',
'2020-12-11 09:00:00',
'SFO',
103,
'2020-12-11 10:00:00',
'DFW',
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


INSERT INTO flight
VALUES (
'1427',
'321',
'2020-12-11 09:00:00',
'ORD',
61,
'2020-12-11 10:00:00',
'LAS',
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


INSERT INTO flight
VALUES (
'1428',
'346',
'2020-12-11 09:00:00',
'LAS',
41,
'2020-12-11 10:00:00',
'LAX',
53,
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


INSERT INTO flight
VALUES (
'1429',
'321',
'2020-12-11 09:00:00',
'JFK',
27,
'2020-12-11 10:00:00',
'ORD',
51,
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


INSERT INTO flight
VALUES (
'1430',
'345',
'2020-12-11 09:00:00',
'DEN',
87,
'2020-12-11 10:00:00',
'ATL',
42,
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


INSERT INTO flight
VALUES (
'1431',
'345',
'2020-12-11 09:00:00',
'MCO',
68,
'2020-12-11 10:00:00',
'SEA',
29,
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


INSERT INTO flight
VALUES (
'1432',
'330',
'2020-12-11 09:00:00',
'MCO',
60,
'2020-12-11 10:00:00',
'DEN',
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


INSERT INTO flight
VALUES (
'1433',
'346',
'2020-12-11 09:00:00',
'SFO',
73,
'2020-12-11 10:00:00',
'DEN',
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


INSERT INTO flight
VALUES (
'1434',
'318',
'2020-12-11 09:00:00',
'DFW',
56,
'2020-12-11 10:00:00',
'LAX',
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


INSERT INTO flight
VALUES (
'1435',
'345',
'2020-12-11 09:00:00',
'LAX',
55,
'2020-12-11 10:00:00',
'SEA',
97,
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


INSERT INTO flight
VALUES (
'1436',
'330',
'2020-12-11 09:00:00',
'DFW',
1,
'2020-12-11 10:00:00',
'MCO',
88,
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


INSERT INTO flight
VALUES (
'1437',
'310',
'2020-12-11 09:00:00',
'DEN',
14,
'2020-12-11 10:00:00',
'MCO',
48,
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


INSERT INTO flight
VALUES (
'1438',
'318',
'2020-12-11 09:00:00',
'MCO',
55,
'2020-12-11 10:00:00',
'LAX',
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


INSERT INTO flight
VALUES (
'1439',
'310',
'2020-12-11 09:00:00',
'ORD',
49,
'2020-12-11 10:00:00',
'ATL',
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


INSERT INTO flight
VALUES (
'1440',
'318',
'2020-12-11 09:00:00',
'MCO',
70,
'2020-12-11 10:00:00',
'JFK',
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


INSERT INTO flight
VALUES (
'1441',
'330',
'2020-12-11 09:00:00',
'ATL',
11,
'2020-12-11 10:00:00',
'SFO',
73,
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


INSERT INTO flight
VALUES (
'1442',
'330',
'2020-12-11 09:00:00',
'JFK',
102,
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


INSERT INTO flight
VALUES (
'1443',
'342',
'2020-12-11 09:00:00',
'MCO',
16,
'2020-12-11 10:00:00',
'ORD',
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


INSERT INTO flight
VALUES (
'1444',
'340',
'2020-12-11 09:00:00',
'MCO',
2,
'2020-12-11 10:00:00',
'SFO',
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


INSERT INTO flight
VALUES (
'1445',
'345',
'2020-12-11 09:00:00',
'SEA',
25,
'2020-12-11 10:00:00',
'MCO',
44,
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


INSERT INTO flight
VALUES (
'1446',
'318',
'2020-12-11 09:00:00',
'LAS',
102,
'2020-12-11 10:00:00',
'SFO',
17,
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


INSERT INTO flight
VALUES (
'1447',
'330',
'2020-12-11 09:00:00',
'DEN',
89,
'2020-12-11 10:00:00',
'LAS',
101,
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


INSERT INTO flight
VALUES (
'1448',
'310',
'2020-12-11 09:00:00',
'LAX',
101,
'2020-12-11 10:00:00',
'LAS',
70,
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


INSERT INTO flight
VALUES (
'1449',
'345',
'2020-12-11 09:00:00',
'SEA',
68,
'2020-12-11 10:00:00',
'MCO',
93,
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


INSERT INTO flight
VALUES (
'1450',
'340',
'2020-12-11 09:00:00',
'ORD',
33,
'2020-12-11 10:00:00',
'JFK',
104,
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


INSERT INTO flight
VALUES (
'1451',
'319',
'2020-12-11 09:00:00',
'DFW',
84,
'2020-12-11 10:00:00',
'JFK',
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


INSERT INTO flight
VALUES (
'1452',
'342',
'2020-12-11 09:00:00',
'ATL',
67,
'2020-12-11 10:00:00',
'DEN',
69,
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


INSERT INTO flight
VALUES (
'1453',
'342',
'2020-12-11 09:00:00',
'LAX',
102,
'2020-12-11 10:00:00',
'ORD',
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


INSERT INTO flight
VALUES (
'1454',
'346',
'2020-12-11 09:00:00',
'LAX',
18,
'2020-12-11 10:00:00',
'DFW',
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


INSERT INTO flight
VALUES (
'1455',
'346',
'2020-12-11 09:00:00',
'ORD',
37,
'2020-12-11 10:00:00',
'DEN',
54,
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


INSERT INTO flight
VALUES (
'1456',
'318',
'2020-12-11 09:00:00',
'ATL',
4,
'2020-12-11 10:00:00',
'MCO',
80,
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


INSERT INTO flight
VALUES (
'1457',
'340',
'2020-12-11 09:00:00',
'DEN',
37,
'2020-12-11 10:00:00',
'ORD',
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


INSERT INTO flight
VALUES (
'1458',
'340',
'2020-12-11 09:00:00',
'LAX',
87,
'2020-12-11 10:00:00',
'DEN',
30,
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


INSERT INTO flight
VALUES (
'1459',
'346',
'2020-12-11 09:00:00',
'SEA',
60,
'2020-12-11 10:00:00',
'LAS',
29,
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


INSERT INTO flight
VALUES (
'1460',
'346',
'2020-12-11 09:00:00',
'DEN',
109,
'2020-12-11 10:00:00',
'SEA',
104,
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


INSERT INTO flight
VALUES (
'1461',
'318',
'2020-12-11 09:00:00',
'MCO',
38,
'2020-12-11 10:00:00',
'LAS',
100,
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


INSERT INTO flight
VALUES (
'1462',
'310',
'2020-12-11 09:00:00',
'LAS',
6,
'2020-12-11 10:00:00',
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


INSERT INTO flight
VALUES (
'1463',
'319',
'2020-12-11 09:00:00',
'LAX',
106,
'2020-12-11 10:00:00',
'JFK',
85,
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


INSERT INTO flight
VALUES (
'1464',
'321',
'2020-12-11 09:00:00',
'ORD',
15,
'2020-12-11 10:00:00',
'ATL',
63,
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


INSERT INTO flight
VALUES (
'1465',
'310',
'2020-12-11 09:00:00',
'LAS',
60,
'2020-12-11 10:00:00',
'ATL',
57,
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


INSERT INTO flight
VALUES (
'1466',
'340',
'2020-12-11 09:00:00',
'ORD',
54,
'2020-12-11 10:00:00',
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


INSERT INTO flight
VALUES (
'1467',
'340',
'2020-12-11 09:00:00',
'LAS',
28,
'2020-12-11 10:00:00',
'MCO',
42,
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


INSERT INTO flight
VALUES (
'1468',
'321',
'2020-12-11 09:00:00',
'LAX',
107,
'2020-12-11 10:00:00',
'MCO',
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


INSERT INTO flight
VALUES (
'1469',
'330',
'2020-12-11 09:00:00',
'SEA',
33,
'2020-12-11 10:00:00',
'ATL',
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


INSERT INTO flight
VALUES (
'1470',
'346',
'2020-12-11 09:00:00',
'MCO',
36,
'2020-12-11 10:00:00',
'SEA',
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


INSERT INTO flight
VALUES (
'1471',
'318',
'2020-12-11 09:00:00',
'SEA',
55,
'2020-12-11 10:00:00',
'DEN',
10,
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


INSERT INTO flight
VALUES (
'1472',
'318',
'2020-12-11 09:00:00',
'ATL',
98,
'2020-12-11 10:00:00',
'DFW',
83,
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


INSERT INTO flight
VALUES (
'1473',
'319',
'2020-12-11 09:00:00',
'DEN',
109,
'2020-12-11 10:00:00',
'SEA',
107,
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


INSERT INTO flight
VALUES (
'1474',
'345',
'2020-12-11 09:00:00',
'JFK',
75,
'2020-12-11 10:00:00',
'DEN',
74,
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


INSERT INTO flight
VALUES (
'1475',
'345',
'2020-12-11 09:00:00',
'MCO',
43,
'2020-12-11 10:00:00',
'SEA',
54,
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


INSERT INTO flight
VALUES (
'1476',
'321',
'2020-12-11 09:00:00',
'DEN',
43,
'2020-12-11 10:00:00',
'LAS',
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


INSERT INTO flight
VALUES (
'1477',
'345',
'2020-12-11 09:00:00',
'SEA',
21,
'2020-12-11 10:00:00',
'ATL',
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


INSERT INTO flight
VALUES (
'1478',
'321',
'2020-12-11 09:00:00',
'ATL',
75,
'2020-12-11 10:00:00',
'LAS',
6,
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


INSERT INTO flight
VALUES (
'1479',
'345',
'2020-12-11 09:00:00',
'SEA',
99,
'2020-12-11 10:00:00',
'JFK',
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


INSERT INTO flight
VALUES (
'1480',
'346',
'2020-12-11 09:00:00',
'SFO',
100,
'2020-12-11 10:00:00',
'LAS',
14,
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


INSERT INTO flight
VALUES (
'1481',
'330',
'2020-12-11 09:00:00',
'SEA',
100,
'2020-12-11 10:00:00',
'ATL',
58,
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


INSERT INTO flight
VALUES (
'1482',
'318',
'2020-12-11 09:00:00',
'MCO',
108,
'2020-12-11 10:00:00',
'DFW',
101,
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


INSERT INTO flight
VALUES (
'1483',
'340',
'2020-12-11 09:00:00',
'ATL',
94,
'2020-12-11 10:00:00',
'MCO',
11,
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


INSERT INTO flight
VALUES (
'1484',
'345',
'2020-12-11 09:00:00',
'LAS',
80,
'2020-12-11 10:00:00',
'MCO',
44,
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


INSERT INTO flight
VALUES (
'1485',
'310',
'2020-12-11 09:00:00',
'DFW',
110,
'2020-12-11 10:00:00',
'LAX',
78,
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


INSERT INTO flight
VALUES (
'1486',
'345',
'2020-12-11 09:00:00',
'DEN',
34,
'2020-12-11 10:00:00',
'LAX',
108,
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


INSERT INTO flight
VALUES (
'1487',
'330',
'2020-12-11 09:00:00',
'DFW',
19,
'2020-12-11 10:00:00',
'JFK',
30,
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


INSERT INTO flight
VALUES (
'1488',
'310',
'2020-12-11 09:00:00',
'LAS',
37,
'2020-12-11 10:00:00',
'MCO',
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


INSERT INTO flight
VALUES (
'1489',
'319',
'2020-12-11 09:00:00',
'SFO',
26,
'2020-12-11 10:00:00',
'SEA',
15,
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


INSERT INTO flight
VALUES (
'1490',
'343',
'2020-12-11 09:00:00',
'MCO',
108,
'2020-12-11 10:00:00',
'LAX',
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


INSERT INTO flight
VALUES (
'1491',
'330',
'2020-12-11 09:00:00',
'SFO',
81,
'2020-12-11 10:00:00',
'JFK',
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


INSERT INTO flight
VALUES (
'1492',
'340',
'2020-12-11 09:00:00',
'MCO',
18,
'2020-12-11 10:00:00',
'DFW',
56,
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


INSERT INTO flight
VALUES (
'1493',
'321',
'2020-12-11 09:00:00',
'LAX',
33,
'2020-12-11 10:00:00',
'DEN',
33,
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


INSERT INTO flight
VALUES (
'1494',
'345',
'2020-12-11 09:00:00',
'DEN',
52,
'2020-12-11 10:00:00',
'DFW',
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


INSERT INTO flight
VALUES (
'1495',
'343',
'2020-12-11 09:00:00',
'SEA',
101,
'2020-12-11 10:00:00',
'JFK',
107,
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


INSERT INTO flight
VALUES (
'1496',
'319',
'2020-12-11 09:00:00',
'SFO',
110,
'2020-12-11 10:00:00',
'MCO',
110,
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


INSERT INTO flight
VALUES (
'1497',
'342',
'2020-12-11 09:00:00',
'DEN',
60,
'2020-12-11 10:00:00',
'LAX',
73,
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


INSERT INTO flight
VALUES (
'1498',
'345',
'2020-12-11 09:00:00',
'MCO',
42,
'2020-12-11 10:00:00',
'ATL',
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


INSERT INTO flight
VALUES (
'1499',
'343',
'2020-12-11 09:00:00',
'LAS',
47,
'2020-12-11 10:00:00',
'SEA',
29,
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


