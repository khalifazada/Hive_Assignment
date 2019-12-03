CREATE DATABASE enhanceit
LOCATION '/enhance_dbs';

USE enhanceit;

CREATE EXTERNAL TABLE engineers(id INT, first_name STRING, last_name STRING, age INT, city STRING, country STRING, salary FLOAT, department_id INT, hire_date STRING, renewal_date STRING, manager_id INT)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
STORED AS TEXTFILE
LOCATION '/enhance_dbs/engineers';

CREATE EXTERNAL TABLE managers(id INT, first_name STRING, last_name STRING, age INT, city STRING, country STRING, salary FLOAT, department_id INT)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
STORED AS TEXTFILE
LOCATION '/enhance_dbs/managers';

CREATE EXTERNAL TABLE departments(id INT, name STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
STORED AS TEXTFILE
LOCATION '/enhance_dbs/departments';

LOAD DATA LOCAL INPATH './data/engineers.csv' OVERWRITE INTO TABLE engineers;

LOAD DATA LOCAL INPATH './data/managers.csv' OVERWRITE INTO TABLE managers;

LOAD DATA LOCAL INPATH './data/departments.csv' OVERWRITE INTO TABLE departments;

--Comment	********************* ASSIGNMENT *********************

--Comment	1. Highest paid manager by department

--Comment	*** QUERY ***

SELECT
result.first_name,
result.salary,
result.name
FROM (
SELECT 
managers.first_name,
managers.salary,
departments.name,
RANK() OVER (PARTITION BY departments.id ORDER BY managers.salary DESC) salary_rank
FROM 
managers 
JOIN departments on managers.department_id = departments.id
) result
WHERE salary_rank = 1;

--Comment	*** RESULT ***

--Comment	JD	87000	Big Data
--Comment	Jacob	85000	Data Science
--Comment	John	78000	Cyber Security
--Comment	David	71000	Android
--Comment	Juliet	83000	iOS
--Comment	Oscar	86000	Exchange

--Comment	2. Find top 3 lowest paid managers

--Comment	*** QUERY ***	

SELECT
managers.first_name,
managers.salary
FROM managers
ORDER BY managers.salary ASC
LIMIT 3;

--Comment	*** RESULT***

--Comment	David	71000
--Comment	Jake	75000
--Comment	Jeremie	77000

--Comment	3. Find top 3 highest paid managers

--Comment	*** QUERY ***

SELECT
managers.first_name,
managers.salary
FROM managers
ORDER BY managers.salary DESC
LIMIT 3;

--Comment	*** RESULT ***
	
--Comment	JD	87000
--Comment	Oscar	86000
--Comment	Jacob	85000

--Comment	4. Find top 2 highest paid engineers

--Comment	*** QUERY ***

SELECT
engineers.first_name,
engineers.salary
FROM engineers
ORDER BY engineers.salary DESC
LIMIT 2;

--Comment	*** RESULT ***

--Comment	Adam	70000
--Comment	Asad	70000

--Comment	5. Highest paid employee by manager

--Comment	*** QUERY ***
	
SELECT
engineer_name,
salary,
manager_name
FROM (
SELECT
engineers.first_name AS engineer_name,
engineers.salary,
managers.first_name AS manager_name,
RANK() OVER (PARTITION BY engineers.manager_id ORDER BY engineers.salary DESC) salary_rank
FROM
engineers
JOIN managers ON managers.id=engineers.manager_id
) result
WHERE
salary_rank = 1;

--Comment	*** RESULT ***

--Comment	Kirby	65000	JD
--Comment	Mike	60000	Jake
--Comment	Chris	67000	Izreal
--Comment	Adam	70000	Jacob
--Comment	Christian	66000	Juliet
--Comment	Alex	61000	Oscar
--Comment	Maria	60000	David
--Comment	Cassandra	67000	Jeremie
--Comment	Eve	62000	Blue
--Comment	Asad	70000	John

