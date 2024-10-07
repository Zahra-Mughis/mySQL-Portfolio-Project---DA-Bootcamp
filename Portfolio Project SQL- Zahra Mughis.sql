#Creating and Activating Schema
create schema `da_portfolio_project`;
use `da_portfolio_project`;

#Customer Churn data loaded using Table Data Import Wizard

#Preparing Data
describe customer_churn;

#Editing Column Names
alter table customer_churn
change column `Customer_ ID` Customer_ID varchar(255);

alter table customer_churn
change column `Custome_Status` Customer_Status varchar(255);

select * from customer_churn;

#Changing data types as appropriate for analysis
alter table customer_churn
modify AvgMonthlyLongDistanceCharges decimal (10, 2),
modify Monthly_Charge decimal (10, 2),
modify Total_Charges decimal (10, 2),
modify Total_Refunds decimal (10, 2),
modify TotalExtraDataCharges decimal (10, 2),
modify TotalLongDistanceCharges decimal (10, 2),
modify Total_Revenue decimal (10, 2);

#Repoorting total number of records in the customer churn dataset
select count(Customer_ID) as Total_Records
from customer_churn;

				#Churn Data Analysis

 
#Customers by Churn Status
select Churn_Label, count(Customer_ID) as Number_of_Customers,
round((count(Customer_ID)/(select count(*) from customer_churn)*100), 2) as Percentage
from customer_churn
group by Churn_Label;

#Or this could be studied as "Churn Rate"
select
round((sum(case when
Churn_Label = "Yes" then 1 else 0 end)/count(Customer_ID))*100, 2)
as Churn_Rate
from customer_churn;

#Churm Rate by Internet Type
select Internet_Type, count(Customer_ID) as Number_of_Customers,
round((count(Customer_ID)/(select count(*) from customer_churn)*100), 2) as Percentage,
round((sum(case when
Churn_Label = "Yes" then 1 else 0 end)/count(Customer_ID))*100, 2)
as Churn_Rate
from customer_churn
group by Internet_Type
order by Number_of_Customers;

#The above numbers show us the churn rate for customers subscribed to specific types of internet service.alter
#To see what percetange of churned customers were subscribed to a certain type of internet service, see below. 

#Distirbution of Churned Customers by Internet Type
select Internet_Type, count(Customer_ID) as Number_of_Churned_Customers,
round((count(Customer_ID)/(select count(*) from customer_churn where Churn_Label = "Yes")*100), 2) as Percentage
from customer_churn
where Churn_Label = "Yes"
group by Internet_Type
order by Number_of_Churned_Customers desc;

#Chur Rate by Type of Contract
select Contract, count(Customer_ID) as Number_of_Customers,
round((sum(case when
Churn_Label = "Yes" then 1 else 0 end)/count(Customer_ID))*100, 2)
as Churn_Rate
from customer_churn
group by Contract;

#Average Monthly Charge for Churned Customers
select round(avg(Monthly_Charge), 2) as Average_Monthly_Charge
from customer_churn
where Churn_Label = "Yes";

#Customers by Churned Category
select Churn_Category, count(Customer_ID) as Number_of_Churned_Customers,
round((count(Customer_ID)/(select count(*) from customer_churn where Churn_Label = "Yes")*100), 2) as Percentage
from customer_churn
where Churn_Label = "Yes"
group by Churn_Category;

#Average Tenure of Churned Customers (in Months)
select round(avg(Tenure_In_Months), 2) as Average_Tenure
from customer_churn
where Churn_Label = "Yes";

#Demographics
#Average Age
#Overall
select round(avg(Age), 2) as Average_Age
from customer_churn;

#Churned Customers
select round(avg(Age), 2) as Average_Age
from customer_churn
where Churn_Label = "Yes";

#Gender Distribution
select Gender, count(Customer_ID) as Number_of_Churned_Customers,
round((count(Customer_ID)/(select count(*) from customer_churn)*100), 2) as Percentage
from customer_churn
group by Gender;   

#Churned Customers
select Gender, count(Customer_ID) as Number_of_Churned_Customers,
round((count(Customer_ID)/(select count(*) from customer_churn where Churn_Label = "Yes")*100), 2) as Percentage
from customer_churn
where Churn_Label = "Yes"
group by Gender;                                                                               
#These results imply that female customers might have a higher churn rate. 
#The query below, thus, has been run to confirm this assumption.

#Churn Rate by Gender
select Gender, 
round((sum(case when
Churn_Label = "Yes" then 1 else 0 end)/count(Customer_ID))*100, 2)
as Churn_Rate
from customer_churn
group by Gender;                 

#Churn Rate by Age Groups
select concat(floor(Age/5)*5, "-", floor(Age/5)*5 + 4) as Age_Group, 
round((sum(case when
Churn_Label = "Yes" then 1 else 0 end)/count(Customer_ID))*100, 2)
as Churn_Rate
from customer_churn
group by Age_Group
order by Churn_Rate desc;     

#Identifyinop 5 groups with the highest
#average monthly charges among churned customers,
#by age, gender, and contract type

#Average Monthly Charge by Gender
select Gender, round(avg(Monthly_Charge), 2) as Average_Monthly_Charge
from customer_churn
where Churn_Label = "Yes"
group by Gender
Order by Average_Monthly_Charge desc;

# Average Monthly Charge by Contract Type
select Contract, round(avg(Monthly_Charge), 2) as Average_Monthly_Charge
from customer_churn
where Churn_Label = "Yes"
group by Contract
Order by Average_Monthly_Charge desc;

#Average Monthly Charge by Age
select Age, round(avg(Monthly_Charge), 2) as Average_Monthly_Charge
from customer_churn
where Churn_Label = "Yes"
group by Age
Order by Average_Monthly_Charge desc
limit 5;

#Using Age brackets
select concat(floor(Age/5)*5, "-", floor(Age/5)*5 + 4) as Age_Group, 
round(avg(Monthly_Charge), 2) as Average_Monthly_Charge
from customer_churn
where Churn_Label = "Yes"
group by Age_Group
order by Average_Monthly_Charge desc;

#Top 5 groups by Average Monthly Charge by Age, Gender, and Contact type
 
#Age 
select Age, Gender, Contract,
round(avg(Monthly_Charge), 2) as Average_Monthly_Charge
from customer_churn
where Churn_Label = "Yes"
group by Age, Gender, Contract
order by Average_Monthly_Charge desc
limit 5;

#By Age Bracket
select 
concat(floor(Age/5)*5, "-", floor(Age/5)*5 + 4) as Age_Group,
Gender, Contract,  
round(avg(Monthly_Charge), 2) as Average_Monthly_Charge
from customer_churn
where Churn_Label = "Yes"
group by Age_Group, Gender, Contract
order by Average_Monthly_Charge desc
limit 5
;

#Feeback or complaints from the churned customers
#Why do customers churn?
select Churn_Reason, count(Customer_ID) as Number_of_Customers, 
round((count(Customer_ID)/(select count(*) from customer_churn where Churn_Label = "Yes")*100), 2) as Percentage
from customer_churn
where Churn_Label = "Yes"
group by Churn_Reason
order by Number_of_Customers desc;

#Churn Reaspms pf the top 5 groups by Average Monthly Charge by Age, Gender, and Contact type

with Top_5_Groups as (
    select 
	concat(floor(Age / 5) * 5, "-", floor(Age / 5) * 5 + 4) as Age_Group,
	Gender, Contract,  
	round(avg(Monthly_Charge), 2) AS Average_Monthly_Charge
    from customer_churn
    where Churn_Label = "Yes"
	group by Age_Group, Gender, Contract
    order by Average_Monthly_Charge DESC
    limit 5
)
select 
    tg.Age_Group,
    tg.Gender,
    tg.Contract,
    tg.Average_Monthly_Charge,
    cc.Churn_Reason
from Top_5_Groups as tg
join ( 
	select 
	concat(floor(Age / 5) * 5, "-", floor(Age / 5) * 5 + 4) as Age_Group,
	Gender, Contract, Churn_Reason, count(Customer_ID) as Reason_Count,
	row_number() over (partition by concat(floor(Age / 5) * 5, "-", floor(Age / 5) * 5 + 4),
		Gender, Contract
		order by count(Customer_ID) desc)
    as row_no
    from customer_churn
    where Churn_Label = "Yes"
    group by Age_Group, Gender, Contract, Churn_Reason
) as cc
on tg.Age_Group = cc.Age_Group and tg.Gender = cc.Gender 
and tg.Contract = cc.Contract
where cc.row_no = 1;


#Payment Method and Churn Behaviour
select Payment_Method, count(Customer_ID) as Number_of_Churned_Customers,
round((count(Customer_ID)/(select count(*) from customer_churn where Churn_Label = "Yes")*100), 2) as Percentage
from customer_churn
where Churn_Label = "Yes"
group by Payment_Method
order by Number_of_Churned_Customers desc;
#The above procides the percxentage distribution of churned customer sby payment method.
#See below to assess the churn rate by payment method i.e. the percentage of users of a specific payment method who have churned

select Payment_Method, count(Customer_ID) as Number_of_Customers,
round((sum(case when
Churn_Label = "Yes" then 1 else 0 end)/count(Customer_ID))*100, 2)
as Churn_Rate
from customer_churn
group by Payment_Method
order by Churn_Rate desc;

