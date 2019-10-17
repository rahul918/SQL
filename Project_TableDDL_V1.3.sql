CREATE TABLE BRAND(
BRAND_ID INTEGER NOT NULL UNIQUE,
BRAND_NAME VARCHAR(100) NOT NULL,
BRAND_TYPE VARCHAR(20) NOT NULL,
PRIMARY KEY (BRAND_ID));

INSERT INTO BRAND (BRAND_ID, BRAND_NAME, BRAND_TYPE)
SELECT distinct BRAND_ID, BRAND_NAME, BRAND_TYPE FROM DataSet3;

select * from BRAND

CREATE TABLE CUSTOMER(
CUST_CODE INTEGER NOT NULL UNIQUE,
CUST_FNAME VARCHAR(20),
CUST_LNAME VARCHAR(20),
CUST_STREET VARCHAR(70),
CUST_CITY VARCHAR(50),
CUST_STATE VARCHAR(2),
CUST_ZIP VARCHAR(5),
CUST_BALANCE numeric(16,4)
PRIMARY KEY (CUST_CODE));

INSERT INTO CUSTOMER (CUST_CODE, CUST_FNAME, CUST_LNAME, CUST_STREET, CUST_CITY, CUST_STATE, CUST_ZIP, CUST_BALANCE)
SELECT distinct CUST_CODE, CUST_FNAME, CUST_LNAME, CUST_STREET, CUST_CITY, CUST_STATE, CUST_ZIP, CUST_BALANCE FROM DataSet2;

select * from CUSTOMER

CREATE TABLE DEPARTMENT(
DEPT_NUM INTEGER NOT NULL UNIQUE,
DEPT_NAME VARCHAR(50),
DEPT_MAIL_BOX VARCHAR(3),
DEPT_PHONE VARCHAR(9),
EMP_NUM INTEGER
PRIMARY KEY (DEPT_NUM));

INSERT INTO DEPARTMENT (DEPT_NUM, DEPT_NAME, DEPT_MAIL_BOX, DEPT_PHONE, EMP_NUM)
SELECT distinct DEPT_NUM, DEPT_NAME, DEPT_MAIL_BOX, DEPT_PHONE, SUPV_EMP_NUM FROM DataSet4;

select * from DEPARTMENT

CREATE TABLE EMPLOYEE(
EMP_NUM INTEGER NOT NULL UNIQUE,
EMP_FNAME VARCHAR(20),
EMP_LNAME VARCHAR(25),
EMP_EMAIL VARCHAR(25),
EMP_PHONE VARCHAR(20),
EMP_HIREDATE datetime,
EMP_TITLE VARCHAR(45),
EMP_COMM numeric(16,4),
DEPT_NUM INTEGER
PRIMARY KEY (EMP_NUM),
FOREIGN KEY (DEPT_NUM) REFERENCES DEPARTMENT );

CREATE INDEX EMPLOYEE_IDX
on EMPLOYEE (DEPT_NUM, EMP_NUM);

INSERT INTO EMPLOYEE (EMP_NUM, EMP_FNAME, EMP_LNAME, EMP_EMAIL, EMP_PHONE, EMP_HIREDATE, EMP_TITLE, EMP_COMM, DEPT_NUM)
SELECT distinct EMP_NUM, EMP_FNAME, EMP_LNAME, EMP_EMAIL, EMP_PHONE, cast(cast(EMP_HIREDATE as int) as datetime), EMP_TITLE, EMP_COMM, DEPT_NUM FROM DataSet4;

select * from EMPLOYEE order by EMP_HIREDATE asc

ALTER TABLE DEPARTMENT
ADD FOREIGN KEY (EMP_NUM) REFERENCES EMPLOYEE;


CREATE TABLE INVOICE(
INV_NUM INTEGER NOT NULL UNIQUE,
INV_DATE datetime,
CUST_CODE INTEGER NOT NULL,
INV_TOTAL numeric(16,4),
EMPLOYEE_ID INTEGER
PRIMARY KEY (INV_NUM),
FOREIGN KEY (CUST_CODE) REFERENCES CUSTOMER,
FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEE(EMP_NUM));

CREATE INDEX INVOICE_IDX
on INVOICE (CUST_CODE, EMPLOYEE_ID, INV_NUM);

INSERT INTO INVOICE (INV_NUM, INV_DATE, CUST_CODE, INV_TOTAL, EMPLOYEE_ID)
SELECT distinct INV_NUM, cast(cast(INV_DATE as int) as datetime), CUST_CODE, INV_TOTAL, EMPLOYEE_ID FROM DataSet2;

select * from INVOICE order by INV_DATE

select distinct INV_NUM from INVOICE 

CREATE TABLE PRODUCT(
PROD_SKU VARCHAR(15) NOT NULL UNIQUE,
PROD_DESCRIPT VARCHAR(255),
PROD_TYPE VARCHAR(255),
PROD_BASE VARCHAR(255),
PROD_CATEGORY VARCHAR(255),
PROD_PRICE numeric(16,4),
PROD_QOH numeric(16,4),
PROD_MIN numeric(16,4),
BRAND_ID INTEGER
PRIMARY KEY (PROD_SKU),
FOREIGN KEY (BRAND_ID) REFERENCES BRAND);



UPDATE DataSet3
SET PROD_QOH = right(PROD_QOH,2)
WHERE PROD_QOH in (SELECT PROD_QOH FROM DataSet3 where PROD_QOH like '�%')

UPDATE DataSet3
SET PROD_QOH = right(PROD_QOH,3)
WHERE PROD_QOH in (SELECT PROD_QOH FROM DataSet3 where PROD_QOH like '?%')

UPDATE DataSet3
SET PROD_QOH = right(PROD_QOH,2)
WHERE PROD_QOH in (SELECT PROD_QOH FROM DataSet3 where PROD_QOH like '?%')

UPDATE DataSet3
SET PROD_SKU = left(PROD_SKU,8)
WHERE PROD_SKU in (SELECT PROD_SKU FROM DataSet3 where PROD_SKU like '%?')

UPDATE DataSet3
SET PROD_SKU = left(PROD_SKU,8)
WHERE PROD_SKU in (SELECT PROD_SKU FROM DataSet3 where PROD_SKU like '%§')

UPDATE DataSet3
SET PROD_SKU = left(PROD_SKU,8)
WHERE PROD_SKU in (SELECT PROD_SKU FROM DataSet3 where PROD_SKU like '%û')


INSERT INTO PRODUCT (PROD_SKU, PROD_DESCRIPT, PROD_TYPE, PROD_BASE, PROD_CATEGORY, PROD_PRICE, PROD_QOH, PROD_MIN, BRAND_ID)
SELECT distinct PROD_SKU, PROD_DESCRIPT, PROD_TYPE, PROD_BASE, PROD_CATEGORY, PROD_PRICE, PROD_QOH, PROD_MIN, BRAND_ID FROM DataSet3;

select * from PRODUCT 


CREATE TABLE LINE(
INV_NUM INTEGER NOT NULL,
LINE_NUM INTEGER NOT NULL,
PROD_SKU VARCHAR(15),
LINE_QTY BIGINT,
LINE_PRICE numeric(16,4),
PRIMARY KEY (INV_NUM, LINE_NUM),
FOREIGN KEY (INV_NUM)  REFERENCES INVOICE,
FOREIGN KEY (PROD_SKU) REFERENCES PRODUCT,
CONSTRAINT LINE_UPK UNIQUE(INV_NUM, LINE_NUM));


INSERT INTO LINE (INV_NUM, LINE_NUM, PROD_SKU, LINE_QTY, LINE_PRICE)
SELECT distinct INV_NUM, LINE_NUM, PROD_SKU, LINE_QTY, LINE_PRICE FROM DataSet2;

select * from LINE 


CREATE TABLE  SALARY_HISTORY(
EMP_NUM INTEGER NOT NULL,
SAL_FROM datetime NOT NULL,
SAL_END datetime,
SAL_AMOUNT numeric(16,4),
PRIMARY KEY (EMP_NUM, SAL_FROM),
FOREIGN KEY (EMP_NUM) REFERENCES EMPLOYEE,
CONSTRAINT SALARY_HISTORY_UPK UNIQUE(EMP_NUM, SAL_FROM));



CREATE INDEX SALARY_HISTORY_IDX
on SALARY_HISTORY (EMP_NUM);

INSERT INTO SALARY_HISTORY (EMP_NUM, SAL_FROM, SAL_END, SAL_AMOUNT)
SELECT distinct EMP_NUM, cast(cast(SAL_FROM as int) as datetime), cast(cast(SAL_END as int) as datetime), SAL_AMOUNT FROM DataSet4;

select * from SALARY_HISTORY where SAL_END is NULL order by SAL_END

UPDATE SALARY_HISTORY
SET SAL_END = NULL
WHERE SAL_END = '1900-01-01 00:00:00.000'


CREATE TABLE VENDOR(
VEND_ID INTEGER NOT NULL UNIQUE,
VEND_NAME VARCHAR(255),
VEND_STREET VARCHAR(50),
VEND_CITY VARCHAR(50),
VEND_STATE VARCHAR(2),
VEND_ZIP VARCHAR(5)
PRIMARY KEY (VEND_ID));

UPDATE DataSet3
SET VEND_NAME = 'Unlimited Wholesale of Ohio' 
WHERE VEND_NAME =''

UPDATE DataSet3
SET VEND_STREET = '454 WINDJAMMER CIRCLE'
WHERE VEND_STREET =''

INSERT INTO VENDOR (VEND_ID, VEND_NAME, VEND_STREET, VEND_CITY, VEND_STATE, VEND_ZIP)
SELECT distinct VEND_ID, VEND_NAME, VEND_STREET, VEND_CITY, VEND_STATE, VEND_ZIP FROM DataSet3;

select * from VENDOR 

CREATE TABLE  SUPPLIES(
PROD_SKU VARCHAR(15) NOT NULL,
VEND_ID INTEGER NOT NULL,
PRIMARY KEY (PROD_SKU, VEND_ID),
FOREIGN KEY (PROD_SKU) REFERENCES PRODUCT,
FOREIGN KEY (VEND_ID) REFERENCES VENDOR,
CONSTRAINT SUPPLIES_UPK UNIQUE(PROD_SKU, VEND_ID));


INSERT INTO SUPPLIES (PROD_SKU, VEND_ID)
SELECT distinct PROD_SKU, VEND_ID FROM DataSet3;

select * from SUPPLIES 

