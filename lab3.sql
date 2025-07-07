DELIMITER //

CREATE FUNCTION CategorySalesPercent(cat_id INT) RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    DECLARE category_total DECIMAL(10,2);

    SELECT SUM(PaymentTotal) INTO total FROM PurchaseOrder;
    SELECT SUM(P.PaymentTotal) 
    INTO category_total 
    FROM PurchaseOrder P
    JOIN Product Pr ON P.ProductRef_Id = Pr.ProductId
    WHERE Pr.ProductCategoryRef_Id = cat_id;

    RETURN (category_total / total) * 100;
END //

DELIMITER ;
