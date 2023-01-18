# Q1 - Create a database called house_price_regression.
Use house_price_regression;

# Q2 - Create a table house_price_data with the same columns as given in the csv file. Please make sure you use the correct data types for the columns.

Create Table house_price_data (
	id bigint,
	date_sold char(10),
	bedrooms decimal,
	bathrooms decimal,
	sqft_living int,
	sqft_lot int,
	floors smallint,
	waterfront bool,
	view smallint,
	cond smallint,
	grade smallint,
	sqft_above int,
	sqft_basement int,
	yr_built int,
	yr_renovated int,
	zipcode int,
	latitude decimal(7,4),
	longitude decimal(7,4),
	sqft_living15 int,
	sqft_lot15 int,
	price int );

# Q3 - Import the data from the csv file into the table. Before you import the data into the empty table, make sure that you have deleted the headers from the csv file. To not modify the original data, if you want you can create a copy of the csv file as well. Note you might have to use the following queries to give permission to SQL to import data from csv files in bulk:
# Have used the Table Data Import Wizard # 

# Q4 - Select all the data from table house_price_data to check if the data was imported correctly
select * from house_price_data;

#Q5 - a - Use the alter table command to drop the column `date` from the database, as we would not use it in the analysis with SQL. Select all the data from the table to verify if the command worked. Limit your returned results to 10.
alter table house_price_data drop date_sold;

#Q5 - b - #Select all the data from the table to verify if the command worked. Limit your returned results to 10.
select * from house_price_data
limit 10; 

#Q6 - Use sql query to find how many rows of data you have.
Select COUNT(*) from house_price_data;

#Q7 - 7.  Now we will try to find the unique values in some of the categorical columns:

#a - What are the unique values in the column `bedrooms`?
select distinct bedrooms from house_price_data order by bedrooms; 

#b - What are the unique values in the column `bathrooms`?
select distinct bathrooms from house_price_data order by bathrooms; 

#c - What are the unique values in the column `floors`?
select distinct floors from house_price_data; 

#d - What are the unique values in the column `condition`?
select distinct cond from house_price_data order by cond; 

#e - What are the unique values in the column `grade`?
select distinct grade from house_price_data order by grade; 

# Q8 - Arrange the data in a decreasing order by the price of the house. Return only the IDs of the top 10 most expensive houses in your data.
select id, price from house_price_data
order by price desc
limit 10;

# Q9 - What is the average price of all the properties in your data?
select avg(price) 
from house_price_data;

# Q10 - In this exercise we will use simple group by to check the properties of some of the categorical variables in our data

    #a - What is the average price of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the prices. Use an alias to change the name of the second column.
    select bedrooms, avg(price) as Average_Price from house_price_data
	group by bedrooms
	order by bedrooms asc;
    
    #b - What is the average `sqft_living` of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the `sqft_living`. Use an alias to change the name of the second column.
    select bedrooms, avg(sqft_living15) as Average_Sqft_Living from house_price_data
	group by bedrooms
	order by bedrooms asc;
    
    #c - What is the average price of the houses with a waterfront and without a waterfront? The returned result should have only two columns, waterfront and `Average` of the prices. Use an alias to change the name of the second column.
    select waterfront, avg(price) as Average_Price from house_price_data
	group by waterfront
    order by Average_Price desc;
    
    #d - Is there any correlation between the columns `condition` and `grade`? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
	select cond, grade from house_price_data
    group by cond
	order by cond asc;
    
    # was getting an error initially on above so ran this query: SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY','')); #


# Q11 - One of the customers is only interested in the following houses:
    #Number of bedrooms either 3 or 4
    #Bathrooms more than 3
    #One Floor
    #No waterfront
    #Condition should be 3 at least
    #Grade should be 5 at least
    #Price less than 300000
	#For the rest of the things, they are not too concerned. Write a simple query to find what are the options available for them?

select * from house_price_data
where bedrooms in ('3','4') and bathrooms > 3 and floors = 1 and waterfront = 0 and cond >= 3 and grade >= 5 and price < 300000; 


# Q12 - Your manager wants to find out the list of properties whose prices are twice more than the average of all the properties in the database. Write a query to show them the list of such properties. You might need to use a sub query for this problem.
select * from house_price_data
where price >= 2*(select avg(price) as total_price from house_price_data);

# Q13 -  Since this is something that the senior management is regularly interested in, create a view of the same query.
create view overpriced_properties as
select * from house_price_data
where price >= 2*(select avg(price) as total_price from house_price_data);

select * from overpriced_properties;

# Q14 -  Most customers are interested in properties with three or four bedrooms. What is the difference in average prices of the properties with three and four bedrooms?
select bedrooms, avg(price) as average_price from house_price_data
where bedrooms in (3,4) 
group by bedrooms;

# Q15 -  What are the different locations where properties are available in your database? (distinct zip codes)
select distinct zipcode from house_price_data
order by zipcode;

# Q16 - Show the list of all the properties that were renovated.
select * from house_price_data
where yr_renovated <> 0; 

# Q17 - Provide the details of the property that is the 11th most expensive property in your database.
select *,  
rank() over (order by price desc) ranking  
from house_price_data
limit 10, 1;