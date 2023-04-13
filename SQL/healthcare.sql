-- creating the table 'hospitals'
CREATE TABLE hospitals (
    facility_id VARCHAR(20) PRIMARY KEY,
    facility_name VARCHAR(255) NOT NULL,
    facility_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    county VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    state_code VARCHAR(10) NOT NULL,
    zip INT NOT NULL,
    phone VARCHAR(20) NOT NULL,
    hosp_type VARCHAR(100) NOT NULL,
    hosp_ownership VARCHAR(100) NOT NULL,
    emergency_unit VARCHAR(3) NOT NULL,
    ehr_interoperability VARCHAR(3) NOT NULL,
    hosp_rating INT 
);

-- creating the table 'locations'
CREATE TABLE locations (
    zip INT PRIMARY KEY,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    state_code VARCHAR(10) NOT NULL,
    latitude VARCHAR(20) NOT NULL,
    longitude VARCHAR(20) NOT NULL,
    timezone VARCHAR(20) NOT NULL
);

-- creating the table 'doctors'
CREATE TABLE doctors (
    npi VARCHAR(20) PRIMARY KEY,
    physician_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    pri_spec VARCHAR(100) NOT NULL,
    is_affltd VARCHAR(10) NOT NULL,
    hosp_affln VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    rating FLOAT NOT NULL,
    patients INT NOT NULL,
    experience INT NOT NULL,
    avg_wttime INT NOT NULL,
    busy_index INT NOT NULL,
    shift_1_begin TIME NOT NULL,
    shift_1_end TIME NOT NULL,
    shift_2_begin TIME NOT NULL,
    shift_2_end TIME NOT NULL,
    emergency_avail VARCHAR(3) NOT NULL,
    street VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    state_code VARCHAR(10) NOT NULL,
    zip VARCHAR(20) NOT NULL
);

-- creating the table 'patients'
CREATE TABLE patients (
    patient_id VARCHAR(10) PRIMARY KEY,
    patient_age INT NOT NULL,
    patient_gender VARCHAR(10) NOT NULL,
    pref_day VARCHAR(20) NOT NULL,
    pref_time VARCHAR(20) NOT NULL,
	consulting_date VARCHAR(20) NOT NULL,
    consulting_time TIME NOT NULL,
    consulting_day VARCHAR(20) NOT NULL,
    consulting_timestamp TIMESTAMP NOT NULL,
    npi VARCHAR(20) NOT NULL,
    pri_spec VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    state_code VARCHAR(10) NOT NULL,
    zip VARCHAR(20) NOT NULL
);


-- Populating the tables:

-- doctors
COPY doctors FROM 'C:\Users\laerc\Desktop\ci\doctors.csv' DELIMITER ',' CSV HEADER;

-- patients
COPY patients FROM 'C:\Users\laerc\Desktop\ci\patients.csv' DELIMITER ',' CSV HEADER;

-- locations
COPY locations FROM 'C:\Users\laerc\Desktop\ci\locations.csv' DELIMITER ',' CSV HEADER;

-- hospitals
COPY hospitals FROM 'C:\Users\laerc\Desktop\ci\hospitals.csv' DELIMITER ',' CSV HEADER;



-- checking locations
SELECT * FROM locations


-- creating a new feature in 'locations' to show the Regions based on the state_code:
-- 1. creating the column
ALTER TABLE locations
ADD COLUMN region VARCHAR(50);

-- 2. populating the column
UPDATE locations
SET region = CASE
    WHEN state_code IN ('ME', 'NH', 'VT', 'MA', 'RI', 'CT') THEN 'Northeast'
    WHEN state_code IN ('NY', 'PA', 'NJ') THEN 'Mid-Atlantic'
    WHEN state_code IN ('OH', 'MI', 'IN', 'IL', 'WI', 'MN') THEN 'Midwest'
    WHEN state_code IN ('MO', 'KS', 'OK', 'TX', 'AR', 'LA', 'MS') THEN 'South'
    WHEN state_code IN ('ND', 'SD', 'NE', 'KS', 'IA', 'MO') THEN 'Great Plains'
    WHEN state_code IN ('MT', 'ID', 'WY', 'UT', 'CO', 'NV', 'AZ', 'NM') THEN 'West'
    WHEN state_code IN ('WA', 'OR', 'CA', 'AK', 'HI') THEN 'Pacific'
    ELSE 'Unknown'
END;

-- 3. Saving the new version as new_locations
COPY locations TO 'C:\Users\laerc\Desktop\ci\new_locations.csv' DELIMITER ',' CSV HEADER;


-- Business Questions
--1.	Can you provide the total number of hospitals, doctors, patients, and specializations?
--doctors
SELECT COUNT(DISTINCT npi) AS total_number_doctors
FROM doctors

--hospitals
SELECT COUNT(DISTINCT facility_id) AS total_number_hospitals
FROM hospitals

--patients
SELECT COUNT(DISTINCT patient_id) AS total_number_patients
FROM patients

--specializations
SELECT COUNT(DISTINCT pri_spec) AS total_number_spec
FROM doctors


--2.	Which regions of the US have a higher concentration of doctors?
SELECT COUNT(DISTINCT doc.npi) AS number_of_doctors, loc.region
FROM doctors AS doc
INNER JOIN locations AS loc
ON CAST(doc.zip AS integer) = loc.zip
WHERE loc.region != 'Unknown'
GROUP BY loc.region
ORDER BY number_of_doctors DESC

--3.	Is there a relationship between doctors' rating and experience, and their availability?
-- POWER BI

--4.	What is the most common time for patients to visit a hospital?
--day
SELECT pref_day AS day_of_the_week, COUNT(pref_day) AS total, 
FROM patients
GROUP BY pref_day
ORDER BY total DESC

--time
SELECT pref_time AS most_prefered_time, COUNT(pref_time) AS total
FROM patients
GROUP BY pref_time
ORDER BY total DESC

