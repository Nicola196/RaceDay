CREATE DATABASE RACEDAY;
USE RACEDAY;

CREATE TABLE Roles (
    RoleId      INT IDENTITY(1,1) PRIMARY KEY,
    RoleName    NVARCHAR(50) NOT NULL UNIQUE
);


-- Users: each user has exactly one role
CREATE TABLE Users (
    UserId          INT IDENTITY(1,1) PRIMARY KEY,
    FullName        NVARCHAR(100) NOT NULL,
    Email           NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash    NVARCHAR(255) NOT NULL,
    RoleId          INT NOT NULL,
    CreatedAt       DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleId) REFERENCES Roles(RoleId)
);


-- Categories: lookup table, one category has many events
CREATE TABLE Categories (
    CategoryId      INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName    NVARCHAR(50) NOT NULL UNIQUE
);


-- Events: each event belongs to exactly one category
CREATE TABLE Events (
    EventId         INT IDENTITY(1,1) PRIMARY KEY,
    EventName       NVARCHAR(100) NOT NULL,
    EventDate       DATE NOT NULL,
    Location        NVARCHAR(100) NULL,
    Latitude        DECIMAL(9,6) NULL,
    Longitude       DECIMAL(9,6) NULL,
    MapUrl          NVARCHAR(255) NULL,    -- new: direct map link
    CategoryId      INT NOT NULL,
    CONSTRAINT FK_Events_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(CategoryId)

);


-- EventEnrolments: junction table resolving the many-to-many
-- between Users and Events. A user cannot enrol twice in the
-- same event (enforced by the unique constraint below).
CREATE TABLE EventEnrolments (
    EnrolmentId     INT IDENTITY(1,1) PRIMARY KEY,
    UserId          INT NOT NULL,
    EventId         INT NOT NULL,
    EnrolmentDate   DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Enrolments_Users FOREIGN KEY (UserId) REFERENCES Users(UserId),
    CONSTRAINT FK_Enrolments_Events FOREIGN KEY (EventId) REFERENCES Events(EventId),
    CONSTRAINT UQ_User_Event UNIQUE (UserId, EventId)
);


-- Results: one result per enrolment (zero-or-one - a result
-- may not exist yet until the event has taken place).
CREATE TABLE Results (
    ResultId        INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentId     INT NOT NULL UNIQUE,
    FinishTime      TIME NOT NULL,
    Position        INT NULL,
    CONSTRAINT FK_Results_Enrolments FOREIGN KEY (EnrolmentId) REFERENCES EventEnrolments(EnrolmentId)
);


-- Roles
INSERT INTO Roles (RoleName) VALUES
    ('member1'),
    ('Organiser1');


-- Users (passwords shown as placeholder hashes - never store plain text)
INSERT INTO Users (RoleId, FullName, Email, PasswordHash) VALUES
    (1, 'Nicola Smith',    'nicola.smith1@example.com',    'HASH_PLACEHOLDER_1'),
    (1, 'Thabo Mokoena',   'thabo.mokoena2@example.com',   'HASH_PLACEHOLDER_2'),
    (1, 'Lerato Dube',     'lerato.dube3@example.com',     'HASH_PLACEHOLDER_3'),
    (2, 'Sarah van Wyk',   'sarah.vanwyk4@example.com',    'HASH_PLACEHOLDER_4'),
    (2, 'James Botha',     'james.botha5@example.com',     'HASH_PLACEHOLDER_5');


-- Categories
INSERT INTO Categories (CategoryName) VALUES
    ('5km Road Race'),
    ('10km Road Race'),
    ('Trail Run'),
    ('Half Marathon');


-- Events
INSERT INTO Events (CategoryId, EventName, EventDate, Location) VALUES
    (1, 'Johannesburg City 5km',       '2026-10-04', 'Sandton, Johannesburg'),
    (3, 'Cradle Trail Challenge',      '2026-10-18', 'Cradle of Humankind'),
    (2, 'Pretoria 10km Classic',       '2026-11-01', 'Union Buildings, Pretoria'),
    (4, 'Vaal Half Marathon',          '2026-11-15', 'Vanderbijlpark');


-- Event Enrolments (members signing up for events)
INSERT INTO EventEnrolments (UserId, EventId, EnrolmentDate) VALUES
    (1, 1, '2026-09-01 09:00:00'),  -- Nicola -> Johannesburg City 5km
    (2, 1, '2026-09-02 10:15:00'),  -- Thabo  -> Johannesburg City 5km
    (3, 2, '2026-09-03 08:30:00'),  -- Lerato -> Cradle Trail Challenge
    (1, 3, '2026-09-05 14:00:00'),  -- Nicola -> Pretoria 10km Classic
    (2, 4, '2026-09-06 16:45:00');  -- Thabo  -> Vaal Half Marathon



INSERT INTO Results (EnrolmentId, FinishTime, Position) VALUES
    (1, '00:24:31', 1),   -- Nicola's 5km result
    (2, '00:26:10', 2),   -- Thabo's 5km result
    (3, '01:12:47', 1);   -- Lerato's trail run result


SELECT * FROM Roles;
SELECT * FROM Users;
SELECT * FROM Categories;
SELECT * FROM Events;
SELECT * FROM EventEnrolments;
SELECT * FROM Results;

ALTER TABLE Events ADD
    Latitude  DECIMAL(9,6) NULL,
    Longitude DECIMAL(9,6) NULL;

    UPDATE Events SET
    Latitude  = -26.107567,
    Longitude = 28.056703
WHERE EventId = 1;   -- Johannesburg City 5km (Sandton)

UPDATE Events SET
    Latitude  = -25.921458,
    Longitude = 27.779192
WHERE EventId = 2;   -- Cradle Trail Challenge (Cradle of Humankind)

UPDATE Events SET
    Latitude  = -25.746019,
    Longitude = 28.187843
WHERE EventId = 3;   -- Pretoria 10km Classic (Union Buildings)

UPDATE Events SET
    Latitude  = -26.683333,
    Longitude = 27.833333
WHERE EventId = 4;   -- Vaal Half Marathon (Vanderbijlpark)