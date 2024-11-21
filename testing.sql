begin
ecommercemanagement.automaticinsertcustomers(20);
ecommercemanagement.automaticinsertproducts (30);
end;

declare 
v_products ecommercemanagement.productDetailsList;

begin 

--place an order
v_products(1).product_id := 50;
v_products(1).quantity:=2;
v_products(2).product_id := 53;
v_products(2).quantity:=1;
ecommercemanagement.palceAnOrder(1000,v_products);
end;

set SERVEROUTPUT ON

begin 
ecommercemanagement.ProcessPayment(100,154);
end;

set SERVEROUTPUT ON;

begin 
ecommercemanagement.ReplenishStock(50,4);
end;


