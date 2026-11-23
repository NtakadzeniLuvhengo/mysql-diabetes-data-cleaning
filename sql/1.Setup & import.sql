-- PART A -Run this first

CREATE DATABASE IF NOT EXISTS Diabetes_130_US_Hospitals;
USE Diabetes_130_US_Hospitals;

-- use the Table Data Import Wizard to import the following datasets:
-- Diabetic_data
-- ids_mapping

SELECT * FROM diabetic_data;
SELECT * FROM ids_mapping;

-- PART B -run this only AFTER the import is finished

CREATE TABLE Diabetic_data_staging 
LIKE diabetic_data;

INSERT INTO Diabetic_data_staging
SELECT * FROM diabetic_data;

SELECT * FROM Diabetic_data_staging;


SET SQL_SAFE_UPDATES = 0;
