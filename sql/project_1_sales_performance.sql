/* 
Project 1: Shipment Sales Performance Analysis
Author: Roopa Chalasani

Objective:
Analyze shipment sales data to identify top-performing countries, salespersons,
and products using SQL joins, aggregations, subqueries, and window functions.
*/

/* View sample data */
select * from shipments limit 10;
select * from geo limit 10;
select * from products limit 10;
select * from people limit 10;


/* Query 1: Total Sales by Country */
select 
    g.Geo,
    sum(s.Amount) as Total_Sales
from shipments s
join geo g on s.Geo = g.GeoID
group by g.Geo
order by Total_Sales desc;


/* Query 2: Salesperson with the Highest Total Sales */
select 
    p.`Sales Person`,
    sum(s.Amount) as Total_Sales
from shipments s
join people p on p.`SP ID` = s.`Sales Person`
group by p.`Sales Person`
order by Total_Sales desc
limit 1;


/* Query 3: Top Product in Each Country */
select *
from (
    select 
        g.Geo,
        pr.Product,
        sum(s.Amount) as Total_Sales,
        row_number() over (
            partition by g.Geo 
            order by sum(s.Amount) desc
        ) as rn
    from shipments s
    join products pr on pr.`Product ID` = s.Product
    join geo g on g.GeoID = s.Geo
    group by g.Geo, pr.Product
) t
where rn = 1;


/* Query 4: Countries with Above-Average Total Sales */
select 
    g.Geo,
    sum(s.Amount) as Total_Sales
from shipments s
join geo g on g.GeoID = s.Geo
group by g.Geo
having sum(s.Amount) > (
    select avg(total_sales)
    from (
        select 
            Geo,
            sum(Amount) as total_sales
        from shipments
        group by Geo
    ) t
)
order by Total_Sales desc;
