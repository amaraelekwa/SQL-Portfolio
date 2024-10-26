/* 
This is the consolidated_trial_balance of all General ledger balances consolidated all by companies,
this CTE considers Balances from inception to date of reporting (March 2024),
YTD Balances (Jan 2024 till March 2024),
MTD Balance (1st March 2024 to 31st March 2024)
*/
WITH Consolidated_trial_balance AS (
    SELECT
        gl_categories.account_code,
        account_id_1,
        date,
        company_id_1,
        account_move_line.debit,
        account_move_line.credit,
        (account_move_line.debit - account_move_line.credit) AS net_balance,
        gl_categories.category_1,
        gl_categories.category_2,
        gl_categories.category_3,
        gl_categories.category_4
    FROM account_move_line
    LEFT JOIN gl_categories
        ON gl_categories.account_id = account_move_line.account_id_0
    WHERE 
        date BETWEEN '2021-04-30' AND '2024-03-31'
        AND company_id_1 LIKE '%TD%'
        AND parent_state = 'posted'
),
YTD_Balance AS ( -- YTD_Balance of each row for year 2024 without adding them
    SELECT *, net_balance AS YTD_Balance
    FROM Consolidated_trial_balance
    WHERE EXTRACT(YEAR FROM date) = 2024
),
MTD_Balance AS (  -- MTD_Balance of each row for March 2024 without adding them
    SELECT *, net_balance AS MTD_Balance
    FROM Consolidated_trial_balance
    WHERE EXTRACT(MONTH FROM date) = 3
          AND EXTRACT(YEAR FROM date) = 2024
)
SELECT * 
FROM YTD_Balance
ORDER BY account_code, company_id_1, date;