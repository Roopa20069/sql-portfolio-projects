/* 
Project 2: Shipment Risk and Anomaly Detection
Author: Roopa Chalasani

Objective:
Analyze shipment data to identify high-value shipments, above-average activity,
and unusual salesperson/product/country patterns using SQL.
*/

/* Query 1: High-Value Shipments */
select 
    p.`Sales Person`,
    g.Geo,
    pr.Product,
    s.Date,
    s.Amount,
    s.Boxes
from shipments s
join people p on p.`SP ID` = s.`Sales Person`
join geo g on g.GeoID = s.Geo
join products pr on pr.`Product ID` = s.Product
where s.Amount > (
    select avg(Amount)
    from shipments
)
order by s.Amount desc;


/* Query 2: Salespersons with Above-Average Shipment Count */
select 
    p.`Sales Person`, 
    count(*) as Total_Shipments
from shipments s
join people p on p.`SP ID` = s.`Sales Person`
group by p.`Sales Person`
having count(*) > (
    select avg(shipment_count)
    from (
        select 
            `Sales Person`,
            count(*) as shipment_count
        from shipments
        group by `Sales Person`
    ) t
)
order by Total_Shipments desc;


/* Query 3: Products with Above-Average Total Sales */
select 
    pr.Product, 
    sum(s.Amount) as Total_Sales
from shipments s
join products pr on pr.`Product ID` = s.Product
group by pr.Product
having sum(s.Amount) > (
    select avg(product_total_sales)
    from (
        select 
            Product,
            sum(Amount) as product_total_sales
        from shipments
        group by Product
    ) t
)
order by Total_Sales desc;


/* Query 4: Countries with Above-Average Box Volume */
select 
    g.Geo,
    sum(s.Boxes) as Total_Boxes
from shipments s
join geo g on g.GeoID = s.Geo
group by g.Geo
having sum(s.Boxes) > (
    select avg(country_boxes)
    from (
        select 
            Geo,
            sum(Boxes) as country_boxes
        from shipments
        group by Geo
    ) t
)
order by Total_Boxes desc;


/* Query 5: Salesperson-Product Combinations with Above-Average Shipment Activity */
select 
    p.`Sales Person`,
    pr.Product,
    count(*) as Total_Shipments
from shipments s
join people p on p.`SP ID` = s.`Sales Person`
join products pr on pr.`Product ID` = s.Product
group by p.`Sales Person`, pr.Product
having count(*) > (
    select avg(combo_count)
    from (
        select 
            `Sales Person`,
            Product,
            count(*) as combo_count
        from shipments
        group by `Sales Person`, Product
    ) t
)
order by Total_Shipments desc;
