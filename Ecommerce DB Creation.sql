delete from e_order_details;
delete from e_orders;
delete from e_payments;
delete from e_products;
delete from e_customers;

drop table e_order_details;
drop table e_orders;
drop table  e_payments;
drop table  e_products;
drop table  e_customers;


create table e_Customers
(
Customer_ID int generated always as identity(start with 1000 INCREMENT by 1) Primary Key,
Name varchar(50) ,
Email varchar(50) , 
Phone varchar(50) ,
Address varchar(50)  
)


create  table e_Products
(
Product_ID int generated always as identity(start with 50 INCREMENT by 1) Primary Key ,
Product_Name varchar(255) not null,
Price number,
Stock_Quantity int default 0
)

create table e_Orders
(
Order_ID int generated always as identity(start with 100 INCREMENT by 1) Primary Key,
Customer_ID ,
Order_Date date,
Total_Amount number ,

constraint fk_customer
foreign key (Customer_ID)
references e_Customers(Customer_ID)
)

create table e_Order_Details
(
OrderDetail_ID int generated always as identity(start with 500 INCREMENT by 1) Primary Key,
Order_ID int ,
Product_ID int ,
Quantity int ,
Price number ,

CONSTRAINT fk_Order_ID
foreign key (Order_ID) references e_Orders(order_ID),

CONSTRAINT fk_Product_ID
foreign key (Product_ID) references e_Products(Product_ID)
)


create table e_Payments(

Payment_ID int generated always as identity(start with 50 INCREMENT by 1) Primary Key,
Order_ID int ,
Payment_Date date,
Payment_Amount number ,
Payment_Status varchar(20) ,

CONSTRAINT fk_payment_Order_ID
foreign key (Order_ID) references e_Orders(order_ID),

CONSTRAINT chk_payment_status check (Payment_Status in ('Pending', 'Completed'))

)


