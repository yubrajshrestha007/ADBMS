DELIMITER $$

CREATE PROCEDURE ApplyMarkupToCategory(
    IN markup DECIMAL(10,2),
    IN categoryId INT,
    OUT totalItems INT
)
BEGIN
    -- Apply the markup to all products in the given category
    UPDATE Product
    SET Price = Price + markup
    WHERE ProductCategoryRef_Id = categoryId;

    -- Count total products in that category after update
    SELECT COUNT(*) INTO totalItems
    FROM Product
    WHERE ProductCategoryRef_Id = categoryId;
END$$

DELIMITER ;
