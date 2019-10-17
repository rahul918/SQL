--Question 1
SELECT E.emp_num, 
       E.emp_fname, 
       E.emp_lname, 
       SH.sal_amount AS CURRENT_SAL_AMOUNT 
FROM   salary_history SH 
       INNER JOIN employee E 
               ON SH.emp_num = E.emp_num 
WHERE  E.dept_num = '300' 
       AND SH.sal_end IS NULL 
ORDER  BY SH.sal_amount DESC 

--Question 2
SELECT SH.emp_num, 
       MSH.start_sal_from, 
       SH.sal_amount AS START_SAL_AMOUNT 
FROM   salary_history SH 
       INNER JOIN (SELECT emp_num, 
                          Min(sal_from) AS START_SAL_FROM 
                   FROM   salary_history 
                   GROUP  BY emp_num) MSH 
               ON SH.emp_num = MSH.emp_num 
                  AND SH.sal_from = MSH.start_sal_from 
ORDER  BY SH.emp_num 

--Question 3

SELECT STC.inv_num, 
       STC.line_num      AS TOP_COAT_LINE_NUM, 
       STC.prod_sku      AS TOP_COAT_PROD_SKU, 
       STC.prod_descript AS TOP_COAT_PROD_DESCRIPT, 
       SS.line_num       AS SEALER_LINE_NUM, 
       SS.prod_sku       AS SEALER_PROD_SKU, 
       SS.prod_descript  AS SEALER_PROD_DESCRIPT, 
       SS.brand_id 
FROM   (SELECT L.inv_num, 
               L.line_num, 
               P.prod_sku, 
               P.prod_descript, 
               P.brand_id 
        FROM   line L 
               INNER JOIN product P 
                       ON P.prod_sku = L.prod_sku 
        WHERE  P.prod_category IN ( 'Top Coat' )) STC 
       INNER JOIN (SELECT L.inv_num, 
                          L.line_num, 
                          P.prod_sku, 
                          P.prod_descript, 
                          P.brand_id 
                   FROM   line L 
                          INNER JOIN product P 
                                  ON P.prod_sku = L.prod_sku 
                   WHERE  P.prod_category IN ( 'Sealer' )) SS 
               ON STC.inv_num = SS.inv_num 
                  AND STC.brand_id = SS.brand_id 



--Question 4

SELECT TOP 1 E.emp_num, 
             E.emp_fname, 
             E.emp_lname, 
             E.emp_email, 
             Sum(L.line_qty) AS TOTAL_UNITS_SOLD 
FROM   employee E 
       INNER JOIN invoice I 
               ON E.emp_num = I.employee_id 
       INNER JOIN line L 
               ON I.inv_num = L.inv_num 
       INNER JOIN product P 
               ON L.prod_sku = P.prod_sku 
       INNER JOIN brand B 
               ON P.brand_id = B.brand_id 
WHERE  brand_name = 'BINDER PRIME' 
       AND I.inv_date BETWEEN '2015-11-01 00:00:00.000' AND 
                              '2015-12-05 00:00:00.000' 
GROUP  BY E.emp_num, 
          E.emp_fname, 
          E.emp_lname, 
          E.emp_email 
ORDER  BY total_units_sold DESC, 
          emp_lname 


--Question 5

SELECT C.cust_code, 
       C.cust_fname, 
       C.cust_lname 
FROM   customer C 
       INNER JOIN invoice I 
               ON C.cust_code = I.cust_code 
WHERE  I.cust_code IN (SELECT cust_code 
                       FROM   invoice 
                       WHERE  employee_id = '83649') 
       AND I.employee_id = '83677' 
ORDER  BY C.cust_lname, 
          C.cust_fname 

--Question 6

SELECT C.cust_code, 
       C.cust_fname, 
       C.cust_lname, 
       C.cust_street, 
       C.cust_city, 
       C.cust_state, 
       C.cust_zip, 
       I.inv_date, 
       Isnull(I.inv_total, 0) AS LargestPurchase 
FROM   customer C 
       INNER JOIN invoice I 
               ON C.cust_code = I.cust_code 
WHERE  C.cust_state = 'AL' 
       AND I.inv_total = (SELECT Max(IM.inv_total) 
                          FROM   invoice IM 
                          WHERE  IM.cust_code = C.cust_code) 
UNION ALL 
SELECT C.cust_code, 
       C.cust_fname, 
       C.cust_lname, 
       C.cust_street, 
       C.cust_city, 
       C.cust_state, 
       C.cust_zip, 
       NULL, 
       0 
FROM   customer c 
WHERE  C.cust_state = 'AL' 
       AND C.cust_code NOT IN (SELECT cust_code 
                               FROM   invoice) 
ORDER  BY C.cust_lname, 
          C.cust_fname;   





--QUESTION 7

SELECT PA.brand_name, 
       PA.brand_type, 
       Avg(PA.average_prod_price) AS AVERAGE_BRAND_PROD_PRICE, 
       Sum(PA.total_units_sold)   AS TOTAL_UNITS_SOLD 
FROM   (SELECT B.brand_name, 
               B.brand_type, 
               P.prod_sku, 
               Avg(P.prod_price) AS AVERAGE_PROD_PRICE, 
               Sum(L.line_qty)   AS TOTAL_UNITS_SOLD 
        FROM   brand B 
               FULL JOIN product P 
                       ON B.brand_id = P.brand_id 
               FULL JOIN line L 
                      ON L.prod_sku = P.prod_sku 
        GROUP  BY B.brand_name, 
                  B.brand_type, 
                  P.prod_sku) PA 
GROUP  BY PA.brand_name, 
          PA.brand_type 
order by 1


--Question 8

SELECT B.brand_name, 
       B.brand_type, 
       P.prod_sku, 
       P.prod_descript, 
       P.prod_price 
FROM   brand B 
       INNER JOIN product P 
               ON B.brand_id = P.brand_id 
WHERE  brand_type != 'PREMIUM' 
       AND P.prod_price > (SELECT TOP 1 P.prod_price 
                           FROM   brand B 
                                  INNER JOIN product P 
                                          ON B.brand_id = P.brand_id 
                           WHERE  brand_type = 'PREMIUM' 
                           ORDER  BY prod_price DESC) 
ORDER  BY P.prod_price, 
          B.brand_name, 
          B.brand_type 


--Question 9

--9(a)
select * from PRODUCT where PROD_PRICE>50
--9(b)
select SUM(PROD_PRICE*PROD_QOH) as TOTAL_INVENTORY_VALUE from PRODUCT 
--9(c)
select count(CUST_CODE) as NUM_OF_CUSTOMERS, sum(CUST_BALANCE) as TOTAL_CUST_BALANCE from CUSTOMER
--9(d)
select top 3 CUST_STATE,SUM(INV_TOTAL) as TOTAL_SALES_Dollars from INVOICE I INNER JOIN CUSTOMER C ON I.CUST_CODE=C.CUST_CODE group by CUST_STATE
order by SUM(INV_TOTAL) desc

--Question 10

select FORMAT(INV_DATE, 'yyyy_MM') AS SALES_PERIOD,sum(INV_TOTAL) as SALES_TOTAL from invoice 
group by FORMAT(INV_DATE, 'yyyy_MM')
order by FORMAT(INV_DATE, 'yyyy_MM')



