CREATE TABLE public.assignments (
    assignment_id INT,
    assignment_name VARCHAR(255),
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    budget DECIMAL(15, 2),
    region VARCHAR(50),
    impact_score DECIMAL(4, 2)
);

CREATE TABLE public.donations (
    index INT,
    donation_id INT,
    donor_id INT,
    amount DECIMAL(10, 2),
    donation_date TIMESTAMP,
    assignment_id INT
);

CREATE TABLE public.donors (
    index INT,
    donor_id INT,
    donor_name VARCHAR(255),
    donor_type VARCHAR(50)
);

SELECT * FROM public.assignments;
SELECT * FROM public.donations;
SELECT * FROM public.donors;

/* Write two SQL queries to answer the following questions:

1. List the top five assignments based on total value of donations, categorized by donor type. 
The output should include four columns: 1) assignment_name, 2) region, 3) rounded_total_donation_amount rounded to two decimal places, and 4) donor_type, sorted by rounded_total_donation_amount in descending order. 
Save the result as highest_donation_assignments.

2. Identify the assignment with the highest impact score in each region, ensuring that each listed assignment has received at least one donation. 
The output should include four columns: 1) assignment_name, 2) region, 3) impact_score, and 4) num_total_donations, sorted by region in ascending order. 
Include only the highest-scoring assignment per region, avoiding duplicates within the same region. 
Save the result as top_regional_impact_assignments.

Note: Please also ensure that you do not change the names of the DataFrames that the three query results will be saved as - creating new cells in the workbook will rename the DataFrame (see image below). 
Make sure that your final solutions use the names provided: highest_donation_assignments and top_regional_impact_assignments. */

-- 1. List the top five assignments based on total value of donations, categorized by donor type.
-- highest_donation_assignments
SELECT 
   assignment_name, 
   region, 
   ROUND(SUM(amount), 2) AS rounded_total_donation_amount, 
   donor_type
FROM public.assignments a   
   JOIN public.donations d ON a.assignment_id = d.assignment_id
   JOIN public.donors o ON  d.donor_id = o.donor_id
GROUP BY
    assignment_name, 
    region,
    donor_type
ORDER BY rounded_total_donation_amount DESC
LIMIT 5; 

-- 2. Identify the assignment with the highest impact score in each region, ensuring that each listed assignment has received at least one donation.
-- top_regional_impact_assignments
WITH ranked_assignments AS (
    SELECT 
        assignment_name, 
        region, 
        impact_score, 
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY impact_score DESC) AS rn,
        COUNT(donation_id) AS num_total_donations
    FROM public.assignments a
        JOIN public.donations d ON a.assignment_id = d.assignment_id
    GROUP BY 
        assignment_name, 
        region, 
        impact_score
)
SELECT 
    assignment_name, 
    region, 
    impact_score, 
    num_total_donations
FROM ranked_assignments 
WHERE rn = 1
ORDER BY region ASC;
