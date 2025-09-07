# Introduction
Explore a hypothetical exploration of Data Analyst roles! Gathered before you are insights and data on top paying jobs, hot skills, and their convergence.

SQL queries? Tickle the link here: [project_sql folder](/project_sql/)
# Background
Carried by a irrepressible urge to find a job in data analytics, this project was born by Luke Baroussee and adopted by me. Deliverables include a siphoning of high salaries for top demanded skills.

Courtesty of [SQL Course](https://lukebarousse.com/sql).

### Questions answered through SQL queries below:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?
# Tools I Used
Project includes following key tools:

- **SQL**: Primary tool: used for querying database and parsing data for insights.
- **PostgreSQL**: Database management system. 
- **Visual Studio Code**: My go-to's go-to for datebase management and executing SQL queries.
- **Git & GitHub**: Version control and sharing tools. Mainly for sharing SQL output, collaboration, and project tracking.
# The Analysis
Each query asks and answers a specific question regarding the data analyst job market:
 
### 1. Top Paying Data Analyst Jobs
To find top paying jobs, I filtered job postings for data analyst roles, further filtering by average yearly salary and location. End result highlights high paying job postings at time of search.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    co.name AS company_name,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN
    company_dim AS co ON job_postings_fact.company_id = co.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 
    10;
```
Here's the breakdown of the top data analyst jobs in 2023: 

- **Salaries vary drastically by seniority**
Entry-to-mid level Data Analyst roles (e.g., at UCLA, Motional, Pinterest) range ~$185K–$232K.
Senior titles like Director or Principal Data Analyst command $255K–$650K+.

- **Tech giants vs. niche companies**
Big names (Meta, AT&T) offer high-paying leadership roles ($255K–$336K).
Niche or specialized companies (SmartAsset, Mantys) also pay competitively, in some cases outpacing larger firms (Mantys posted the dataset’s highest salary at $650K).

- **Remote flexibility is now the norm**
Every posting in the sample listed remote positions. These  practices are deeply embedded in 2023’s data job market.

### 2. Skills for Top Paying Jobs
To identify the skills required for our top paying jobs, I combined the job posting results with our skills table and traced all the linked skills tied to our golden geese. 

```sql
WITH top_paying_jobs AS (
SELECT
    job_id,
    job_title,
    salary_year_avg,
    co.name AS company_name
FROM
    job_postings_fact
LEFT JOIN
    company_dim AS co ON job_postings_fact.company_id = co.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 
    10
)

SELECT 
    top_paying_jobs.*,
    skills_dim.skills
FROM top_paying_jobs
INNER JOIN skills_job_dim AS skills_to_job ON top_paying_jobs.job_id = skills_to_job.job_id
INNER JOIN skills_dim ON skills_to_job.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```
Here's the breakdown of the most valuable skills for the top 10 data analyst jobs in 2023: 

- **High pay demands high skill count**
At top salaried positions (Associate Director, Director) companies expect a broad skill range accross programming, cloud, and BI tools. This means a technical, analytical, and business minded applicant to fill such shoes. 

- **Core skills**
Accross all roles a baseline of necessary skills forms around SQL, Python, and visualization tools (Tableau/Power BI/Excel). These three represent the bricks of success in the field. 

### 3. Top Demanded Skills for Data Analysts
To pull the most demanded skills across all data analyst roles, I combined job postings with the skills table before counting up which skills pinged most often. 

```sql
SELECT 
    skills,
    COUNT(skills_to_job.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim AS skills_to_job ON job_postings_fact.job_id = skills_to_job.job_id
INNER JOIN skills_dim ON skills_to_job.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```
Here's the breakdown for top 5 demanded skills for data analysts:

- **SQL is King, Excel is Queen:**
if you want to jump into the field, these two skills represent the bedrock of your job demands. 

- **Programming and visualization tools**
are in high demand for data analysts, represented by Python, Tableau, and Power BI in descending order.

| Skill    | Demand Count |
|----------|--------------|
| SQL      | 7,291        |
| Excel    | 4,611        |
| Python   | 4,330        |
| Tableau  | 3,745        |
| Power BI | 2,609        |

### 4. Top Paying Skills for Data Analysts
To measure the impact each skill has on salary in CA, I grouped the average salary for our job potings by their skills and singled out how much pay is afforded to each skill.

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS average_skill_pay
FROM job_postings_fact
INNER JOIN skills_job_dim AS skills_to_job ON job_postings_fact.job_id = skills_to_job.job_id
INNER JOIN skills_dim ON skills_to_job.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL 
    AND job_location LIKE '%CA%'
GROUP BY
    skills
ORDER BY
    average_skill_pay DESC
LIMIT 25;
```

Here's the breakdown for the highest paying skills:

- **Specialized frameworks and collaborations tools top the list,** 
such as Asana, Scala, and MXNet. There's premium pay in niche learning. 

- **AI/ML libraries and big data tools dominate:**
Keras and PyTorch have a strong demand and salary, averaging $174k and $153k, respectively!

| Skill         | Avg. Salary ($) |
|---------------|-----------------|
| Asana         | 235,000         |
| Scala         | 204,667         |
| MXNet         | 198,000         |
| Node          | 180,000         |
| MongoDB       | 176,362         |
| Keras         | 174,040         |
| Cassandra     | 168,695         |
| DynamoDB      | 165,000         |
| Puppet        | 159,640         |
| Bash          | 159,640         |
| Ansible       | 159,640         |
| PyTorch       | 153,226         |

### 5. Optimal Skills (Demand + Pay) for Data Analaysts
To find the convergence of desirable demand and peak pay, I joined the job postings with the skill table and filtered not only for high average salary, but high job posting counts for all skills. 

```sql
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
```
Here lies the last breakdown, that of optimal skills:

- **Big data and cloud tools are the salary standout**, with Spark, Airflow, and BigQuery all above $120k **with** a respectable demand count. 

- **Core skills remain peak in demand** but with slightly lower average salaries. SQL (419 listings), Python (267), and Tableau (247) dominate demand with respectable average salaries (~$111k–118k). 

| Skill      | Demand Count | Avg. Salary ($) |
|------------|--------------|-----------------|
| Spark      | 21           | 147,856         |
| Express    | 31           | 133,310         |
| Airflow    | 19           | 130,351         |
| Looker     | 35           | 124,256         |
| BigQuery   | 11           | 120,928         |
| Flow       | 32           | 120,703         |
| Redshift   | 16           | 119,248         |
| NoSQL      | 14           | 119,077         |
| Python     | 267          | 118,321         |
| Matlab     | 19           | 116,660         |
| Jira       | 12           | 116,548         |
| Go         | 48           | 115,541         |
| MySQL      | 14           | 114,754         |
| Snowflake  | 36           | 113,770         |
| R          | 157          | 113,692         |
| Tableau    | 247          | 112,822         |
| Java       | 16           | 110,980         |
| SQL        | 419          | 110,899         |
| SSIS       | 13           | 110,824         |
| SAS        | 58           | 110,324         |
| C          | 14           | 108,392         |
| SSRS       | 22           | 106,029         |
| AWS        | 38           | 105,142         |
| Azure      | 35           | 104,245         |

# What I learned

I learned two mini things, to count.

- **Complex Query Creation:** I learned how to SELECT descriptive values, JOIN tables like an architect, and show WHERE insights were hidden by filtering my results.

- **Analytical Asscendence:** garnered real world insights the way a gardener gathers his harvest. Used detailed plotting of values, measuring their impact (skill, demand, location), and reaping an actionable answer for each question asked of my query. 

# Conclusions

### Insights
Overall, these insights are the bounty of my analysis:

1. **Top Paying Data Analyst Jobs:** Even among entry-to-mid level roles data analysts are paid well ($185k-$232k). Upper bound can reach $650k.
2. **Skills for Top Paying Jobs:** High paying jobs require the bedrock of SQL, Python, and Excel. More importantly, many director roles require 10+ skills accross technical, analaytical, and buisness domains. 
3. **Top Demanded Skills for Data Analysts:** The top 5 demanded skills are clearly SQL, Excel, Python, Tableau, and Power BI. Database management, programming and visualization tools are a must. 
4.  **Top Paying Skills for Data Analysts:** Niche and emerging skills around project management tools, AI/ML, and big data offer choice cuts of the average data analyst's salary. 
5. **Optimal Skills (Demand + Pay) for Data Analaysts:** SQL, Python, and Tableau are the trifecta between pay and demand. Those willing to trade some demand or grow as a data analyst can expect higher earning around big data and cloud tools (Spark, Airflow). 

### Closing thoughts

This project sharpened my SQL skills and structured the way I view data. The most bsurd amound of data can become a pristine insight with the proper query. The job market for data analysis is stronger than I expected, with entry-points accross different domains and skills. Finally, the high salaries tied to AI/ML reveal an emerging demand that can be capitalized on while in its infancy. 