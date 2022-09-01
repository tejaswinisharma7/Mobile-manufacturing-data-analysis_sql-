--SQL Advance Case Study
select * from FACT_TRANSACTIONS
select * from DIM_CUSTOMER
select * from DIM_DATE
SELECT * FROM DIM_LOCATION
SELECT * FROM DIM_MANUFACTURER
SELECT * FROM DIM_MODEL

--Q1--BEGIN 

select dm.State
from DIM_LOCATION as dm inner join
FACT_TRANSACTIONS as ft
on dm.IDLocation=ft.IDLocation
where ft.Date>= '2005-01-01'


--Q1--END

--Q2--BEGIN

select top 1 
state from DIM_LOCATION
inner join FACT_TRANSACTIONS on DIM_LOCATION.IDLOCATION=FACT_TRANSACTIONS.IDLOCATION
inner join DIM_MODEL on FACT_TRANSACTIONS.IDMODEL = DIM_MODEL.IDMODEL
inner join DIM_MANUFACTURER on DIM_MANUFACTURER.IDMANUFACTURER= DIM_MODEL.IDMANUFACTURER
where MANUFACTURER_NAME = 'Samsung'
group by State
order by sum(Quantity) desc



--Q2--END

--Q3--BEGIN     

select t2.IDCustomer,t2.IDModel,t1.ZipCode,t1.State,t2.TotalPrice
from DIM_LOCATION as t1
join FACT_TRANSACTIONS as t2
on t1.IDLocation= t2.IDLocation

--Q3--END

--Q4--BEGIN
select
min(totalprice)
from FACT_TRANSACTIONS

--Q4--END

--Q5--BEGIN


select Model_Name, AVG (Unit_price)as Avg_price from DIM_MODEL
inner join DIM_MANUFACTURER on DIM_MANUFACTURER.IDManufacturer=DIM_MODEL.IDManufacturer
where Manufacturer_Name in 
(
select top 5 Manufacturer_Name from FACT_TRANSACTIONS
inner join DIM_MODEL ON FACT_TRANSACTIONS.IDModel=DIM_MODEL.IDModel
inner join DIM_MANUFACTURER on DIM_MANUFACTURER.IDManufacturer=DIM_MODEL.IDManufacturer
group by Manufacturer_Name
order by sum(Quantity)
)
group by Model_Name
order by avg(Unit_price) desc


--Q5--END

--Q6--BEGIN

select Customer_name, avg(TOTALPRICE) avg_spent
from DIM_CUSTOMER
inner join FACT_TRANSACTIONS on DIM_CUSTOMER.IDCUSTOMER = FACT_TRANSACTIONS.IDCUSTOMER
where year(Date) = 2009 
group by CUSTOMER_NAME
having avg (TotalPrice)>500


--Q6--END
	
--Q7--BEGIN  

select * from (SELECT 
    TOP 5 Manufacturer_name
    FROM Fact_Transactions T1
    LEFT JOIN DIM_Model D1 ON T1.IDModel = D1.IDModel
    LEFT JOIN DIM_MANUFACTURER D2  ON D2.IDManufacturer = D1.IDManufacturer
    Where DATEPART(Year,date)='2008' 
    group by Manufacturer_name, Quantity 
    Order by  SUM(Quantity ) DESC  
    intersect
SELECT  TOP 5 Manufacturer_name
    FROM Fact_Transactions T1
    LEFT JOIN DIM_Model D1 ON T1.IDModel = D1.IDModel
    LEFT JOIN DIM_MANUFACTURER D2  ON D2.IDManufacturer = D1.IDManufacturer
    Where DATEPART(Year,date)='2009' 
    group by Manufacturer_name, Quantity 
    Order by  SUM(Quantity ) DESC  
    intersect
SELECT TOP 5 Manufacturer_name
    FROM Fact_Transactions T1
    LEFT JOIN DIM_Model D1 ON T1.IDModel = D1.IDModel
    LEFT JOIN DIM_MANUFACTURER D2  ON D2.IDManufacturer = D1.IDManufacturer
    Where DATEPART(Year,date)='2010' 
    group by Manufacturer_name, Quantity 
    Order by  SUM(Quantity ) DESC)  as A


--Q8--BEGIN

with cte as
(
select Manufacturer_name, datepart(Year,date)as yr,
dense_rank() over (partition by datepart(Year,date) order by sum(TotalPrice) desc) as rank
from FACT_TRANSACTIONS as T1
left join DIM_MODEL AS T2 ON T1.IDModel=T2.IDModel
left join DIM_MANUFACTURER AS T3 ON T3.IDManufacturer=T2.IDManufacturer
group by Manufacturer_Name,datepart(year,date)
),
cte2 as 
(
select Manufacturer_Name,yr
from cte where rank= 2 and yr in('2009','2010')
)
select c.Manufacturer_Name as Manufacturer_Name_2009,
t.Manufacturer_Name as Manufacturer_Name_2010
from cte2 as c,cte2 as t
where c.yr < t.yr


--Q8--END

--Q9--BEGIN

select Manufacturer_name from DIM_MANUFACTURER qw
inner join DIM_MODEL as er on qw.IDManufacturer=er.IDManufacturer
inner join FACT_TRANSACTIONS ty on er.IDModel=ty.IDModel
where year(date)=2010
except
select Manufacturer_name from DIM_MANUFACTURER qw
inner join DIM_MODEL er on qw.IDManufacturer=er.IDManufacturer
inner join FACT_TRANSACTIONS ty on er.IDModel=ty.IDModel
where year(date)=2009


--Q9--END

--Q10--BEGIN

 select top 100 Customer_Name as Customers,
 avg(TotalPrice) Average_price,
 avg(Quantity) Average_Qty
 from FACT_TRANSACTIONS as vb
 inner join DIM_CUSTOMER as vc
 on vb.IDCustomer=VC.IDCustomer
 inner join DIM_DATE as vx
 on vb.Date=vx.DATE	
 group by Customer_Name

 select
 ( 
 Lag(TotalPrice,1) over(partition by IDCustomer order by TotalPrice asc))/TotalPrice * 100 as Percentage_change
 from FACT_TRANSACTIONS
 where TotalPrice>0
 order by Date desc, IDCustomer




---not able to fix this last question.