CREATE PROCEDURE dbo.ApplyMarkupToCategory
    @Markup DECIMAL(10, 2),         -- Input: Amount to add to price
    @CategoryId INT,                -- Input: Category to update
    @TotalItems INT OUTPUT          -- Output: Total items updated
AS
BEGIN
    SET NOCOUNT ON;

    -- Step 1: Apply the markup to all products in the given category
    UPDATE Product
    SET Price = Price + @Markup
    WHERE ProductCategoryRef_Id = @CategoryId;

    -- Step 2: Count how many products were updated
    SELECT @TotalItems = COUNT(*)
    FROM Product
    WHERE ProductCategoryRef_Id = @CategoryId;
END;



-- Declare a variable to store the output
DECLARE @Count INT;

-- Execute the procedure
EXEC dbo.ApplyMarkupToCategory
    @Markup = 100,
    @CategoryId = 2,
    @TotalItems = @Count OUTPUT;

-- View the result
SELECT @Count AS NumberOfItems;
