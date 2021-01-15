# Panda Airways
A web app for demonstrating database ER Design and normalization through an airline database system

### Languages:

**Front End:** JavaScript (Node.js, jQuery), HTML, CSS

**Back End:** JavaScript (Node.js), PostgreSQL

## Getting Started

### Prerequisites
- Node.js installed on your local machine (nodejs.org)
- Access to a web browser (Firefox recommended)
- A PostgreSQL database

### Installation
#### Create the Database
- Open the file pandaAirways/Server/password.txt and insert your PostgreSQL database username and password as follows:
```text
 username
 password
```
- Navigate to your PostgreSQL database by whatever means you prefer (Terminal window, GUI, etc.)
- Set the schema to whatever you would like to hold the airline database
- To create all of the database tables, run:
```sql
\i createdb.sql
```



#### Start up the server
  + Open a new Terminal window
  + Navigate to pandaAirways/Server using cd
  + Type:
```text
npm install
```
  + If on Windows, start both the web and database servers by typing:
```text
runserver.bat
```
+ If on Mac/Linux, start both the web and database servers by typing:
```text
./runserver.sh
```
  Open up web interface
  + Open a new window in your web browser
  + Type into the URL:
```text
localhost:8000/Pages/airlineweb.html
```
  
This is the main homepage for booking flights. Start by selecting the starting city/airport and destination.
Flights are available from 12/10 to 12/19, and up to 5 ticket can be purchased at once.
If there is any confusion, please watch our short video explaining setup and usage.

## Outline
### The Client

- Components
    + bookStepProgressbar.html
    + changeStepProgressbar.html
    + flightInfo.html
    + flightInfo.js
    + header.html
    + passengerForm.html
    + styling.css

- Pages
    + booking
    + change
    + checkIn
    + status
    + admin.html
    + admin.js
    + airlineweb.html : main web page
    + airlineweb.js

### The Server

- createdb.sql : setting up the database
- db.js : connect the webserver to the database
- index.js : communicate with the client
- password.txt : store user access information
- processing.js : generate information about the flight
- queryBank.js : communicate with the database
- performBookings.js : create random bookings


