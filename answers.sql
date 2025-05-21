QUESTION 1
WITH RECURSIVE ProductSplit AS (
    SELECT
        OrderID,
        CustomerName,
        TRIM(SUBSTRING_INDEX(Products, ',', 1)) AS Product,
        SUBSTRING(Products, LENGTH(SUBSTRING_INDEX(Products, ',', 1)) + 2) AS RemainingProducts
    FROM ProductDetail
    WHERE Products LIKE '%,%'

    UNION ALL

    SELECT
        OrderID,
        CustomerName,
        TRIM(SUBSTRING_INDEX(RemainingProducts, ',', 1)),
        CASE
            WHEN RemainingProducts LIKE '%,%' THEN
                SUBSTRING(RemainingProducts, LENGTH(SUBSTRING_INDEX(RemainingProducts, ',', 1)) + 2)
            ELSE
                ''
        END
    FROM ProductSplit
    WHERE RemainingProducts != ''
)

SELECT
    OrderID,
    CustomerName,
    Product
FROM
(
    SELECT
        OrderID,
        CustomerName,
        TRIM(SUBSTRING_INDEX(Products, ',', 1)) AS Product
    FROM ProductDetail
    WHERE Products NOT LIKE '%,%'
    
    UNION ALL
    
    SELECT
        OrderID,
        CustomerName,
        Product
    FROM ProductSplit
) AS NormalizedProducts;
