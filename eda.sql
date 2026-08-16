SELECT * FROM world_layoffs.layoffs_staging2;

-- Overview stats

-- Largest single layoff event recorded
SELECT 
MAX(total_laid_off)
FROM world_layoffs.layoffs_staging2;

-- Companies where percentage_laid_off = 1 shut down entirely
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1;
-- Most of these appear to be startups that closed during this period

-- Ordering by funds raised shows which of these shutdowns were the most heavily funded companies
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;



-- Aggregate totals (GROUP BY)

-- Companies with the biggest single-day layoff event
SELECT company, total_laid_off
FROM world_layoffs.layoffs_staging
ORDER BY total_laid_off DESC
LIMIT 5;

-- Companies with the highest total layoffs across the full dataset
SELECT company,
SUM(total_laid_off) AS total
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY total DESC
LIMIT 10;

-- By location
SELECT location,
SUM(total_laid_off) AS total
FROM world_layoffs.layoffs_staging2
GROUP BY location
ORDER BY total DESC
LIMIT 10;

-- By country
SELECT country,
SUM(total_laid_off) AS total
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY total DESC;

-- By year
SELECT YEAR(date) AS year,
SUM(total_laid_off) AS total
FROM world_layoffs.layoffs_staging2
GROUP BY year
ORDER BY year ASC;

-- By industry
SELECT industry,
 SUM(total_laid_off) AS total
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY total DESC;

-- By funding stage
SELECT stage, 
SUM(total_laid_off) AS total
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY total DESC;


-- Top companies per year (CTE + DENSE_RANK)

-- Top 3 companies by total layoffs, within each year
WITH Company_Year AS (
    SELECT company, 
    YEAR(date) AS year,
    SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    GROUP BY company, YEAR(date)
),

Company_Year_Rank AS (
    SELECT company, year, total_laid_off,
           DENSE_RANK() 
           OVER (PARTITION BY year ORDER BY total_laid_off DESC) 
           AS ranking
    FROM Company_Year
)
SELECT company, year, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
  AND year IS NOT NULL
ORDER BY year ASC, total_laid_off DESC;


-- Rolling monthly total (window function)

-- Total layoffs per month
SELECT 
SUBSTRING(date, 1, 7) AS month,
SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY month
ORDER BY month ASC;

-- Rolling total of layoffs over time
WITH Monthly_Totals AS (
    SELECT
    SUBSTRING(date, 1, 7) AS month,
    SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    GROUP BY month
    ORDER BY month ASC
)
SELECT month,
SUM(total_laid_off)
OVER (ORDER BY month ASC) AS rolling_total_layoffs
FROM Monthly_Totals
ORDER BY month ASC;



-- Key summary figures (for my git README)

-- Total layoffs across the full cleaned dataset
SELECT SUM(total_laid_off) FROM layoffs_staging2;

-- Top 3 industries by total laid off
SELECT industry,
SUM(total_laid_off) AS total
FROM layoffs_staging2
GROUP BY industry
ORDER BY total DESC
LIMIT 3;

-- Top 3 funding stages by total laid off
SELECT stage,
SUM(total_laid_off) AS total
FROM layoffs_staging2
GROUP BY stage
ORDER BY total DESC
LIMIT 3;

-- Single peak month for layoffs
SELECT 
DATE_FORMAT(date, '%Y-%m') AS month,
SUM(total_laid_off) AS total
FROM layoffs_staging2
GROUP BY month
ORDER BY total DESC
LIMIT 1;