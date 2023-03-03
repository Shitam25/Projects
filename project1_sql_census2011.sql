SELECT * FROM project.`sqldata1 - data1`;
SELECT * FROM project.`sqldata2 - sheet1`;

-- Number of rows into dataset

select count(*) from project.`sqldata1 - data1`;
select count(*) from project.`sqldata2 - sheet1`;

-- dataset for jharkhand and bihar

select * from project.`sqldata1 - data1` where state in ('Jharkhand','Bihar');

-- population of India

select sum(Population) from project.`sqldata2 - sheet1`;

-- avg growth

select state,avg(Growth)*100 as avg_growth from project.`sqldata1 - data1` group by state;

-- avg sex ratio

select state,round(avg(sex_ratio),0) as avg_sex_ratio from project.`sqldata1 - data1` group by state order by avg_sex_ratio desc;

-- avg literacy rate

select state,round(avg(literacy),0) as avg_literacy_rate from project.`sqldata1 - data1` group by state 
having round(avg(literacy),0) > 90 order by avg_literacy_rate desc;

-- top 3 state showing highest growth ratio

select state, avg(Growth)*100 as avg_growth from project.`sqldata1 - data1` group by state 
order by avg_growth desc limit 3 ;

-- bottom 3 state showing lowest sex ratio

select state, round(avg(sex_ratio),0) as avg_sex_ratio from project.`sqldata1 - data1` group by state 
order by avg_sex_ratio asc limit 3;

-- top and bottom 3 state in literacy rate

use project;

drop table if exists topstates;
create table topstates (state nvarchar(255), TOPstates float);
insert into topstates
select state,round(avg(literacy),0) as avg_literacy_ratio from project.`sqldata1 - data1` group by state
order by avg_literacy_ratio desc;
select * from topstates limit 3; 
-- bottom
drop table if exists bottomstates;
create table bottomstates (state nvarchar(255), BOTstates float);
insert into bottomstates
select state,round(avg(literacy),0) as avg_literacy_ratio from project.`sqldata1 - data1` group by state
order by avg_literacy_ratio asc;
select * from bottomstates limit 3; 

-- union operator

select * from(
select * from topstates limit 3) as a
union
select * from(
select * from bottomstates limit 3) as b;

-- states starting with letter a

select distinct state from project.`sqldata1 - data1` where state like 'A%' or state like '%d';

-- joining both table
-- (female/male = sex_ratio),(female + male = population),(population/(sex_ratio + 1)...males),(population-population/(sex_ratio + 1)...females)

select d.state,sum(d.males) as total_males,sum(d.females) as total_females from
(select c.district,c.state,round(c.population/(c.sex_ratio-1),0) as males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) as females from
(select a.district,a.state,a.sex_ratio,b.population from project.`sqldata1 - data1` as a inner join project.`sqldata2 - sheet1`
as b on a.district = b.district) c) d group by d.state;

-- total literacy rate
-- (total_literate_people = literacy_ratio * population),(total_iliterate_people = [1 - literacy_ratio] * population)

select c.state,sum(literate_people) as total_literate_pop,sum(iliterate_people) as total_iliterate_pop from
(select d.district,d.state,round(d.literacy_ratio*d.population,0) as literate_people,round((1-d.literacy_ratio)*d.population,0) as iliterate_people from
(select a.district,a.state,(a.literacy)/100 as literacy_ratio, b.population from project.`sqldata1 - data1` as a inner join project.`sqldata2 - sheet1`as b
on a.district = b.district) d) c group by c.state;












