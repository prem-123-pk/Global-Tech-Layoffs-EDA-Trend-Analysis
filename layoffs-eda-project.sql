
USE Layoffs;
CREATE TABLE Layoffs(
	Company INT,
    Location VARCHAR(50),
    Industry VARCHAR(50),
    Total_Laid_off INT,
    Percentage_laid_off INT,
    Date date,
    Stage VARCHAR(50),
    Country VARCHAR(50),
	funds_raised_millions INT
);

SELECT * 
FROM layoffs;


SELECT COUNT(*) AS Total_Rows FROM layoffs;

SELECT
  SUM(company IS NULL) AS company_nulls,
  SUM(location IS NULL) AS location_nulls,
  SUM(industry IS NULL) AS industry_nulls,
  SUM(total_laid_off IS NULL) AS total_laid_off_nulls,
  SUM(percentage_laid_off IS NULL) AS percentage_laid_off_nulls,
  SUM(date IS NULL) AS date_nulls,
  SUM(stage IS NULL) AS stage_nulls,
  SUM(country IS NULL) AS country_nulls,
  SUM(funds_raised_millions IS NULL) AS funds_raised_nulls
FROM layoffs;

SELECT 
	COUNT(DISTINCT company) AS companies,
	COUNT(DISTINCT industry) AS industries,
	COUNT(DISTINCT country) AS countries,
	COUNT(DISTINCT stage) AS stages 
FROM layoffs;

SELECT 
	MIN(date) AS started,
    MAX(date) AS end
FROM layoffs;

SELECT 
  MIN(total_laid_off) AS min_laid_off,
  MAX(total_laid_off) AS max_laid_off,
  AVG(total_laid_off) AS avg_laid_off
FROM layoffs;

SELECT 
	MAX(total_laid_off),
    MAX(percentage_laid_off)
FROM layoffs;

SELECT * 
FROM layoffs
WHERE percentage_laid_off=1
ORDER BY total_laid_off DESC;

SELECT * 
FROM layoffs
WHERE percentage_laid_off=1
ORDER BY funds_raised_millions DESC;

SELECT company,SUM(total_laid_off) 
FROM layoffs
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`) AS layoffs_started_from,
MAX(`date`) AS layoffs_till
FROM layoffs;

SELECT industry, SUM(total_laid_off)
FROM layoffs
GROUP BY industry 
ORDER BY 2 DESC;

-- OR 

SELECT industry, SUM(total_laid_off) AS total_laid_off_sum
FROM layoffs
GROUP BY industry 
ORDER BY total_laid_off_sum DESC;

SELECT country, SUM(total_laid_off) AS total_laid_off_sum
FROM layoffs
GROUP BY country
ORDER BY total_laid_off_sum DESC;

-- 1. Check raw date values (first 10)
SELECT `date`, LENGTH(`date`) as date_length
FROM layoffs 
LIMIT 10;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs
GROUP BY stage
ORDER BY 1 DESC;

SELECT company, AVG(percentage_laid_off)
FROM layoffs
GROUP BY company
ORDER BY 2 DESC;

SELECT 
  SUBSTRING(`date`, 1, 7) AS Month,
  SUM(total_laid_off) AS total_layoffs
FROM layoffs
WHERE  SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY  Month
ORDER BY 1 ASC;

WITH Rolling_total AS (
	SELECT 
		SUBSTRING(`date`, 1, 7) AS `Month`,
		SUM(total_laid_off) AS total_layoffs
	FROM layoffs
	WHERE  SUBSTRING(`date`, 1, 7) IS NOT NULL
	GROUP BY  Month
)

SELECT 
	`Month`,total_layoffs,SUM(total_layoffs) 
	OVER(ORDER BY `Month`) AS rolling_total
	FROM Rolling_total
;

SELECT company,SUM(total_laid_off) 
FROM layoffs 
GROUP BY company 
ORDER BY 2 DESC;


-- SELECT company,YEAR(`date`),SUM(total_laid_off) AS total_layoff
-- FROM layoffs 
-- GROUP BY company,YEAR(`date`)

-- See what's actually in your date column


SELECT company,
       YEAR(STR_TO_DATE(`date`, '%m/%d/%Y')) AS year,
       SUM(total_laid_off) AS total_layoff
FROM layoffs 
GROUP BY company, YEAR(STR_TO_DATE(`date`, '%m/%d/%Y'))
HAVING year IS NOT NULL
ORDER BY year DESC, total_layoff DESC;

SELECT company,
	YEAR(STR_TO_DATE(`date`,'%m/%d/%Y')) AS Years,
    SUM(total_laid_off) AS total_layoff
FROM layoffs
GROUP BY company,YEAR(STR_TO_DATE(`date`,'%m/%d/%Y'))
ORDER BY company ASC;

SELECT 
	Company,
	YEAR(STR_TO_DATE(`date`,'%m/%d/%Y')) AS Years,
    SUM(total_laid_off) AS total_layoff,
	DENSE_RANK() OVER(
		PARTITION by YEAR(STR_TO_DATE(`date`,'%m/%d/%Y')) 
		ORDER BY SUM(total_laid_off) DESC
        ) AS company_rank
FROM layoffs
WHERE YEAR(STR_TO_DATE(`date`,'%m/%d/%Y')) is NOT NULL
GROUP BY company,YEAR(STR_TO_DATE(`date`,'%m/%d/%Y'))
ORDER BY 3 DESC,
company_rank ASC;

    




    

    





