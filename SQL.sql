show databases;
Use supply_chain_data;
select * from meeting;
desc meeting;
alter table meeting modify meeting_date date;

-- KPI 1 -- No of invoice by account executive
select * from invoice;
select account_executive, count(invoice_number) as Invoice_Count from invoice group by account_executive order by Invoice_Count desc;
select account_executive,
sum(case when income_class= "Cross Sell" then 1 else 0 end) as Cross_Sell_Count,
sum(case when income_class= "New" then 1 else 0 end) as New_Count,
sum(case when income_class= "Renewal" then 1 else 0 end) as Renewal_Count,
count(invoice_number) as Invoice_Count from invoice group by account_executive order by Invoice_Count desc;

-- KPI 2 -- Yearly meeting count
SELECT YEAR(meeting_date) AS year, COUNT(*) AS meeting_count FROM meeting
GROUP BY YEAR(meeting_date) ORDER BY year;


-- KPI 3 -- Income class vise target, achieved and invoice
select * from individual_budgets;
select * from invoice;
select * from brokerage;

SELECT 
sum(i.Amount) AS 'Invoice',
sum(ib.New_budget) AS 'Target',
sum(b.Amount) AS 'Achieved'
FROM 
    Invoice i
JOIN 
   Individual_budgets ib ON i.account_executive = ib.Employee_name
JOIN 
    Brokerage b ON i.income_class = b.income_class
    where 
     i.income_class = "New"
    AND b.income_class = "New";


SELECT 
    (SELECT SUM(ib.new_budget)/1000000
     FROM individual_budgets ib) AS 'Target (Million)',
    (SELECT SUM(br.amount) /1000000
     FROM brokerage br 
     WHERE br.income_class = 'New') AS 'Achieved (Million)',
    (SELECT SUM(i.amount) / 1000000
     FROM invoice i 
     WHERE i.income_class = 'New') AS 'Invoice (Milion)';
     
     
      SELECT 
    (SELECT SUM(ib.cross_sell_bugdet)/1000000
     FROM individual_budgets ib) AS 'Target (Million)',
    (SELECT SUM(br.amount)/1000000
     FROM brokerage br 
     WHERE br.income_class = 'Renewal') AS 'Achieved (Million)',
    (SELECT SUM(i.amount)/ 1000000
     FROM invoice i 
     WHERE i.income_class = 'Renewal') AS 'Invoice (Milion)';
     
	

     SELECT 
    (SELECT SUM(ib.renewal_budget) /1000000
     FROM individual_budgets ib) AS 'Target (Million)',
    (SELECT SUM(br.amount)/1000000
     FROM brokerage br 
     WHERE br.income_class = 'Renewal') AS 'Achieved (Million)',
    (SELECT SUM(i.amount)/ 1000000
     FROM invoice i 
     WHERE i.income_class = 'Renewal') AS 'Invoice (Milion)';


-- KPI 4 -- Stage funnel by Revenue
select stage, sum(revenue_amount) as Revenue_Amt from opportunity group by stage order by Revenue_amt desc;

-- KPI 5 -- No of meeting by account executive
SELECT Account_Executive as Executive_Name , COUNT(*) AS meeting_count FROM meeting
GROUP BY Account_Executive ORDER BY meeting_count DESC;

-- KPI 6 -- Top open opportunity
select * from opportunity;
select opportunity_name, sum(revenue_amount) as Revenue_Amount from opportunity group by opportunity_name order by Revenue_Amount desc limit 5;

-- Opportunity- Product distribution
Select product_group, count(opportunity_name) as Opportunity_count from opportunity group by product_group order by Opportunity_Count desc;


