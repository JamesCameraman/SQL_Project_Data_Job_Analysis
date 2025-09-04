SELECT *
FROM ( -- SubQuery begins
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(Month FROM job_posted_date) = 1
    ) AS january_jobs;
    -- SubQuery fin

-- CTE
WITH january_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(Month FROM job_posted_date) = 1
)

SELECT *
FROM january_jobs;

-- SubQuery for jobs without degree mention
SELECT 
    company_id,
    name AS company_name
FROM 
    company_dim
WHERE 
    company_id IN (
        SELECT
            company_id
        FROM
            job_postings_fact
        WHERE
            job_no_degree_mention = TRUE
        ORDER BY
            company_id
);

/*
Find the companies that have the most job openings.
- Get the total number of job postings per company id (job_posting_fact)
- Return the total number of jobs with the company name (company_dim)
*/

WITH job_postings AS (
    SELECT 
        company_id,
        COUNT(*) AS total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

SELECT
    company_dim.name AS company_name,
    job_postings.total_jobs
FROM
    company_dim 
LEFT JOIN job_postings ON job_postings.company_id = company_dim.company_id
ORDER BY
    total_jobs DESC

