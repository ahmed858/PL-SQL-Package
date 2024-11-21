# PL-SQL-Package
Ecommerce PL/SQL Package



# 1- Ecommerce DB Creation.sql
This script handles the database schema setup:

## 1. Deletes existing data and drops tables if they exist.
## 2. Creates the following tables:
e_Customers, e_Products, e_Orders, e_Order_Details, and e_Payments.
## 3. Sets up constraints:
Foreign keys for relationships (e.g., orders linked to customers).
A CHECK constraint for Payment_Status.
The structure is clear and aligned with relational database design principles.

# 1- ecommerceManagementpackage signeture.sql
This file contains the package specification, defining:

## 1. Custom Types:
ProductDetail as a record with Product_ID and Quantity.
productDetailsList as a collection (table of ProductDetail).
## 2. Procedures:
automaticInsertCustomers: Inserts multiple customers.
automaticInsertProducts: Inserts multiple products.
palceAnOrder: Places an order using product details.
ProcessPayment: Processes payments for orders.
ReplenishStock: Updates product stock.
## 3. Function:
CheckOrderStatus: Returns the status of a given order.


# 3- ecommerceManagementpackage body.sql
This file contains the implementation of the package:

## 1. CheckOrderStatus: 
Fetches payment status for an order.
automaticInsertCustomers and automaticInsertProducts: Inserts random data into e_customers and e_products.
## 2. palceAnOrder:  
Verifies stock availability for ordered products.
Inserts into e_orders, calculates the total, updates stock, and adds a pending payment.
## 3. ProcessPayment:
Validates the order, processes payment if the amount matches, and updates the payment status.
## 4. ReplenishStock:
Updates the stock of a specific product.

# Instructions for Running the Test
1. Execute Ecommerce DB Creation.sql to set up the database schema.
2. Execute the package specification and body scripts.
3. Run testing.sql to validate the package functionality.

### The package body is logically implemented and uses SQL%ROWCOUNT, FOR LOOP, and error handling appropriately.
