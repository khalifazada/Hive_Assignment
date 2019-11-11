CREATE DATABASE enhanceit
LOCATION '/enhance_dbs';

USE enhanceit;

CREATE EXTERNAL TABLE engineers(id INT, first_name STRING, last_name STRING, age INT, city STRING, country STRING, salary FLOAT, department INT)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
STORED AS TEXTFILE
LOCATION '/enhance_dbs/engineers';

CREATE EXTERNAL TABLE managers
LIKE engineers
LOCATION '/enhance_dbs/managers';

CREATE EXTERNAL TABLE departments(
id INT,
name STRING)
LOCATION '/enhance_dbs/departments';

LOAD DATA LOCAL INPATH '/home/maria_dev/hive_assignment/values.csv' OVERWRITE INTO TABLE engineers;

INSERT INTO managers
VALUES	(1, "Olson", "Dimanche", 25, "Atlanta", "USA", 45748776.0, 1);

INSERT INTO departments
VALUES	(1, "BigData");

ALTER TABLE engineers
ADD COLUMNS (hire_date DATE, renewal_date DATE);

--Comment UPDATE engineers 
--Comment SET hire_date = "2019-10-29",
--Comment renewal_date = DATE_ADD(ADD_MONTHS("2019-10-29", 12), 0);

INSERT OVERWRITE TABLE engineers SELECT
id, 
first_name, 
last_name, 
city, 
country, 
salary, 
department, 
coalesce(hire_date, date'2019-10-29') as hire_date, 
coalesce(renewal_date, cast(DATE_ADD(ADD_MONTHS('2019-10-29', 12),0) as date)) as renewal_date
FROM engineers;

--Comment cast(to_date(from_unixtime(unix_timestamp('05-06-2018', 'dd-MM-yyyy'))) as date)
