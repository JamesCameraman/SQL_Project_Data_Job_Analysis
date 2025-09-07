/*
Answer: What are the most optimal skills to learn (high demand + high pay)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles.
- Concentrates on remote & CA positions with specified salaries.
-Why? Targets skills that offer job security and financial incentives, 
    offering strategic insights for career development in data analystics 
*/ 

-- rewrite for brevity with expanded search
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(salary_year_avg), 0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL 
    AND job_location LIKE '%CA%'
GROUP BY
    skills_dim.skill_id
HAVING 
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    average_salary DESC,
    demand_count DESC
LIMIT 25;

-- old-write for posterity

WITH skills_demand AS (
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_to_job.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim AS skills_to_job ON job_postings_fact.job_id = skills_to_job.job_id
INNER JOIN skills_dim ON skills_to_job.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL 
    AND job_location LIKE '%CA%'
GROUP BY
    skills_dim.skill_id
), average_salary AS (
SELECT 
    skills_to_job.skill_id,
    ROUND(AVG(salary_year_avg), 0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim AS skills_to_job ON job_postings_fact.job_id = skills_to_job.job_id
INNER JOIN skills_dim ON skills_to_job.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL 
    AND job_location LIKE '%CA%'
GROUP BY
    skills_to_job.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    average_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id 
WHERE
    demand_count > 50
ORDER BY
    average_salary DESC,
    demand_count DESC
LIMIT 25;