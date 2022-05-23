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
/*
1) �ֹ����̺�
- ���̺� : ORDERS
- �÷� :   ORDER_ID	    NUMBER(12,0)
           ORDER_DATE   DATE 
           ORDER_MODE	  VARCHAR2(8 BYTE)
           CUSTOMER_ID	NUMBER(6,0)
           ORDER_STATUS	NUMBER(2,0)
           ORDER_TOTAL	NUMBER(8,2)
           SALES_REP_ID	NUMBER(6,0)
           PROMOTION_ID	NUMBER(6,0)
- ������� : �⺻Ű�� ORDER_ID  
             ORDER_MODE���� 'direct', 'online'�� �Է°���
             ORDER_TOTAL�� ����Ʈ ���� 0
*/
CREATE TABLE ORDERS(
    ORDER_ID        NUMBER(12,0) PRIMARY KEY,
    ORDER_DATE      DATE,
    ORDER_MODE	    VARCHAR2(8 BYTE),
    CUSTOMER_ID	    NUMBER(6,0),
    ORDER_STATUS	NUMBER(2,0),
    ORDER_TOTAL	    NUMBER(8,2) DEFAULT 0,
    SALES_REP_ID	NUMBER(6,0),
    PROMOTION_ID	NUMBER(6,0),
    CHECK (ORDER_MODE IN('direct', 'online'))
);
--�Էµǳ� Ȯ���غ�
INSERT INTO ORDERS VALUES(1, '2022-05-18','direct',1,1,DEFAULT,5,5);
SELECT * FROM ORDERS;
--���̺� �������� ���� Ȯ��
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'ORDERS';
 
--����� �� 
--�������� ���� : ���̺� ���� ����
CREATE TABLE ORDERS1(
    ORDER_ID        NUMBER(12,0),
    ORDER_DATE      DATE,
    ORDER_MODE	    VARCHAR2(8 BYTE),
    CUSTOMER_ID	    NUMBER(6,0),
    ORDER_STATUS	NUMBER(2,0),
    ORDER_TOTAL	    NUMBER(8,2) DEFAULT 0,
    SALES_REP_ID	NUMBER(6,0),
    PROMOTION_ID	NUMBER(6,0),
    CONSTRAINTS PK_ORDER  PRIMARY KEY (ORDER_ID),
    CONSTRAINTS CK_ORDER_MODE CHECK (ORDER_MODE IN('direct', 'online'))
);

/*
2)�ֹ� �� ���̺�
- ���̺� : ORDER_ITEMS 
- �÷� :   ORDER_ID	    NUMBER(12,0)
           LINE_ITEM_ID NUMBER(3,0) 
           PRODUCT_ID   NUMBER(3,0) 
           UNIT_PRICE   NUMBER(8,2) 
           QUANTITY     NUMBER(8,0)
- ������� : �⺻Ű�� ORDER_ID�� LINE_ITEM_ID
             UNIT_PRICE, QUANTITY �� ����Ʈ ���� 0
             
- ����Ű�� �⺻Ű�� ������ �� �÷������� ���� ����� ����Ͽ� �ش��ϴ� �÷����� PRIMARY KEY�� �����ϸ� ������ ��
        ORDER_ID	    NUMBER(12,0) PRIMARY KEY,
        LINE_ITEM_ID    NUMBER(3,0) PRIMARY J\KEY,
    - TABLE CAN HAVE ONLY ONE PRIMARY KEY ���� �߻�
    -> ���̺� ���� �������� �۾�
*/
-- ����Ű: �÷�1���� PRIMARY KEY
-- ����Ű: �÷� 2�� �̻��� ��� PRIMARY KEY �� ���̺� ���� ����
CREATE TABLE ORDER_ITEMS(
    ORDER_ID	    NUMBER(12,0),
    LINE_ITEM_ID    NUMBER(3,0),
    PRODUCT_ID      NUMBER(3,0),
    UNIT_PRICE      NUMBER(8,2) DEFAULT 0,
    QUANTITY        NUMBER(8,0) DEFAULT 0,
    PRIMARY KEY(ORDER_ID, LINE_ITEM_ID)
);
--���̺� �������� ���� Ȯ��
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'ORDER_ITEMS';
 
 --������ �Է�
 INSERT INTO ORDER_ITEMS(ORDER_ID, LINE_ITEM_ID, PRODUCT_ID) VALUES(921019,32, 10);
 SELECT * FROM ORDER_ITEMS;
/*
3)
- ���̺� : PROMOTIONS
- �÷� :   PROMO_ID	    NUMBER(6,0)
           PROMO_NAME   VARCHAR2(20) 
- ������� : �⺻Ű�� PROMO_ID
*/
CREATE TABLE PROMOTIONS(
    PROMO_ID	    NUMBER(6,0) PRIMARY KEY,
    PROMO_NAME   VARCHAR2(20)
);
--���̺� �������� ���� Ȯ��
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'PROMOTIONS';
 
 --����� ��
 CREATE TABLE PROMOTIONS1(
    PROMO_ID	    NUMBER(6,0) CONSTRAINTS PK_PROMOTIONS PRIMARY KEY,
    PROMO_NAME   VARCHAR2(20)
);
 CREATE TABLE PROMOTIONS2(
    PROMO_ID	    NUMBER(6,0),
    PROMO_NAME   VARCHAR2(20),
     CONSTRAINTS PK_PROMOTIONS PRIMARY KEY(PROMO_ID)
);



-----------------------------------------------------------------------------
--20220519
/*
������(SEQUENCE) : �ڵ� �Ϸù�ȣ �����ϴ� ���

������ ��ɾ�
1) ��������.NEXTVAL : INCREMENT BY �� ����Ǿ� ���� Ȥ�� ����(���̳ʽ� ���̶��)
2) ��������.CURRVAL : ���� ���� ��
*/
--��Ű��
 CREATE TABLE ��Ű��.PROMOTIONS2(
    COL1    VARCHAR2(10)
);
 CREATE TABLE ora_user.PROMOTIONS2(
    COL1    VARCHAR2(10)
);

CREATE SEQUENCE my_seq1; -- �� 1�� �����ϴ� Ư¡
--��������.NEXTVAL : INCREMENT_BY ���� ����
SELECT MY_SEQ1.nextval FROM DUAL;
--��������.CURRVAL : ���� ������ �� �б�
SELECT my_seq1.CURRVAL FROM DUAL;
--������ ����
DROP SEQUENCE my_seq1;

--�ɼ� �߰� ������ ����
CREATE SEQUENCE my_seq1
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 1000
NOCYCLE
NOCACHE;
--������ �� ����
SELECT my_seq1.nextval FROM DUAL;

--����� �ٽ� ����
CREATE SEQUENCE my_seq1
INCREMENT BY 1
START WITH 100;

CREATE SEQUENCE my_seq2
INCREMENT BY 10 --�������� ����
START WITH 100;

CREATE SEQUENCE my_seq3;
--my_seq3.NEXTVAL ��ɾ �ּ� 1�� ����� �Ŀ� ����ؾ� ��
--���� my_seq3.CURRVAL ��ɾ� ���� ���� �߻�
--08002. 00000 -  "sequence %s.CURRVAL is not yet defined in this session"
--INCREMENT BY ����� ���� Ȯ���ϱ� ����
SELECT my_seq3.CURRVAL FROM DUAL;

--�������� ����ϱ� ���� ���̺�
CREATE TABLE ex2_11_seq (
    COL1    NUMBER  PRIMARY KEY
);
CREATE SEQUENCE seq_ex2_11_seq;

--�������� �̿��� ������ �Է�
INSERT INTO ex2_11_seq(COL1) VALUES(seq_ex2_11_seq.NEXTVAL);
--INCREMENT BY ���� ���Ѽ� ������ ��ȯ���� COL1�� ����
SELECT * FROM ex2_11_seq;]

--���� ��ȣ ���
SELECT seq_ex2_11_seq.CURRVAL FROM DUAL;

/*
DML : SELECT, INSERT, UPDATE, DELETE 
*/
/*
�⺻ ����, ��� ���� ���� X
SELECT �÷���, ...
FROM ���̺��
WHERE ���ǽ�
ORDER BY ����

���ۼ���
1) FROM ���̺�� : �޸𸮻� ���̺���� ��� �÷��� �����Ͱ� �ε� ��> 100�� ������ ��
2) WHERW ���ǽ� : �޸��� 100���� ������ �� ���ǿ� �ش��ϴ� ������ ����
3) ORDER BY : ���� ��ɾ ����Ͽ�, �޸��� �����͸� ����
4) SELECT �÷���1, �÷���2, ... : SELECT ������ ����� �÷��� ���(��ȸ)
*/

--EMPLOYEES ���̺��� ��� �����͸� ���(��ȸ)�϶�

-- * : ���̺��� ��� �÷����� �ǹ�, ���� �� �ڵ忡 ����� ���� �ʴ´�(������ ������)
SELECT * FROM EMPLOYEES;
--������ EMPLOYEES ���̺��� ��� �÷� �������
SELECT employee_id, EMP_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, SALARY, MANAGER_ID, COMMISSION_PCT, RETIRE_DATE, DEPARTMENT_ID, JOB_ID, CREATE_DATE, UPDATE_DATE
FROM EMPLOYEES;

--�Ϲ� �۾� �� ��Ű�� ���� �����Ѵ�. ��) ORA_USER.EMPLOYEES
--���� �� ����� �������� ��Ű�������� ���Ǳ� ������

--���� ORA_USER ������̹Ƿ� ������ ����
--1)��Ű�� �� ����
SELECT employee_id, EMP_NAME FROM EMPLOYEES;
--2) ��Ű�� �� ���
SELECT EMP_NAME, employee_id, SALARY  FROM ORA_USER.EMPLOYEES; --�����ٲٱ�

--���� ����
--EMPLOYEES ���̺��� ������ 2�� �λ� �� ��� ���
SELECT employee_id, EMP_NAME, SALARY, SALARY * 2, SALARY * 0.7, SALARY - (SALARY * 0.3)
FROM EMPLOYEES;

--���ڿ� ���� ������ : ||
--��Ī ���� : AS
SELECT EMP_NAME ||  '   ' || employee_id || '   :    ' || SALARY AS PROFILE
FROM EMPLOYEES;

--����(QUERY) ���� : ������̺��� �޿�(����)�� 5000���� ū ������ ��ȸ
SELECT *
FROM EMPLOYEES --107��
WHERE SALARY > 5000; --58��

--ORDER BY : ����
/*
1)�÷� 1�� ����
���� ���� : ORDER BY �÷��� ASC;
�������� ORDER BY �÷��� DESC;

2)�÷� 2�� ����
ORDER BY �÷���1 ASC, �÷���2 DESC;
*/
--EMPLOYEE_ID �������� ����
SELECT *
FROM EMPLOYEES --107��
WHERE SALARY > 5000 --58��
ORDER BY EMPLOYEE_ID; --ORDER BY EMPLOYEE_ID ASC;
--EMP_NAME �������� ����
SELECT *
FROM EMPLOYEES --107��
WHERE SALARY > 5000 --58��
ORDER BY EMP_NAME;

--�μ�ID �������� ����
SELECT emp_name, DEPARTMENT_ID, SALARY
FROM EMPLOYEES --107��
WHERE SALARY > 5000 --58��
ORDER BY DEPARTMENT_ID;

--�μ�ID �������� ����, SALARY �������� ����
--�μ�ID ���� ������������ ���� �� ���� �μ�ID �߿��� SALARY�� �������� ����
SELECT emp_name, DEPARTMENT_ID, SALARY
FROM EMPLOYEES --107��
WHERE SALARY > 5000 --58��
ORDER BY DEPARTMENT_ID,SALARY DESC ;

--���� ����
/*
AND
OR
*/
--SALARYRY 5000�̻��̰� JOB_ID�� 'IT_PROG'�� ����� ��ȸ
SELECT *
FROM EMPLOYEES
WHERE SALARY >= 5000 AND JOB_ID = 'IT_PROG';
--SALARYRY 5000�̻��̰ų� JOB_ID�� 'IT_PROG'�� ����� ��ȸ
SELECT *
FROM EMPLOYEES
WHERE SALARY >= 5000 OR JOB_ID = 'IT_PROG';

--�÷� ��Ī
SELECT employee_id AS �����ȣ, EMP_NAME AS �����
FROM EMPLOYEES;

SELECT employee_id AS �� �� �� ȣ, EMP_NAME AS �� �� ��
FROM EMPLOYEES;--����
SELECT employee_id AS "�� �� �� ȣ", EMP_NAME AS "�� �� ��"
FROM EMPLOYEES;

--1)���̺��.�÷���
SELECT EMPLOYEES.employee_id, EMPLOYEES.EMP_NAME
FROM EMPLOYEES;
--2)���̺�� ����
SELECT employee_id, EMP_NAME
FROM EMPLOYEES; 

--INSERT �� : ���̺� ������ �Է�
CREATE TABLE ex3_1 (
    COL1    VARCHAR2(10)    NULL, --NULL ���� ����
    COL2    NUMBER  NULL,
    COL3    DATE    NULL
);
--�÷��� ���̺��� �ۼ��� �������
INSERT INTO ex3_1(col1, COL2, COL3) VALUES('ABC',10, SYSDATE); --����Ŭ�� ��¥�Լ� : SYSDATE
--���� �ٲ㵵 �Ǳ� ��, �Է� �÷����� ������ ���� ����
INSERT INTO ex3_1( COL2,col1, COL3) VALUES(27,'DEF', SYSDATE);
--�Է��ϴ� ���� �÷��� ������Ÿ�԰� ��ġ�ؾ� ��
INSERT INTO ex3_1(COL3, col1, COL2 ) VALUES ('ABC',10, 30);-- ����

--�÷��� ���� �� ��� �÷����� ����Ŵ
INSERT INTO ex3_1 VALUES('GHI',10, SYSDATE);
--�÷��� �Ϻθ� ������ ��� : �÷��� NULL���� OR �÷��� DEFAULT�� ���
--COL3�� ���� ������ ����? COL3 DATE NULL
INSERT INTO ex3_1(COL1, COL2) VALUES('GHI',21);
SELECT * FROM ex3_1;
--INSERT ���� �⺻ ��Ģ : �÷��� ������ ���� ��ġ�ؾ� �ϰ�, ���� �÷��� ������ Ÿ���� �����ؾ� �Ѵ�

--���� NULL��� : �÷��� NULL������ �״�� ����
INSERT INTO ex3_1 VALUES(NULL, NULL, NULL);
--��¥������ ���ڿ������͸� ��¥�����ͷ� ��밡��
/*
VALUES(10,'10','2022-05-19')
    10 -> '10' : COL1�÷��� VARCHAR2(10)
    '10' -> 10 : COL2�÷��� NUMBER
    '2022-05-19' -> ��¥Ÿ������ ��ȯ : COL3�÷��� DATE
*/
INSERT INTO ex3_1(col1, COL2, COL3) VALUES(10,'10','2022-05-19');


--���̺� ���� : PRIMARY KEY�� �����󿡼� ����
--���̺��� ���� ����
CREATE TABLE EMPLOYEES_TEMP
AS
SELECT * FROM EMPLOYEES;
/*
INSERT~SELECT��
������ �����ϴ� ���̺� �ټ��� ������ ����
*/
CREATE TABLE ex3_2(
    EMP_ID  NUMBER,
    EMP_NAME    VARCHAR2(100)
);
--ex3_2���̺� EMPLOYEES���� ������ 5000���� ū �����͸� �����ȣ, ����̸��� �����͸� ����
INSERT INTO ex3_2(EMP_ID, EMP_NAME)
SELECT employee_id, EMP_NAME
FROM EMPLOYEES
WHERE SALARY > 5000;


--UPDATE��
--���̺��� �����͸� ������ �� ����ϴ� ��ɾ�
SELECT * FROM ex3_1;

--WHERE�� �����ϸ� ���̺��� ��� �����͸� ������� ����
UPDATE ex3_1
SET COL2 = 50; --COL1�� �����͸� ���� 50���� ����

UPDATE ex3_1
    SET COL2 = 10, COL3 = '2022-05-20'
WHERE COL1 = 'GHI'; 

--COL3�÷��� NULL�� �����͸� ��ȸ
--�߸��� ��
SELECT *
FROM ex3_1
WHERE COL3 = ''; --����Ŭ���� ''�� NULL�� �ǹ����� ���ǽĿ����� NULL�� �ƴ�
--NULL��ȸ�� IS NULL
SELECT *
FROM ex3_1
WHERE COL3 IS NULL;
--COL3�÷��� �����Ͱ� �����ϴ� �� : IS NOT NULL
SELECT *
FROM ex3_1
WHERE COL3 IS NOT NULL;

/*
DELETE : ���̺��� ����Ÿ ����

DELETE ���̺��
WHERE ���ǽ�
*/
SELECT * FROM ex3_1;

DELETE ex3_1; --���̺��� ��� ������ ����!!!!!!!! ����!!!!!!!!!!!!!!!

DELETE ex3_1
WHERE COL1 = '10';


--���̺� INSERT, UPDATE, DELETE �۾��� �ӽû��¿��� ����
--���������� DOCMALL.DBF ���Ͽ� ������ �ȵ� ����

--���̺��� �ӽû��¿� �ִ� INSERT, UPDATE, DELETE �۾��� ��� ���
ROLLBACK;
--���̺��� �ӽû��¿� �ִ� INSERT, UPDATE, DELETE �۾��� ��� �ݿ�
COMMIT;

--COMMIT�� ROLLBACK�� �׽�Ʈ�ϱ� ���� ������ �۾�
INSERT INTO ex3_1(col1, COL2, COL3) VALUES('ABC',10, SYSDATE);
INSERT INTO ex3_1(col1, COL2, COL3) VALUES('DEF',20, SYSDATE);
INSERT INTO ex3_1(col1, COL2, COL3) VALUES('ABC',30, SYSDATE);
INSERT INTO ex3_1(col1, COL2, COL3) VALUES('DEF',40, SYSDATE);
INSERT INTO ex3_1(col1, COL2, COL3) VALUES('GHI',50, SYSDATE);

COMMIT;
--���������� �ݿ� ��
SELECT * FROM ex3_1;

DELETE ex3_1;
--������ -> �ӽ��۾�
SELECT * FROM ex3_1;
--�����Ȱ� Ȯ��

ROLLBACK;
--COMMIT�۾� ������ �ֽ��۾��� ��ҽ����ִ� ��
SELECT * FROM ex3_1;

COMMIT; --���������� �ݿ�

/*
TRUNCATE TABLE ���̺��: ���̺��� ��� �����͸� ������Ű�� ȿ��(�ν��� ���ϰ� �Ѵ�)
                        ROLLBACK ��ɾ� �ǹ� X (�α׿� ��� X����)
DELETE ���̺�� : ���̺��� ��� �����͸� ����
*/
TRUNCATE TABLE ex3_1;

SELECT * FROM EMPLOYEES;

/*
�ǻ��÷�(Pseudo-column)
���̺� �������� �ʴ´�
���̺��� �÷�ó�� �����ϴ� Ư¡�� �ִ�
SELECT������ ����� �� ������ INSERT, UPDATE, DELETE���� ����� �� ����.
*/
--ROWNUM : ���̺� ���������� ��� ����, �������� �ε���(�Ϸù�ȣ)�� ���ʴ�� �ο��ϴ� Ư¡
SELECT ROWNUM, employee_id, EMP_NAME 
FROM EMPLOYEES;

SELECT ROWNUM, employee_id, EMP_NAME 
FROM EMPLOYEES
WHERE SALARY > 10000;

SELECT employee_id, EMP_NAME 
FROM EMPLOYEES
WHERE ROWNUM <= 5;

--ROWID : ���̺� ����� �� �ο�(��, ���� ������)�� ����� �ּҰ��� ����Ű�� �ǻ��÷�
SELECT employee_id, EMP_NAME, ROWID
FROM EMPLOYEES
WHERE ROWNUM <= 5;

/*
WHERE ���ǽ�
ANY, ALL, SOME
*/
--1)ANY : � ���̵�
SELECT employee_id, SALARY
FROM EMPLOYEES
WHERE SALARY = ANY(2000, 3000, 4000)
ORDER BY employee_id;
--2)
SELECT employee_id, SALARY
FROM EMPLOYEES
WHERE SALARY = IN(2000, 3000, 4000)
ORDER BY employee_id;
--3)
SELECT employee_id, SALARY
FROM EMPLOYEES
WHERE SALARY = 2000 OR SALARY = 3000 OR SALARY = 4000
ORDER BY employee_id;

--4) SOME
SELECT employee_id, SALARY
FROM EMPLOYEES
WHERE SALARY = SOME(2000, 3000, 4000)
ORDER BY employee_id;

--ALL�� AND �������� ��ȯ �� �� ����
--��� ������ ���ÿ� �����ؾ� ��
SELECT employee_id, SALARY
FROM EMPLOYEES
WHERE SALARY = ALL(2000, 3000, 4000)
ORDER BY employee_id;

--BETWEEN A AND B (���ǽ�)
SELECT employee_id, SALARY
FROM EMPLOYEES
WHERE SALARY BETWEEN 2000 AND 4000
ORDER BY employee_id;
--AND�� ��ȯ ����
SELECT employee_id, SALARY
FROM EMPLOYEES
WHERE SALARY >= 2000 AND SALARY <= 4000
ORDER BY employee_id;

--NOT ���ǽ�
SELECT employee_id, SALARY
FROM EMPLOYEES
WHERE NOT (SALARY >= 2500)
ORDER BY employee_id;
--�Ʒ��� ����
SELECT employee_id, SALARY
FROM EMPLOYEES
WHERE SALARY < 2500
ORDER BY employee_id;


--================================================================================
--20220520
--ANY 2-1)
SELECT employee_id, SALARY
FROM EMPLOYEES
WHERE SALARY NOT IN(2000, 3000, 4000)
ORDER BY employee_id;

-- ǥ����
/*
CASE����
����1>
CASE ��� 
    WHEN ��1 THEN ���1 
    WHEN ��2 THEN ���2 . . . 
    WHEN ��n THEN ���m 
    ELSE ���
END;

����2>
CASE 
    WHEN ����1 THEN ���1 
    WHEN ����2 THEN ���2 . . . 
    WHEN ����3 THEN ���m 
    ELSE ���
END;
*/
--����1
SELECT employee_id, JOB_ID,
    CASE JOB_ID
        WHEN 'IT_PROG' THEN 'Programmer'
        WHEN 'MK_MAN' THEN 'Marketing Manager'
        WHEN 'HR_REP' THEN 'Human Resources Representative'
        ELSE 'ETC'
    END AS �����̸� --�����Ͱ� �ƴϰ� �÷����̶� '' �ϸ� �ȵ� Ȥ�� "���� �̸�" �̷��� 
FROM EMPLOYEES;

/*����2
��� ���̺��� �� ����� �޿��� ���� 
   5000 ���Ϸ� �޿��� �޴� ����� C, 
   5000~15000�� B, 
   15000 �̻��� A����� 
   ��ȯ�ϴ� ������ �ۼ��� ����.
*/
SELECT EMPLOYEE_ID, SALARY,
    CASE WHEN SALARY <= 5000 THEN 'C���'
         WHEN SALARY > 5000 AND SALARY <= 15000 THEN 'B���'
         ELSE 'A���'
    END AS SALARY_GRADE
FROM EMPLOYEES;

--LIKE
/*
��������
WHERE �÷��� LIKE '���ڿ�����'
�÷����� ���ڿ� ������Ÿ���̾�� ��(CHAR, VARCHAR2)
��, CLOB�� ����� �� �� ����
*/
--������̺��� ����̸��� ��A���� ���۵Ǵ� ��� ��ȸ
SELECT EMP_NAME
FROM EMPLOYEES
WHERE EMP_NAME LIKE 'A%'; -- % : 0�� �̻��� ���ڿ� WHERE EMP_NAME LIKE 'A'�� ����(A�ѱ��ڸ��� ����)
SELECT EMP_NAME
FROM EMPLOYEES
WHERE EMP_NAME LIKE 'Al%'; --'Al'����

--  _ : 1���� ����
--��) 'A__B' : ���̰� 4�̾�� �ϰ� 1��° ���ڴ� A, 2,3��° ���ڴ� ��� ���� 4��°���ڴ� B
SELECT EMP_NAME
FROM EMPLOYEES
WHERE EMP_NAME LIKE 'Al_x%'; --3��° ��ġ�� _ (�����)�� �ǹ̴� ����� ��ġ�� � 1���� ���ڰ� �͵� ��� ����

--���� ������
CREATE TABLE ex3_5 (
    NAMES VARCHAR2(30)
);
INSERT INTO ex3_5 VALUES('����');
INSERT INTO ex3_5 VALUES('������');
INSERT INTO ex3_5 VALUES('������');
INSERT INTO ex3_5 VALUES('������');
INSERT INTO ex3_5 VALUES('�������');

SELECT * FROM ex3_5;

--�̸��� '����'�� �����ϴ� �̸��� ��ȸ�϶�
SELECT * FROM ex3_5
WHERE NAMES LIKE '����%';

--�̸��� '����'�� �����ϴ� �̸��� 3���� ��츸 ��ȸ
SELECT * FROM ex3_5
WHERE NAMES LIKE '����_';

--�̸��� '����' ��� �ܾ �����ϴ� �����͸� ��ȸ�϶�
SELECT * FROM ex3_5
WHERE NAMES LIKE '%����%';

--�̸��� '����' ��� �ܾ�� ������ �����͸� ��ȸ�϶�
SELECT * FROM ex3_5
WHERE NAMES LIKE '%����';

/*
CLOB ��뷮 ������Ÿ�� : ���� �̽�, �ڷ�Ȯ�� ����
*/
CREATE TABLE ex3_5_2(
    NAMES CLOB --4GB ��뷮 ������ Ÿ��
);
INSERT INTO ex3_5_2 VALUES('����');
INSERT INTO ex3_5_2 VALUES('������');
INSERT INTO ex3_5_2 VALUES('������');
INSERT INTO ex3_5_2 VALUES('������');
INSERT INTO ex3_5_2 VALUES('�������');

SELECT * FROM ex3_5_2;

SELECT * FROM ex3_5_2
WHERE NAMES LIKE '����%';

--ORDER BY ����: ���� �ȵ�
SELECT * FROM ex3_5_2
ORDER BY NAMES;

SELECT LENGTH(NAMES) FROM ex3_5_2; --���ڿ� ���� -> ����
SELECT LENGTHB(NAMES) FROM ex3_5_2; --������ ũ�� -> �Ұ���
--22998. 00000 -  "CLOB or NCLOB in multibyte character set not supported"

-- ������. 4GB�� �Ѱ��Ѱ� �ߺ� �� ���� ��
CREATE TABLE ex3_5_2(
    NAMES CLOB PRIMARY KEY --4GB ��뷮 ������ Ÿ��
);

/*
����Ŭ �Լ�
1) ���� �Լ��� ���� ������ �ϴ� ������ �ϴ� �Լ��� ���� ��� ��, �Ű������� ��ȯ ���� ��κ� ���� ����
*/
--DUAL ���̺�
--SELECT�� ���� �������� ������ ���߱� ���Ͽ� ����ϴ� Ư���� ���̺�
SELECT 10 + 20 FROM DUAL;

/*
�� ABS(n)
ABS �Լ��� �Ű������� ���ڸ� �޾� �� ���밪�� ��ȯ�ϴ� �Լ���.
*/
SELECT ABS(10), ABS(-10), ABS(-10.23) FROM DUAL;

/*
�� CEIL(n) :�ø��Լ� �� FLOOR(n):�����Լ�
CEIL �Լ��� �Ű����� n�� ���ų� ���� ū ������ ��ȯ�Ѵ�.
*/
SELECT CEIL(10.123), CEIL(10.541), CEIL(11.001), CEIL(11.000) FROM DUAL;
SELECT FLOOR(10.123), FLOOR(10.541), FLOOR(11.001), FLOOR(11.000) FROM DUAL;

/*
�� ROUND(n, i)�� TRUNC(n1, n2)
ROUND �Լ��� �Ű����� n�� �Ҽ��� ���� (i+1)�� °���� �ݿø��� ����� ��ȯ�Ѵ�. 
i�� ������ �� �ְ� ����Ʈ ���� 0, �� �Ҽ��� ù ��° �ڸ����� �ݿø��� �Ͼ ���� �κ��� ���� �ڸ��� ����� �ݿ��ȴ�.
*/
--�⺻(�Ҽ� ù°�ڸ����� �ݿø��Ͽ� �����κп� �ݿ�)
SELECT ROUND(10.154), ROUND(10.541), ROUND(11.001) FROM DUAL;
--2��° �Ķ���Ͱ� ����� ���, �Ҽ��ڸ��� �����Ͽ� �ݿø� �ݿ�
SELECT ROUND(10.154, 1), ROUND(10.541, 2), ROUND(10.154, 3) FROM DUAL;
--2��° �Ķ���Ͱ� ������ ���, �����ڸ��� �����Ͽ� �ݿø� üũ
SELECT ROUND(0, 3), ROUND(115.155, -1), ROUND(115.115, -2) FROM DUAL;

--������ �ڸ��� ���ĸ� ���� : TRUNC
SELECT TRUNC(115.155), TRUNC(115.155, -1), TRUNC(115.155, 2), TRUNC(115.155, -2) FROM DUAL;

--������
--      3�� 2��       3�� 3��
SELECT POWER(3, 2), POWER(3, 3), POWER(3, 3.0001)
  FROM DUAL;  
--����
SELECT POWER(-3, 3.0001) FROM DUAL;  
--��Ʈ
SELECT SQRT(2), SQRT(5)
  FROM DUAL;
  
  /*
 REMAINDER �Լ� ���� n2�� n1���� ���� ������ ���� ��ȯ�ϴµ�, 
 �������� ���ϴ� ������ ���� ����� MOD �Լ��ʹ� �ణ �ٸ���.

? MOD �� n2 - n1 * FLOOR (n2/n1)

? REMAINDER �� n2 - n1 * ROUND (n2/n1)
 */
SELECT MOD(19,4), MOD(19.123, 4.2) FROM DUAL;
SELECT REMAINDER(19,4), REMAINDER(19.123, 4.2) FROM DUAL;

SELECT REMAINDER(18,4) FROM DUAL;

/*
�����Լ�
�� INITCAP(char), LOWER(char), UPPER(char)
INITCAP �Լ��� �Ű������� ������ char�� ù ���ڴ� �빮�ڷ�, �������� �ҹ��ڷ� ��ȯ�ϴ� �Լ���.
*/
SELECT INITCAP('never say goodbye'), INITCAP('never6say*good��bye') FROM DUAL;
SELECT LOWER('NEVER SAY GOODBYE'), UPPER('never say goodbye') FROM DUAL;
--�÷��� ����
SELECT EMP_NAME, LOWER(EMP_NAME) FROM EMPLOYEES;

/*
CONCAT(char1, char2), SUBSTR(char, pos, len), SUBSTRB(char, pos, len)
CONCAT �Լ��� ��||�� ������ó�� �Ű������� ������ �� ���ڸ� �ٿ� ��ȯ�Ѵ�.
*/
-- CONCAT �Լ��� ��||�� ������ó�� �Ű������� ������ �� ���ڸ� �ٿ� ��ȯ�Ѵ�.  
-- �Ű������� 2���� ����
SELECT CONCAT('I Have', ' A Dream'), 'I Have' || ' A Dream' || '!!!' FROM DUAL;

SELECT SUBSTR('ABCD EFG', 1, 4) FROM DUAL;
SELECT SUBSTR('ABCDEFT', 1, 4), SUBSTR('ABCDEFG', -2, 4) FROM DUAL;

SELECT LENGTHB('ȫ') FROM DUAL;
SELECT SUBSTRB('ABCDEFG', 1, 4), SUBSTRB('�����ٶ󸶹ٻ�',1, 4) FROM DUAL;

/*
�� LTRIM(char, set), RTRIM(char, set)
LTRIM �Լ��� �Ű������� ���� char ���ڿ����� set���� ������ ���ڿ��� ���� ������ ������ �� ������ ���ڿ��� ��ȯ�Ѵ�.
�� ��° �Ű������� set�� ������ �� ������, ����Ʈ�� ���� ���� �� ���ڰ� ���ȴ�. 
RTRIM �Լ��� LTRIM �Լ��� �ݴ�� ������ ������ ������ �� ������ ���ڿ��� ��ȯ�Ѵ�.
*/
--1) ����, ���� ��������
SELECT LENGTH('     ABCDEF'), LENGTH('ABCDEF     ') FROM DUAL;
SELECT LENGTH(LTRIM('     ABCDEF')), LENGTH(RTRIM('ABCDEF     ')) FROM DUAL;

--2)�� ��° �Ķ���͸� ���� �Ǵ� �������� ������ �������� ��ȯ
SELECT
    LTRIM('ABCDEFGABC' ,'ABC'),
    LTRIM('�����ٶ�', '��'),
    RTRIM('ABCDEFGABC', 'ABC'),
    RTRIM('�����ٶ�', '��')
FROM DUAL;

--������ �� �ִ� ������ �ƴϾ �ڽ��� ��ȯ
SLELECT LTRIM('�����ٶ�', '��'), RTRIM('�����ٶ�','��') FROM DUAL;

/*
�� LPAD(expr1, n, expr2), RPAD(expr1, n, expr2)
LPAD �Լ��� �Ű������� ���� expr2 ���ڿ�(������ �� ����Ʈ�� ���� �� ����)�� n�ڸ���ŭ ���ʺ��� ä�� expr1�� ��ȯ�ϴ� �Լ���. 
�Ű����� n�� expr2�� expr1�� ������ ��ȯ�Ǵ� �� �ڸ����� �ǹ��Ѵ�.
*/
CREATE TABLE ex4_1 (
    phone_num VARCHAR2(30)
);

INSERT INTO ex4_1 VALUES('111-1111');
INSERT INTO ex4_1 VALUES('111-2222');
INSERT INTO ex4_1 VALUES('111-3333');

SELECT * FROM ex4_1;
--������ȣ�� �߰��ϰڴ�
SELECT LPAD(phone_num, 12, '(02)') FROM ex4_1; --phone_num�÷��� �����͸� 12�ڸ��� ǥ���ϴµ� ���� 4�ڸ��� (02)�� ä����
SELECT RPAD(phone_num, 12, '(02)') FROM ex4_1;

/*
�� REPLACE(char, search_str, replace_str), TRANSLATE(expr, FROM_str, to_str)
REPLACE �Լ��� char ���ڿ����� search_str ���ڿ��� ã�� �̸� replace_str ���ڿ��� ��ü�� ����� ��ȯ�ϴ� �Լ���.
TRANSLATE �Լ��� REPLACE�� �����ϴ�. expr ���ڿ����� FROM_str�� �ش��ϴ� ���ڸ� ã�� to_str�� �ٲ� ����� ��ȯ
*/
SELECT REPLACE('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�?', '��','��') FROM DUAL;
--'��'�� �˻��ؼ� '��'�� �ٲ�
SELECT 
    LTRIM(' ABC DEF '),
    RTRIM(' ABC DEF '),
    REPLACE(' ABC DEF ', ' ', '')
FROM DUAL;

--TRANSLATE : ���ڿ� ��ü�� �ƴ� ���� �� ���ھ� ������ �ٲ� ����� ��ȯ
--REPLACE : �ܾ(���ڿ�) �˻��Ͽ� �ٲٱ�(���ڿ��� �ϳ��� ��� ã��)
--TRANSLATE : ���� 1���� ���� ã�Ƽ� �����ϴ� �ٲٱ�
SELECT REPLACE('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�?', '����', '�ʸ�') AS rep,
       TRANSLATE('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�?', '����', '�ʸ�') AS trn
  FROM DUAL;


/*
�� INSTR(str, substr, pos, occur), LENGTH(chr), LENGTHB(chr)
INSTR �Լ��� str ���ڿ����� substr�� ��ġ�ϴ� ��ġ�� ��ȯ�ϴµ�, pos�� ���� ��ġ�� ����Ʈ ���� 1, occur�� �� ��° ��ġ�ϴ����� ����ϸ� ����Ʈ ���� 1�̴�.
*/
SELECT 
    INSTR('���� ���� �ܷο� ����, ���� ���� ���ο� ����, ���� ���� ��ſ� ����', '���࿡') AS INSTR, --0
    INSTR('���� ���� �ܷο� ����, ���� ���� ���ο� ����, ���� ���� ��ſ� ����', '����') AS INSTR1, --4
    INSTR('���� ���� �ܷο� ����, ���� ���� ���ο� ����, ���� ���� ��ſ� ����', '����', 5) AS INSTR2,-- 18 - ���ڿ� 5��° ��ġ���� �˻�����
    INSTR('���� ���� �ܷο� ����, ���� ���� ���ο� ����, ���� ���� ��ſ� ����', '����', 5, 2) AS INSTR3 --32 - ���ڿ� 5���� ��ġ�����˻� ����, 2���� ��ġ�Ǵ� ���ڿ�
FROM DUAL;

/*��¥�Լ�
�� SYSDATE, SYSTIMESTAMP
SYSDATE�� SYSTIMESTAMP�� �������ڿ� �ð��� ���� DATE, TIMESTAMP ������ ��ȯ�Ѵ�.
*/
SELECT SYSDATE, SYSTIMESTAMP FROM DUAL;

CREATE TABLE TEST (
    COL1    DATE,
    COL2    TIMESTAMP
);

INSERT INTO TEST VALUES(SYSDATE, SYSTIMESTAMP);

SELECT * FROM TEST;

/*
�� ADD_MONTHS (date, integer)
ADD_MONTHS �Լ��� �Ű������� ���� ��¥�� interger ��ŭ�� ���� ���� ��¥�� ��ȯ�Ѵ�.
*/
SELECT SYSDATE, ADD_MONTHS(SYSDATE, 1), ADD_MONTHS(SYSDATE, -1) FROM DUAL;

/*
�� MONTHS_BETWEEN(date1, date2)
MONTHS_BETWEEN �Լ��� �� ��¥ ������ ���� ���� ��ȯ�ϴµ�, date2�� date1���� ���� ��¥�� �´�.
*/
SELECT
    MONTHS_BETWEEN(SYSDATE, ADD_MONTHS(SYSDATE, 1)) Mon1,
    MONTHS_BETWEEN(ADD_MONTHS(SYSDATE, 1), SYSDATE) MON2
FROM DUAL;

/*
�� LAST_DAY(date)
LAST_DAY�� date ��¥�� �������� �ش� ���� ������ ���ڸ� ��ȯ�Ѵ�.
*/
SELECT LAST_DAY(SYSDATE), LAST_DAY('2020-08-01') FROM DUAL;

/*
�� ROUND(date, format), TRUNC(date, format)
ROUND�� TRUNC�� ���� �Լ��̸鼭 ��¥ �Լ��ε� ���̴µ�, ROUND�� format�� ���� �ݿø��� ��¥��, TRUNC�� �߶� ��¥�� ��ȯ�Ѵ�.
*/
SELECT SYSDATE, ROUND(SYSDATE, 'month'), TRUNC(SYSDATE, 'month') FROM DUAL;

--��¥ �����͵� �ݿø�(ROUND), ����(TRUNC)�� ���� �ִ�.
--��¥ �����Ͱ� 15�� �ݿø� �ȵ�, 16�� �̻��̸� �ݿø�
SELECT 
    ROUND(TO_DATE('2022-05-15'), 'month'), 
    ROUND(TO_DATE('2022-05-16'), 'month'), 
    TRUNC(TO_DATE('2022-05-15'), 'month') 
FROM DUAL;

/*
�� NEXT_DAY (date, char)
NEXT_DAY�� date�� char�� ����� ��¥�� ���� �� ���� ���ڸ� ��ȯ�Ѵ�.
*/
SELECT NEXT_DAY(SYSDATE, '�ݿ���') FROM DUAL;

/*
����ȯ �Լ�
�� TO_CHAR (���� Ȥ�� ��¥, format)
���ڳ� ��¥�� ���ڷ� ��ȯ�� �ִ� �Լ��� �ٷ� TO_CHAR��, �Ű������δ� ���ڳ� ��¥�� �� �� �ְ� ��ȯ ����� Ư�� ���Ŀ� �°� ����� �� �ִ�
*/
SELECT TO_CHAR(123456789) FROM DUAL; --���� 123456789 �� ���ڿ� 123456789�� ��ȯ
SELECT TO_CHAR(123456789, '999,999,999') FROM DUAL; --���� 123456789 �� ���ڿ� 123456789�� ��ȯ�ϴµ� ������ ����

DESC EMPLOYEES;
SELECT HIRE_DATE, TO_CHAR(HIRE_DATE) FROM EMPLOYEES;
SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'MONTH') FROM EMPLOYEES; --��
SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'DAY') FROM EMPLOYEES; --����
SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'YYYY') FROM EMPLOYEES; --�⵵ 4�ڸ�
SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'YY') FROM EMPLOYEES; --�⵵ 2�ڸ�

SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'D') FROM EMPLOYEES; --������ ���ڷ�
SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'DD') FROM EMPLOYEES; --��
SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'DDD') FROM EMPLOYEES; --1�� 1�Ϻ��� ��ĥ°

SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') FROM EMPLOYEES;

--��¥ ���� �˻�
--1)
SELECT HIRE_DATE FROM EMPLOYEES
WHERE HIRE_DATE > '2007-06-01'
ORDER BY HIRE_DATE ASC;

--2) 1���� TO_DATE ������ ������
SELECT HIRE_DATE FROM EMPLOYEES
WHERE HIRE_DATE > TO_DATE('2007-06-01')
ORDER BY HIRE_DATE ASC;

--3) 1), 2)�� ���� ������ ���ϵ�
--HIRE_DATE�� ������ ����ŭ TO_CHAR() ����
SELECT HIRE_DATE FROM EMPLOYEES
WHERE TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') > '2007-06-01'
ORDER BY HIRE_DATE ASC;
--����� 1), 2), 3) ��� ����
--1), 2) ����ȯ���� TO_DATE()�ε����� ���� -> '2007-06-01'�� ����ȯ ��
--3) TO_CHAR()�� ����

--�Ⱓ�� ��¥�˻�
--'2005-12-24' -> 2005-12-24 00:00:00, '2007-06-21' -> 2007-06-21 00:00:00
--2005-12-24 00:00:00 ~ 2007-06-21 00:00:00 �������� 2005�� 12�� 24�� 3�� �̷��� ���Եǰ� 2007�� 6�� 21�� 00�� 00�� 01�ʺ��� ���� X
SELECT HIRE_DATE FROM EMPLOYEES
WHERE HIRE_DATE >= '2005-12-24' AND HIRE_DATE <= '2007-06-21';
--���� ���� ��� ���ַ� �̰ڴ�
SELECT HIRE_DATE FROM EMPLOYEES
WHERE TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') >= '2005-12-24' AND TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') <= '2007-06-21';
--�ƴϸ� �׳� +1�� �� ���� �־� ��ȣ�� ���� ��
--1)
SELECT HIRE_DATE FROM EMPLOYEES
WHERE HIRE_DATE >= '2005-12-24' AND HIRE_DATE < '2007-06-22';
--2)
SELECT HIRE_DATE FROM EMPLOYEES
WHERE HIRE_DATE >= '2005-12-24' AND HIRE_DATE < (TO_DATE('2007-06-21') + 1);

--��¥ �����͸� �� �� ��, ��, �� ����� ���� Ȯ���Ͽ� �񱳺м�
SELECT HIRE_DATE FROM EMPLOYEES
WHERE HIRE_DATE = '2007-06-21' 
--TO_DATE('2007-06-01') -> 2007-06-21 00:00:00
--�⺻���� SYSDATE�� �ϸ� 00:00:00�� �ƴ϶� �״���� �ú��ʰ� ����Ǿ� ������ ������ ���� x�� ����
ORDER BY HIRE_DATE ASC;

--��ϳ�¥�� �˻�(�ú��ʰ� ����)
SELECT CREATE_DATE FROM EMPLOYEES
WHERE CREATE_DATE = '2014-01-08'
ORDER BY CREATE_DATE ASC; --�� ���ٰ� ����
--���� ���߱�
SELECT CREATE_DATE FROM EMPLOYEES
WHERE TO_CHAR(CREATE_DATE, 'YYYY-MM-DD') = '2014-01-08'
ORDER BY CREATE_DATE ASC;

--�ú��ʰ� �ʿ���� ��¥ ������
CREATE TABLE DATE_01 (
    COL1    DATE
);

INSERT INTO DATE_01 VALUES(SYSDATE);
INSERT INTO DATE_01 VALUES(TO_CHAR(SYSDATE, 'YYYY-MM-DD'));

SELECT * FROM DATE_01;


/*
�� TO_NUMBER(expr, format)
���ڳ� �ٸ� ������ ���ڸ� NUMBER ������ ��ȯ�ϴ� �Լ�
*/
SELECT TO_NUMBER('123456') FROM DUAL;
SELECT TO_NUMBER('123,456', '999,999') FROM DUAL; --123456 ���
SELECT TO_NUMBER('80,000', '999,999') FROM DUAL;
SELECT TO_NUMBER('100,000', '999,999') - TO_NUMBER('80,000', '999,999') FROM DUAL; --20000 ���


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--20220523

/*
NULL ���� �Լ�
    WHERE��
        IS NULL
        IS NOT NULLL
*/

/*
�� NVL(expr1, expr2)
NVL �Լ��� expr1�� NULL�� �� expr2�� ��ȯ�Ѵ�.(�Ķ���� 2���� ���)
*/
--�������� �Ķ���� �� NULL�� �ƴ� �� ������ �Ķ���Ͱ��� ��ȯ�Ѵ�.
SELECT NVL(NULL,0) FROM DUAL; --ù��° ���� NULL�̸� 0�� ����ϰڴ�
SELECT NVL('������', 0) FROM DUAL; --'������'�̶�� ���� ���� ������ '������'�� ���
SELECT NVL(NULL, NULL) FROM DUAL;
SELECT NVL(NULL, NULL, 0) FROM DUAL; --�Ķ���� 2���� �����ؼ� ����

--EMPLOYEE_ID : NOT NULL ����
--manager_id : NULL ����
SELECT manager_id, EMPLOYEE_ID, NVL(manager_id, EMPLOYEE_ID) 
FROM EMPLOYEES
WHERE manager_id IS NULL; --Steven King �� �ش�ǰ�

/*
��-2) NVL2((expr1, expr2, expr3)
 expr1�� NULL�� �ƴϸ� expr2��, 
 NULL�̸� expr3�� ��ȯ
*/
SELECT NVL2(NULL, 0, 1) FROM DUAL; --ù��° �Ķ���Ͱ� NULL�̸� 1�� ��ȯ���� �ȴ�.
SELECT NVL2('������', 0, 1) FROM DUAL;

--NULL���� ���ǻ���
-- �� �÷��� ���� �� ������� NULL�� �ȴ�.
SELECT NULL + '������' FROM DUAL; --NULL���
SELECT NULL + 10 FROM DUAL;
--2���� �÷� �� �ϳ��� ���̸� ������� ���� �ȴ�.
SELECT SALARY * COMMISSION_PCT FROM EMPLOYEES; --SALARY�� COMMISSION_PCT �� �ϳ��� NULL�̾ NULL ���

/*�޿�����
���� ������ Ŀ�̼�(COMMISSION_PCT)�� 
NULL�� ����� �׳� �޿���,
NULL�� �ƴϸ� '�޿� + (�޿� * Ŀ�̼�)'
�� ��ȸ
*/
--�޿����� ����1)
SELECT EMPLOYEE_ID, SALARY,
    NVL2(COMMISSION_PCT, SALARY + (SALARY * COMMISSION_PCT), SALARY)AS SALARY2 
FROM EMPLOYEES;

/*
�� COALESCE (expr1, expr2, ��)
COALESCE �Լ��� �Ű������� ������ ǥ���Ŀ��� NULL�� �ƴ� ù ��° ǥ������ ��ȯ�ϴ� �Լ�
*/
SELECT COALESCE(NULL, 1, 2) FROM DUAL; --1
SELECT COALESCE(NULL, NULL, 2) FROM DUAL; --2
SELECT COALESCE(NULL, NULL, NULL) FROM DUAL; -- NULL
--�޿����� ����2
SELECT EMPLOYEE_ID, SALARY, COMMISSION_PCT,
    COALESCE(SALARY + (SALARY * COMMISSION_PCT), SALARY) AS SALARY2 
FROM EMPLOYEES;

--���ǽĿ��� NULL�� �����Ǵ� ������ �� Ȯ��
--Ŀ�̼��� 0.2���� ���� �����͸� ��ȸ�϶�
SELECT EMPLOYEE_ID, COMMISSION_PCT
FROM EMPLOYEES
WHERE COMMISSION_PCT < 0.2; --��°���� Ŀ�̼��� NULL(72��) �����Ͱ� ���� X

SELECT EMPLOYEE_ID, COMMISSION_PCT
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NULL;

--11�� + NULL�� 0���� ��ȯ�Ͽ� ���ǽĿ� ���� (72��) = ���� 83��
SELECT EMPLOYEE_ID, COMMISSION_PCT
FROM EMPLOYEES
WHERE NVL(COMMISSION_PCT, 0) < 0.2; --NULL(72��)�� 0���� ��ȯ�ϰ� < 0.2 ���ǽ� �񱳰� ó�� -> NULL ������ ����

--COUNT(*) : ������ ������ Ȯ���ϴ� �Լ�
--1���� 2���� ���� ��� ���
--1��
SELECT COUNT(*)
FROM EMPLOYEES
WHERE NVL(COMMISSION_PCT, 0) < 0.2;

/*
LNNVL(���ǽ�)
�Ű������� ������ ���ǽ��� ����� FALSE�� UNKNOWN�̸� TRUE��, TRUE�̸� FALSE�� ��ȯ
*/
--2��
SELECT COUNT(*)
FROM EMPLOYEES
WHERE LNNVL(COMMISSION_PCT >= 0.2);

/*
3)NULLIF (expr1, expr2)
NULLIF �Լ��� expr1�� expr2�� ���� ������ NULL��, ���� ������ expr1�� ��ȯ
*/
--���� ��
SELECT NULLIF(1, 1) FROM DUAL; --NULL
SELECT NULLIF('������', '������') FROM DUAL; --NULL
--�ٸ� ��
SELECT NULLIF(1, 2) FROM DUAL; --1

/*
JOB_HISTORY ���̺��� 
START_DATE�� END_DATE�� ������ ������ �� �⵵�� ������ NULL��,
���� ������ ����⵵�� ���
*/
--�⵵�� �ʿ��ϱ� ������ ���� 4�ڸ��� ��������
SELECT TO_CHAR(START_DATE, 'YYYY'), TO_CHAR(END_DATE, 'YYYY') FROM JOB_HISTORY;
SELECT TO_CHAR(START_DATE, 'YYYY') AS START_YESR,
       TO_CHAR(END_DATE, 'YYYY') AS END_YEAR,
       NULLIF(TO_CHAR(END_DATE, 'YYYY'), TO_CHAR(START_DATE, 'YYYY')) AS NULLIF_YEAR
FROM JOB_HISTORY;

/*
GREATEST(expr1, expr2, ��), LEAST(expr1, expr2, ��)
GREATEST�� �Ű������� ������ ǥ���Ŀ��� ���� ū ����, LEAST�� ���� ���� ���� ��ȯ
*/
    SELECT GREATEST(1, 2, 3, 2),
           LEAST(1, 2, 3, 2)
      FROM DUAL;
      
    SELECT GREATEST('�̼���', '������', '�������'),
           LEAST('�̼���', '������', '�������')
      FROM DUAL;
      
/*
DECODE (expr, search1, result1, search2, result2, ��, default)
DECODE�� expr�� search1�� ���� �� ���� ������ result1��, 
���� ������ �ٽ� search2�� ���� ���� ������ result2�� ��ȯ�ϰ�, 
�̷� ������ ��� ���� �� ���������� ���� ���� ������ default ���� ��ȯ
*/
--����
/*
CHANNEL_ID �÷��� ���� 3�̸� 'Direct' ���
                     9�̸�, 'Direct' 
                     5�̸� 'Indirect'
                     4�̸� 'Indirect'
                     �������� 'Others'
������ ���� �������
*/
--������ �ִ� �ڵ�
SELECT CHANNEL_ID, DECODE(CHANNEL_ID, 3, 'Direct',
                                      9, 'Direct',
                                      5, 'Indirect',
                                      4, 'Indirect',
                                     'Others') AS DECODES

FROM CHANNELS;

--������ ���� �ڵ�
SELECT CHANNEL_ID, DECODE(CHANNEL_ID, 3, 'Direct', 9, 'Direct', 5, 'Indirect', 4, 'Indirect', 'Others') AS DECODES
FROM CHANNELS;

/*
�⺻ �����Լ�
�����Լ��� ��� �����͸� Ư�� �׷����� ���� ���� �� �׷쿡 ���� ����(SUM), ���(AVG), �ִ�(MAX), �ּڰ�(MIN), ����(COUNT) ���� ���ϴ� �Լ�
NULL �����͸� �����ϰ� ����� ����
���ϰ��� ��ȯ
*/
SELECT * FROM EMPLOYEES;
/*
�� COUNT (expr)
���� ��� �Ǽ�, �� ��ü �ο� ���� ��ȯ�ϴ� ���� �Լ�
���̺� ��ü �ο�� ���� WHERE �������� �ɷ��� �ο� ���� ��ȯ
Ư�� �÷����� �Ǽ��� ��ȸ�� �� NULL�� ���ܵȴ�
*/

SELECT COUNT(*) FROM EMPLOYEES;

/*
�߸��� ��� (���������� ���� ����� ���� ������ �Ǿ� �ִ�.
COUNT(*) : 107 �� ���
EMPLOYEE_ID : 107���� �������� ���
*/
SELECT COUNT(*), EMPLOYEE_ID, EMP_NAME FROM EMPLOYEES;

DESC EMPLOYEES; --���̺��� NULL ���θ� Ȯ��
SELECT COUNT(EMPLOYEE_ID) FROM EMPLOYEES; --EMPLOYEE_ID�÷��� PRIMARY KEY �����Ǿ� �����Ƿ� NOT NULL�̱� ������ 107 ���

--NULL�����ʹ� ����
SELECT COUNT(DEPARTMENT_ID) FROM EMPLOYEES; --DEPARTMENT_ID �÷��� NULL�̰� NULL�� �����Ϳ� ���ԵǾ� ������ ���ܵǰ� ���
--NULL�� ������ Ȯ��
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID IS NULL;

/*
DISTINCT : �ߺ��� ������ ���� 1���� �����ϰ�  �������� �����ϴ� ���
*/
--������̺��� �����Ͽ� �μ��� ����� �˰� �ʹ�
SELECT COUNT(DISTINCT DEPARTMENT_ID) FROM EMPLOYEES;
--� �μ��� �ִ��� Ȯ��(�ߺ� ����)
SELECT DISTINCT DEPARTMENT_ID FROM EMPLOYEES;
--���Ľ� �÷��� ��� ���� ��� ����
SELECT DISTINCT DEPARTMENT_ID FROM EMPLOYEES
ORDER BY 1;
-- �������� �÷� �� ���ÿ� �����ϴ� �����͸� 1���� �����ϰ� �������� ����
SELECT DISTINCT EMPLOYEE_ID, DEPARTMENT_ID FROM EMPLOYEES;

/*
�� SUM(expr)
SUM�� expr�� ��ü �հ踦 ��ȯ�ϴ� �Լ��� �Ű����� expr���� �������� 
*/
--��� ���̺��� �޿��� �������̹Ƿ� �� ����� �޿� �Ѿ��� ���� ����.
SELECT SUM(SALARY) FROM EMPLOYEES; --�����Լ��� �÷��� �� �����͸� �����ϰ� �Լ��� ���
--���� NULL�� �ִ��� ��ȸ�Ͽ� Ȯ��
SELECT SALARY FROM EMPLOYEES WHERE SALARY IS NULL;

--��� : AVG �Լ� ���
SELECT AVG(SALARY) FROM EMPLOYEES;
--�Ҽ� ��°�ڸ������� ���
SELECT ROUND(AVG(SALARY), 2) FROM EMPLOYEES;

--���� ���� ����?
SELECT MAX(SALARY) FROM EMPLOYEES;
--���� ���� ����
SELECT MIN(SALARY) FROM EMPLOYEES;

--���ļ�
SELECT COUNT(*), SUM(SALARY), AVG(SALARY), MAX(SALARY), MIN(SALARY) FROM EMPLOYEES;

/*
�ڰ��� ���� : 30��
���� �̴���� : 25��
������ �ο��� : 5��

��ü 30���� ����� ���ؾ� ��
*/
SELECT AVG(����) FROM �ڰ��� ����;

--���� �÷��� NULL�� �����͸� 0���� �����Ͽ� ó��
SELECT AVG(NVL(����,0)) FROM �ڰ��� ����;


/*
GROUP BY��
- Ư�� �׷����� ���� �����͸� ����
- �׷����� ���� �÷����̳� ǥ������ GROUP BY ���� ����ؼ� ���
- WHERE�� ORDER BY�� ���̿� ��ġ

�׷�ȭ
- �÷��� ������ �����͸� ������� �Ͽ� ���� �ǹ�

GROUP BY ������ ���ÿ��� SELECT���� ����ϴ� �÷��� ������ �Ǿ� �ִ�.
- GROUP BY�� ����� �÷���� �����Լ��� SELECT���� ��� ����
*/

/*
������, �׷�ȭ ����� �÷��� �������� �Ǵ�!!
��� ���̺��� �� �μ��� �޿��� �Ѿ�
*/
--�μ� ID�� ������������ ����
SELECT DEPARTMENT_ID, SALARY
FROM EMPLOYEES
ORDER BY DEPARTMENT_ID; 
 --DEPARTMENT_ID�� ������ �����͵��� ����(�׷�ȭ) �μ��� �հ踦 ���Ѵ�.
SELECT SUM(SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

--�� �� ��ħ
SELECT DEPARTMENT_ID, SUM(SALARY)
FROM EMPLOYEES --��ü ������ ��� �۾�
GROUP BY DEPARTMENT_ID --DEPARTMENT_ID�� ������ �����͵��� ���´�
ORDER BY DEPARTMENT_ID; --�������� ����

--GROUP BY ������ ���ÿ��� SELECT���� ����ϴ� �÷��� ����
SELECT EMPLOYEE_ID /* 107�� ������ ��� */, DEPARTMENT_ID /*�׷�ȭ�� �����͸� ��� */, SUM(SALARY)
FROM EMPLOYEES 
GROUP BY DEPARTMENT_ID 
ORDER BY DEPARTMENT_ID;
--00979. 00000 -  "not a GROUP BY expression"
--EMPLOYEE_ID �÷� ��� X

/*
��� ���̺��� �� �μ��� �ο���
*/
SELECT DEPARTMENT_ID, COUNT(EMPLOYEE_ID)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;

/*
��� ���̺��� �� �μ��� ��� ������ ���϶�
*/
SELECT DEPARTMENT_ID, ROUND(AVG(SALARY), 2)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;

--�������� �����Լ��� ��� ���
--�� �μ��� -> �޿��հ� �޿� ���, ��� ��, �μ��� ���� ���� �ݾ�, �μ��� ���� ���� �ݾ�
SELECT DEPARTMENT_ID, COUNT(EMPLOYEE_ID), SUM(SALARY), ROUND(AVG(SALARY), 2), MAX(SALARY), MIN(SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;

/*
HAVING �� : GROUP BY ������ �Բ� ����ϸ�, �߻��� �����Ϳ� ���Ͽ� ���ǽ��� ���
GROUP BY�� ������ ��ġ�� GROUP BY�� ����� ������� �ٽ� ���͸� �Ŵ� ������ ����
HAVING ���� ���� ���·� ���
*/
--��� ���̺��� �� �μ��� ��� ������ 3000���� ū �����͸� ����϶�
SELECT DEPARTMENT_ID, ROUND(AVG(SALARY), 2)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) > 3000
ORDER BY DEPARTMENT_ID;

--������� ���̺� : KOR_LOAN_STATUS
SELECT * FROM KOR_LOAN_STATUS;
DESC KOR_LOAN_STATUS; --������Ÿ�԰� �� ���� Ȯ��

--2013�� ������ ������� �� �ܾ�
SELECT REGION, SUM(LOAN_JAN_AMT) TOT_LOAN
FROM KOR_LOAN_STATUS
WHERE PERIOD LIKE '2013%'
GROUP BY REGION
ORDER BY REGION;

--2013�� ������ ������⺰ �� �ܾ�
SELECT REGION, GUBUN, SUM(LOAN_JAN_AMT) TOT_LOAN
FROM KOR_LOAN_STATUS
WHERE PERIOD LIKE '2013%'
GROUP BY REGION, GUBUN
ORDER BY REGION;

--2013�� 11�� ������ ���� ������ ������� �� �ܾ�
SELECT REGION, SUM(LOAN_JAN_AMT) TOT_LOAN
FROM KOR_LOAN_STATUS
WHERE PERIOD LIKE '201311'
GROUP BY REGION
ORDER BY REGION;

--������̺��� �μ�ID�� JOBID�� ��� �޿��� 3000���� ū �����͸� ��ȸ�϶�
SELECT department_id, JOB_ID, COUNT(*), ROUND(AVG(SALARY),2) AVGSALARY
FROM EMPLOYEES --1)
GROUP BY department_id, JOB_ID --2)
HAVING AVG(SALARY) > 3000 --3)
ORDER BY department_id, JOB_ID; --4)

/*
ROLLUP ���� CUBE ��
GROUP BY������ ���Ǿ� �׷캰 �Ұ踦 �߰��� ���� �ִ� ����
*/
--ROLLUP�� �������� ���� ����
SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, gubun --2�� �÷��� ���ÿ� �����ϴ� ������
ORDER BY period;
/*
PERIOD GUBUN                            TOTL_JAN
------ ------------------------------ ----------
201310 ��Ÿ����                           676078
201310 ���ô㺸����                     411415.9
201311 ��Ÿ����                         681121.3
201311 ���ô㺸����                     414236.9
*/

--ROLLUP ����
--GROUP BY PERIOD, GUBUN �����͸� �������� �Ͽ� �߰��Ұ�, �����Ұ� �Բ� ���
SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY ROLLUP(period, gubun) --�÷� �� 2 + 1 -> 3����
ORDER BY period;
/*
PERIOD GUBUN                            TOTL_JAN
------ ------------------------------ ----------
201310 ��Ÿ����                           676078 --���� -3����
201310 ���ô㺸����                     411415.9 --���� -3����
201310                                 1087493.9 --PERIOD �߰� �Ұ� - 2����
201311 ��Ÿ����                         681121.3 --���� -3����
201311 ���ô㺸����                     414236.9 --���� -3����
201311                                 1095358.2 --PERIOD �߰� �Ұ� - 2����
                                       2182852.1 --��ü ���� - 1����
*/
--PERIOD�� GUBUN �� ROLLUP ������ �ٲٸ�?
SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY ROLLUP(gubun, period) --�÷� �� 2 + 1 -> 3����, ��ü����, GUBUN�߰� �Ұ�, ����
ORDER BY period;
/*
PERIOD GUBUN                            TOTL_JAN
------ ------------------------------ ----------
201310 ��Ÿ����                           676078
201310 ���ô㺸����                     411415.9
201311 ���ô㺸����                     414236.9
201311 ��Ÿ����                         681121.3
       ��Ÿ����                        1357199.3 --GUBUN ����
                                      2182852.1 --��ü ����
       ���ô㺸����                      825652.8 --GUBUN ����
*/

SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, ROLLUP(gubun); --��ü ���� ������ ��¸��, ROLLUP�� �÷� 1�� + 1 -> 2����
/*
PERIOD GUBUN                            TOTL_JAN
------ ------------------------------ ----------
201310 ��Ÿ����                           676078 --���� - 2����
201310 ���ô㺸����                     411415.9 --���� -2����
201310                                 1087493.9 --1����
201311 ��Ÿ����                         681121.3 --���� -2����
201311 ���ô㺸����                     414236.9 --���� -2����
201311                                 1095358.2--1����
*/

/*ROLLUP �ǽ� ���� - HR���� */
