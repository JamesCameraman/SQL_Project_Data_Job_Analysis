SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    january_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM march_jobs



-- Get corresponding skill and skill type for each job posting in q1
-- Include those without any skills
-- 

SELECT
    jp.job_id
FROM    
    job_postings_fact AS jp
LEFT JOIN skills_job_dim AS skills_to_job ON skills_to_job.job_id = jp.job_id