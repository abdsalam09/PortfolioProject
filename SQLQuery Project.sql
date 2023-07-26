
select *
from [Portofolio Project]..CovidDeath
order by 3,4

--select *
--from [Portofolio Project]..CovidVaccination
--order by 3,4

--Select Data that we are using

select Location, date, total_cases, new_cases, total_deaths, population
from [Portofolio Project]..CovidDeath
order by 1,2

--Total Cases vs Total Deaths

select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPescentage
from [Portofolio Project]..CovidDeath
where location like '%Indonesia%'
order by 1,2

-- Looking at Total Cases vs Population
-- Show what percentage got Covid
select Location, date, population, total_cases, (total_cases/population)*100 as CasesPescentage
from [Portofolio Project]..CovidDeath
where location like '%Indonesia%'
order by date

--Looking at Countries with Highest infection Rate 

select Location, population, max(total_cases) as MaxCases, max((total_cases/population))*100 as PercentPopulationInfected
from [Portofolio Project]..CovidDeath
Group by location, population
order by PercentPopulationInfected desc

-- Looking Countries with Highest Death Count per Population

select Location, max(cast(total_deaths as int)) as TotalDeathCount 
from [Portofolio Project]..CovidDeath
where continent is not null
Group by location
order by TotalDeathCount desc

-- Break down thing by continent

select continent, max(cast(total_deaths as int)) as TotalDeathCount 
from [Portofolio Project]..CovidDeath
where continent is not null
Group by continent
order by TotalDeathCount desc


--Showing Continents with highest death per population

select continent, max(cast(total_deaths as int)) as TotalDeathCount 
from [Portofolio Project]..CovidDeath
where continent is not null
Group by continent
order by TotalDeathCount desc

--Total Population vs Vaccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVac
from [Portofolio Project]..CovidDeath dea
join [Portofolio Project]..CovidVaccination vac
	on dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not null
order by 2,3


--Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVac numeric
)

Insert into #PercentPopulationVaccinated

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVac
from [Portofolio Project]..CovidDeath dea
join [Portofolio Project]..CovidVaccination vac
	on dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not null
order by 2,3

Select *, (RollingPeopleVac/Population)*100
from #PercentPopulationVaccinated


--Create View to store data visualization

Create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVac
from [Portofolio Project]..CovidDeath dea
join [Portofolio Project]..CovidVaccination vac
	on dea.location = vac.location
	and dea.date =vac.date
where dea.continent is not null
--order by 2,3

Select *
from PercentPopulationVaccinated