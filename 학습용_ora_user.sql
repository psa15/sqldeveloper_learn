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

/*
���̺��� Į������ NULL, NOT NULL
NULL : ������ �Է� ����(�⺻��)
NOT NULL : �ݵ�� �Է�
*/

CREATE TABLE ex2_6(
    COL_NULL        VARCHAR2(10),
    COL_NOT_NULL    VARCHAR2(10) NOT NULL
);

--ORA-01400: cannot insert NULL into ("ORA_USER"."EX2_6"."COL_NOT_NULL") ���� �߻�
INSERT INTO ex2_6(COL_NULL) VALUES('AA'); -- COL_NOT_NULL  �÷��� NOT NULL �̹Ƿ� �ݵ�� INSERT������ ������ �۾� �ڵ� �ؾ���

--����Ŭ������ ���� ǥ������ '' �� �ϸ� NULL �� �ǹ��Ѵ�.
INSERT INTO ex2_6 VALUES('AA','');
INSERT INTO ex2_6 VALUES('AA',NULL);

INSERT INTO ex2_6(COL_NOT_NULL) VALUES('AA'); --COL_NULL�÷��� NULL�����̹Ƿ� �Է½� ���� ����
INSERT INTO ex2_6 VALUES('AA','BB');

select * from ex2_6;