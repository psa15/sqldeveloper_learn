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