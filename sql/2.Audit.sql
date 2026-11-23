USE Diabetes_130_US_Hospitals;

-- duplicates

SELECT Encounter_id,COUNT(*)
FROM Diabetic_data_staging
GROUP BY encounter_id
HAVING COUNT(*) > 1;

SELECT DISTINCT encounter_id
FROM Diabetic_data_staging
LIMIT 200000;

SELECT patient_nbr,COUNT(*)
FROM Diabetic_data_staging
GROUP BY patient_nbr
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS encounters,
       COUNT(DISTINCT patient_nbr) AS unique_patients
FROM Diabetic_data_staging;

-- Blanks values 
    
 SET SESSION group_concat_max_len = 1000000;   
 
    SELECT CONCAT('SELECT ', 
              GROUP_CONCAT(
                  CONCAT('COUNT(*) - COUNT(NULLIF(`', COLUMN_NAME, '`, "?")) AS `Blank_', COLUMN_NAME,'`')
                  ORDER BY ORDINAL_POSITION
              ), 
              ' FROM Diabetic_data_staging;') AS Generated_Query
FROM information_schema.COLUMNS 
WHERE TABLE_NAME = 'Diabetic_data_staging' 
  AND TABLE_SCHEMA = 'Diabetes_130_US_Hospitals';
  
  -- Copy(copy unquoted) and paste the generated query and execute 
 
  
  -- below is the copy above query organised
  SELECT COUNT(*) - COUNT(NULLIF(`encounter_id`, "?")) AS `Blank_encounter_id`,
  COUNT(*) - COUNT(NULLIF(`patient_nbr`, "?")) AS `Blank_patient_nbr`,
  COUNT(*) - COUNT(NULLIF(`race`, "?")) AS `Blank_race`,
  COUNT(*) - COUNT(NULLIF(`gender`, "?")) AS `Blank_gender`,
  COUNT(*) - COUNT(NULLIF(`age`, "?")) AS `Blank_age`,
  COUNT(*) - COUNT(NULLIF(`weight`, "?")) AS `Blank_weight`,
  COUNT(*) - COUNT(NULLIF(`admission_type_id`, "?")) AS `Blank_admission_type_id`,
  COUNT(*) - COUNT(NULLIF(`discharge_disposition_id`, "?")) AS `Blank_discharge_disposition_id`,
  COUNT(*) - COUNT(NULLIF(`admission_source_id`, "?")) AS `Blank_admission_source_id`,
  COUNT(*) - COUNT(NULLIF(`time_in_hospital`, "?")) AS `Blank_time_in_hospital`,
  COUNT(*) - COUNT(NULLIF(`payer_code`, "?")) AS `Blank_payer_code`,
  COUNT(*) - COUNT(NULLIF(`medical_specialty`, "?")) AS `Blank_medical_specialty`,
  COUNT(*) - COUNT(NULLIF(`num_lab_procedures`, "?")) AS `Blank_num_lab_procedures`,
  COUNT(*) - COUNT(NULLIF(`num_procedures`, "?")) AS `Blank_num_procedures`,
  COUNT(*) - COUNT(NULLIF(`num_medications`, "?")) AS `Blank_num_medications`,
  COUNT(*) - COUNT(NULLIF(`number_outpatient`, "?")) AS `Blank_number_outpatient`,
  COUNT(*) - COUNT(NULLIF(`number_emergency`, "?")) AS `Blank_number_emergency`,
  COUNT(*) - COUNT(NULLIF(`number_inpatient`, "?")) AS `Blank_number_inpatient`,
  COUNT(*) - COUNT(NULLIF(`diag_1`, "?")) AS `Blank_diag_1`,
  COUNT(*) - COUNT(NULLIF(`diag_2`, "?")) AS `Blank_diag_2`,
  COUNT(*) - COUNT(NULLIF(`diag_3`, "?")) AS `Blank_diag_3`,
  COUNT(*) - COUNT(NULLIF(`number_diagnoses`, "?")) AS `Blank_number_diagnoses`,
  COUNT(*) - COUNT(NULLIF(`max_glu_serum`, "?")) AS `Blank_max_glu_serum`,
  COUNT(*) - COUNT(NULLIF(`A1Cresult`, "?")) AS `Blank_A1Cresult`,
  COUNT(*) - COUNT(NULLIF(`metformin`, "?")) AS `Blank_metformin`,
  COUNT(*) - COUNT(NULLIF(`repaglinide`, "?")) AS `Blank_repaglinide`,
  COUNT(*) - COUNT(NULLIF(`nateglinide`, "?")) AS `Blank_nateglinide`,
  COUNT(*) - COUNT(NULLIF(`chlorpropamide`, "?")) AS `Blank_chlorpropamide`,
  COUNT(*) - COUNT(NULLIF(`glimepiride`, "?")) AS `Blank_glimepiride`,
  COUNT(*) - COUNT(NULLIF(`acetohexamide`, "?")) AS `Blank_acetohexamide`,
  COUNT(*) - COUNT(NULLIF(`glipizide`, "?")) AS `Blank_glipizide`,
  COUNT(*) - COUNT(NULLIF(`glyburide`, "?")) AS `Blank_glyburide`,
  COUNT(*) - COUNT(NULLIF(`tolbutamide`, "?")) AS `Blank_tolbutamide`,
  COUNT(*) - COUNT(NULLIF(`pioglitazone`, "?")) AS `Blank_pioglitazone`,
  COUNT(*) - COUNT(NULLIF(`rosiglitazone`, "?")) AS `Blank_rosiglitazone`,
  COUNT(*) - COUNT(NULLIF(`acarbose`, "?")) AS `Blank_acarbose`,
  COUNT(*) - COUNT(NULLIF(`miglitol`, "?")) AS `Blank_miglitol`,
  COUNT(*) - COUNT(NULLIF(`troglitazone`, "?")) AS `Blank_troglitazone`,
  COUNT(*) - COUNT(NULLIF(`tolazamide`, "?")) AS `Blank_tolazamide`,
  COUNT(*) - COUNT(NULLIF(`examide`, "?")) AS `Blank_examide`,
  COUNT(*) - COUNT(NULLIF(`citoglipton`, "?")) AS `Blank_citoglipton`,
  COUNT(*) - COUNT(NULLIF(`insulin`, "?")) AS `Blank_insulin`,
  COUNT(*) - COUNT(NULLIF(`glyburide-metformin`, "?")) AS `Blank_glyburide-metformin`,
  COUNT(*) - COUNT(NULLIF(`glipizide-metformin`, "?")) AS `Blank_glipizide-metformin`,
  COUNT(*) - COUNT(NULLIF(`glimepiride-pioglitazone`, "?")) AS `Blank_glimepiride-pioglitazone`,
  COUNT(*) - COUNT(NULLIF(`metformin-rosiglitazone`, "?")) AS `Blank_metformin-rosiglitazone`,
  COUNT(*) - COUNT(NULLIF(`metformin-pioglitazone`, "?")) AS `Blank_metformin-pioglitazone`,
  COUNT(*) - COUNT(NULLIF(`change`, "?")) AS `Blank_change`,
  COUNT(*) - COUNT(NULLIF(`diabetesMed`, "?")) AS `Blank_diabetesMed`,
  COUNT(*) - COUNT(NULLIF(`readmitted`, "?")) AS `Blank_readmitted`
  FROM Diabetic_data_staging;
  
  
  
