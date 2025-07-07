-- Drop if it already exists
IF OBJECT_ID('dbo.GetCategorySalesPercentage', 'FN') IS NOT NULL
    DROP FUNCTION dbo.GetCategorySalesPercentage;


CREATE FUNCTION dbo.GetCategorySalesPercentage (
    @CategoryId INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @CategorySales DECIMAL(18,2);
    DECLARE @TotalSales DECIMAL(18,2);
    DECLARE @Percentage DECIMAL(5,2);

    -- Get total sales for the specified category
    SELECT @CategorySales = SUM(po.PaymentTotal)
    FROM Product p
    JOIN PurchaseOrder po ON p.ProductId = po.ProductRef_Id
    WHERE p.ProductCategoryRef_Id = @CategoryId;

    -- Get total sales across all categories
    SELECT @TotalSales = SUM(PaymentTotal)
    FROM PurchaseOrder;

    -- Avoid NULL or divide-by-zero
    IF @TotalSales = 0 OR @CategorySales IS NULL
        SET @Percentage = 0;
    ELSE
        SET @Percentage = ROUND((@CategorySales * 100.0) / @TotalSales, 2);

    RETURN @Percentage;
END;


-- Example: Get percentage sales for Category ID = 10
SELECT dbo.GetCategorySalesPercentage(10) AS SalesPercentage;
