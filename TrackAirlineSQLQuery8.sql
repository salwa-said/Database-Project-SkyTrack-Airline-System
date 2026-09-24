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
ALTER TABLE Passenger
ALTER COLUMN National_ID INT;

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
    FOREIGN KEY (Flight_number) 
        REFERENCES Flight(Flight_number)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Crew_license) 
        REFERENCES CrewMember(License_number)
        ON DELETE CASCADE ON UPDATE CASCADE
);

---SkyTrack Airline System – SQL Practice
---Part 1: Insert Sample Data
INSERT INTO Airport VALUES ('MCT','Muscat International','Muscat','Oman');
INSERT INTO Airport VALUES ('DXB','Dubai International','Dubai','UAE');
INSERT INTO Airport VALUES ('LHR','Heathrow','London','UK');
INSERT INTO Airport VALUES ('JFK','John F. Kennedy','New York','USA');
INSERT INTO Airport VALUES ('CDG','Charles de Gaulle','Paris','France');


INSERT INTO Aircraft VALUES ('A123','A320','Airbus',2015,180);
INSERT INTO Aircraft VALUES ('B456','737-800','Boeing',2012,160);
INSERT INTO Aircraft VALUES ('C789','777-300','Boeing',2018,350);
INSERT INTO Aircraft VALUES ('D321','A350','Airbus',2020,300);
INSERT INTO Aircraft VALUES ('E654','Embraer E190','Embraer',2016,100);

ALTER TABLE Flight
DROP CONSTRAINT C2;


ALTER TABLE Flight
ALTER COLUMN Departure_datetime DATETIME NOT NULL;

ALTER TABLE Flight
ALTER COLUMN Arrival_datetime DATETIME NOT NULL;

ALTER TABLE Flight
ADD CONSTRAINT C2 CHECK (Arrival_datetime > Departure_datetime);

select * from Flight
select * from Airport
select * from Aircraft


INSERT INTO Flight VALUES ('SK101','2026-09-25 08:00:00','2026-09-25 12:00:00','Scheduled','MCT','DXB','A123');
INSERT INTO Flight VALUES ('SK102','2026-09-26 09:00:00','2026-09-26 15:00:00','Delayed','DXB','LHR','B456');
INSERT INTO Flight VALUES ('SK103','2026-09-27 07:30:00','2026-09-27 13:45:00','Cancelled','LHR','JFK','C789');
INSERT INTO Flight VALUES ('SK104','2026-09-28 10:00:00','2026-09-28 18:00:00','Completed','JFK','CDG','D321');
INSERT INTO Flight VALUES ('SK105','2026-09-29 06:00:00','2026-09-29 09:30:00','Scheduled','CDG','MCT','E654');
INSERT INTO Flight VALUES ('SK106','2026-09-30 11:00:00','2026-09-30 16:00:00','Delayed','MCT','LHR','A123');
INSERT INTO Flight VALUES ('SK107','2026-10-01 14:00:00','2026-10-01 20:00:00','Cancelled','DXB','JFK','B456');
INSERT INTO Flight VALUES ('SK108','2026-10-02 05:00:00','2026-10-02 11:00:00','Completed','CDG','DXB','C789');

INSERT INTO Passenger VALUES ('P001','Ali Hassan','ali.hassan@email.com','968123456','Omani','1990-05-12');
INSERT INTO Passenger VALUES ('P002','John Smith','john.smith@email.com','001987654','American','1985-03-20');
INSERT INTO Passenger VALUES ('P003','Fatima Khan','fatima.khan@email.com','971555123','Pakistani','1992-07-15');
INSERT INTO Passenger VALUES ('P004','Pierre Dupont','pierre.dupont@email.com','331234567','French','1988-11-02');
INSERT INTO Passenger VALUES ('P005','Maria Lopez','maria.lopez@email.com','341234567','Spanish','1995-09-10');
INSERT INTO Passenger VALUES ('P006','Chen Wei','chen.wei@email.com','861234567','Chinese','1987-01-25');
INSERT INTO Passenger VALUES ('P007','Ahmed Al-Sayed','ahmed.sayed@email.com','201234567','Egyptian','1993-12-05');
INSERT INTO Passenger VALUES ('P008','Sophia Rossi','sophia.rossi@email.com','391234567','Italian','1991-06-18');


INSERT INTO Booking (Booking_date,Seat_number,Class,Price,Paid,Flight_number,Passenger_ID)
VALUES (GETDATE(),'12A','Economy',200,1,'SK101','P001');

INSERT INTO Booking VALUES (GETDATE(),'14B','Business',500,1,'SK102','P002');
INSERT INTO Booking VALUES (GETDATE(),'15C','First',1000,1,'SK103','P003');
INSERT INTO Booking VALUES (GETDATE(),'16D','Economy',220,1,'SK104','P004');
INSERT INTO Booking VALUES (GETDATE(),'17E','Business',550,1,'SK105','P005');
INSERT INTO Booking VALUES (GETDATE(),'18F','First',1200,1,'SK106','P006');
INSERT INTO Booking VALUES (GETDATE(),'19G','Economy',180,1,'SK107','P007');
INSERT INTO Booking VALUES (GETDATE(),'20H','Business',600,1,'SK108','P008');
INSERT INTO Booking VALUES (GETDATE(),'21I','Economy',210,1,'SK101','P002');
INSERT INTO Booking VALUES (GETDATE(),'22J','First',1100,1,'SK102','P003');


INSERT INTO CrewMember VALUES ('C001','Captain Khalid','Pilot');
INSERT INTO CrewMember VALUES ('C002','First Officer James','Co-Pilot');
INSERT INTO CrewMember VALUES ('C003','Sarah Ali','Flight Attendant');
INSERT INTO CrewMember VALUES ('C004','Mohammed Noor','Flight Attendant');
INSERT INTO CrewMember VALUES ('C005','Elena Petrova','Engineer');
INSERT INTO CrewMember VALUES ('C006','David Brown','Pilot');


INSERT INTO FlightCrew VALUES ('SK101','C001','2026-09-25','Pilot',8);
INSERT INTO FlightCrew VALUES ('SK101','C003','2026-09-25','Flight Attendant',8);

INSERT INTO FlightCrew VALUES ('SK102','C002','2026-09-26','Co-Pilot',7);
INSERT INTO FlightCrew VALUES ('SK102','C004','2026-09-26','Flight Attendant',7);

INSERT INTO FlightCrew VALUES ('SK103','C006','2026-09-27','Pilot',9);
INSERT INTO FlightCrew VALUES ('SK103','C003','2026-09-27','Flight Attendant',9);

INSERT INTO FlightCrew VALUES ('SK104','C001','2026-09-28','Pilot',8);
INSERT INTO FlightCrew VALUES ('SK104','C004','2026-09-28','Flight Attendant',8);

INSERT INTO FlightCrew VALUES ('SK105','C006','2026-09-29','Pilot',6);
INSERT INTO FlightCrew VALUES ('SK105','C003','2026-09-29','Flight Attendant',6);

INSERT INTO FlightCrew VALUES ('SK106','C001','2026-09-30','Pilot',7);
INSERT INTO FlightCrew VALUES ('SK106','C004','2026-09-30','Flight Attendant',7);

INSERT INTO FlightCrew VALUES ('SK107','C006','2026-10-01','Pilot',8);
INSERT INTO FlightCrew VALUES ('SK107','C003','2026-10-01','Flight Attendant',8);

INSERT INTO FlightCrew VALUES ('SK108','C001','2026-10-02','Pilot',9);
INSERT INTO FlightCrew VALUES ('SK108','C004','2026-10-02','Flight Attendant',9);

UPDATE Flight
SET Status = 'Completed'
WHERE Flight_number = 'SK101';


UPDATE Flight
SET Status = 'Cancelled'
WHERE Flight_number = 'SK102';


UPDATE Booking
SET Price = Price * 1.10
WHERE Class = 'Economy';


UPDATE Passenger
SET Phone = '968999999'
WHERE National_ID = 'P001';


UPDATE CrewMember
SET Role = 'Engineer'
WHERE License_number = 'C002';


SELECT * FROM Flight WHERE Status = 'Cancelled';
DELETE FROM Flight WHERE Flight_number = 'SK103';


SELECT * FROM Booking WHERE Flight_number = 'SK103';
DELETE FROM Booking WHERE Flight_number = 'SK103';

SELECT * FROM Passenger WHERE National_ID = 'P001';
DELETE FROM Passenger WHERE National_ID = 'P001';
-- This DELETE will fail because Passenger P001 has existing bookings.
-- The foreign key constraint prevents deleting a passenger who is still linked to bookings.



----------
---SkyTrack Airline System – Query Practice
--Part 3: Data Queries
--Basic Level:

SELECT Flight_number, Status, Departure_datetime, Arrival_datetime
FROM Flight
ORDER BY Departure_datetime;


SELECT full_name, Nationality, Email
FROM Passenger
ORDER BY full_name;

SELECT Registration_num  ber, Model, Manufacturer, Total_seating_capacity
FROM Aircraft
ORDER BY Total_seating_capacity DESC;



SELECT DISTINCT Class
FROM Booking;



SELECT Flight_number, Status
FROM Flight
WHERE Status IN ('Delayed','Cancelled');


SELECT full_name, Nationality
FROM Passenger
WHERE Nationality = 'Omani';



SELECT IATA_code, Name, City, Country
FROM Airport
ORDER BY Country;


-- MEDIUM LEVEL
SELECT F.Flight_number, OA.Name, DA.Name
FROM Flight F
JOIN Airport OA ON F.Origin_airport = OA.IATA_code
JOIN Airport DA ON F.Destination_airport = DA.IATA_code;


SELECT * FROM Passenger
SELECT B.Booking_id, P.full_name, B.Flight_number
FROM Booking B
JOIN Passenger P ON B.Passenger_ID = P.National_ID;



SELECT * FROM CrewMember

SELECT C.full_name, C.Role
FROM FlightCrew FC
JOIN CrewMember C ON FC.Crew_license = C.License_number
WHERE FC.Flight_number = 'SK101';


SELECT * FROM   Aircraft

--4
SELECT F.Flight_number , A.Model
FROM Flight F
JOIN Aircraft A ON F.Aircraft_reg = A.Registration_number
WHERE F.Status = 'Completed';


SELECT * FROM Passenger
SELECT * FROM Booking
--5
SELECT P.Full_name, COUNT(B.Booking_id)
FROM Passenger P
LEFT JOIN Booking B ON P.National_ID = B.Passenger_ID
GROUP BY P.Full_name
ORDER BY COUNT(B.Booking_id) DESC;


--6
SELECT Class, SUM(Price)
FROM Booking
GROUP BY Class;

---7
SELECT Aircraft_reg, COUNT(*)
FROM Flight
GROUP BY Aircraft_reg;


---8
SELECT Flight_number, COUNT(*)
FROM Booking
GROUP BY Flight_number
HAVING COUNT(*) > 1;


--9

SELECT P.full_name, B.Flight_number, F.Origin_airport, F.Destination_airport, B.Class, B.Price
FROM Booking B
JOIN Passenger P ON B.Passenger_ID = P.National_ID
JOIN Flight F ON B.Flight_number = F.Flight_number;

---Advanced Level


