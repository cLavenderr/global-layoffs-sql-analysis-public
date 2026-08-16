# Global Layoffs Data Analysis

![Logo](https://cdn.phototourl.com/free/2026-07-30-d262be37-3d57-4c04-9155-a3c6b6a6798c.jpg)

---

## 1. Executive Summary

This project builds an end to end data pipeline in MySQL to import, clean, and analyse a global layoffs dataset covering 383,659 recorded layoffs across companies of all sizes and funding stages. Duplicate and dirty records were identified and removed using CTEs and window functions. The cleaned data was used to analyse downsizing of industries and their funding stages within certain time periods.

This project was initially completed following a tutorial by Alex The Analyst to build hands on proficiency in SQL data cleaning and window functions. Building on the tutorial I furthered the analysis by comparing the average % of workforce laid off against the layoff totals and also looked at which industries and funding stages had companies face complete shutdown. 
## 2. Business Problem

To make properly informed company decisions such as hiring priority, investors, HR analysts and managers need to understand where and why layoffs are concentrated as the company continues to develop over time. Raw workforce datasets are typically messy with duplicate records, inconsistent text formatting, and poorly structured dates, making trend analysis unreliable without first properly cleaning the data.


## 3. Methodology

- Designed an end to end data pipeline in MySQL to import, clean, and structure raw data ready for analysis
- Enforced database integrity by using CTEs combined with ROW_NUMBER() window functions to identify and remove duplicate records. 
- Standardised inconsistent text fields using TRIM, and corrected poorly formatted dates using STR_TO_DATE
- Analysed corporate downsizing trends by funding stage and industry, using PARTITION BY() and DENSE_RANK() to calculate monthly rolling totals and rank trends over time
- Extended the analysis by calculating the average percentage of workface lay offs per company by industry (AVG()) and by counting full company shutdowns (100% layoff) grouped by industry and funding stage (GROUP BY)

## 4. Skills Demonstrated

MySQL: General SQL, CTEs, Window Functions, ROW_NUMBER(), DENSE_RANK(), PARITION_BY(), GROUP_BY(), Data Cleaning and Trend Analysis
## 5. Results & Business Recommendation

**Results:**
- Upon cleaning of the dataset, records decreased from 2,361 to 1,995, a reduction of 15.5%. 
- Analysed 383,659 total layoffs across the dataset's full time span.
- Consumer, Retail, and Other were the three hardest hit industries, together accounting for 125,084 layoffs which is 32.6% of the overall layoffs made.
- Post-IPO companies alone accounted for 204,132 layoffs which is 53% of all layoffs. Showing downsizing was concentrated overwhelmingly in well established public companies rather than early stage startups.
- January 2023 was the single peak month for layoffs, with 84,714 layoffs occurring in that one month alone, this accounted for 22% of the entire dataset.
- Going by the percentage of lay offs whilst taking sample size (n) into consideration, Education (35.7% n=54), Travel (34.9% n=44) and Real Estate (31.7% n=78) saw the most layoffs when compared to other companies. Aerospace had the largest percentage at 56.5% however it only has 4 companies.
- Complete shutdowns of companies (100% lay offs) were primarily in Seed and Unknown stage companies. Despite being 53% of layoff volume, Post-IPO companies remained open with their layoffs being large scale reductions as opposed to full shutdowns.


<p align="center">
  <img src="https://cdn.phototourl.com/free/2026-07-30-9784770c-a11b-4e41-bd05-855f6a5a1ed7.png"/>
</p>


**Recommendation:**
Because Post-IPO companies held 53% of total layoff volume, risk analysts should weight funding stage as heavily as industry when assessing downsizing. However layoff totals alone can be misleading, Post-IPO layoffs were mostly large scale reductions at companies that remained open, whilst actual shutdowns were concentrated in Seed and Unknown stage companies. A better approach would separate how many people a company laid off from how likely it is to shutdown entirely, the data here shows they aren't the same. The January 2023 spike also suggests a seasonal/annual budget cycle which may be worth investigating further, as a single month accounted for over a fifth of layoff volume. Analysts could continue to use this pipeline to flag similar concentration risks as new data comes in month by month. 

## 6. Next Steps

- Build a dashboard using the cleaned dataset for non technical stakeholders to easily observe trends and make informed decisions. 
- Collect further data for additional variables (company size, headcount, salaries) to refine the trend analysis
- Automate the pipeline so new monthly data is cleaned and ranked without manual script updates.



