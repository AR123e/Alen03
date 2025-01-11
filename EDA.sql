select * from world_layoffs.layoffs;
-- Things to be done in this Project
-- Remove Duplicates
-- Standardize data
-- Remove any columns
-- Null values or blank Values
use world_layoffs;
create table layoff_staging like world_layoffs.layoffs;

insert into layoff_staging select * from world_layoffs.layoffs;

select * from layoff_staging;

with CTE1 as(
select * ,row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num from layoff_staging
)select * from CTE1 where row_num>1;


CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `rownum` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoff_staging2 select * ,row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num from layoff_staging;

select * from layoff_staging2;

delete from layoff_staging2 where rownum>1;

select * from layoff_staging2;
-- select distinct *,row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num from layoffs;

-- Standardizing Data
update layoff_staging2 set company=trim(company);

update layoff_staging2 set industry='Crypto' where industry like'Crypto%';

select distinct industry from layoff_staging2;

update layoff_staging2 set country=trim(trailing '.' from country) where country like "United States%" ;

select distinct country from layoff_staging2 order by 1;

update layoff_staging2 set `date` = str_to_date(`date`,'%m/%d/%Y');

select `date` from layoff_staging2;

alter table layoff_staging2 modify column `date` date;

update layoff_staging2 set industry = NULL where industry='';
 
select t1.industry,t2.industry from layoff_staging2 t1 join layoff_staging2 t2 on t1.company=t2.company where (t1.industry is null or t1.industry='') and t2.industry is not null;

select company from layoff_staging2 where industry is null;

update layoff_staging2 t1 join layoff_staging2 t2 on t1.company=t2.company set t1.industry=t2.industry where (t1.industry is null or t1.industry='') and t2.industry is not null;

select * from layoff_staging2 where total_laid_off is null and percentage_laid_off is null;

delete from layoff_staging2 where total_laid_off is null and percentage_laid_off is null;

alter table layoff_staging2 drop column rownum;

select * from layoff_staging2;


-- EDA (Exlpoaratory Data Analysis)

use world_layoffs;

select * from layoff_staging2;

select max(total_laid_off) as Highest_Layoffs,max(percentage_laid_off) as Highest_layoff_percentage from layoff_staging2;

select * from layoff_staging2 where total_laid_off = 12000; 

select company, sum(total_laid_off) as Total_Layoffs from layoff_staging2 group by company order by 2 desc;

select industry, sum(total_laid_off) as Total_Layoffs from layoff_staging2 group by industry order by 2 desc;

select min(`date`) as Layoff_start_date,max(`date`) as Layoff_end_date from layoff_staging2;

select country, sum(total_laid_off) as Total_Layoffs from layoff_staging2 group by country order by 2 desc;

select year(`date`) as Year, sum(total_laid_off) as Total_Layoffs from layoff_staging2 group by Year order by 1 desc;

select stage, sum(total_laid_off) as Total_Layoffs from layoff_staging2 group by stage order by 2 desc;

select substring(`date`,1,7) as Months, sum(Total_laid_off) as Total_Layoffs from layoff_staging2 where substring(`date`,1,7) is not null  group by Months order by 1 asc;

with Rolling_Total as
(
select substring(`date`,1,7) as Months, sum(Total_laid_off) as Total_Layoffs from layoff_staging2 where substring(`date`,1,7) is not null  group by Months order by 1 asc
)
select Months,Total_Layoffs,sum(Total_Layoffs) over(order by Months) as rolling_total from Rolling_Total;

select company, year(`date`) as Year,sum(total_laid_off) as Total_Layoffs from layoff_staging2 group by company;

with Company_year(company,years,Total_layoffs) as
(
select company, year(`date`),sum(total_laid_off) from layoff_staging2 group by company,year(`date`)
),Company_Year_Rank as
(
select *,dense_rank() over(partition by years order by Total_layoffs desc) as Ranking from Company_year where years is not null order by Ranking asc
)select * from Company_Year_Rank where Ranking<=5;
