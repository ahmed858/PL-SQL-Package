CREATE OR REPLACE PACKAGE BODY EcommerceManagement AS

--==============================================================================

-- Function: CheckOrderStatus
function CheckOrderStatus (p_OrderID int) return VARCHAR as
    v_status varchar(10);
begin
    select payment_status into v_status
    from e_payments
    where order_id = p_OrderID;
    return v_status;
exception
    when NO_DATA_FOUND then
        return 'Order Not Found';
    when OTHERS then
        return 'Error Occurred';
end;

--==============================================================================

-- Procedure: automaticInsertCustomers
PROCEDURE automaticInsertCustomers(numberOfRows NUMBER) IS
BEGIN
    FOR i IN 1..numberOfRows LOOP
        INSERT INTO e_customers (name, phone, address, email)
        VALUES (
            'Customer_' || i,
            'Phone_' || i,
            'Address_' || TRUNC(DBMS_RANDOM.VALUE(1, 10)),
            'email_' || i || '@example.com'
        );
    END LOOP;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in automaticInsertCustomers: ' || SQLERRM);
        ROLLBACK;
END;

--==============================================================================

-- Procedure: automaticInsertProducts
PROCEDURE automaticInsertProducts(numberOfRows NUMBER) IS
BEGIN
    FOR i IN 1..numberOfRows LOOP
        INSERT INTO e_products (product_name, price, stock_quantity)
        VALUES (
            'Product_' || i || i,
            ROUND(DBMS_RANDOM.VALUE(10, 100), 2),
            TRUNC(DBMS_RANDOM.VALUE(1, 50))
        );
    END LOOP;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in automaticInsertProducts: ' || SQLERRM);
        ROLLBACK;
END;

--==============================================================================

-- Procedure: palceAnOrder
PROCEDURE palceAnOrder (p_CustomerID int ,p_orderProductsDetails productDetailsList ) IS
    v_order_ID int;
    v_Total_Amount int := 0;
    v_Product_Price int;
    v_flag BOOLEAN := true;
    v_quantity_Temp int;
BEGIN
    -- Check stock availability
    FOR i IN 1..p_orderProductsDetails.count LOOP
        SELECT stock_quantity INTO v_quantity_Temp
        FROM e_products 
        WHERE product_ID = p_orderProductsDetails(i).Product_id;
        
        IF v_quantity_Temp < p_orderProductsDetails(i).Quantity THEN
            v_flag := false;
        END IF;
    END LOOP;

    IF v_flag THEN
        -- Insert order
        INSERT INTO e_orders (customer_ID, order_date, total_amount)
        VALUES (p_CustomerID, SYSDATE, 0)
        RETURNING order_id INTO v_order_ID;

        -- Calculate total amount and update stock
        FOR i IN 1..p_orderProductsDetails.count LOOP
            SELECT price INTO v_Product_Price
            FROM e_products
            WHERE product_id = p_orderProductsDetails(i).product_id;

            v_Total_Amount := v_Total_Amount + v_Product_Price * p_orderProductsDetails(i).quantity;

            INSERT INTO e_order_details (order_id, product_id, quantity, price)
            VALUES (v_order_id, p_orderProductsDetails(i).product_id,
                    p_orderProductsDetails(i).quantity, v_Product_Price);

            UPDATE e_products
            SET stock_quantity = stock_quantity - p_orderProductsDetails(i).quantity
            WHERE product_id = p_orderProductsDetails(i).product_id;
        END LOOP;

        -- Update order total
        UPDATE e_orders
        SET total_amount = v_Total_Amount
        WHERE order_id = v_order_ID;

        -- Add payment entry
        INSERT INTO e_payments (order_id, payment_date, payment_amount, payment_status) 
        VALUES (v_order_id, SYSDATE, v_Total_Amount, 'Pending');

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Order placed successfully with Order ID: ' || v_order_ID);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Insufficient stock for one or more products.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Product not found during stock check.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in palceAnOrder: ' || SQLERRM);
        ROLLBACK;
END;

--==============================================================================

-- Procedure: ProcessPayment
PROCEDURE ProcessPayment(p_OrderID int, p_Amount int) IS
    v_amount int := -1;
BEGIN
    SELECT o.total_amount INTO v_amount 
    FROM e_orders o 
    JOIN e_payments p ON o.order_id = p.order_id
    WHERE o.order_id = p_OrderID AND p.payment_status = 'Pending';

    IF v_amount = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Invalid order ID.');
    ELSIF v_amount = p_Amount THEN
        UPDATE e_payments
        SET payment_status = 'Completed'
        WHERE order_id = p_OrderID;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Payment processed successfully.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('The payment amount does not match the order total.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Order ID not found or no pending payment.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in ProcessPayment: ' || SQLERRM);
        ROLLBACK;
END;

--==============================================================================

-- Procedure: ReplenishStock
PROCEDURE ReplenishStock(p_ProductID int, p_Quantity int) AS
BEGIN
    UPDATE e_products
    SET stock_quantity = p_Quantity
    WHERE product_id = p_ProductID;

    IF SQL%ROWCOUNT > 0 THEN
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Product stock updated successfully.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Product ID does not exist.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in ReplenishStock: ' || SQLERRM);
        ROLLBACK;
END;

--==============================================================================
END EcommerceManagement;
/
