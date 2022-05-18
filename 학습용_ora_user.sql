/*���̺� ���� */
CREATE TABLE ex2_1 (
    --����
    COLUMN1 CHAR(10),
    COLUMN2 VARCHAR2(10),
    COLUMN3 NVARCHAR2(10),
    --����
    COLUMN4 NUMBER
);

--���̺� ����
DESC ex2_1;

--���ڼ� Ȯ��
SELECT name, value$
FROM sys.props$
WHERE name = 'NLS_CHARACTERSET';

--���� Ȯ��
SELECT name, value$
FROM sys.props$
WHERE name = 'NLS_LANGUAGE';

--������ ���� INSERT
INSERT INTO ex2_1(COLUMN1, COLUMN2) VALUES('abc', 'abc');
/*
column3 �� column4��??
=> �� -> NULLABLE -> YES : ��� �ȴٴ� ��
*/
INSERT INTO ex2_1(COLUMN1, COLUMN2) VALUES('������','������');

-- * : ���̺��� ��� �÷��� ��Ÿ���� ��ȣ
SELECT * FROM ex2_1;

--LENGTH() : ���ڿ��� ����Ȯ��
SELECT COLUMN1, LENGTH(COLUMN1) AS LEN1, 
        COLUMN2, LENGTH(COLUMN2) AS LEN2 
FROM ex2_1;

--LENGTHB() : ���ڿ� ������ ũ�� Ȯ��
SELECT COLUMN1, LENGTHB(COLUMN1) AS LEN1, 
        COLUMN2, LENGTHB(COLUMN2) AS LEN2 
FROM ex2_1;

CREATE TABLE ex2_2 (
    COLUMN1 VARCHAR2(3), --�Ⱦ��� BYTE
    COLUMN2 VARCHAR2(3 BYTE),
    COLUMN3 VARCHAR2(3 CHAR) --�ѱ�, ���� ������� 3�� ����
);

--�÷��� ���� : ���̺��� ��� �÷����� �ǹ�
INSERT INTO ex2_2 VALUES('abc','abc','abc');
-- = INSERT INTO ex2_2(COLUMN1, COLUMN2, COLUMN3) VALUES('abc','abc','abc');

INSERT INTO ex2_2 VALUES('abc','������','������'); --����(column2�� 3byte �� ������)
INSERT INTO ex2_2 VALUES('abc','abc','������');

SELECT * FROM ex2_2;

SELECT COLUMN3, LENGTH(COLUMN3) AS LEN1, 
                LENGTHB(COLUMN3) AS LEN2 
FROM ex2_2;



--���� ������ Ÿ�� - INTEGER, DECIMAL, NUMBER ��� ���������δ� NUMBER�� �ν�
--���� ����� NUMBER�� ���
CREATE TABLE ex2_3(
    COL_INT INTEGER,
    COL_DEC DECIMAL,
    COL_NUM NUMBER
);

--������ �Է�
INSERT INTO ex2_3 VALUES(10, 20, 30);
INSERT INTO ex2_3 VALUES(10.23, 20.45, 30.50); --NUMBER������Ÿ�Ը� �Ҽ��ڸ� �Է°� ����

SELECT * FROM ex2_3;


--user_tab_cols : �ý��� �� - ������ ���̺� �÷��� Ÿ�԰� ����
    SELECT column_id, column_name, data_type, data_length
      FROM user_tab_cols
     WHERE table_name = 'EX2_3' --���̺� ���� �빮�ڷ� ����ؾ� �� (�ҹ��ڴ� '���õ� �� ����' ���)
     ORDER BY column_id;
     
     
--��¥ ������ Ÿ��
--���̺� ����
CREATE TABLE ex2_5(
    COL_DATE        DATE, --�⺻���� null
    COL_TIMESTAMP   TIMESTAMP -- �⺻���� NULL
);

/* 
��¥ ������ �Լ�
SYSDATE : ���� �ý����� ��¥(�ʱ���)
SYSTIMESTAMP : ���� �ý����� ��¥(�и��ʱ���)

��¥ ��� ���� ���� : NLS
    ���� �� ȯ�漳�� �� �����ͺ��̽� �� NLS
*/
SELECT SYSDATE, SYSTIMESTAMP FROM DUAL; --���� ���̺��� �ƴ� ��¸� DUAL

INSERT INTO ex2_5 VALUES(SYSDATE, SYSTIMESTAMP);

SELECT * FROM ex2_5;

--20220518
--����� ���� ���̺� ����
--��

--�������� : ������ ���Ἲ�� �����ϱ� ���� ��ɾ�
/*
���̺� ���� �� ���������� �����ϴ� ���� 2���� ����
1)�÷� ���� ����
    �÷��� ������Ÿ�� �������Ǹ�ɾ�
2)���̺� ���� ����
    --CONSTRAINTS �������ǰ�ü�̸� �������Ǹ�ɾ� (�÷���)

*/
/*
���̺��� Į������ NULL, NOT NULL
1) NOT NULL : �÷��� �ݵ�� �����͸� �Է��ϰ��� �� �� ���
    NULL : ������ �Է� ����(�⺻��) -> �������� X
*/

CREATE TABLE ex2_6(
    COL_NULL        VARCHAR2(10),
    COL_NOT_NULL    VARCHAR2(10) NOT NULL --NOT NULL �������� ��ü�� ������
    --�̸��� �������� ������ ����Ŭ�� �ڵ����� �������ǰ�ü �̸��� ����(SYS_)
);

--ORA-01400: cannot insert NULL into ("ORA_USER"."EX2_6"."COL_NOT_NULL") ���� �߻�
INSERT INTO ex2_6(COL_NULL) VALUES('AA'); -- COL_NOT_NULL  �÷��� NOT NULL �̹Ƿ� �ݵ�� INSERT������ ������ �۾� �ڵ� �ؾ���

--����Ŭ������ ���� ǥ������ '' �� �ϸ� NULL �� �ǹ��Ѵ�.
INSERT INTO ex2_6 VALUES('AA','');
INSERT INTO ex2_6 VALUES('AA',NULL);

INSERT INTO ex2_6(COL_NOT_NULL) VALUES('AA'); --COL_NULL�÷��� NULL�����̹Ƿ� �Է½� ���� ����
INSERT INTO ex2_6 VALUES('AA','BB');

select * from ex2_6;

-- user_constraints :���̺� ���� �������� ������ ����Ǿ� �ִ� �ý��� ��
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'EX2_6';


/*
2) UNIQUE : �÷� ���� �����ؾ� �Ѵ�
- �����÷�
-�����÷�
-���̺� UNIQUE ���������� ������ ���� ����
*/
--�������ǰ�ü �̸��� �ߺ� X
CREATE TABLE ex2_7 (
    COL_UNIQUE_NULL     VARCHAR2(10)    UNIQUE, --UNIQUE �������� ��ü �̸��� �ڵ����� SYS_~~
    COL_UNIQUE_NNUL     VARCHAR2(10)    UNIQUE NOT NULL,
    COL_UNIQUE          VARCHAR2(10),
    --CONSTRAINTS �������ǰ�ü�̸� �������Ǹ�ɾ� (�÷���)
    CONSTRAINTS unique_nm1 UNIQUE(COL_UNIQUE)
    --�����÷�
);
CREATE TABLE ex2_7_02 (
    COL_UNIQUE_NULL     VARCHAR2(10)    UNIQUE, 
    COL_UNIQUE_NNUL     VARCHAR2(10)    UNIQUE NOT NULL,
    COL_UNIQUE          VARCHAR2(10),
    CONSTRAINTS unique_nm2 UNIQUE(COL_UNIQUE)
);
CREATE TABLE ex2_7_03 (
    COL_UNIQUE_NULL     VARCHAR2(10)    CONSTRAINTS unique_nm_01 UNIQUE, 
    COL_UNIQUE_NNUL     VARCHAR2(10)    CONSTRAINTS unique_nm_02 UNIQUE NOT NULL,
    COL_UNIQUE          VARCHAR2(10),
    CONSTRAINTS unique_nm3 UNIQUE(COL_UNIQUE)
);

--���̺� ������������ Ȯ�� �ý��� ��
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'EX2_7';
 
 --������ �Է�
INSERT INTO ex2_7 VALUES('AA','AA','AA'); --����

INSERT INTO ex2_7 VALUES('AA','AA','AA'); --ERROR
 --ORA-00001: unique constraint (ORA_USER.SYS_C007047) violated 
 --�� ���������� Ȯ��
 SELECT * FROM ex2_7;
 
 INSERT INTO ex2_7 VALUES('','BB','BB'); -- '' �� NULL / �ٸ� DBMS������ ������ �ǹ�
 INSERT INTO ex2_7 VALUES('','cc','cc'); -- NULL�� �ߺ����� ���ܵǾ� ���ȴ�
  SELECT * FROM ex2_7;
  
 INSERT INTO ex2_7 VALUES('','cc','cc'); --ERROR
 --ORA-00001: unique constraint (ORA_USER.SYS_C007048) violated
 
 --UNIQUE ���̺� ���� �������� ���� �÷� ����
CREATE TABLE ex2_temp(
    COL1    VARCHAR2(10) NOT NULL,
    COL2    VARCHAR2(10) NOT NULL,
    CONSTRAINTS unique_complex_nm1 UNIQUE(COL1, COL2)
    --���ÿ� �����ϴ� ������ �ߺ� ��� X
);

INSERT INTO ex2_temp(COL1,COL2) VALUES('AA','BB'); --����
INSERT INTO ex2_temp(COL1,COL2) VALUES('AA','AA'); --����

INSERT INTO ex2_temp(COL1,COL2) VALUES('AA','BB'); --����
--ORA-00001: unique constraint (ORA_USER.UNIQUE_COMPLEX_NM1) violated
----���ÿ� �����ϴ� ������ �ߺ� ��� X

SELECT * FROM ex2_temp; -- ctrl + enter (����)

/*
3)�⺻Ű (PRIMARY KEY) : NOT NULL + UNIQUE
- ���̺� �� 1���� ��������
-����Ű : �÷� 1���� ������� ����
-����Ű : ���� �÷��� ������� ����
*/

CREATE TABLE ex2_8 (
    COL1    VARCHAR2(10) PRIMARY KEY, -- NOT NULL + UNIQUE
    COL2    VARCHAR2(10) 
);

INSERT INTO ex2_8 VALUES('A',NULL);

INSERT INTO ex2_8(COL2) VALUES('A'); --ERROR COL1�� PRIMARY KEY ���� ���� �ݵ�� �����
--ORA-01400: cannot insert NULL into ("ORA_USER"."EX2_8"."COL1")
INSERT INTO ex2_8 VALUES('A',NULL); --ERROR COL1�� PRIMARY KEY���� �ߺ� X
--ORA-00001: unique constraint (ORA_USER.SYS_C007053) violated

--DATA �Է� Ȯ��
SELECT * FROM ex2_8;

CREATE TABLE ex2_8_02 (
    COL1    VARCHAR2(10) PRIMARY KEY, -- NOT NULL + UNIQUE
    COL2    VARCHAR2(10) PRIMARY KEY
); --ERROR
--02260. 00000 -  "table can have only one primary key"
--COL1�÷��� PRIMARY KEY, COL2�÷��� PRIMARY KEY ���̺� PRIMARY KEY�� 2�� �����Ѵٴ� �ǹ̷� �ؼ��Ǿ� �����߻�

/*
PRIMARY KEY�� ����Ű�� �����ϴ� ��� : ���̺� ���� ���� ���� ���� ���
*/
CREATE TABLE complex_1 (
    A VARCHAR2(10),
    B VARCHAR2(10),
    C VARCHAR2(10),
    CONSTRAINTS PK_COMPLEX_NM1 PRIMARY KEY(A, B)
    --�̸� ���ְ� ������ �׳� PRIMARY KEY(�÷���)
);

INSERT INTO complex_1(A,B,C) VALUES('A','B','C');
INSERT INTO complex_1(A,B,C) VALUES('A','A','C');

--�� ���� ������ ������ �Ǹ� 'A','B' �����ϹǷ� �⺻Ű�������ǿ� ���Ͽ� ���� �߻�
INSERT INTO complex_1(A,B,C) VALUES('A','B','C'); --���� A�÷��� A�� B�÷��� B�� ���� �̹� �����ϱ� ����
--ORA-00001: unique constraint (ORA_USER.PK_COMPLEX_NM1) violated

CREATE TABLE complex_2 (
    A VARCHAR2(10),
    B VARCHAR2(10),
    C VARCHAR2(10),
    CONSTRAINTS PK_COMPLEX_NM2 PRIMARY KEY(A, B, C)
);

INSERT INTO complex_2(A,B,C) VALUES('A','B','C');

INSERT INTO complex_2(A,B,C) VALUES('A','B','C'); --����
--���ÿ� 3���� �÷��� �����Ͱ� �տ� �����ϹǷ� �⺻Ű �������� ����

--������ ��� ����
INSERT INTO complex_2(A,B,C) VALUES('B','C','A');

--�������� �ý��� ��
--���̺� �� �빮�ڷ�!!!!!!!!!!!!!!!!!!!!!!!! -> ALT + '
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'EX2_8';
 
 SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'COMPLEX_1';
 
 /*
 4) ����Ű (FOREIGN KEY)
 - �⺻Ű ���̺�(dept)�� DEPT_CODE�÷��� PRIMARY KEY ������ �Ǿ� �־�� �Ѵ�
 - ����Ű ���̺�(emp)�� DEPT_CODE�÷����� dept���̺��� DEPT_CODE �÷����� �������� �ʾƵ� ��������� ���� �����ϰ� �Ѵ�.
   Ÿ���� ��ġ�ϰų� ȣȯ�Ǿ�� �Ѵ�.
   
 - ����Ű�� ����Ű �۾� ����
 */
 
 --�⺻Ű ���̺�
 CREATE TABLE dept(
    DEPT_CODE   VARCHAR2(2) PRIMARY KEY,
    DEPT_NAME   VARCHAR2(20)    NOT NULL
 );
 
 INSERT INTO dept VALUES('1','�ѹ���');
 INSERT INTO dept VALUES('2','�����ú�');
 INSERT INTO dept VALUES('3','��ȹ��');
 INSERT INTO dept VALUES('4','������');
 
 SELECT * FROM dept;
 
 --����Ű ���̺�
 --���̺� ���� ����
 CREATE TABLE emp (
    EMP_ID      VARCHAR2(2) PRIMARY KEY,
    EMP_NAME    VARCHAR2(20) NOT NULL,
    DEPT_CODE   VARCHAR2(2) NOT NULL, --dept���̺��� �μ��ڵ� �÷���� Ÿ���� ����!
    FOREIGN KEY(DEPT_CODE) REFERENCES dept(DEPT_CODE)
 );
 
 INSERT INTO emp(EMP_ID, EMP_NAME, DEPT_CODE) VALUES('1','������','5'); -- ����
 --ORA-02291: integrity constraint (ORA_USER.SYS_C007061) violated - parent key not found
 
 INSERT INTO emp(EMP_ID, EMP_NAME, DEPT_CODE) VALUES('1','������1','1'); 
 INSERT INTO emp(EMP_ID, EMP_NAME, DEPT_CODE) VALUES('2','������2','2'); 
 INSERT INTO emp(EMP_ID, EMP_NAME, DEPT_CODE) VALUES('3','������3','3'); 
 INSERT INTO emp(EMP_ID, EMP_NAME, DEPT_CODE) VALUES('4','������4','4'); 
 
 INSERT INTO emp(EMP_ID, EMP_NAME, DEPT_CODE) VALUES('5','������5','4'); 
 INSERT INTO emp(EMP_ID, EMP_NAME, DEPT_CODE) VALUES('6','������6','3'); 
 INSERT INTO emp(EMP_ID, EMP_NAME, DEPT_CODE) VALUES('7','������7','2'); 
 INSERT INTO emp(EMP_ID, EMP_NAME, DEPT_CODE) VALUES('8','������8','1'); 
 
 SELECT * FROM emp;
 
 /*
 ����޴� - DATA MODELER -> ������
 ������ �� -> ��Ŭ�� -> �� ������ ��
 */
 -- ����Ű�� ����Ű �۾� ����
 --�⺻Ű ���̺��� PRIMARY KEY�� ����Ű�� ���� �Ǿ� ���� ���, ����Ű ���̺��� ����Ű ���� ����
 --�⺻Ű ���̺��� ����Ű�� ������ �÷� A, B�� ������ ���� ����Ű ���� �� �� ����
 CREATE TABLE PARENT_TBL (
    A   VARCHAR2(10),
    B   VARCHAR2(10),
    C   VARCHAR2(10),
    CONSTRAINTS PK_PARENT_NM01 PRIMARY KEY(A,B)
 );
 SELECT * FROM PARENT_
 INSERT INTO PARENT_TBL VALUES('A','B','C');
 
 CREATE TABLE CHILD_TBL(
    A    VARCHAR2(10),
    B    VARCHAR2(10),
    C    VARCHAR2(10),
    CONSTRAINTS FK_PARENT_CHILD_NM01 FOREIGN KEY(A, B) REFERENCES PARENT_TBL(A,B)
 );
 INSERT INTO CHILD_TBL(A,B,C) VALUES('A','B','C');
  INSERT INTO CHILD_TBL(A,B,C) VALUES('A','A','C'); --����
  --ORA-02291: integrity constraint (ORA_USER.FK_PARENT_CHILD_NM01) violated - parent key not found
  
  /*
  5) CHECK ���� ���� : �÷��� �ԷµǴ� �����͸� üũ�� ���� ���ǿ� ������ �����͸� �Է��� �����ϰ� �ϴ� ���
  */
  CREATE TABLE ex2_9 (
    NUM1    NUMBER
            CONSTRAINTS check1 CHECK (NUM1 BETWEEN 1 AND 9), --1~9����
    GENDER  VARCHAR2(10)
            CONSTRAINTS check2 CHECK (GENDER IN ('MALE','FENAKE')) --MALE OR FEMALE�� ��� IN(��� ���� ��, ��� ���� ��, ...)
  );
  
  SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'EX2_9';
 
 INSERT INTO ex2_9(NUM1, GENDER) VALUES(10, 'MALE'); --ERROR 10�� �������ǿ� �ȸ���
 --ORA-02290: check constraint (ORA_USER.CHECK1) violated
 
 INSERT INTO ex2_9(NUM1, GENDER) VALUES(5, 'fenake'); --���� FENAKE�� �ҹ��ڿ���
 --ORA-02290: check constraint (ORA_USER.CHECK2) violated
 
 INSERT INTO ex2_9(NUM1, GENDER) VALUES(5, 'FENAKE');
 
 SELECT * FROM EX2_9;
 
 /*
 DEFAULT ��ɾ� : �������� ��ɾ� X
 ���̺� ������ �Է� �� DEFAULT ��ɾ ������ �÷��� ���� ����
 DEFAULT ��� �۵�
 */
 CREATE TABLE ex2_10 (
    COL1            VARCHAR2(10)    NOT NULL,
    COL2            VARCHAR2(10)    NULL,
    CREATE_DATE     DATE    DEFAULT SYSDATE --SYSDATE : ����Ŭ ��¥ �Լ�
 );
 
INSERT INTO ex2_10(COL1, COL2) VALUES('AA','AA'); --CREATE_DATE �÷��� ������ ���� -> DEFAULT �۵�

--�÷��� �����ϸ� ��� �÷����� �ǹ�
INSERT INTO ex2_10 VALUES('AA','AA'); --���� �÷��� 3���ε� ���� 2����
--00947. 00000 -  "not enough values"
INSERT INTO ex2_10 VALUES('AA','AA', DEFAULT); --����

--�̷��� �� �ʿ�� ������ �������� 
INSERT INTO ex2_10 VALUES('AA','AA', SYSDATE);

INSERT INTO ex2_10 VALUES('AA','AA', '2022.05.18'); --������ �Է� ���� - ��¥ ������ ���ڿ� ������ ��� ����

INSERT INTO ex2_10 VALUES('AA','AA', '2022.05.50'); -- ��¥ ���� �ʰ��� ����ȯ ���� �߻�
--ORA-01847: day of month must be between 1 and last day of month

INSERT INTO ex2_10 VALUES('AA','AA', '2022.05.18 21:10:00'); --����
SELECT * FROM ex2_10;

/*
���̺� ����
DROP TABLE ���̺��;

���̺� ���� �� �⺻Ű ���̺��� �����Ͱ� ������ �Ǿ����� ��쿡 ������ �ȵȴ�.
����Ű ���̺��� ���� �����ؾ� ��
*/
DROP TABLE dept; --���� �Ұ�
--02449. 00000 -  "unique/primary keys in table referenced by foreign keys"

--����Ű ���谡 �Ǿ� ���� ���, ���̺� ���� ����(���̺� ���� ������ �ݴ�)
DROP TABLE emp; --����Ű ���̺��� ���� ������ �Ǿ��, �⺻Ű ���̺��� �������� ������ ������ �� �ִ�
DROP TABLE dept; --�⺻Ű ���̺�

--���� ���̺� ������� ���� ��ɾ �����ϰ� �ٽ� dept �� emp ���̺� ���� �� ������ �Է� ����(299����)
--�Ʊ� ������� ������ �� ���� �� �ٽ� ����

--DEPT �μ� ���̺��� �⺻Ű�������� ����, EMP�ڽ����̺��� ����Ű�������� ������ �Բ� ����
--EMP�� DEPT_CODE�� ���� ����
DROP TABLE dept
CASCADE CONSTRAINTS;

--���̺� �������� ���� Ȯ��
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'DEPT';
 
 SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'EMP';
 
 SELECT    * FROM EMP;
 
 /*
 ���̺� ���� �� �������ư�ü�� �԰� ����
 */
 CREATE TABLE TEMP_01(
    COL1 VARCHAR2(10) CONSTRAINTS PR_TEMP_NM1 PRIMARY KEY
 );
 DROP TABLE TEMP_01;
  --�������ǰ�ü���� TEMP_01�� ������ TEMP_01���̺��� �����Ǹ鼭 PR_TEMP_NM1�� �Բ� �����Ǿ� TEMP_02���� ��� ����
  CREATE TABLE TEMP_02(
    COL1 VARCHAR2(10) CONSTRAINTS PR_TEMP_NM1 PRIMARY KEY
 );
 
 DROP TABLE ex2_10;
 
 --���̺� ����(ALTER TABLE) : ���̺��� ������ ����(���÷� �߰�, ����Į���� ������Ÿ�� ũ�� ����, ���� Į�� ���� ��)
 CREATE TABLE ex2_10(
    COL1    VARCHAR2(10)    NOT NULL,
    COL2    VARCHAR2(10)    NULL,
    CREATE_DATE DATE DEFAULT SYSDATE
 );

--COL1�÷����� COL11�� ����
ALTER TABLE ex2_10
RENAME COLUMN COL1 TO COL11;

--���̺� ���� ���� ��ɾ�
DESC ex2_10;

--�÷��� ������Ÿ�� ���� COL2 VARCHAR2(10) -> VARCHAR2(30)
ALTER TABLE ex2_10
MODIFY COL2 VARCHAR2(30);

-- �÷� �߰�
ALTER TABLE ex2_10
ADD COL3 NUMBER;

--�����Ͱ� ����ִ� ���¿��� �÷� �߰�
DROP TABLE ex2_10;
 CREATE TABLE ex2_10(
    COL1    VARCHAR2(10)    NOT NULL,
    COL2    VARCHAR2(10)    NULL,
    CREATE_DATE DATE DEFAULT SYSDATE
 );
 INSERT INTO ex2_10 VALUES('AA','BB',DEFAULT);
 ALTER TABLE ex2_10
RENAME COLUMN COL1 TO COL11;
ALTER TABLE ex2_10
MODIFY COL2 VARCHAR2(30);
SELECT * FROM ex2_10;
--�����Ͱ� ���� �� �÷��߰��ϸ鼭 NOT NULL �� ������������ �����ϸ� ����
ALTER TABLE ex2_10
ADD COL3 NUMBER NOT NULL;
--01758. 00000 -  "table must be empty to add mandatory (NOT NULL) column"

--�÷� �߰��� NULL�� ����
ALTER TABLE ex2_10
ADD COL3 NUMBER;

--�����Ͱ� �ϳ��� ���ǽ� ��� ���ϰ� ������ �Է�
UPDATE ex2_10
SET COL3 = 100;

SELECT * FROM ex2_10;

--�÷� ���� - �����͵� ����
ALTER TABLE ex2_10
DROP COLUMN COL3;

--�������� �߰�
DESC ex2_10;
--���̺� �������� ���� Ȯ��
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'EX2_10';
 
ALTER TABLE ex2_10
ADD PRIMARY KEY (COL11);

--�������� ����
ALTER TABLE ex2_10
DROP CONSTRAINTS SYS_C007077;


SELECT * FROM EMPLOYEES;
--���̺� ���� : PRIMARY KEY�� �����󿡼� ����
CREATE TABLE EMPLOYEES_TEMP
AS
SELECT * FROM EMPLOYEES;
--���̺� �������� ���� Ȯ��
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'EMPLOYEES';
 
 SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'EMPLOYEES_TEMP';


/*
���� ����
*/
--1)
CREATE TABLE ORDERS(
    ORDER_ID    NUMBER(12,0) PRIMARY KEY,
    ORDER_DATE  DATE,
    ORDER_MODE	VARCHAR2(8 BYTE),
    CUSTOMER_ID	NUMBER(6,0),
    ORDER_STATUS	NUMBER(2,0),
    ORDER_TOTAL	NUMBER(8,2) DEFAULT 0,
    SALES_REP_ID	NUMBER(6,0),
    PROMOTION_ID	NUMBER(6,0),
    CHECK (ORDER_MODE IN('direct', 'online'))
);
INSERT INTO ORDERS VALUES(1, '2022-05-18','direct',1,1,DEFAULT,5,5);
SELECT * FROM ORDERS;
--���̺� �������� ���� Ȯ��
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'ORDERS';

--2)
CREATE TABLE ORDER_ITEMS(
    ORDER_ID	    NUMBER(12,0),
    LINE_ITEM_ID NUMBER(3,0),
    PRODUCT_ID   NUMBER(3,0),
    UNIT_PRICE   NUMBER(8,2) DEFAULT 0,
    QUANTITY     NUMBER(8,0) DEFAULT 0,
    PRIMARY KEY(ORDER_ID, LINE_ITEM_ID)
);
--���̺� �������� ���� Ȯ��
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'ORDER_ITEMS';
 
--3)
CREATE TABLE PROMOTIONS(
    PROMO_ID	    NUMBER(6,0) PRIMARY KEY,
    PROMO_NAME   VARCHAR2(20)
);
--���̺� �������� ���� Ȯ��
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'PROMOTIONS';