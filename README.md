# RaceDay
# RaceDay System

## Overview

RaceDay is a system that lets running event organisers create and manage race events, and lets members browse those events, enrol in them, and view their results afterwards. This repository contains Part 1 of the Portfolio of Evidence: the planning stage of the project, completed before any application code is written.

Part 1 includes:

- An Entity Relationship Diagram (ERD) showing the full data model
- A SQL script that creates and populates the database
- A full API endpoint plan describing every route the system will expose
- A GitHub Actions workflow that checks the repository structure is correct

Later parts of this Portfolio of Evidence (not included in this submission) will build the RESTful API in C#, connect it to the database, and build the MVC web application that consumes it.

## User Roles

The system has two roles:

**Member**
A registered user who can browse events and categories, enrol in events, cancel their own enrolments, and view their own results and race history.

**Organiser**
An administrator who can create and manage categories, events, and locations, and who is responsible for capturing official results once an event has taken place.

## Repository Structure

```
RaceDay/
|-- docs/
|   |-- RaceDay_ERD.png              (Entity Relationship Diagram)
|   |-- RaceDay_API_Endpoint_Plan.pdf (Full API endpoint plan)
|   |-- RaceDay_Database_Script.sql   (Database creation and seed script)
|-- .github/
|   |-- workflows/
|       |-- validate-docs.yml         (GitHub Actions workflow)
|-- README.md
```

## Database Design

The database is made up of seven entities:

- **Roles** - defines the two user roles (Member and Organiser)
- **Users** - registered accounts, each linked to a role
- **Categories** - the type of race an event belongs to (for example, 5km Road Race, Trail Run)
- **Locations** - the venues where events take place, storing an address and coordinates
- **Events** - a specific race, linked to a category and a location
- **EventEnrolments** - the link between a user and an event they have signed up for
- **Results** - the finishing time and position for a completed enrolment

The full diagram, showing every field, primary key, foreign key, and relationship, is available at `docs/RaceDay_ERD.png`.

## Database Script

The SQL script at `docs/RaceDay_Database_Script.sql` creates all seven tables with their constraints and inserts sample data into each one. To run it:

1. Open SQL Server Management Studio (SSMS)
2. Connect to a local or remote SQL Server instance
3. Open a new query window and paste the contents of `RaceDay_Database_Script.sql`
4. Execute the script

The script can be run more than once without errors, since it drops any existing tables with the same names before recreating them.

## API Endpoint Plan

The full endpoint plan is available at `docs/RaceDay_API_Endpoint_Plan.pdf`. It covers eight areas:

1. Authentication (register and login)
2. User Profile
3. Categories
4. Locations
5. Events
6. Event Enrolments
7. Results
8. Weather (an additional endpoint that returns a weather forecast for an event, using the coordinates stored against its Location)

Each row in the plan lists the HTTP method, route, a description, the role required to call it, the request body, and the expected response, including relevant failure codes.

## GitHub and CI/CD

This repository uses a GitHub Actions workflow, defined in `.github/workflows/validate-docs.yml`, which runs automatically on every push. It checks that the `/docs` folder exists and that all three required planning documents are present. If any file is missing, the workflow fails and reports which one.


## Video Walkthrough

An unlisted YouTube video explaining the ERD decisions, the API endpoint plan, and a live run of the SQL script in SSMS is available at the link below.

[https://youtu.be/hzlxy3Tzj-8?si=VVMPUmihlaXBbODM]

## Author

Nicola
GitHub: [Nicola196](https://github.com/Nicola196)
