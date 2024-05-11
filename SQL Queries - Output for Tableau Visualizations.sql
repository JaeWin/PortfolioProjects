-- Queries used for Tableau Project


--1.


select sum(new_cases) as Total_Cases, sum(new_deaths) as Total_Deaths, sum(new_deaths)/nullif(sum(new_cases),0)*100 as DeathPercentage
from dbo.CovidDeaths$
--where location like '%states%'
where continent is not null
--group by date
order by 1,2

-- 2.

--we take these out as they are not included in the above queries and want to stay consistent
-- European Union is part of Europe


Select Location, SUM(cast(total_deaths as bigint)) as TotalDeathCount
from dbo.CovidDeaths$
--where location like '%states%'
where continent is null
and location not in ('World', 'European Union', 'International')
Group by Location
order by TotalDeathCount desc


--3.

Select Location, Population, max(total_cases) as HighestInfectionCount, max((total_cases)/(population))*100 as PercentPopulationInfected
from dbo.CovidDeaths$
Group by Location, population
Order by PercentPopulationInfected desc


--4.

Select Location, Population, date, max(total_cases) as HighestInfectionCount, max((total_cases)/(population))*100 as PercentPopulationInfected
from dbo.CovidDeaths$
Group by Location, population, date
Order by PercentPopulationInfected desc

