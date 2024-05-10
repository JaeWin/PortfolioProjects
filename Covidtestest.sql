Select *
From dbo.CovidDeaths$
where continent is not null
order by 3,4;


Select *
from dbo.CovidVaccinations$
Order by 3,4;




Select Location, date, total_cases, new_cases, total_deaths, population
from dbo.CovidDeaths$
Order by 1,2;


-- Total cases vs Total Deaths

Select Location, date, total_cases, total_deaths, (total_deaths)/cast(total_cases as float)*100 as DeathPercentage
from dbo.CovidDeaths$
Where location like '%states%'
Order by 1,2;

Select Location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
from dbo.CovidDeaths$
Where location like 'Vietnam'
Order by 1,2;


-- total cases vs total population
-- percentage of population got covid

Select Location, date, total_cases, population, (cast(total_cases as float)/cast(population as float))*100 as CasesPercentage
from dbo.CovidDeaths$
Where location like '%states%'
Order by 1,2;



Select Location, date, total_cases, population, (cast(total_cases as float)/cast(population as float))*100 as CasesPercentage
from dbo.CovidDeaths$
Where location like 'Vietnam'
Order by 1,2;

-- countries with highest infection rate compared to population
-- changed column type to float

Select Location, population, max(total_cases) as HighestInfectionCount, max((total_cases)/(population))*100 as CasesPercentage
from dbo.CovidDeaths$
Group by Location, population
Order by 1,2;

Select Location, population, max(total_cases) as HighestInfectionCount, max((total_cases)/(population))*100 as CasesPercentage
from dbo.CovidDeaths$
Group by Location, population
order by CasesPercentage desc


-- countries with highest death count per population

Select Location, max(total_deaths) as TotalDeathCount
from dbo.CovidDeaths$
where continent is not null
Group by Location
order by population desc

Select Location, population, max(total_deaths) as TotalDeathCount
from dbo.CovidDeaths$
where continent is not null
Group by Location, population
order by population desc


-- break things down by continent
--maybe create view for this
Select continent, max(total_deaths) as TotalDeathCount
from dbo.CovidDeaths$
where continent is not null
Group by continent
order by TotalDeathCount desc




--global numbers


select sum(new_cases) as Total_Cases, sum(new_deaths) as Total_Deaths, sum(new_deaths)/nullif(sum(new_cases),0)*100 as DeathPercentage
from dbo.CovidDeaths$
where continent is not null
--group by date
order by 1,2


--total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From dbo.CovidDeaths$ dea
JOIN dbo.CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- USE CTE

With PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
	dea.Date) as RollingPeopleVaccinated
From dbo.CovidDeaths$ dea
Join dbo.CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac





--temp table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From dbo.CovidDeaths$ dea
JOIN dbo.CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Create View to store data for later visualizations


Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From dbo.CovidDeaths$ dea
JOIN dbo.CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
FROM PercentPopulationVaccinated