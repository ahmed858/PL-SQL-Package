CREATE OR REPLACE PACKAGE BODY EcommerceManagement AS
--==============================================================================
--start function
--==============================================================================
function CheckOrderStatus (p_OrderID int) return VARCHAR as
v_status varchar(10);
begin
    select payment_status into v_status
    from e_payments
    where order_id = p_orderID;
    return v_status;
end;
--==============================================================================
--end function
--==============================================================================
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
        COMMIT; -- Commit the transaction
    END automaticInsertCustomers;
    --==============================================================================
--==============================================================================
    PROCEDURE automaticInsertProducts(numberOfRows NUMBER) IS
    BEGIN
        FOR i IN 1..numberOfRows LOOP
            INSERT INTO e_products (product_name, price, stock_quantity)
            VALUES (
                'Product_' || i||i,
                ROUND(DBMS_RANDOM.VALUE(10, 100), 2), -- Random price between 10 and 100
                TRUNC(DBMS_RANDOM.VALUE(1, 50))       -- Random stock between 1 and 50
            );
        END LOOP;
        COMMIT; -- Commit the transaction
    END automaticInsertProducts;
    
--==============================================================================
--==============================================================================
PROCEDURE palceAnOrder (p_CustomerID int ,p_orderProductsDetails productDetailsList )is
v_order_ID int ;
v_Total_Amount int :=0;
v_Product_Price int ;
v_flag BOOLEAN :=true;
v_quantity_Temp int ;
begin 
-- check all quantity order products in stock
    for i in 1..p_orderProductsDetails.count loop 
    
        select stock_quantity into v_quantity_Temp
        from e_products 
        where product_ID = p_orderProductsDetails(i).Product_id;
        
        if v_quantity_Temp < p_orderProductsDetails(i).Quantity then
            v_flag  :=false;
        end if;
            
    end loop;
    
    if v_flag = true then 
        -- insert order 
        insert into e_orders (customer_ID,order_date,total_amount)
        values( p_CustomerID,sysdate ,0)
        RETURNING order_id into  v_order_ID;
        --============================================================
        --calc the total amount and insetin into order details
        for i in 1..p_orderProductsDetails.count loop 
            select price into v_Product_Price
            from e_products
            where product_id =   p_orderProductsDetails(i).product_id;
            
            v_total_amount := v_total_amount + v_Product_Price * p_orderProductsDetails(i).quantity ;
            
            --======================================
            
            insert into e_order_details (order_id,product_id,quantity,price)
            values(v_order_id,p_orderProductsDetails(i).product_id,
                    p_orderProductsDetails(i).quantity,v_product_price);
                    
        --==============================================
        
            -- update product quantity
            update e_products
            set stock_quantity = stock_quantity -p_orderProductsDetails(i).quantity
            where product_id = p_orderProductsDetails(i).product_id;
        end loop;
        --==========================
        -- Step 3: Update Order Total Amount    
        update e_orders
        set total_amount = v_Total_Amount
        where order_id = v_order_id;
        
        insert into e_payments (order_id,payment_date,payment_amount ,payment_status) 
        values( v_order_id,sysdate, v_Total_Amount,'Pending');
        commit;
    end if;
    DBMS_OUTPUT.PUT_LINE('Order placed successfully with Order ID: ' || v_Order_ID);
end palceAnOrder ;

--==============================================================================
--==============================================================================
PROCEDURE ProcessPayment(p_OrderID int, p_Amount int) as
v_amount int:=-1;
begin
    select o.total_amount into v_amount 
    from e_orders o 
    join e_payments p  on  o.order_id = p.order_id
    where o.order_id = p_orderID and p.payment_status = 'Pending';

    if v_amount = -1 then
        DBMS_OUTPUT.PUT_LINE('invalid order id! ');
    elsif v_amount = p_amount then
        update e_payments
        set payment_status = 'Completed';
        commit;
        DBMS_OUTPUT.PUT_LINE('pross paymaent ');
    else 
    DBMS_OUTPUT.PUT_LINE('the total amount not equal the order amount ');
    
    end if; 
end;
--==============================================================================
--==============================================================================
PROCEDURE ReplenishStock(p_ProductID int, p_Quantity int)as 
begin
     -- Attempt to update the product quantity
    UPDATE e_products
    SET stock_quantity = p_Quantity
    WHERE product_id = p_productID;

    -- Check if any rows were updated
    IF SQL%ROWCOUNT > 0 THEN
        commit;
        DBMS_OUTPUT.PUT_LINE('Product updated successfully.');
        
    ELSE
        DBMS_OUTPUT.PUT_LINE('Product ID does not exist.');
    END IF;
end;
--==============================================================================
--==============================================================================
END EcommerceManagement;
/
