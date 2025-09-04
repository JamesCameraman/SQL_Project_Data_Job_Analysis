-- Case query for locations
SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere'THEN 'Remote'
        WHEN job_location = 'San Jose, CA' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY
    location_category;

-- Case query for salaries
SELECT
    job_id,
    job_title_short,
    job_location,
    salary_year_avg,
    CASE
        WHEN salary_year_avg < 75000 THEN 'Low'
        WHEN salary_year_avg BETWEEN 75000 AND 95000 THEN 'Standard'
        WHEN salary_year_avg > 95000 THEN 'High'
        ELSE 'Below low'
    END AS salary_level
FROM
    job_postings_fact
WHERE 
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC