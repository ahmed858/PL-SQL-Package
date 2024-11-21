SET SERVEROUTPUT ON;

BEGIN
    -- Test inserting customers
    DBMS_OUTPUT.PUT_LINE('Testing: Automatic Customer Insertion');
    EcommerceManagement.automaticInsertCustomers(5);
    DBMS_OUTPUT.PUT_LINE('Inserted 5 customers.');

    -- Test inserting products
    DBMS_OUTPUT.PUT_LINE('Testing: Automatic Product Insertion');
    EcommerceManagement.automaticInsertProducts(10);
    DBMS_OUTPUT.PUT_LINE('Inserted 10 products.');

    -- Test placing an order
    DBMS_OUTPUT.PUT_LINE('Testing: Place an Order');
    DECLARE
        orderDetails EcommerceManagement.productDetailsList;
    BEGIN
        orderDetails(1).Product_id := 51; -- Replace with a valid product ID
        orderDetails(1).Quantity := 2;

        orderDetails(2).Product_id := 52; -- Replace with another valid product ID
        orderDetails(2).Quantity := 1;

        EcommerceManagement.palceAnOrder(1001, orderDetails); -- Replace with a valid customer ID
    END;

    -- Test checking order status
    DBMS_OUTPUT.PUT_LINE('Testing: Check Order Status');
    DECLARE
        v_status VARCHAR(20);
    BEGIN
        v_status := EcommerceManagement.CheckOrderStatus(101); -- Replace with a valid order ID
        DBMS_OUTPUT.PUT_LINE('Order Status: ' || v_status);
    END;

    -- Test processing payment
    DBMS_OUTPUT.PUT_LINE('Testing: Process Payment');
    BEGIN
        EcommerceManagement.ProcessPayment(101, 300); -- Replace with a valid order ID and total amount
    END;

    -- Test replenishing stock
    DBMS_OUTPUT.PUT_LINE('Testing: Replenish Stock');
    BEGIN
        EcommerceManagement.ReplenishStock(51, 100); -- Replace with a valid product ID and stock quantity
        DBMS_OUTPUT.PUT_LINE('Stock replenished.');
    END;

END;
/
