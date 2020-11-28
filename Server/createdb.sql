DROP TABLE IF EXISTS passenger;
DROP TABLE IF EXISTS credit_card;
DROP TABLE IF EXISTS transaction;
DROP TABLE IF EXISTS airport;
DROP TABLE IF EXISTS ticket;
DROP TABLE IF EXISTS aircraft;
DROP TABLE IF EXISTS flight;

CREATE TABLE passenger(
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    date_of_birth TIMESTAMP NOT NULL
);

CREATE TABLE credit_card(
    card_number NUMERIC(16,0) PRIMARY KEY,
    expiration_month INTEGER NOT NULL,
    expiration_year INTEGER NOT NULL
);

CREATE TABLE transaction(
    id SERIAL PRIMARY KEY,
    card_number NUMERIC(16,0) REFERENCES credit_card(card_number) NOT NULL,
    voucher VARCHAR,
    amount NUMERIC(7,2) NOT NULL,
    contact_email TEXT NOT NULL,
    contact_phone_number NUMERIC(10,0) NOT NULL
);

CREATE TABLE aircraft(
  -- add stuff here
);


CREATE TABLE airport(
  code CHAR(3) PRIMARY KEY,
  name CHAR(40) NOT NULL,
  city CHAR(20) NOT NULL,
  coordinates POINT,
  timezone TEXT
);

CREATE TABLE flight(
  -- add stuff here
);

CREATE TABLE ticket(
  id SERIAL PRIMARY KEY,
  transaction_id SERIAL REFERENCES transaction(id) NOT NULL,
  flight_id SERIAL REFERENCES flight(id) NOT NULL,
  standby_flight_id SERIAL REFERENCES flight(id),
  passenger_id SERIAL REFERENCES passenger(id) NOT NULL,
  boarding_no SERIAL NOT NULL,
  fare_condition CHAR VARYING(10) NOT NULL
);
