USE Diabetes_130_US_Hospitals;
    
-- Removing parantheses from Age column 
UPDATE Diabetic_data_staging 
SET Age = TRIM(TRAILING ')' FROM(TRIM(LEADING '[' FROM age)));

-- Removing parantheses from weight column 
UPDATE Diabetic_data_staging 
SET weight = TRIM(TRAILING ')' FROM(TRIM(LEADING '[' FROM weight)));


-- CREATING SEPARATE ID MAPPING TABLES 


ALTER TABLE ids_mapping
ADD COLUMN Row_numb INT AUTO_INCREMENT UNIQUE FIRST; -- assigning unique identifier

CREATE TABLE Admission_type_id_mapping(
Admission_type_id INT PRIMARY KEY,
Description VARCHAR(50) 
);

CREATE TABLE Discharge_disposition_id_mapping(
Discharge_disposition_Id INT PRIMARY KEY ,
Description VARCHAR(255)
);

CREATE TABLE Admission_source_Id_mapping(
Admission_source_id INT PRIMARY KEY,
Description VARCHAR(255) 
);

INSERT INTO Admission_type_id_mapping 
SELECT Admission_type_id,description 
FROM ids_mapping
WHERE Row_numb < 9;

INSERT INTO Discharge_disposition_id_mapping
SELECT Admission_type_id,description 
FROM ids_mapping
WHERE Row_numb BETWEEN 9 AND 38;

INSERT INTO Admission_source_Id_mapping
SELECT Admission_type_id,description 
FROM ids_mapping
WHERE Row_numb BETWEEN 39 AND 63;

-- Adding Id description column 
ALTER TABLE Diabetic_data_staging
ADD COLUMN Admission_type_desc VARCHAR(50) AFTER admission_type_id;

ALTER TABLE Diabetic_data_staging
ADD COLUMN Discharge_disposition_desc VARCHAR(255) AFTER Discharge_disposition_id;

ALTER TABLE Diabetic_data_staging
ADD COLUMN Admission_source_desc VARCHAR(255) AFTER admission_source_id;

UPDATE Diabetic_data_staging AS D
JOIN Admission_type_id_mapping AS A
ON D.admission_type_id = A.admission_type_id
SET D.Admission_type_desc = A.description;

UPDATE Diabetic_data_staging AS D
JOIN Discharge_disposition_id_mapping AS DPM
ON D.Discharge_disposition_id = DPM.Discharge_disposition_id
SET D.Discharge_disposition_desc = DPM.description;

UPDATE Diabetic_data_staging AS D
JOIN Admission_source_id_mapping AS ASM
ON D.admission_source_id = ASM.admission_source_id
SET D.Admission_source_desc = ASM.description;

-- populating blank race with already known race from repeating patients
WITH true_race AS (
SELECT patient_nbr,MAX(race) AS known_race
FROM Diabetic_data_staging
WHERE race <> '?'
GROUP BY patient_nbr)
UPDATE Diabetic_data_staging AS D 
JOIN True_race AS T 
ON D.patient_nbr = T.patient_nbr
SET D.race = T.known_race 
WHERE D.race = '?';

-- Handling blanks

UPDATE Diabetic_data_staging
 SET
 `race`= NULLIF(`race`,'?'),
 `weight`= NULLIF(`weight`,'?'),
 `payer_code`= NULLIF(`payer_code`,'?'),
 `medical_specialty`= NULLIF(`medical_specialty`,'?'),
 `diag_2`= NULLIF(`diag_2`,'?'),
 `diag_3`= NULLIF(`diag_3`,'?')
 ;
 
  -- Handling Unknown/invalid value under gender 
 UPDATE Diabetic_data_staging
 SET 
 Gender = NULLIF(gender,'unknown/invalid');

-- Fixing none values
UPDATE Diabetic_data_staging SET 
max_glu_serum = IF(max_glu_serum='none','Not_Tested',max_glu_serum),
A1Cresult = IF(A1Cresult = 'none','Not_Tested',A1Cresult);

-- Renaming columns 

ALTER TABLE Diabetic_data_staging 
RENAME COLUMN `change` TO Med_change,
RENAME COLUMN `glyburide-metformin` TO glyburide_metformin,
RENAME COLUMN `glipizide-metformin` TO glipizide_metformin,
RENAME COLUMN `glimepiride-pioglitazone` TO glimepiride_pioglitazone,
RENAME COLUMN `metformin-rosiglitazone` TO metformin_rosiglitazone,
RENAME COLUMN `metformin-pioglitazone` TO metformin_pioglitazone,
RENAME COLUMN A1Cresult TO a1c_result,
RENAME COLUMN age TO Age_Group;

-- Adding minimum age column for analytical purpose
ALTER TABLE Diabetic_data_staging 
ADD COLUMN Age_Min TINYINT AFTER age_group;

UPDATE Diabetic_data_staging
SET Age_Min = SUBSTRING_INDEX(age_group,'-',1);

-- adding diagnosis category columns 
ALTER TABLE Diabetic_data_staging 
ADD diag_1_category VARCHAR(50) AFTER diag_1,
ADD diag_2_category VARCHAR(50) AFTER diag_2,
ADD diag_3_category VARCHAR(50) AFTER diag_3;

UPDATE Diabetic_data_staging 
SET diag_1_category =
CASE  WHEN diag_1 LIKE 'V%' THEN 'Supplimental_Classification'
	  WHEN diag_1 LIKE 'E%' THEN 'External_cause'
      WHEN diag_1 IS NULL THEN 'Unknown'
      WHEN diag_1 LIKE '250%' THEN 'Diabetes'
      WHEN CAST(diag_1 AS DECIMAL(6,2)) BETWEEN 390 AND 459 
      OR FLOOR(CAST(diag_1 AS DECIMAL(6,2))) = 785 THEN 'Circulatory'
      WHEN CAST(diag_1 AS DECIMAL(6,2)) BETWEEN 460 AND 519 
      OR FLOOR(CAST(diag_1 AS DECIMAL(6,2))) = 786 THEN 'Respiratory'
      WHEN CAST(diag_1 AS DECIMAL(6,2)) BETWEEN 520 AND 579 
      OR FLOOR(CAST(diag_1 AS DECIMAL(6,2))) = 787 THEN 'Digestive'
      WHEN CAST(diag_1 AS DECIMAL(6,2)) BETWEEN 580 AND 629 
      OR FLOOR(CAST(diag_1 AS DECIMAL(6,2))) =788 THEN 'Genitourinary'
      WHEN CAST(diag_1 AS DECIMAL(6,2)) BETWEEN 140 AND 239 THEN 'Neoplasms'
      WHEN CAST(diag_1 AS DECIMAL(6,2)) BETWEEN 710 AND 739 THEN 'Musculoskeletal'
      WHEN CAST(diag_1 AS DECIMAL(6,2)) BETWEEN 800 AND 999 THEN 'Injury'
      ELSE 'other' END;

UPDATE Diabetic_data_staging 
SET diag_2_category =
CASE  WHEN diag_2 LIKE 'V%' THEN 'Supplimental_Classification'
	  WHEN diag_2 LIKE 'E%' THEN 'External_cause'
      WHEN diag_2 IS NULL THEN 'Unknown'
      WHEN diag_2 LIKE '250%' THEN 'Diabetes'
      WHEN CAST(diag_2 AS DECIMAL(6,2)) BETWEEN 390 AND 459 
      OR FLOOR(CAST(diag_2 AS DECIMAL(6,2))) = 785 THEN 'Circulatory'
      WHEN CAST(diag_2 AS DECIMAL(6,2)) BETWEEN 460 AND 519 
      OR FLOOR(CAST(diag_2 AS DECIMAL(6,2))) = 786 THEN 'Respiratory'
      WHEN CAST(diag_2 AS DECIMAL(6,2)) BETWEEN 520 AND 579 
      OR FLOOR(CAST(diag_2 AS DECIMAL(6,2))) = 787 THEN 'Digestive'
      WHEN CAST(diag_2 AS DECIMAL(6,2)) BETWEEN 580 AND 629 
      OR FLOOR(CAST(diag_2 AS DECIMAL(6,2))) =788 THEN 'Genitourinary'
      WHEN CAST(diag_2 AS DECIMAL(6,2)) BETWEEN 140 AND 239 THEN 'Neoplasms'
      WHEN CAST(diag_2 AS DECIMAL(6,2)) BETWEEN 710 AND 739 THEN 'Musculoskeletal'
      WHEN CAST(diag_2 AS DECIMAL(6,2)) BETWEEN 800 AND 999 THEN 'Injury'
      ELSE 'other' END ;

UPDATE Diabetic_data_staging 
SET diag_3_category =
CASE  WHEN diag_3 LIKE 'V%' THEN 'Supplimental_Classification'
	  WHEN diag_3 LIKE 'E%' THEN 'External_cause'
      WHEN diag_3 IS NULL THEN 'Unknown'
      WHEN diag_3 LIKE '250%' THEN 'Diabetes'
      WHEN CAST(diag_3 AS DECIMAL(6,2)) BETWEEN 390 AND 459 
      OR FLOOR(CAST(diag_3 AS DECIMAL(6,2))) = 785 THEN 'Circulatory'
      WHEN CAST(diag_3 AS DECIMAL(6,2)) BETWEEN 460 AND 519 
      OR FLOOR(CAST(diag_3 AS DECIMAL(6,2))) = 786 THEN 'Respiratory'
      WHEN CAST(diag_3 AS DECIMAL(6,2)) BETWEEN 520 AND 579 
      OR FLOOR(CAST(diag_3 AS DECIMAL(6,2))) = 787 THEN 'Digestive'
      WHEN CAST(diag_3 AS DECIMAL(6,2)) BETWEEN 580 AND 629 
      OR FLOOR(CAST(diag_3 AS DECIMAL(6,2))) =788 THEN 'Genitourinary'
      WHEN CAST(diag_3 AS DECIMAL(6,2)) BETWEEN 140 AND 239 THEN 'Neoplasms'
      WHEN CAST(diag_3 AS DECIMAL(6,2)) BETWEEN 710 AND 739 THEN 'Musculoskeletal'
      WHEN CAST(diag_3 AS DECIMAL(6,2)) BETWEEN 800 AND 999 THEN 'Injury'
      ELSE 'other' END ;

-- Creating table without repeating patients 
CREATE TABLE diabetic_first_encounter AS
SELECT * FROM (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY patient_nbr ORDER BY encounter_id) rn
  FROM Diabetic_data_staging) t
WHERE rn = 1;

ALTER TABLE diabetic_first_encounter 
DROP COLUMN rn;

-- Assigning primary key to the dataset
ALTER TABLE Diabetic_data_staging
ADD PRIMARY KEY (encounter_id);

-- Data dictionary
SET GLOBAL local_infile = 1;

CREATE TABLE Data_dictionary (
Field VARCHAR(50),
Description_and_Values VARCHAR(255),
`Type` VARCHAR(50),
`pct_missing` VARCHAR(10)
);

LOAD DATA LOCAL INFILE '/Users/ntakadzeniluvhengo/Documents/ALX Data Science/SQL/Portfolio/Project 2 -Diabetics/Data dictionary.csv'
INTO TABLE Data_dictionary
CHARACTER SET utf8mb4 
FIELDS TERMINATED BY ','
 OPTIONALLY ENCLOSED BY '"'
 LINES TERMINATED BY '\r\n'
 IGNORE 1 LINES;
