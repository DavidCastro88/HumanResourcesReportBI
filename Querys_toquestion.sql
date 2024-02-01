-- QUESTIONS
SELECT * FROM hr;

-- 1. What is the gender breakdown of employees in the company?
SELECT gender, COUNT(*) AS count
FROM hr
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, COUNT(*) AS count
FROM hr
GROUP BY race
ORDER BY count DESC;

-- 3. What is the age distribution of employees in the company?
SELECT age, COUNT(*) AS count
FROM hr
GROUP by age
ORDER BY age ASC;

SELECT 
	CASE
		WHEN age>=20 AND age<=25 THEN '20-25'
		WHEN age>=26 AND age<=32 THEN '26-32'
		WHEN age>=33 AND age<=40 THEN '33-40'
		WHEN age>=41 AND age<=48 THEN '41-48'
		ELSE '48+'
	END AS age_interval,
	count(*) AS count
FROM hr
GROUP BY age_interval
ORDER BY age_interval;

SELECT 
	CASE
		WHEN age>=20 AND age<=25 THEN '20-25'
		WHEN age>=26 AND age<=32 THEN '26-32'
		WHEN age>=33 AND age<=40 THEN '33-40'
		WHEN age>=41 AND age<=48 THEN '41-48'
		ELSE '48+'
	END AS age_interval,gender,
	count(*) AS count
FROM hr
GROUP BY age_interval,gender
ORDER BY age_interval,gender;

-- 4. How many employees work at headquarters versus remote locations?
SELECT location, COUNT(*) AS type_location
FROM hr
GROUP BY location
ORDER BY type_location;

-- 5. What is the average length of employment for employees who have been terminated?

SELECT 
	ROUND(AVG(termdate - hire_date)/365,1) AS avg_length_employment
FROM hr
	WHERE termdate<=CURRENT_DATE AND termdate IS NOT NULL;
;

-- 6. How does the gender distribution vary across departments and job titles?

SELECT department,gender, COUNT(*) AS count
FROM hr
GROUP BY department,gender
ORDER BY department,count ASC;

SELECT jobtitle,gender, COUNT(*) AS count
FROM hr
GROUP BY jobtitle,gender
ORDER BY jobtitle,count ASC;

-- 7. What is the distribution of job titles across the company?

SELECT jobtitle, COUNT(*) AS count
FROM hr
GROUP BY jobtitle
ORDER BY count DESC;

-- 8. Which department has the highest turnover rate?
SELECT 
    department,
    total_count,
    terminated_count,
    ROUND(CAST(terminated_count AS DECIMAL) / total_count, 3) AS termination_rate
FROM (
    SELECT 
        department,
        COUNT(*) AS total_count,
        SUM(CASE WHEN termdate IS NOT NULL AND termdate <= CURRENT_DATE THEN 1 ELSE 0 END) AS terminated_count
    FROM hr
    GROUP BY department
) AS subquery
ORDER BY termination_rate DESC;

-- 9. What is the distribution of employees across locations by city and state?
SELECT location_city,COUNT(*) count
FROM hr
GROUP BY location_city
ORDER BY count DESC;

SELECT location_state,COUNT(*) count
FROM hr
GROUP BY location_state
ORDER BY count DESC;

-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT
	year,
	hires,
	terminations,
	hires - terminations AS net_change,
	round(cast(hires-terminations as decimal)/hires*100,2) AS net_change_percent
FROM (
	SELECT 
		EXTRACT (YEAR FROM hire_date) AS year,
		count(*) as hires,
		SUM(
			CASE 
			WHEN termdate IS NOT NULL AND termdate <=CURRENT_DATE THEN 1 ELSE 0 END)AS terminations
	FROM hr
	GROUP BY EXTRACT (YEAR FROM hire_date)
)AS subquery
ORDER BY year ASC;

-- 11. What is the tenure distribution for each department?
SELECT 
	department,ROUND(AVG(termdate-hire_date)/365,2) as avg_tenure
FROM hr
WHERE termdate<=CURRENT_DATE AND termdate IS NOT NULL
GROUP BY department;