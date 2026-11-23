USE Diabetes_130_US_Hospitals;

-- 4.Validating 
SELECT 
	(SELECT COUNT(*) FROM diabetic_data) AS raw_data,
    (SELECT COUNT(*) FROM Diabetic_data_staging) AS clean_data;
    

SELECT SUM(race = '?') AS bad_race,
	   SUM(weight = '?') AS bad_weight,
       SUM(payer_code = '?') AS bad_payer_code,
       SUM(medical_specialty = '?') AS bad_medical_specialty,
       SUM(diag_2 = '?') AS bad_diag_2,
       SUM(diag_3 = '?') AS bad_diag_3
	FROM Diabetic_data_staging;
    
DESCRIBE Diabetic_data_staging;
