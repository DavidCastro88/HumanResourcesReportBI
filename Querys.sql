CREATE TABLE  IF NOT EXISTS hr(
	id VARCHAR(100) PRIMARY KEY,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	birthdate VARCHAR(100),
	gender VARCHAR(100),
	race VARCHAR(100),
	department VARCHAR(100),
	jobtitle VARCHAR(100),
	location VARCHAR(100),
	hire_date VARCHAR(100),
	termdate VARCHAR(100),
	location_city VARCHAR(100),
	location_state VARCHAR(100)
);

SELECT * FROM hr ;

--DELETE FIRST ROW
--DELETE FROM hr
-- WHERE ctid = (SELECT ctid FROM hr ORDER BY ctid LIMIT 1);

SELECT birthdate FROM hr;
SELECT age FROM hr;

--- birthdate, unify date YYYY-MM-DD format

UPDATE hr
SET birthdate =
    CASE
        WHEN birthdate LIKE '%/%' THEN
            TO_CHAR(TO_TIMESTAMP(birthdate, 'MM/DD/YY'), 'YYYY-MM-DD')
        WHEN birthdate LIKE '%-%' THEN
            TO_CHAR(TO_TIMESTAMP(birthdate, 'MM-DD-YY'), 'YYYY-MM-DD')
        ELSE
            NULL
    END;

UPDATE hr
SET birthdate = TO_CHAR(
    CASE
        WHEN TO_DATE(birthdate, 'YYYY-MM-DD') > CURRENT_DATE THEN
            TO_DATE(birthdate, 'YYYY-MM-DD') - INTERVAL '100 years'
        ELSE
            TO_DATE(birthdate, 'YYYY-MM-DD')
    END,
    'YYYY-MM-DD'
);

ALTER TABLE hr
ALTER COLUMN birthdate TYPE DATE
USING TO_DATE(birthdate, 'YYYY-MM-DD');

--- hire_date, unify date YYYY-MM-DD format

UPDATE hr
SET hire_date =
    CASE
        WHEN hire_date LIKE '%/%' THEN
            TO_CHAR(TO_TIMESTAMP(hire_date, 'MM/DD/YY'), 'YYYY-MM-DD')
        WHEN hire_date LIKE '%-%' THEN
            TO_CHAR(TO_TIMESTAMP(hire_date, 'MM-DD-YY'), 'YYYY-MM-DD')
        ELSE
            NULL
    END;
	
UPDATE hr
SET hire_date = TO_CHAR(
    CASE
        WHEN TO_DATE(hire_date, 'YYYY-MM-DD') > CURRENT_DATE THEN
            TO_DATE(hire_date, 'YYYY-MM-DD') - INTERVAL '100 years'
        ELSE
            TO_DATE(hire_date, 'YYYY-MM-DD')
    END,
    'YYYY-MM-DD'
);

ALTER TABLE hr
ALTER COLUMN hire_date TYPE DATE
USING TO_DATE(hire_date, 'YYYY-MM-DD');


UPDATE hr
SET termdate = TO_TIMESTAMP(termdate, 'YYYY-MM-DD HH24:MI:SS')::date
WHERE termdate IS NOT NULL AND termdate != ' ';

ALTER TABLE hr
ALTER COLUMN termdate TYPE DATE
USING TO_DATE(termdate, 'YYYY-MM-DD');

--- Create COLUMN AGE

ALTER TABLE hr ADD COLUMN age INT;

SELECT * FROM hr;

UPDATE hr
SET age = EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate));

SELECT birthdate,age from hr;


SELECT 
	min(age) AS youngest,
    max(age) AS oldest
FROM hr;

SELECT count(*) FROM hr WHERE age < 18;

SELECT COUNT(*) FROM hr WHERE termdate > CURRENT_DATE;

SELECT COUNT(*)
FROM hr
WHERE termdate = '0001-01-01';

SELECT location FROM hr;

DROP table hr;
--ROLLBACK;

