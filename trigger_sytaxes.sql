-- Trigger 1

CREATE TRIGGER trg_order_placed
ON Order_Item
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE i
    SET i.quantity = i.quantity - inserted.quantity
    FROM Inventory i
    INNER JOIN inserted ON i.product_id = inserted.product_id;
END;

-- Trigger 2 
CREATE TRIGGER trg_prevent_product_delete
ON Product
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT 1 FROM deleted d JOIN Order_Item oi ON d.product_id = oi.product_id)
    BEGIN
        THROW 50000, 'Cannot delete product: referenced in orders.', 1;
        RETURN;
    END
    
    DELETE FROM Product
    WHERE product_id IN (SELECT product_id FROM deleted);
END;