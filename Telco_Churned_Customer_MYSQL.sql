select * from customerchurn;
select * from customerchurn_services;
select * from customerchurn_status;


-- Query 1 Find the Top 5 average monthly charges amoung he Churned Customers
with avgmonthlycharges as(
select Customer_ID, Avg_Monthly_Charges, Contract
from customerchurn_services),

churned as (
select Customer_ID, Customer_Status from customerchurn_status
where Customer_Status = 'Churned'
) 

select cc.Customer_ID, cc.Age, cc.Gender, amc.Avg_Monthly_Charges, amc.Contract, ch.Customer_Status
from customerchurn as cc
join avgmonthlycharges as amc on cc.Customer_ID = amc.Customer_ID
join churned as ch on amc.Customer_ID = ch.Customer_ID
order by amc.Avg_Monthly_Charges desc
limit 5;
-- Create CTE name avgmonthlycharges to retrieve the data of average monthly rate of all customers from customer churn table
-- Then create second CTE to extact the data of only churned customers from customer status table
-- In finally query retrieved the data of top 5 churned customers which are having high average monthly rate among the churned customers by join the all above CTEs data

-- Query 2 What are the feedback or complaints from those churned customers

with avgmonthlycharges as(
select Customer_ID, Avg_Monthly_Charges, Contract
from customerchurn_services),

churned as (
select Customer_ID, Customer_Status, Churn_Reason from customerchurn_status
where Customer_Status = 'Churned'
)

select cc.Customer_ID, cc.Age, cc.Gender, amc.Avg_Monthly_Charges, ch.Customer_Status, ch.Churn_Reason
from customerchurn as cc
join avgmonthlycharges as amc on cc.Customer_ID = amc.Customer_ID
join churned as ch on amc.Customer_ID = ch.Customer_ID
order by amc.Avg_Monthly_Charges desc
limit 5;
-- Same queries are used to extact the churn reason data of top 5 churned customer with the little changes. Adding the Churn_Reason column data in the churned CTE to
-- retrieve the churned reason data of top 5 churned customers

-- Query 3 How does the payment method influence churn behavior?

select cs.PaymentMethod,count(cs.PaymentMethod) 
from customerchurn_services as cs
join customerchurn_status as ccs
on cs.Customer_ID = ccs.Customer_ID
where ccs.Customer_Status = 'Churned'
group by PaymentMethod;
-- the above query shows the most common payment method used by churned customers; The results shows that the bank withdrawal payment mode customers are churned significantly
-- The reason of this is maybe company charged extra charges or maybe subscription package was recharged without informing customer  

-- For Sumamry Query
select * from customerchurn_status
where Customer_Status = 'Churned';

-- find top 3 Churned Category
select Churn_Category, count(Churn_Category) as Total_Churned
from customerchurn_status
where Customer_Status = 'Churned'
group by Churn_Category
order by Total_Churned desc
limit 3;

-- Dissatisfaction Category Churned Reasons
select Customer_ID, Churn_Category, Churn_Reason
from customerchurn_status
where Customer_Status = 'Churned' and Churn_Category = 'Dissatisfaction'
order by Churn_Category;

 -- Competitor Category Churned Reasons
select Customer_ID, Churn_Category, Churn_Reason
from customerchurn_status
where Customer_Status = 'Churned' and Churn_Category = 'Competitor'
order by Churn_Category;

 -- Attitude Category Churned Reasons
select Customer_ID, Churn_Category, Churn_Reason
from customerchurn_status
where Customer_Status = 'Churned' and Churn_Category = 'Attitude'
order by Churn_Category;

-- Most Churned Customers Age group

select cc.Age, cs.Customer_Status
from customerchurn as cc
join (select Customer_ID, Customer_Status from customerchurn_status
where Customer_Status = 'Churned') as cs
on cc.Customer_ID =cs.Customer_ID
group by Age
order by Age;
-- the above query identify the which age group people were churned most so that company make strategy to retain that age group people

-- Most Churned Customer Location
select Customer_ID, City,Zip_Code
from customerchurn_location
where Customer_ID in (select Customer_ID from customerchurn_status
where Customer_Status = 'Churned')
order by City;
-- In above query, identify churned customers belonge to which cities; So that company can make strategy to improve their service in that cities and reduce the customer churned 
-- rate





