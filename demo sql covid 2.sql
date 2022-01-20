--prepare data query and table for later visualization
 
 --Global numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercent
from SQLtest..CovidDeath
where continent is not NULL
order by 1, 2 


--data filter and queries 
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
from SQLtest..CovidDeath
where continent is NULL
and location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Low income', 'Lower middle income')
Group by location
order by TotalDeathCount desc


--Country w highest InfectRate compared to Population
Select Location, population, MAX(total_cases) as HighestInfectCount, MAX((total_cases/population))*100 as PerPopulationInfect
from SQLtest..CovidDeath
group by Location, Population 
order by PerPopulationInfect desc


Select Location, population, Date, MAX(total_cases) as HighestInfectCount, MAX((total_cases/population))*100 as PerPopulationInfect
from SQLtest..CovidDeath
group by Location, Population, date
order by PerPopulationInfect desc
