-- Average % of workforce laid off per company, by industry (company count included to flag small sample sizes)
SELECT industry,
AVG(percentage_laid_off) AS avg_pct_laid_off,
COUNT(*) AS companies
FROM layoffs_staging2
WHERE percentage_laid_off IS NOT NULL
GROUP BY industry
ORDER BY avg_pct_laid_off DESC;

-- Full company shutdowns (100% of staff laid off), grouped by industry and funding stage
SELECT industry,
stage,
COUNT(*) AS companies_shut_down
FROM layoffs_staging2
WHERE percentage_laid_off = 1
GROUP BY industry, stage
ORDER BY companies_shut_down DESC;
