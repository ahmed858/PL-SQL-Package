-- Test Script for EcommerceManagement Package

SET SERVEROUTPUT ON;

BEGIN
    -- Insert 5 random customers
    EcommerceManagement.automaticInsertCustomers(5);
    DBMS_OUTPUT.PUT_LINE('Inserted 5 customers.');

    -- Insert 10 random products
    EcommerceManagement.automaticInsertProducts(10);
    DBMS_OUTPUT.PUT_LINE('Inserted 10 products.');

    -- Test placing an order
    DECLARE
        orderDetails EcommerceManagement.productDetailsList;
    BEGIN
        orderDetails(1).Product_id := 51;
        orderDetails(1).Quantity := 2;

        orderDetails(2).Product_id := 52;
        orderDetails(2).Quantity := 1;

        EcommerceManagement.palceAnOrder(1001, orderDetails);
    END;

    DBMS_OUTPUT.PUT_LINE('Order placed.');

    -- Test checking order status
    DECLARE
        v_status VARCHAR(20);
    BEGIN
        v_status := EcommerceManagement.CheckOrderStatus(101);
        DBMS_OUTPUT.PUT_LINE('Order Status: ' || v_status);
    END;

    -- Test processing payment
    BEGIN
        EcommerceManagement.ProcessPayment(101, 300); -- Replace with actual order ID and amount
    END;

    -- Test replenishing stock
    BEGIN
        EcommerceManagement.ReplenishStock(51, 100);
        DBMS_OUTPUT.PUT_LINE('Stock replenished.');
    END;

END;
/
