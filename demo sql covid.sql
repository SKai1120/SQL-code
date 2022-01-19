--select *
--from SQLtest..CovidDeath
--order by 3,4

--select *
--from SQLtest..CovidVaccin
--order by 3,4

--Select use data
Select Location, date, total_cases, new_cases, total_deaths, population
from SQLtest..CovidDeath
order by location, date

--Total Cases vs Total Deaths
--Death Percentage 
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercent
from SQLtest..CovidDeath
where location like '%viet%'
order by Location, date

--Total Cases vs Population (%getCovid)
Select location, date, total_cases, population, (total_cases/population)*100 as InfectPercent
from SQLtest..CovidDeath
order by location, date

--Country with highest InfectRate compared to Population
Select Location, population, MAX(total_cases) as HighestInfectCount, MAX((total_cases/population))*100 as PerPopulationInfect
from SQLtest..CovidDeath
group by Location, Population 
order by PerPopulationInfect desc

----Countries w Highest Death Count per Population
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
from SQLtest..CovidDeath
where continent is not NULL
group by Location
order by TotalDeathCount desc

--Highest Death Count per Population by Continent
Select Continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from SQLtest..CovidDeath
where continent is not NULL
group by continent
order by TotalDeathCount desc

--Global numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercent
from SQLtest..CovidDeath
where continent is not NULL

----Total Pop vs Vacc
--with  PopvsVac (Continent, Location, Date, Population, New_Vaccinatons, TotalPplVaccinated)
--as
--(
--select dea.continent, dea.location, dea.date, dea.location, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (PARTITION by dea.location order by dea.location, dea.date) as TotalPplVaccinated
--from SQLtest..CovidDeath dea
--join SQLtest..CovidVaccinations vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not NULL
----order by 2, 3
--)
--select *, (TotalPplVaccinated/population)*100
--from PopvsVac



--Temp table
drop table if exists #VaccinatedbyPopPercent
create table #VaccinatedbyPopPercent
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
TotalPplVaccinated numeric
)
 Insert into #VaccinatedbyPopPercent
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(numeric,vac.new_vaccinations)) over (PARTITION by dea.location order by dea.location, dea.date) as TotalPplVaccinated
from SQLtest..CovidDeath dea
join SQLtest..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not NULL
--order by 2, 3

select *, (TotalPplVaccinated/population)*100
from #VaccinatedbyPopPercent


--Create View for visualization

Create view VaccinatedbyPopPercent as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(numeric,vac.new_vaccinations)) over (PARTITION by dea.location order by dea.location, dea.date) as TotalPplVaccinated
from SQLtest..CovidDeath dea
join SQLtest..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not NULL
--order by 2, 3

select *
from VaccinatedbyPopPercent
