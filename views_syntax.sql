-- Top Selling Products View
CREATE VIEW top_selling_products AS
SELECT TOP 100 PERCENT
    p.product_id, 
    p.name, 
    SUM(oi.quantity) AS total_sold
FROM Product p
JOIN Order_Item oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name
ORDER BY total_sold DESC;


-- Customer Purchase History View
CREATE VIEW customer_purchase_history 
AS
SELECT 
    c.customer_id, 
    CONCAT(c.First_Name, ' ', c.Last_Name) AS Name,  -- Combined name column
    o.order_id, 
    o.order_date, 
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM Customer c
JOIN [Order] o ON c.customer_id = o.customer_id 
JOIN Order_Item oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.First_Name, c.Last_Name, o.order_id, o.order_date;