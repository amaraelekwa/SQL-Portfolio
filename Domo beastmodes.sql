CASE
    WHEN `Category` = 'Cash' AND 
         (`GL Account Name` LIKE '%Outstanding receipts%' OR 
          `GL Account Name` LIKE '%Outstanding payments%' OR 
          `GL Account Name` LIKE '%Suspense%') AND 
          `YTD Calculated Balance` <> 0 THEN 'Unreconciled'
    
    WHEN (`Category` LIKE '%Cash%' OR 
          `Category` LIKE '%Bank Balance%' OR 
          `Category` LIKE '%Biller%' OR 
          `Category` LIKE '%Wallet%' OR 
          `Category` LIKE '%Collection%' OR 
          `Category` LIKE '%Imprest%' OR 
          `Category` LIKE '%OD%') AND 
          `YTD Calculated Balance` = 0 THEN 'Reconciled'

    WHEN (`Category` LIKE '%Cash%' OR 
          `Category` LIKE '%Bank Balance%' OR 
          `Category` LIKE '%Biller%' OR 
          `Category` LIKE '%Wallet%' OR 
          `Category` LIKE '%Collection%' OR 
          `Category` LIKE '%Imprest%' OR 
          `Category` LIKE '%OD%') AND 
          `YTD Calculated Balance` <> 0 THEN 'Unreconciled'

    WHEN `Category` LIKE '%Bank%' AND 
         (`GL Account Name` LIKE '%Outstanding receipts%' OR 
          `GL Account Name` LIKE '%Outstanding payments%' OR 
          `GL Account Name` LIKE '%Suspense%') AND 
          `YTD Calculated Balance` <> 0 THEN 'Unreconciled'
    
    WHEN `Category` LIKE '%Bank%' AND `YTD Calculated Balance` = 0 THEN 'Reconciled'
    
    WHEN `Category` LIKE '%Stock%' AND 
         `GL Account Name` LIKE '%Stock%' AND 
         `YTD Calculated Balance` <> 0 THEN 'Unreconciled'
    
    ELSE 'Others'
END
-- Ayo's suggesed Query
CASE
    WHEN `Category` = 'Cash' AND 
         (`GL Account Name` LIKE '%Outstanding%' OR 
          `GL Account Name` LIKE '%Suspense%') AND 
          `YTD Calculated Balance` <> 0 THEN 'Unreconciled'

    WHEN (`Category` LIKE '%Cash%' OR 
          `Category` LIKE '%Bank%' OR 
          `Category` LIKE '%Biller%' OR 
          `Category` LIKE '%Wallet%' OR 
          `Category` LIKE '%Collection%' OR 
          `Category` LIKE '%Imprest%' OR 
          `Category` LIKE '%OD%') AND
         (`GL Account Name` LIKE '%Outstanding%' OR 
          `GL Account Name` LIKE '%Suspense%') AND 
          `YTD Calculated Balance` <> 0 THEN 'Unreconciled'
      
    WHEN (`Category` LIKE '%Cash%' OR 
          `Category` LIKE '%Bank%' OR 
          `Category` LIKE '%Biller%' OR 
          `Category` LIKE '%Wallet%' OR 
          `Category` LIKE '%Collection%' OR 
          `Category` LIKE '%Imprest%' OR 
          `Category` LIKE '%OD%') AND 
         (`GL Account Name` LIKE '%Outstanding%' OR 
          `GL Account Name` LIKE '%Suspense%') AND 
          `YTD Calculated Balance` = 0 THEN 'Reconciled'
    
    WHEN `Category` LIKE '%Stock%' AND 
         `GL Account Name` LIKE '%Stock%' AND 
         `YTD Calculated Balance` <> 0 THEN 'Unreconciled'
    
    ELSE 'Others'
END


CASE
    WHEN `Account Type` = 'Asset'    AND `YTD Calculated Balance` < 0 THEN 'Credit Balance'
    WHEN `Account Type` = 'Liablity' AND `YTD Calculated Balance` > 0 THEN 'Debit Balance'
    WHEN `Account Type` = 'Equity'   AND `YTD Calculated Balance` > 0 THEN 'Debit Balance'
    WHEN `Account Type` = 'Cost of Sales'   AND `MTD Calculated Balance` < 0 THEN 'Credit Balance'
    WHEN `Account Type` = 'Revenue'   AND `MTD Calculated Balance` > 0 THEN 'Debit Balance'
    ELSE 'Normal'
END     

SUM(IFNULL(`end_bal_debit`,0)) - SUM(IFNULL(`end_bal_credit`,0))

CASE 
    WHEN DATEDIFF(CURRENT_DATE(), `date`) < 31 THEN '0-30 Days'
    WHEN DATEDIFF(CURRENT_DATE(), `date`) >= 31 AND DATEDIFF(CURRENT_DATE(), `date`) <= 60  THEN '31-60 Days'
    WHEN DATEDIFF(CURRENT_DATE(), `date`) >= 61 AND DATEDIFF(CURRENT_DATE(), `date`) <= 90  THEN '61-90 Days'
    WHEN DATEDIFF(CURRENT_DATE(), `date`) >= 91 AND DATEDIFF(CURRENT_DATE(), `date`) <= 120 THEN '91-120 Days'
    ELSE '120+ Days'
END
