create or replace package  EcommerceManagement As

-- start custom types
type ProductDetail is record(
Product_id int ,
Quantity INT
);
type productDetailsList is table of ProductDetail index  by PLS_INTEGER;
-- end custom types

--start functions
function CheckOrderStatus (p_OrderID int) return VARCHAR;
--end functions


-- start procedures
PROCEDURE automaticInsertCustomers(numberOfRows number);
PROCEDURE automaticInsertProducts(numberOfRows number );
PROCEDURE palceAnOrder (p_CustomerID int ,p_orderProductsDetails productDetailsList );
PROCEDURE ProcessPayment(p_OrderID int, p_Amount int) ;
PROCEDURE ReplenishStock(p_ProductID int, p_Quantity int);
-- end procedures


end EcommerceManagement;



