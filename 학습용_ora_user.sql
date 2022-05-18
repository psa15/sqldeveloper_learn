/*테이블 생성 */
CREATE TABLE ex2_1 (
    --문자
    COLUMN1 CHAR(10),
    COLUMN2 VARCHAR2(10),
    COLUMN3 NVARCHAR2(10),
    --숫자
    COLUMN4 NUMBER
);

--테이블 구조
DESC ex2_1;

--문자셋 확인
SELECT name, value$
FROM sys.props$
WHERE name = 'NLS_CHARACTERSET';

--언어셋 확인
SELECT name, value$
FROM sys.props$
WHERE name = 'NLS_LANGUAGE';

--데이터 삽입 INSERT
INSERT INTO ex2_1(COLUMN1, COLUMN2) VALUES('abc', 'abc');
/*
column3 과 column4는??
=> 열 -> NULLABLE -> YES : 없어도 된다는 뜻
*/
INSERT INTO ex2_1(COLUMN1, COLUMN2) VALUES('김지원','염미정');

-- * : 테이블의 모든 컬럼을 나타내는 기호
SELECT * FROM ex2_1;

--LENGTH() : 문자열의 길이확인
SELECT COLUMN1, LENGTH(COLUMN1) AS LEN1, 
        COLUMN2, LENGTH(COLUMN2) AS LEN2 
FROM ex2_1;

--LENGTHB() : 문자열 길이의 크기 확인
SELECT COLUMN1, LENGTHB(COLUMN1) AS LEN1, 
        COLUMN2, LENGTHB(COLUMN2) AS LEN2 
FROM ex2_1;

CREATE TABLE ex2_2 (
    COLUMN1 VARCHAR2(3), --안쓰면 BYTE
    COLUMN2 VARCHAR2(3 BYTE),
    COLUMN3 VARCHAR2(3 CHAR) --한글, 영문 상관없이 3개 문자
);

--컬럼명 생략 : 테이블의 모든 컬럼명을 의미
INSERT INTO ex2_2 VALUES('abc','abc','abc');
-- = INSERT INTO ex2_2(COLUMN1, COLUMN2, COLUMN3) VALUES('abc','abc','abc');

INSERT INTO ex2_2 VALUES('abc','김지원','김지원'); --에러(column2는 3byte 기 때문에)
INSERT INTO ex2_2 VALUES('abc','abc','김지원');

SELECT * FROM ex2_2;

SELECT COLUMN3, LENGTH(COLUMN3) AS LEN1, 
                LENGTHB(COLUMN3) AS LEN2 
FROM ex2_2;



--숫자 데이터 타입 - INTEGER, DECIMAL, NUMBER 모두 내부적으로는 NUMBER로 인식
--실제 사용은 NUMBER로 사용
CREATE TABLE ex2_3(
    COL_INT INTEGER,
    COL_DEC DECIMAL,
    COL_NUM NUMBER
);

--데이터 입력
INSERT INTO ex2_3 VALUES(10, 20, 30);
INSERT INTO ex2_3 VALUES(10.23, 20.45, 30.50); --NUMBER데이터타입만 소수자리 입력값 지원

SELECT * FROM ex2_3;


--user_tab_cols : 시스템 뷰 - 생성된 테이블 컬럼의 타입과 길이
    SELECT column_id, column_name, data_type, data_length
      FROM user_tab_cols
     WHERE table_name = 'EX2_3' --테이블 명을 대문자로 사용해야 함 (소문자는 '선택된 행 없음' 출력)
     ORDER BY column_id;
     
     
--날짜 데이터 타입
--테이블 생성
CREATE TABLE ex2_5(
    COL_DATE        DATE, --기본값이 null
    COL_TIMESTAMP   TIMESTAMP -- 기본값이 NULL
);

/* 
날짜 데이터 함수
SYSDATE : 현재 시스템의 날짜(초까지)
SYSTIMESTAMP : 현재 시스템의 날짜(밀리초까지)

날짜 출력 포맷 설정 : NLS
    도구 → 환경설정 → 데이터베이스 → NLS
*/
SELECT SYSDATE, SYSTIMESTAMP FROM DUAL; --실제 테이블이 아닌 출력만 DUAL

INSERT INTO ex2_5 VALUES(SYSDATE, SYSTIMESTAMP);

SELECT * FROM ex2_5;

--20220518
--비쥬얼 툴로 테이블 생성
--완

--제약조건 : 데이터 무결성을 보장하기 위한 명령어
/*
테이블 생성 시 제약조건을 설정하는 구문 2가지 형식
1)컬럼 수준 제약
    컬럼명 데이터타입 제약조건명령어
2)테이블 수준 제약
    --CONSTRAINTS 제약조건객체이름 제약조건명령어 (컬럼명)

*/
/*
테이블의 칼럼에는 NULL, NOT NULL
1) NOT NULL : 컬럼에 반드시 데이터를 입력하고자 할 때 사용
    NULL : 선택적 입력 가능(기본값) -> 제약조건 X
*/

CREATE TABLE ex2_6(
    COL_NULL        VARCHAR2(10),
    COL_NOT_NULL    VARCHAR2(10) NOT NULL --NOT NULL 제약조건 객체가 생성됨
    --이름을 지정하지 않으면 오라클이 자동으로 제약조건객체 이름을 생성(SYS_)
);

--ORA-01400: cannot insert NULL into ("ORA_USER"."EX2_6"."COL_NOT_NULL") 오류 발생
INSERT INTO ex2_6(COL_NULL) VALUES('AA'); -- COL_NOT_NULL  컬럼이 NOT NULL 이므로 반드시 INSERT문에서 데이터 작업 코드 해야함

--오라클에서는 값의 표현으로 '' 를 하면 NULL 을 의미한다.
INSERT INTO ex2_6 VALUES('AA','');
INSERT INTO ex2_6 VALUES('AA',NULL);

INSERT INTO ex2_6(COL_NOT_NULL) VALUES('AA'); --COL_NULL컬럼은 NULL설정이므로 입력시 생략 가능
INSERT INTO ex2_6 VALUES('AA','BB');

select * from ex2_6;

-- user_constraints :테이블에 대한 제약조건 정보가 저장되어 있는 시스템 뷰
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'EX2_6';


/*
2) UNIQUE : 컬럼 값이 유일해야 한다
- 단일컬럼
-복합컬럼
-테이블에 UNIQUE 제약조건은 여러개 설정 가능
*/
--제약조건객체 이름은 중복 X
CREATE TABLE ex2_7 (
    COL_UNIQUE_NULL     VARCHAR2(10)    UNIQUE, --UNIQUE 제약조건 객체 이름이 자동생성 SYS_~~
    COL_UNIQUE_NNUL     VARCHAR2(10)    UNIQUE NOT NULL,
    COL_UNIQUE          VARCHAR2(10),
    --CONSTRAINTS 제약조건객체이름 제약조건명령어 (컬럼명)
    CONSTRAINTS unique_nm1 UNIQUE(COL_UNIQUE)
    --단일컬럼
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

--테이블 제약조건정보 확인 시스템 뷰
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'EX2_7';
 
 --데이터 입력
INSERT INTO ex2_7 VALUES('AA','AA','AA'); --성공

INSERT INTO ex2_7 VALUES('AA','AA','AA'); --ERROR
 --ORA-00001: unique constraint (ORA_USER.SYS_C007047) violated 
 --왜 에러났는지 확인
 SELECT * FROM ex2_7;
 
 INSERT INTO ex2_7 VALUES('','BB','BB'); -- '' 은 NULL / 다른 DBMS에서는 공백을 의미
 INSERT INTO ex2_7 VALUES('','cc','cc'); -- NULL은 중복에서 제외되어 허용된다
  SELECT * FROM ex2_7;
  
 INSERT INTO ex2_7 VALUES('','cc','cc'); --ERROR
 --ORA-00001: unique constraint (ORA_USER.SYS_C007048) violated
 
 --UNIQUE 테이블 수준 제약조건 복합 컬럼 가능
CREATE TABLE ex2_temp(
    COL1    VARCHAR2(10) NOT NULL,
    COL2    VARCHAR2(10) NOT NULL,
    CONSTRAINTS unique_complex_nm1 UNIQUE(COL1, COL2)
    --동시에 만족하는 데이터 중복 허용 X
);

INSERT INTO ex2_temp(COL1,COL2) VALUES('AA','BB'); --성공
INSERT INTO ex2_temp(COL1,COL2) VALUES('AA','AA'); --성공

INSERT INTO ex2_temp(COL1,COL2) VALUES('AA','BB'); --에러
--ORA-00001: unique constraint (ORA_USER.UNIQUE_COMPLEX_NM1) violated
----동시에 만족하는 데이터 중복 허용 X

SELECT * FROM ex2_temp; -- ctrl + enter (실행)

/*
3)기본키 (PRIMARY KEY) : NOT NULL + UNIQUE
- 테이블에 단 1개만 설정가능
-단일키 : 컬럼 1개를 대상으로 설정
-복합키 : 여러 컬럼을 대상으로 설정
*/

CREATE TABLE ex2_8 (
    COL1    VARCHAR2(10) PRIMARY KEY, -- NOT NULL + UNIQUE
    COL2    VARCHAR2(10) 
);

INSERT INTO ex2_8 VALUES('A',NULL);

INSERT INTO ex2_8(COL2) VALUES('A'); --ERROR COL1이 PRIMARY KEY 여서 값을 반드시 줘야함
--ORA-01400: cannot insert NULL into ("ORA_USER"."EX2_8"."COL1")
INSERT INTO ex2_8 VALUES('A',NULL); --ERROR COL1은 PRIMARY KEY여서 중복 X
--ORA-00001: unique constraint (ORA_USER.SYS_C007053) violated

--DATA 입력 확인
SELECT * FROM ex2_8;

CREATE TABLE ex2_8_02 (
    COL1    VARCHAR2(10) PRIMARY KEY, -- NOT NULL + UNIQUE
    COL2    VARCHAR2(10) PRIMARY KEY
); --ERROR
--02260. 00000 -  "table can have only one primary key"
--COL1컬럼에 PRIMARY KEY, COL2컬럼에 PRIMARY KEY 테이블에 PRIMARY KEY를 2개 설정한다는 의미로 해석되어 에러발생

/*
PRIMARY KEY를 복합키로 설정하는 방법 : 테이블 수준 제약 문법 형식 사용
*/
CREATE TABLE complex_1 (
    A VARCHAR2(10),
    B VARCHAR2(10),
    C VARCHAR2(10),
    CONSTRAINTS PK_COMPLEX_NM1 PRIMARY KEY(A, B)
    --이름 안주고 싶으면 그냥 PRIMARY KEY(컬럼명)
);

INSERT INTO complex_1(A,B,C) VALUES('A','B','C');
INSERT INTO complex_1(A,B,C) VALUES('A','A','C');

--맨 위의 문장이 실행이 되면 'A','B' 존재하므로 기본키제약조건에 의하여 에러 발생
INSERT INTO complex_1(A,B,C) VALUES('A','B','C'); --에러 A컬럼이 A고 B컬럼이 B인 행이 이미 존재하기 때문
--ORA-00001: unique constraint (ORA_USER.PK_COMPLEX_NM1) violated

CREATE TABLE complex_2 (
    A VARCHAR2(10),
    B VARCHAR2(10),
    C VARCHAR2(10),
    CONSTRAINTS PK_COMPLEX_NM2 PRIMARY KEY(A, B, C)
);

INSERT INTO complex_2(A,B,C) VALUES('A','B','C');

INSERT INTO complex_2(A,B,C) VALUES('A','B','C'); --에러
--동시에 3개의 컬럼의 데이터가 앞에 존재하므로 기본키 제약조건 위배

--순서는 상관 없음
INSERT INTO complex_2(A,B,C) VALUES('B','C','A');

--제약조건 시스템 뷰
--테이블 명 대문자로!!!!!!!!!!!!!!!!!!!!!!!! -> ALT + '
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'EX2_8';
 
 SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'COMPLEX_1';
 
 /*
 4) 참조키 (FOREIGN KEY)
 - 기본키 테이블(dept)은 DEPT_CODE컬럼이 PRIMARY KEY 설정이 되어 있어야 한다
 - 참조키 테이블(emp)의 DEPT_CODE컬럼명은 dept테이블의 DEPT_CODE 컬럼명은 동일하지 않아도 상관없지만 보통 동일하게 한다.
   타입은 일치하거나 호환되어야 한다.
   
 - 참조키도 복합키 작업 가능
 */
 
 --기본키 테이블
 CREATE TABLE dept(
    DEPT_CODE   VARCHAR2(2) PRIMARY KEY,
    DEPT_NAME   VARCHAR2(20)    NOT NULL
 );
 
 INSERT INTO dept VALUES('1','총무부');
 INSERT INTO dept VALUES('2','마케팅부');
 INSERT INTO dept VALUES('3','기획부');
 INSERT INTO dept VALUES('4','영업부');
 
 SELECT * FROM dept;
 
 --참조키 테이블
 --테이블 수준 제약
 CREATE TABLE emp (
    EMP_ID      VARCHAR2(2) PRIMARY KEY,
    EMP_NAME    VARCHAR2(20) NOT NULL,
    DEPT_CODE   VARCHAR2(2) NOT NULL, --dept테이블의 부서코드 컬럼명과 타입을 같게!
    FOREIGN KEY(DEPT_CODE) REFERENCES dept(DEPT_CODE)
 );
 
 INSERT INTO emp(EMP_ID, EMP_NAME, DEPT_CODE) VALUES('1','김지원','5'); -- 에러
 --ORA-02291: integrity constraint (ORA_USER.SYS_C007061) violated - parent key not found
 
 INSERT INTO emp(EMP_ID, EMP_NAME, DEPT_CODE) VALUES('1','김지원1','1'); 
 INSERT INTO emp(EMP_ID, EMP_NAME, DEPT_CODE) VALUES('2','김지원2','2'); 
 INSERT INTO emp(EMP_ID, EMP_NAME, DEPT_CODE) VALUES('3','김지원3','3'); 
 INSERT INTO emp(EMP_ID, EMP_NAME, DEPT_CODE) VALUES('4','김지원4','4'); 
 
 INSERT INTO emp(EMP_ID, EMP_NAME, DEPT_CODE) VALUES('5','김지원5','4'); 
 INSERT INTO emp(EMP_ID, EMP_NAME, DEPT_CODE) VALUES('6','김지원6','3'); 
 INSERT INTO emp(EMP_ID, EMP_NAME, DEPT_CODE) VALUES('7','김지원7','2'); 
 INSERT INTO emp(EMP_ID, EMP_NAME, DEPT_CODE) VALUES('8','김지원8','1'); 
 
 SELECT * FROM emp;
 
 /*
 보기메뉴 - DATA MODELER -> 브라우저
 관계형 모델 -> 우클릭 -> 새 관계형 모델
 */
 -- 참조키도 복합키 작업 가능
 --기본키 테이블의 PRIMARY KEY가 복합키로 설정 되어 있을 경우, 참조키 테이블의 참조키 설정 구문
 --기본키 테이블의 복합키로 설정된 컬럼 A, B를 개별로 각각 참조키 설정 할 수 없음
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
  INSERT INTO CHILD_TBL(A,B,C) VALUES('A','A','C'); --오류
  --ORA-02291: integrity constraint (ORA_USER.FK_PARENT_CHILD_NM01) violated - parent key not found
  
  /*
  5) CHECK 제약 조건 : 컬럼에 입력되는 데이터를 체크해 제약 조건에 설정된 데이터만 입력을 가능하게 하는 기능
  */
  CREATE TABLE ex2_9 (
    NUM1    NUMBER
            CONSTRAINTS check1 CHECK (NUM1 BETWEEN 1 AND 9), --1~9까지
    GENDER  VARCHAR2(10)
            CONSTRAINTS check2 CHECK (GENDER IN ('MALE','FENAKE')) --MALE OR FEMALE만 허용 IN(사용 가능 값, 사용 가능 값, ...)
  );
  
  SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'EX2_9';
 
 INSERT INTO ex2_9(NUM1, GENDER) VALUES(10, 'MALE'); --ERROR 10이 제약조건에 안맞음
 --ORA-02290: check constraint (ORA_USER.CHECK1) violated
 
 INSERT INTO ex2_9(NUM1, GENDER) VALUES(5, 'fenake'); --에러 FENAKE이 소문자여서
 --ORA-02290: check constraint (ORA_USER.CHECK2) violated
 
 INSERT INTO ex2_9(NUM1, GENDER) VALUES(5, 'FENAKE');
 
 SELECT * FROM EX2_9;
 
 /*
 DEFAULT 명령어 : 제약조건 명령어 X
 테이블 데이터 입력 시 DEFAULT 명령어가 설정된 컬럼은 생략 가능
 DEFAULT 기능 작동
 */
 CREATE TABLE ex2_10 (
    COL1            VARCHAR2(10)    NOT NULL,
    COL2            VARCHAR2(10)    NULL,
    CREATE_DATE     DATE    DEFAULT SYSDATE --SYSDATE : 오라클 날짜 함수
 );
 
INSERT INTO ex2_10(COL1, COL2) VALUES('AA','AA'); --CREATE_DATE 컬럼명 데이터 생략 -> DEFAULT 작동

--컬럼명 생략하면 모든 컬럼명을 의미
INSERT INTO ex2_10 VALUES('AA','AA'); --에러 컬럼은 3개인데 값은 2개라
--00947. 00000 -  "not enough values"
INSERT INTO ex2_10 VALUES('AA','AA', DEFAULT); --성공

--이렇게 할 필요는 없으나 수동으로 
INSERT INTO ex2_10 VALUES('AA','AA', SYSDATE);

INSERT INTO ex2_10 VALUES('AA','AA', '2022.05.18'); --데이터 입력 성공 - 날짜 형식의 문자열 데이터 사용 가능

INSERT INTO ex2_10 VALUES('AA','AA', '2022.05.50'); -- 날짜 범위 초가로 형변환 에러 발생
--ORA-01847: day of month must be between 1 and last day of month

INSERT INTO ex2_10 VALUES('AA','AA', '2022.05.18 21:10:00'); --성공
SELECT * FROM ex2_10;

/*
테이블 삭제
DROP TABLE 테이블명;

테이블 삭제 시 기본키 테이블이 데이터가 참조가 되어있을 경우에 삭제가 안된다.
참조키 테이블을 먼저 삭제해야 함
*/
DROP TABLE dept; --삭제 불가
--02449. 00000 -  "unique/primary keys in table referenced by foreign keys"

--참조키 관계가 되어 있을 경우, 테이블 삭제 순서(테이블 생성 순서와 반대)
DROP TABLE emp; --참조키 테이블이 먼저 삭제가 되어야, 기본키 테이블의 데이터의 참조가 해제될 수 있다
DROP TABLE dept; --기본키 테이블

--위의 테이블 순서대로 삭제 명령어를 진행하고 다시 dept 와 emp 테이블 생성 및 데이터 입력 진행(299라인)
--아까 만들었던 관계형 모델 삭제 후 다시 생성

--DEPT 부서 테이블의 기본키제약조건 삭제, EMP자식테이블의 참조키제약조건 삭제가 함께 진행
--EMP의 DEPT_CODE는 남아 있음
DROP TABLE dept
CASCADE CONSTRAINTS;

--테이블 제약조건 정보 확인
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'DEPT';
 
 SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'EMP';
 
 SELECT    * FROM EMP;
 
 /*
 테이블 삭제 시 제약조걱객체도 함게 삭제
 */
 CREATE TABLE TEMP_01(
    COL1 VARCHAR2(10) CONSTRAINTS PR_TEMP_NM1 PRIMARY KEY
 );
 DROP TABLE TEMP_01;
  --제약조건객체명이 TEMP_01과 같은데 TEMP_01테이블이 삭제되면서 PR_TEMP_NM1도 함께 삭제되어 TEMP_02에서 사용 가능
  CREATE TABLE TEMP_02(
    COL1 VARCHAR2(10) CONSTRAINTS PR_TEMP_NM1 PRIMARY KEY
 );
 
 DROP TABLE ex2_10;
 
 --테이블 변경(ALTER TABLE) : 테이블의 구조를 변경(새컬럼 추가, 기존칼럼의 데이터타입 크기 변경, 기존 칼럼 삭제 등)
 CREATE TABLE ex2_10(
    COL1    VARCHAR2(10)    NOT NULL,
    COL2    VARCHAR2(10)    NULL,
    CREATE_DATE DATE DEFAULT SYSDATE
 );

--COL1컬럼명을 COL11로 변경
ALTER TABLE ex2_10
RENAME COLUMN COL1 TO COL11;

--테이블 구조 보는 명령어
DESC ex2_10;

--컬럼의 데이터타입 변경 COL2 VARCHAR2(10) -> VARCHAR2(30)
ALTER TABLE ex2_10
MODIFY COL2 VARCHAR2(30);

-- 컬럼 추가
ALTER TABLE ex2_10
ADD COL3 NUMBER;

--데이터가 들어있는 상태에서 컬럼 추가
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
--데이터가 있을 때 컬럼추가하면서 NOT NULL 을 제약조건으로 설정하면 오류
ALTER TABLE ex2_10
ADD COL3 NUMBER NOT NULL;
--01758. 00000 -  "table must be empty to add mandatory (NOT NULL) column"

--컬럼 추가시 NULL로 적용
ALTER TABLE ex2_10
ADD COL3 NUMBER;

--데이터가 하나라 조건식 사용 안하고 데이터 입력
UPDATE ex2_10
SET COL3 = 100;

SELECT * FROM ex2_10;

--컬럼 삭제 - 데이터도 삭제
ALTER TABLE ex2_10
DROP COLUMN COL3;

--제약조건 추가
DESC ex2_10;
--테이블 제약조건 정보 확인
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'EX2_10';
 
ALTER TABLE ex2_10
ADD PRIMARY KEY (COL11);

--제약조건 삭제
ALTER TABLE ex2_10
DROP CONSTRAINTS SYS_C007077;


SELECT * FROM EMPLOYEES;
--테이블 복사 : PRIMARY KEY는 복사대상에서 제외
CREATE TABLE EMPLOYEES_TEMP
AS
SELECT * FROM EMPLOYEES;
--테이블 제약조건 정보 확인
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'EMPLOYEES';
 
 SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'EMPLOYEES_TEMP';


/*
연습 문제
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
--테이블 제약조건 정보 확인
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
--테이블 제약조건 정보 확인
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'ORDER_ITEMS';
 
--3)
CREATE TABLE PROMOTIONS(
    PROMO_ID	    NUMBER(6,0) PRIMARY KEY,
    PROMO_NAME   VARCHAR2(20)
);
--테이블 제약조건 정보 확인
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'PROMOTIONS';