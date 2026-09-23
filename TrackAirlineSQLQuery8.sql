CREATE TABLE Airport(
	IATA_code CHAR(3) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    Country NVARCHAR(100) NOT NULL
);

CREATE TABLE Aircraft (
    Registration_number NVARCHAR(20) PRIMARY KEY,
    Model NVARCHAR(50) NOT NULL,
    Manufacturer NVARCHAR(50) NOT NULL,
    Year_of_manufacture INT,
    Total_seating_capacity INT NOT NULL
        CONSTRAINT C1 CHECK (Total_seating_capacity > 0)
);

CREATE TABLE Flight (
     Flight_number NVARCHAR(10) PRIMARY KEY,
    Departure_datetime DATETIME NOT NULL,
    Arrival_datetime DATETIME NOT NULL
       CONSTRAINT C2 CHECK (Arrival_datetime > Departure_datetime),
    Status NVARCHAR(20) NOT NULL DEFAULT 'Scheduled'
        CONSTRAINT C3 CHECK (Status IN ('Scheduled','Delayed','Cancelled','Completed')),
    Origin_airport CHAR(3) NOT NULL,
    Destination_airport CHAR(3) NOT NULL,
    Aircraft_reg NVARCHAR(20) NOT NULL,
    FOREIGN KEY (Origin_airport) 
        REFERENCES Airport(IATA_code)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Destination_airport) 
        REFERENCES Airport(IATA_code)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Aircraft_reg) 
        REFERENCES Aircraft(Registration_number)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Passenger (
    National_ID NVARCHAR(20) PRIMARY KEY,
    Full_name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Phone NVARCHAR(20),
    Nationality NVARCHAR(50) NOT NULL,
    Date_of_birth DATE NOT NULL
);

CREATE TABLE Booking (
    Booking_id INT PRIMARY KEY IDENTITY(1,1),
    Booking_date DATE NOT NULL DEFAULT GETDATE(),
    Seat_number NVARCHAR(10) NOT NULL,
    Class NVARCHAR(20) NOT NULL
        CONSTRAINT C4 CHECK(Class IN ('Economy','Business','First')),
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    Paid INT NOT NULL,
    Flight_number NVARCHAR(10) NOT NULL,
    Passenger_ID NVARCHAR(20) NOT NULL,
    FOREIGN KEY (Flight_number) 
        REFERENCES Flight(Flight_number)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Passenger_ID) 
        REFERENCES Passenger(National_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE CrewMember (
    License_number NVARCHAR(20) PRIMARY KEY,
    Full_name NVARCHAR(100) NOT NULL,
    Role NVARCHAR(30) NOT NULL
       CONSTRAINT C5 CHECK (Role IN ('Pilot','Co-Pilot','Flight Attendant','Engineer'))
);


CREATE TABLE FlightCrew (
   PRIMARY KEY (Flight_number, Crew_license),
   Flight_number NVARCHAR(10),
    Crew_license NVARCHAR(20),
    Assignment_date DATE,
    Duty_role NVARCHAR(30),
    Shift_hours INT,
    FOREIGN KEY (Flight_number) REFERENCES Flight(Flight_number)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Crew_license) REFERENCES CrewMember(License_number)
        ON DELETE CASCADE ON UPDATE CASCADE
);

