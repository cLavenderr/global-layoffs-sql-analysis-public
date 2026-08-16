
SELECT * 
FROM world_layoffs.layoffs;

CREATE TABLE world_layoffs.layoffs_staging 
LIKE world_layoffs.layoffs;

INSERT INTO world_layoffs.layoffs_staging 
SELECT * FROM world_layoffs.layoffs;


-- Data Cleaning
-- Remove Duplicates
-- Standardise Data( Errors/Null Values)
-- Remove Junk Columns/Rows


-- Removing Duplicates

-- Uses a window function, assigns a row number to each partition/record based on every column matching, duplicates will show a row_num > 1, can then be deleted
SELECT *
FROM (
    SELECT 
        company, location, industry, total_laid_off, percentage_laid_off, 
        `date`, stage, country, funds_raised_millions,
        ROW_NUMBER() OVER (
            PARTITION BY company, location, industry, total_laid_off, 
                         percentage_laid_off, `date`, stage, country, funds_raised_millions
        ) AS row_num
    FROM world_layoffs.layoffs_staging
) duplicates
WHERE row_num > 1;


CREATE TABLE `world_layoffs`.`layoffs_staging2` (
    `company` TEXT,
    `location` TEXT,
    `industry` TEXT,
    `total_laid_off` INT,
    `percentage_laid_off` TEXT,
    `date` TEXT,
    `stage` TEXT,
    `country` TEXT,
    `funds_raised_millions` INT,
    row_num INT
);

INSERT INTO `world_layoffs`.`layoffs_staging2`
(`company`, `location`, `industry`, `total_laid_off`, `percentage_laid_off`, 
 `date`, `stage`, `country`, `funds_raised_millions`, `row_num`)
SELECT 
    `company`, `location`, `industry`, `total_laid_off`, `percentage_laid_off`, 
    `date`, `stage`, `country`, `funds_raised_millions`,
    ROW_NUMBER() OVER (
        PARTITION BY company, location, industry, total_laid_off, 
                     percentage_laid_off, `date`, stage, country, funds_raised_millions
    ) AS row_num
FROM world_layoffs.layoffs_staging;

DELETE FROM world_layoffs.layoffs_staging2
WHERE row_num >= 2;


-- Standardising Data

-- Blanks/Nulls
SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
ORDER BY industry;

-- Convert blank strings to NULLs, easier to work with
UPDATE world_layoffs.layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Backfill missing company records using a self join to find the missing data by using a copy of itself (t1.company and t2.company)
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

-- Industry has many variants of "Crypto", standardise
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry IN ('Crypto Currency', 'CryptoCurrency');

-- Strip trailing punctuation
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);

-- Date was stored as text (MM/DD/YYYY) - convert to a proper DATE type (Used American Date Format as dataset was American, may change to English in future)
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;



-- Junk Rows and Columns 

-- Rows with no layoff figure at all have no usable information (for this analysis) so can be removed
DELETE FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

-- Drop the helper column now that we have removed duplicates
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT * 
FROM world_layoffs.layoffs_staging2;