# COSC3380 HW4
Database ER Design, Normalization, and Web App for An Airline Database System  

Prefered system: Window

# Prerequisites
node.js installed on local machine (nodejs.org)
source-code editor such as visual studio code
UH server connection

# Getting Started

  The Client
  
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
   
  The Server
  
  - createdb.sql : setting up the database
  - db.js : connect the webserver to the database
  - index.js : communicate with the client
  - password.txt : store user access information
  - processing.js : generate information about the flight
  - queryBank.js : communicate with the database
    
# The following instruction is made using Visual Studio Code
- Log in to your UH server and upload the file hw4/Server/createdb.sql
- Run createdb.sql in your database to establish the necessary relations
- Open the file hw4/Server/password.txt and insert your UH server username and password as follow:
 #username
 #password
 
- Navigate to the Extension tab and install "Live Server" extension

  Start up the server
  + Open a new Terminal inside Visual Studio Code (Terminal - New Terminal)
  + Navigate to hw4/Server using cd
  + Install dependencies by using command "npm install", follow by "npm install line-reader"
  + After succesfully installing dependencies, start the server using "node index.js"
  
  Open up web interface
  + Open up hw4/Client/Pages/airlineweb.html with Visual Studio Code
  + Right click and select "Open with Live Server"
  
This is our main homepage for the project, start by selecting the starting city/airport and destination.
Available Flight date is from 12/10 to 12/19, and up to 5 ticket can be purchased at once.
Please watch our short video explaining the project if there is any confusion.
