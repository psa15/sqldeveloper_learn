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
/*
1) 주문테이블
- 테이블 : ORDERS
- 컬럼 :   ORDER_ID	    NUMBER(12,0)
           ORDER_DATE   DATE 
           ORDER_MODE	  VARCHAR2(8 BYTE)
           CUSTOMER_ID	NUMBER(6,0)
           ORDER_STATUS	NUMBER(2,0)
           ORDER_TOTAL	NUMBER(8,2)
           SALES_REP_ID	NUMBER(6,0)
           PROMOTION_ID	NUMBER(6,0)
- 제약사항 : 기본키는 ORDER_ID  
             ORDER_MODE에는 'direct', 'online'만 입력가능
             ORDER_TOTAL의 디폴트 값은 0
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
--입력되나 확인해봄
INSERT INTO ORDERS VALUES(1, '2022-05-18','direct',1,1,DEFAULT,5,5);
SELECT * FROM ORDERS;
--테이블 제약조건 정보 확인
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'ORDERS';
 
--강사님 답 
--제약조건 설정 : 테이블 수준 제약
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
2)주문 상세 테이블
- 테이블 : ORDER_ITEMS 
- 컬럼 :   ORDER_ID	    NUMBER(12,0)
           LINE_ITEM_ID NUMBER(3,0) 
           PRODUCT_ID   NUMBER(3,0) 
           UNIT_PRICE   NUMBER(8,2) 
           QUANTITY     NUMBER(8,0)
- 제약사항 : 기본키는 ORDER_ID와 LINE_ITEM_ID
             UNIT_PRICE, QUANTITY 의 디폴트 값은 0
             
- 복합키를 기본키로 설정할 때 컬럼수준의 제약 방법을 사용하여 해당하는 컬럼마다 PRIMARY KEY를 설정하면 오류가 남
        ORDER_ID	    NUMBER(12,0) PRIMARY KEY,
        LINE_ITEM_ID    NUMBER(3,0) PRIMARY J\KEY,
    - TABLE CAN HAVE ONLY ONE PRIMARY KEY 오류 발생
    -> 테이블 수준 제약으로 작업
*/
-- 단일키: 컬럼1개를 PRIMARY KEY
-- 복합키: 컬럼 2개 이상을 묶어서 PRIMARY KEY → 테이블 수준 제약
CREATE TABLE ORDER_ITEMS(
    ORDER_ID	    NUMBER(12,0),
    LINE_ITEM_ID    NUMBER(3,0),
    PRODUCT_ID      NUMBER(3,0),
    UNIT_PRICE      NUMBER(8,2) DEFAULT 0,
    QUANTITY        NUMBER(8,0) DEFAULT 0,
    PRIMARY KEY(ORDER_ID, LINE_ITEM_ID)
);
--테이블 제약조건 정보 확인
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'ORDER_ITEMS';
 
 --데이터 입력
 INSERT INTO ORDER_ITEMS(ORDER_ID, LINE_ITEM_ID, PRODUCT_ID) VALUES(921019,32, 10);
 SELECT * FROM ORDER_ITEMS;
/*
3)
- 테이블 : PROMOTIONS
- 컬럼 :   PROMO_ID	    NUMBER(6,0)
           PROMO_NAME   VARCHAR2(20) 
- 제약사항 : 기본키는 PROMO_ID
*/
CREATE TABLE PROMOTIONS(
    PROMO_ID	    NUMBER(6,0) PRIMARY KEY,
    PROMO_NAME   VARCHAR2(20)
);
--테이블 제약조건 정보 확인
SELECT constraint_name, constraint_type, table_name, search_condition
  FROM user_constraints
 WHERE table_name = 'PROMOTIONS';
 
 --강사님 답
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
시퀀스(SEQUENCE) : 자동 일련번호 생성하는 기능

시퀀스 명령어
1) 시퀀스명.NEXTVAL : INCREMENT BY 값 적용되어 증가 혹은 감소(마이너스 값이라면)
2) 시퀀스명.CURRVAL : 현재 상태 값
*/
--스키마
 CREATE TABLE 스키마.PROMOTIONS2(
    COL1    VARCHAR2(10)
);
 CREATE TABLE ora_user.PROMOTIONS2(
    COL1    VARCHAR2(10)
);

CREATE SEQUENCE my_seq1; -- 값 1씩 증가하는 특징
--시퀀스명.NEXTVAL : INCREMENT_BY 설정 적용
SELECT MY_SEQ1.nextval FROM DUAL;
--시퀀스명.CURRVAL : 현재 시퀀스 값 읽기
SELECT my_seq1.CURRVAL FROM DUAL;
--시퀀스 삭제
DROP SEQUENCE my_seq1;

--옵션 추가 시퀀스 생성
CREATE SEQUENCE my_seq1
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 1000
NOCYCLE
NOCACHE;
--시퀀스 값 증가
SELECT my_seq1.nextval FROM DUAL;

--지우고 다시 생성
CREATE SEQUENCE my_seq1
INCREMENT BY 1
START WITH 100;

CREATE SEQUENCE my_seq2
INCREMENT BY 10 --음수값도 가능
START WITH 100;

CREATE SEQUENCE my_seq3;
--my_seq3.NEXTVAL 명령어가 최소 1번 적용된 후에 사용해야 함
--먼저 my_seq3.CURRVAL 명령어 사용시 에러 발생
--08002. 00000 -  "sequence %s.CURRVAL is not yet defined in this session"
--INCREMENT BY 적용된 값을 확인하기 위함
SELECT my_seq3.CURRVAL FROM DUAL;

--시퀀스를 사용하기 위한 테이블
CREATE TABLE ex2_11_seq (
    COL1    NUMBER  PRIMARY KEY
);
CREATE SEQUENCE seq_ex2_11_seq;

--시퀀스를 이용한 데이터 입력
INSERT INTO ex2_11_seq(COL1) VALUES(seq_ex2_11_seq.NEXTVAL);
--INCREMENT BY 적용 시켜서 나오는 반환값을 COL1에 삽입
SELECT * FROM ex2_11_seq;]

--현재 번호 출력
SELECT seq_ex2_11_seq.CURRVAL FROM DUAL;

/*
DML : SELECT, INSERT, UPDATE, DELETE 
*/
/*
기본 구조, 사용 순서 변경 X
SELECT 컬럼명, ...
FROM 테이블명
WHERE 조건식
ORDER BY 정렬

동작순서
1) FROM 테이블명 : 메모리상에 테이블명의 모든 컬럼의 데이터가 로딩 예> 100개 데이터 행
2) WHERW 조건식 : 메모리의 100개의 데이터 중 조건에 해당하는 데이터 추출
3) ORDER BY : 정렬 명령어를 사용하여, 메모리의 데이터를 정렬
4) SELECT 컬럼명1, 컬럼명2, ... : SELECT 절에서 언급한 컬럼을 출력(조회)
*/

--EMPLOYEES 테이블의 모든 데이터를 출력(조회)하라

-- * : 테이블의 모든 컬럼명을 의미, 개발 시 코드에 사용은 하지 않는다(성능이 안좋음)
SELECT * FROM EMPLOYEES;
--접속의 EMPLOYEES 테이블의 모든 컬럼 끌어오기
SELECT employee_id, EMP_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, SALARY, MANAGER_ID, COMMISSION_PCT, RETIRE_DATE, DEPARTMENT_ID, JOB_ID, CREATE_DATE, UPDATE_DATE
FROM EMPLOYEES;

--일반 작업 시 스키마 명은 생략한다. 예) ORA_USER.EMPLOYEES
--접속 시 사용한 계정명이 스키마명으로 사용되기 때문에

--현재 ORA_USER 사용자이므로 동일한 구문
--1)스키마 명 생략
SELECT employee_id, EMP_NAME FROM EMPLOYEES;
--2) 스키마 명 사용
SELECT EMP_NAME, employee_id, SALARY  FROM ORA_USER.EMPLOYEES; --순서바꾸기

--연산 가능
--EMPLOYEES 테이블의 연봉을 2배 인상 시 결과 출력
SELECT employee_id, EMP_NAME, SALARY, SALARY * 2, SALARY * 0.7, SALARY - (SALARY * 0.3)
FROM EMPLOYEES;

--문자열 연결 연산자 : ||
--별칭 지정 : AS
SELECT EMP_NAME ||  '   ' || employee_id || '   :    ' || SALARY AS PROFILE
FROM EMPLOYEES;

--질의(QUERY) 내용 : 사원테이블에서 급여(연봉)이 5000보다 큰 데이터 조회
SELECT *
FROM EMPLOYEES --107건
WHERE SALARY > 5000; --58건

--ORDER BY : 정렬
/*
1)컬럼 1개 지정
오름 차순 : ORDER BY 컬럼명 ASC;
내림차순 ORDER BY 컬럼명 DESC;

2)컬럼 2개 지정
ORDER BY 컬럼명1 ASC, 컬럼명2 DESC;
*/
--EMPLOYEE_ID 오름차순 정렬
SELECT *
FROM EMPLOYEES --107건
WHERE SALARY > 5000 --58건
ORDER BY EMPLOYEE_ID; --ORDER BY EMPLOYEE_ID ASC;
--EMP_NAME 오름차순 정렬
SELECT *
FROM EMPLOYEES --107건
WHERE SALARY > 5000 --58건
ORDER BY EMP_NAME;

--부서ID 오름차순 정렬
SELECT emp_name, DEPARTMENT_ID, SALARY
FROM EMPLOYEES --107건
WHERE SALARY > 5000 --58건
ORDER BY DEPARTMENT_ID;

--부서ID 오름차순 정렬, SALARY 내림차순 정렬
--부서ID 먼저 오름차순으로 정렬 후 같은 부서ID 중에서 SALARY로 내림차순 정렬
SELECT emp_name, DEPARTMENT_ID, SALARY
FROM EMPLOYEES --107건
WHERE SALARY > 5000 --58건
ORDER BY DEPARTMENT_ID,SALARY DESC ;

--복수 조건
/*
AND
OR
*/
--SALARYRY 5000이상이고 JOB_ID가 'IT_PROG'인 사원을 조회
SELECT *
FROM EMPLOYEES
WHERE SALARY >= 5000 AND JOB_ID = 'IT_PROG';
--SALARYRY 5000이상이거나 JOB_ID가 'IT_PROG'인 사원을 조회
SELECT *
FROM EMPLOYEES
WHERE SALARY >= 5000 OR JOB_ID = 'IT_PROG';

--컬럼 별칭
SELECT employee_id AS 사원번호, EMP_NAME AS 사원명
FROM EMPLOYEES;

SELECT employee_id AS 사 원 번 호, EMP_NAME AS 사 원 명
FROM EMPLOYEES;--에러
SELECT employee_id AS "사 원 번 호", EMP_NAME AS "사 원 명"
FROM EMPLOYEES;

--1)테이블명.컬럼명
SELECT EMPLOYEES.employee_id, EMPLOYEES.EMP_NAME
FROM EMPLOYEES;
--2)테이블명 생략
SELECT employee_id, EMP_NAME
FROM EMPLOYEES; 

--INSERT 문 : 테이블에 데이터 입력
CREATE TABLE ex3_1 (
    COL1    VARCHAR2(10)    NULL, --NULL 생략 가능
    COL2    NUMBER  NULL,
    COL3    DATE    NULL
);
--컬럼은 테이블의 작성한 순서대로
INSERT INTO ex3_1(col1, COL2, COL3) VALUES('ABC',10, SYSDATE); --오라클의 날짜함수 : SYSDATE
--순서 바꿔도 되긴 함, 입력 컬럼명의 순서는 변경 가능
INSERT INTO ex3_1( COL2,col1, COL3) VALUES(27,'DEF', SYSDATE);
--입력하는 값이 컬럼의 데이터타입과 일치해야 함
INSERT INTO ex3_1(COL3, col1, COL2 ) VALUES ('ABC',10, 30);-- 에러

--컬럼명 생략 시 모든 컬럼명을 가리킴
INSERT INTO ex3_1 VALUES('GHI',10, SYSDATE);
--컬럼명 일부를 생략한 경우 : 컬럼이 NULL설정 OR 컬럼이 DEFAULT일 경우
--COL3이 생략 가능한 이유? COL3 DATE NULL
INSERT INTO ex3_1(COL1, COL2) VALUES('GHI',21);
SELECT * FROM ex3_1;
--INSERT 문의 기본 규칙 : 컬럼의 개수와 값이 일치해야 하고, 값이 컬럼의 데이터 타입이 동일해야 한다

--값에 NULL사용 : 컬럼의 NULL설정을 그대로 적용
INSERT INTO ex3_1 VALUES(NULL, NULL, NULL);
--날짜형식의 문자열데이터를 날짜데이터로 사용가능
/*
VALUES(10,'10','2022-05-19')
    10 -> '10' : COL1컬럼은 VARCHAR2(10)
    '10' -> 10 : COL2컬럼은 NUMBER
    '2022-05-19' -> 날짜타입으로 변환 : COL3컬럼은 DATE
*/
INSERT INTO ex3_1(col1, COL2, COL3) VALUES(10,'10','2022-05-19');


--테이블 복사 : PRIMARY KEY는 복사대상에서 제외
--테이블을 새로 생성
CREATE TABLE EMPLOYEES_TEMP
AS
SELECT * FROM EMPLOYEES;
/*
INSERT~SELECT문
기존에 존재하는 테이블에 다수의 데이터 삽입
*/
CREATE TABLE ex3_2(
    EMP_ID  NUMBER,
    EMP_NAME    VARCHAR2(100)
);
--ex3_2테이블에 EMPLOYEES에서 연봉이 5000보다 큰 데이터를 사원번호, 사원이름의 데이터만 삽입
INSERT INTO ex3_2(EMP_ID, EMP_NAME)
SELECT employee_id, EMP_NAME
FROM EMPLOYEES
WHERE SALARY > 5000;


--UPDATE문
--테이블의 데이터를 수정할 때 사용하는 명령어
SELECT * FROM ex3_1;

--WHERE절 제외하면 테이블의 모든 데이터를 대상으로 변경
UPDATE ex3_1
SET COL2 = 50; --COL1의 데이터를 전부 50으로 변경

UPDATE ex3_1
    SET COL2 = 10, COL3 = '2022-05-20'
WHERE COL1 = 'GHI'; 

--COL3컬럼이 NULL인 데이터를 조회
--잘못된 예
SELECT *
FROM ex3_1
WHERE COL3 = ''; --오라클에서 ''는 NULL의 의미지만 조건식에서는 NULL이 아님
--NULL조회는 IS NULL
SELECT *
FROM ex3_1
WHERE COL3 IS NULL;
--COL3컬럼에 데이터가 존재하는 것 : IS NOT NULL
SELECT *
FROM ex3_1
WHERE COL3 IS NOT NULL;

/*
DELETE : 테이블의 데이타 삭제

DELETE 테이블명
WHERE 조건식
*/
SELECT * FROM ex3_1;

DELETE ex3_1; --테이블의 모든 데이터 삭제!!!!!!!! 주의!!!!!!!!!!!!!!!

DELETE ex3_1
WHERE COL1 = '10';


--테이블에 INSERT, UPDATE, DELETE 작업은 임시상태에서 진행
--물리적으로 DOCMALL.DBF 파일에 적용이 안된 상태

--테이블의 임시상태에 있는 INSERT, UPDATE, DELETE 작업을 모두 취소
ROLLBACK;
--테이블의 임시상태에 있는 INSERT, UPDATE, DELETE 작업을 모두 반영
COMMIT;

--COMMIT과 ROLLBACK을 테스트하기 위한 데이터 작업
INSERT INTO ex3_1(col1, COL2, COL3) VALUES('ABC',10, SYSDATE);
INSERT INTO ex3_1(col1, COL2, COL3) VALUES('DEF',20, SYSDATE);
INSERT INTO ex3_1(col1, COL2, COL3) VALUES('ABC',30, SYSDATE);
INSERT INTO ex3_1(col1, COL2, COL3) VALUES('DEF',40, SYSDATE);
INSERT INTO ex3_1(col1, COL2, COL3) VALUES('GHI',50, SYSDATE);

COMMIT;
--물리적으로 반영 완
SELECT * FROM ex3_1;

DELETE ex3_1;
--삭제완 -> 임시작업
SELECT * FROM ex3_1;
--삭제된거 확인

ROLLBACK;
--COMMIT작업 이후의 최신작업을 취소시켜주는 것
SELECT * FROM ex3_1;

COMMIT; --물리적으로 반영

/*
TRUNCATE TABLE 테이블명: 테이블의 모든 데이터를 삭제시키는 효과(인식을 못하게 한다)
                        ROLLBACK 명령어 의미 X (로그에 기록 X여서)
DELETE 테이블명 : 테이블의 모든 데이터를 삭제
*/
TRUNCATE TABLE ex3_1;

SELECT * FROM EMPLOYEES;

/*
의사컬럼(Pseudo-column)
테이블에 존재하지 않는다
테이블의 컬럼처럼 동작하는 특징이 있다
SELECT문에서 사용할 수 있지만 INSERT, UPDATE, DELETE문은 사용할 수 없다.
*/
--ROWNUM : 테이블에 공통적으로 사용 가능, 데이터의 인덱스(일련번호)를 차례대로 부여하는 특징
SELECT ROWNUM, employee_id, EMP_NAME 
FROM EMPLOYEES;

SELECT ROWNUM, employee_id, EMP_NAME 
FROM EMPLOYEES
WHERE SALARY > 10000;

SELECT employee_id, EMP_NAME 
FROM EMPLOYEES
WHERE ROWNUM <= 5;

--ROWID : 테이블에 저장된 각 로우(행, 실제 데이터)에 저장된 주소값을 가리키는 의사컬럼
SELECT employee_id, EMP_NAME, ROWID
FROM EMPLOYEES
WHERE ROWNUM <= 5;

/*
WHERE 조건식
ANY, ALL, SOME
*/
--1)ANY : 어떤 것이든
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

--ALL은 AND 조건으로 변환 할 수 있음
--모든 조건을 동시에 만족해야 함
SELECT employee_id, SALARY
FROM EMPLOYEES
WHERE SALARY = ALL(2000, 3000, 4000)
ORDER BY employee_id;

--BETWEEN A AND B (조건식)
SELECT employee_id, SALARY
FROM EMPLOYEES
WHERE SALARY BETWEEN 2000 AND 4000
ORDER BY employee_id;
--AND로 변환 가능
SELECT employee_id, SALARY
FROM EMPLOYEES
WHERE SALARY >= 2000 AND SALARY <= 4000
ORDER BY employee_id;

--NOT 조건식
SELECT employee_id, SALARY
FROM EMPLOYEES
WHERE NOT (SALARY >= 2500)
ORDER BY employee_id;
--아래와 같음
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

-- 표현식
/*
CASE구문
유형1>
CASE 대상값 
    WHEN 값1 THEN 결과1 
    WHEN 값2 THEN 결과2 . . . 
    WHEN 값n THEN 결과m 
    ELSE 결과
END;

유형2>
CASE 
    WHEN 조건1 THEN 결과1 
    WHEN 조건2 THEN 결과2 . . . 
    WHEN 조건3 THEN 결과m 
    ELSE 결과
END;
*/
--유형1
SELECT employee_id, JOB_ID,
    CASE JOB_ID
        WHEN 'IT_PROG' THEN 'Programmer'
        WHEN 'MK_MAN' THEN 'Marketing Manager'
        WHEN 'HR_REP' THEN 'Human Resources Representative'
        ELSE 'ETC'
    END AS 업무이름 --데이터가 아니고 컬럼명이라 '' 하면 안됨 혹은 "업무 이름" 이렇게 
FROM EMPLOYEES;

/*유형2
사원 테이블에서 각 사원의 급여에 따라 
   5000 이하로 급여를 받는 사원은 C, 
   5000~15000은 B, 
   15000 이상은 A등급을 
   반환하는 쿼리를 작성해 보자.
*/
SELECT EMPLOYEE_ID, SALARY,
    CASE WHEN SALARY <= 5000 THEN 'C등급'
         WHEN SALARY > 5000 AND SALARY <= 15000 THEN 'B등급'
         ELSE 'A등급'
    END AS SALARY_GRADE
FROM EMPLOYEES;

--LIKE
/*
구문형식
WHERE 컬럼명 LIKE '문자열패턴'
컬럼명이 문자열 데이터타입이어야 함(CHAR, VARCHAR2)
단, CLOB는 사용할 수 가 없다
*/
--사원테이블에서 사원이름이 ‘A’로 시작되는 사원 조회
SELECT EMP_NAME
FROM EMPLOYEES
WHERE EMP_NAME LIKE 'A%'; -- % : 0개 이상의 문자열 WHERE EMP_NAME LIKE 'A'도 포함(A한글자만도 포함)
SELECT EMP_NAME
FROM EMPLOYEES
WHERE EMP_NAME LIKE 'Al%'; --'Al'포함

--  _ : 1개의 문자
--예) 'A__B' : 길이가 4이어야 하고 1번째 글자는 A, 2,3번째 글자는 상관 없고 4번째글자는 B
SELECT EMP_NAME
FROM EMPLOYEES
WHERE EMP_NAME LIKE 'Al_x%'; --3번째 위치에 _ (언더바)의 의미는 언더바 위치에 어떤 1개의 문자가 와도 상관 없다

--샘플 데이터
CREATE TABLE ex3_5 (
    NAMES VARCHAR2(30)
);
INSERT INTO ex3_5 VALUES('김지');
INSERT INTO ex3_5 VALUES('김지원');
INSERT INTO ex3_5 VALUES('김지투');
INSERT INTO ex3_5 VALUES('김지삼');
INSERT INTO ex3_5 VALUES('김지삼사');

SELECT * FROM ex3_5;

--이름이 '김지'로 시작하는 이름을 조회하라
SELECT * FROM ex3_5
WHERE NAMES LIKE '김지%';

--이름이 '김지'로 시작하는 이름이 3자인 경우만 조회
SELECT * FROM ex3_5
WHERE NAMES LIKE '김지_';

--이름이 '김지' 라는 단어가 존재하는 데이터를 조회하라
SELECT * FROM ex3_5
WHERE NAMES LIKE '%김지%';

--이름이 '김지' 라는 단어로 끝나는 데이터를 조회하라
SELECT * FROM ex3_5
WHERE NAMES LIKE '%김지';

/*
CLOB 대용량 데이터타입 : 성능 이슈, 자료확인 권장
*/
CREATE TABLE ex3_5_2(
    NAMES CLOB --4GB 대용량 데이터 타입
);
INSERT INTO ex3_5_2 VALUES('김지');
INSERT INTO ex3_5_2 VALUES('김지원');
INSERT INTO ex3_5_2 VALUES('김지투');
INSERT INTO ex3_5_2 VALUES('김지삼');
INSERT INTO ex3_5_2 VALUES('김지삼사');

SELECT * FROM ex3_5_2;

SELECT * FROM ex3_5_2
WHERE NAMES LIKE '김지%';

--ORDER BY 정렬: 지원 안됨
SELECT * FROM ex3_5_2
ORDER BY NAMES;

SELECT LENGTH(NAMES) FROM ex3_5_2; --문자열 길이 -> 가능
SELECT LENGTHB(NAMES) FROM ex3_5_2; --데이터 크기 -> 불가능
--22998. 00000 -  "CLOB or NCLOB in multibyte character set not supported"

-- 오류남. 4GB를 한건한건 중복 비교 못함 ㅎ
CREATE TABLE ex3_5_2(
    NAMES CLOB PRIMARY KEY --4GB 대용량 데이터 타입
);

/*
오라클 함수
1) 숫자 함수란 수식 연산을 하는 연산을 하는 함수로 연산 대상 즉, 매개변수나 반환 값이 대부분 숫자 형태
*/
--DUAL 테이블
--SELECT문 사용시 문법적이 구조를 맞추기 위하여 사용하는 특수한 테이블
SELECT 10 + 20 FROM DUAL;

/*
① ABS(n)
ABS 함수는 매개변수로 숫자를 받아 그 절대값을 반환하는 함수다.
*/
SELECT ABS(10), ABS(-10), ABS(-10.23) FROM DUAL;

/*
② CEIL(n) :올림함수 과 FLOOR(n):내림함수
CEIL 함수는 매개변수 n과 같거나 가장 큰 정수를 반환한다.
*/
SELECT CEIL(10.123), CEIL(10.541), CEIL(11.001), CEIL(11.000) FROM DUAL;
SELECT FLOOR(10.123), FLOOR(10.541), FLOOR(11.001), FLOOR(11.000) FROM DUAL;

/*
③ ROUND(n, i)와 TRUNC(n1, n2)
ROUND 함수는 매개변수 n을 소수점 기준 (i+1)번 째에서 반올림한 결과를 반환한다. 
i는 생략할 수 있고 디폴트 값은 0, 즉 소수점 첫 번째 자리에서 반올림이 일어나 정수 부분의 일의 자리에 결과가 반영된다.
*/
--기본(소수 첫째자리에서 반올림하여 정수부분에 반영)
SELECT ROUND(10.154), ROUND(10.541), ROUND(11.001) FROM DUAL;
--2번째 파라미터가 양수인 경우, 소수자리를 지정하여 반올림 반영
SELECT ROUND(10.154, 1), ROUND(10.541, 2), ROUND(10.154, 3) FROM DUAL;
--2번째 파라미터가 음수인 경우, 정수자리를 지정하여 반올림 체크
SELECT ROUND(0, 3), ROUND(115.155, -1), ROUND(115.115, -2) FROM DUAL;

--지정한 자리수 이후를 절삭 : TRUNC
SELECT TRUNC(115.155), TRUNC(115.155, -1), TRUNC(115.155, 2), TRUNC(115.155, -2) FROM DUAL;

--제곱근
--      3의 2승       3의 3승
SELECT POWER(3, 2), POWER(3, 3), POWER(3, 3.0001)
  FROM DUAL;  
--에러
SELECT POWER(-3, 3.0001) FROM DUAL;  
--루트
SELECT SQRT(2), SQRT(5)
  FROM DUAL;
  
  /*
 REMAINDER 함수 역시 n2를 n1으로 나눈 나머지 값을 반환하는데, 
 나머지를 구하는 내부적 연산 방법이 MOD 함수와는 약간 다르다.

? MOD → n2 - n1 * FLOOR (n2/n1)

? REMAINDER → n2 - n1 * ROUND (n2/n1)
 */
SELECT MOD(19,4), MOD(19.123, 4.2) FROM DUAL;
SELECT REMAINDER(19,4), REMAINDER(19.123, 4.2) FROM DUAL;

SELECT REMAINDER(18,4) FROM DUAL;

/*
문자함수
① INITCAP(char), LOWER(char), UPPER(char)
INITCAP 함수는 매개변수로 들어오는 char의 첫 문자는 대문자로, 나머지는 소문자로 반환하는 함수다.
*/
SELECT INITCAP('never say goodbye'), INITCAP('never6say*good가bye') FROM DUAL;
SELECT LOWER('NEVER SAY GOODBYE'), UPPER('never say goodbye') FROM DUAL;
--컬럼명 넣음
SELECT EMP_NAME, LOWER(EMP_NAME) FROM EMPLOYEES;

/*
CONCAT(char1, char2), SUBSTR(char, pos, len), SUBSTRB(char, pos, len)
CONCAT 함수는 ‘||’ 연산자처럼 매개변수로 들어오는 두 문자를 붙여 반환한다.
*/
-- CONCAT 함수는 ‘||’ 연산자처럼 매개변수로 들어오는 두 문자를 붙여 반환한다.  
-- 매개변수가 2개만 지원
SELECT CONCAT('I Have', ' A Dream'), 'I Have' || ' A Dream' || '!!!' FROM DUAL;

SELECT SUBSTR('ABCD EFG', 1, 4) FROM DUAL;
SELECT SUBSTR('ABCDEFT', 1, 4), SUBSTR('ABCDEFG', -2, 4) FROM DUAL;

SELECT LENGTHB('홍') FROM DUAL;
SELECT SUBSTRB('ABCDEFG', 1, 4), SUBSTRB('가나다라마바사',1, 4) FROM DUAL;

/*
③ LTRIM(char, set), RTRIM(char, set)
LTRIM 함수는 매개변수로 들어온 char 문자열에서 set으로 지정된 문자열을 왼쪽 끝에서 제거한 후 나머지 문자열을 반환한다.
두 번째 매개변수인 set은 생략할 수 있으며, 디폴트로 공백 문자 한 글자가 사용된다. 
RTRIM 함수는 LTRIM 함수와 반대로 오른쪽 끝에서 제거한 뒤 나머지 문자열을 반환한다.
*/
--1) 좌측, 우측 공백제거
SELECT LENGTH('     ABCDEF'), LENGTH('ABCDEF     ') FROM DUAL;
SELECT LENGTH(LTRIM('     ABCDEF')), LENGTH(RTRIM('ABCDEF     ')) FROM DUAL;

--2)두 번째 파라미터를 좌측 또는 우측에서 제거한 나머지를 반환
SELECT
    LTRIM('ABCDEFGABC' ,'ABC'),
    LTRIM('가나다라', '가'),
    RTRIM('ABCDEFGABC', 'ABC'),
    RTRIM('가나다라', '라')
FROM DUAL;

--제거할 수 있는 구조가 아니어서 자신이 반환
SLELECT LTRIM('가나다라', '나'), RTRIM('가나다라','나') FROM DUAL;

/*
④ LPAD(expr1, n, expr2), RPAD(expr1, n, expr2)
LPAD 함수는 매개변수로 들어온 expr2 문자열(생략할 때 디폴트는 공백 한 문자)을 n자리만큼 왼쪽부터 채워 expr1을 반환하는 함수다. 
매개변수 n은 expr2와 expr1이 합쳐져 반환되는 총 자릿수를 의미한다.
*/
CREATE TABLE ex4_1 (
    phone_num VARCHAR2(30)
);

INSERT INTO ex4_1 VALUES('111-1111');
INSERT INTO ex4_1 VALUES('111-2222');
INSERT INTO ex4_1 VALUES('111-3333');

SELECT * FROM ex4_1;
--지역번호를 추가하겠다
SELECT LPAD(phone_num, 12, '(02)') FROM ex4_1; --phone_num컬럼의 데이터를 12자리로 표현하는데 남은 4자리는 (02)로 채워라
SELECT RPAD(phone_num, 12, '(02)') FROM ex4_1;

/*
⑤ REPLACE(char, search_str, replace_str), TRANSLATE(expr, FROM_str, to_str)
REPLACE 함수는 char 문자열에서 search_str 문자열을 찾아 이를 replace_str 문자열로 대체한 결과를 반환하는 함수다.
TRANSLATE 함수는 REPLACE와 유사하다. expr 문자열에서 FROM_str에 해당하는 문자를 찾아 to_str로 바꾼 결과를 반환
*/
SELECT REPLACE('나는 너를 모르는데 너는 나를 알겠는가?', '나','너') FROM DUAL;
--'나'를 검색해서 '너'로 바꿈
SELECT 
    LTRIM(' ABC DEF '),
    RTRIM(' ABC DEF '),
    REPLACE(' ABC DEF ', ' ', '')
FROM DUAL;

--TRANSLATE : 문자열 자체가 아닌 문자 한 글자씩 매핑해 바꾼 결과를 반환
--REPLACE : 단어별(문자열) 검색하여 바꾸기(문자열을 하나로 묶어서 찾기)
--TRANSLATE : 문자 1개씩 각각 찾아서 대응하는 바꾸기
SELECT REPLACE('나는 너를 모르는데 너는 나를 알겠는가?', '나는', '너를') AS rep,
       TRANSLATE('나는 너를 모르는데 너는 나를 알겠는가?', '나는', '너를') AS trn
  FROM DUAL;


/*
⑥ INSTR(str, substr, pos, occur), LENGTH(chr), LENGTHB(chr)
INSTR 함수는 str 문자열에서 substr과 일치하는 위치를 반환하는데, pos는 시작 위치로 디폴트 값은 1, occur은 몇 번째 일치하는지를 명시하며 디폴트 값은 1이다.
*/
SELECT 
    INSTR('내가 만약 외로울 때만, 내가 만약 괴로울 때면, 내가 만약 즐거울 때면', '만약에') AS INSTR, --0
    INSTR('내가 만약 외로울 때만, 내가 만약 괴로울 때면, 내가 만약 즐거울 때면', '만약') AS INSTR1, --4
    INSTR('내가 만약 외로울 때만, 내가 만약 괴로울 때면, 내가 만약 즐거울 때면', '만약', 5) AS INSTR2,-- 18 - 문자열 5번째 위치에서 검색시작
    INSTR('내가 만약 외로울 때만, 내가 만약 괴로울 때면, 내가 만약 즐거울 때면', '만약', 5, 2) AS INSTR3 --32 - 문자열 5번쨰 위치에서검색 시작, 2번쨰 일치되는 문자열
FROM DUAL;

/*날짜함수
① SYSDATE, SYSTIMESTAMP
SYSDATE와 SYSTIMESTAMP는 현재일자와 시간을 각각 DATE, TIMESTAMP 형으로 반환한다.
*/
SELECT SYSDATE, SYSTIMESTAMP FROM DUAL;

CREATE TABLE TEST (
    COL1    DATE,
    COL2    TIMESTAMP
);

INSERT INTO TEST VALUES(SYSDATE, SYSTIMESTAMP);

SELECT * FROM TEST;

/*
② ADD_MONTHS (date, integer)
ADD_MONTHS 함수는 매개변수로 들어온 날짜에 interger 만큼의 월을 더한 날짜를 반환한다.
*/
SELECT SYSDATE, ADD_MONTHS(SYSDATE, 1), ADD_MONTHS(SYSDATE, -1) FROM DUAL;

/*
③ MONTHS_BETWEEN(date1, date2)
MONTHS_BETWEEN 함수는 두 날짜 사이의 개월 수를 반환하는데, date2가 date1보다 빠른 날짜가 온다.
*/
SELECT
    MONTHS_BETWEEN(SYSDATE, ADD_MONTHS(SYSDATE, 1)) Mon1,
    MONTHS_BETWEEN(ADD_MONTHS(SYSDATE, 1), SYSDATE) MON2
FROM DUAL;

/*
④ LAST_DAY(date)
LAST_DAY는 date 날짜를 기준으로 해당 월의 마지막 일자를 반환한다.
*/
SELECT LAST_DAY(SYSDATE), LAST_DAY('2020-08-01') FROM DUAL;

/*
⑤ ROUND(date, format), TRUNC(date, format)
ROUND와 TRUNC는 숫자 함수이면서 날짜 함수로도 쓰이는데, ROUND는 format에 따라 반올림한 날짜를, TRUNC는 잘라낸 날짜를 반환한다.
*/
SELECT SYSDATE, ROUND(SYSDATE, 'month'), TRUNC(SYSDATE, 'month') FROM DUAL;

--날짜 데이터도 반올림(ROUND), 절삭(TRUNC)할 수가 있다.
--날짜 데이터가 15일 반올림 안됨, 16일 이상이면 반올림
SELECT 
    ROUND(TO_DATE('2022-05-15'), 'month'), 
    ROUND(TO_DATE('2022-05-16'), 'month'), 
    TRUNC(TO_DATE('2022-05-15'), 'month') 
FROM DUAL;

/*
⑥ NEXT_DAY (date, char)
NEXT_DAY는 date를 char에 명시한 날짜로 다음 주 주중 일자를 반환한다.
*/
SELECT NEXT_DAY(SYSDATE, '금요일') FROM DUAL;

/*
형변환 함수
① TO_CHAR (숫자 혹은 날짜, format)
숫자나 날짜를 문자로 변환해 주는 함수가 바로 TO_CHAR로, 매개변수로는 숫자나 날짜가 올 수 있고 반환 결과를 특정 형식에 맞게 출력할 수 있다
*/
SELECT TO_CHAR(123456789) FROM DUAL; --숫자 123456789 가 문자열 123456789로 변환
SELECT TO_CHAR(123456789, '999,999,999') FROM DUAL; --숫자 123456789 가 문자열 123456789로 변환하는데 포맷을 정함

DESC EMPLOYEES;
SELECT HIRE_DATE, TO_CHAR(HIRE_DATE) FROM EMPLOYEES;
SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'MONTH') FROM EMPLOYEES; --월
SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'DAY') FROM EMPLOYEES; --요일
SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'YYYY') FROM EMPLOYEES; --년도 4자리
SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'YY') FROM EMPLOYEES; --년도 2자리

SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'D') FROM EMPLOYEES; --요일을 숫자로
SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'DD') FROM EMPLOYEES; --일
SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'DDD') FROM EMPLOYEES; --1월 1일부터 며칠째

SELECT HIRE_DATE, TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') FROM EMPLOYEES;

--날짜 조건 검색
--1)
SELECT HIRE_DATE FROM EMPLOYEES
WHERE HIRE_DATE > '2007-06-01'
ORDER BY HIRE_DATE ASC;

--2) 1번은 TO_DATE 과정이 생략됨
SELECT HIRE_DATE FROM EMPLOYEES
WHERE HIRE_DATE > TO_DATE('2007-06-01')
ORDER BY HIRE_DATE ASC;

--3) 1), 2)에 비해 성능이 저하됨
--HIRE_DATE의 데이터 수만큼 TO_CHAR() 동작
SELECT HIRE_DATE FROM EMPLOYEES
WHERE TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') > '2007-06-01'
ORDER BY HIRE_DATE ASC;
--결과는 1), 2), 3) 모두 동일
--1), 2) 형변환으로 TO_DATE()로동일한 동작 -> '2007-06-01'만 형변환 함
--3) TO_CHAR()로 동작

--기간별 날짜검색
--'2005-12-24' -> 2005-12-24 00:00:00, '2007-06-21' -> 2007-06-21 00:00:00
--2005-12-24 00:00:00 ~ 2007-06-21 00:00:00 까지여서 2005년 12월 24일 3시 이런거 포함되고 2007년 6월 21일 00시 00분 01초부턴 포함 X
SELECT HIRE_DATE FROM EMPLOYEES
WHERE HIRE_DATE >= '2005-12-24' AND HIRE_DATE <= '2007-06-21';
--성능 무시 결과 위주로 뽑겠다
SELECT HIRE_DATE FROM EMPLOYEES
WHERE TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') >= '2005-12-24' AND TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') <= '2007-06-21';
--아니면 그냥 +1일 한 값을 넣어 등호를 빼면 됨
--1)
SELECT HIRE_DATE FROM EMPLOYEES
WHERE HIRE_DATE >= '2005-12-24' AND HIRE_DATE < '2007-06-22';
--2)
SELECT HIRE_DATE FROM EMPLOYEES
WHERE HIRE_DATE >= '2005-12-24' AND HIRE_DATE < (TO_DATE('2007-06-21') + 1);

--날짜 데이터를 비교 시 시, 분, 초 저장된 것을 확인하여 비교분석
SELECT HIRE_DATE FROM EMPLOYEES
WHERE HIRE_DATE = '2007-06-21' 
--TO_DATE('2007-06-01') -> 2007-06-21 00:00:00
--기본값을 SYSDATE로 하면 00:00:00이 아니라 그당시의 시분초가 저장되어 동일한 데이터 존재 x로 나옴
ORDER BY HIRE_DATE ASC;

--등록날짜로 검색(시분초가 있음)
SELECT CREATE_DATE FROM EMPLOYEES
WHERE CREATE_DATE = '2014-01-08'
ORDER BY CREATE_DATE ASC; --값 없다고 나옴
--포맷 맞추기
SELECT CREATE_DATE FROM EMPLOYEES
WHERE TO_CHAR(CREATE_DATE, 'YYYY-MM-DD') = '2014-01-08'
ORDER BY CREATE_DATE ASC;

--시분초가 필요없는 날짜 데이터
CREATE TABLE DATE_01 (
    COL1    DATE
);

INSERT INTO DATE_01 VALUES(SYSDATE);
INSERT INTO DATE_01 VALUES(TO_CHAR(SYSDATE, 'YYYY-MM-DD'));

SELECT * FROM DATE_01;


/*
② TO_NUMBER(expr, format)
문자나 다른 유형의 숫자를 NUMBER 형으로 변환하는 함수
*/
SELECT TO_NUMBER('123456') FROM DUAL;
SELECT TO_NUMBER('123,456', '999,999') FROM DUAL; --123456 출력
SELECT TO_NUMBER('80,000', '999,999') FROM DUAL;
SELECT TO_NUMBER('100,000', '999,999') - TO_NUMBER('80,000', '999,999') FROM DUAL; --20000 출력


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--20220523

/*
NULL 관련 함수
    WHERE절
        IS NULL
        IS NOT NULLL
*/

/*
① NVL(expr1, expr2)
NVL 함수는 expr1이 NULL일 때 expr2를 반환한다.(파라미터 2개만 사용)
*/
--여러개의 파라미터 중 NULL이 아닌 그 다음의 파라미터값을 반환한다.
SELECT NVL(NULL,0) FROM DUAL; --첫번째 값이 NULL이면 0을 출력하겠다
SELECT NVL('김지원', 0) FROM DUAL; --'김지원'이라는 값이 없기 때문에 '김지원'이 출력
SELECT NVL(NULL, NULL) FROM DUAL;
SELECT NVL(NULL, NULL, 0) FROM DUAL; --파라미터 2개만 가능해서 에러

--EMPLOYEE_ID : NOT NULL 설정
--manager_id : NULL 설정
SELECT manager_id, EMPLOYEE_ID, NVL(manager_id, EMPLOYEE_ID) 
FROM EMPLOYEES
WHERE manager_id IS NULL; --Steven King 만 해당되게

/*
①-2) NVL2((expr1, expr2, expr3)
 expr1이 NULL이 아니면 expr2를, 
 NULL이면 expr3를 반환
*/
SELECT NVL2(NULL, 0, 1) FROM DUAL; --첫번째 파라미터가 NULL이면 1이 반환값이 된다.
SELECT NVL2('김지원', 0, 1) FROM DUAL;

--NULL연산 주의사항
-- 널 컬럼과 연산 시 결과값은 NULL이 된다.
SELECT NULL + '김지원' FROM DUAL; --NULL출력
SELECT NULL + 10 FROM DUAL;
--2개의 컬럼 중 하나라도 널이면 결과값은 널이 된다.
SELECT SALARY * COMMISSION_PCT FROM EMPLOYEES; --SALARY와 COMMISSION_PCT 중 하나만 NULL이어도 NULL 출력

/*급여정산
앞의 쿼리는 커미션(COMMISSION_PCT)이 
NULL인 사원은 그냥 급여를,
NULL이 아니면 '급여 + (급여 * 커미션)'
을 조회
*/
--급여정산 쿼리1)
SELECT EMPLOYEE_ID, SALARY,
    NVL2(COMMISSION_PCT, SALARY + (SALARY * COMMISSION_PCT), SALARY)AS SALARY2 
FROM EMPLOYEES;

/*
② COALESCE (expr1, expr2, …)
COALESCE 함수는 매개변수로 들어오는 표현식에서 NULL이 아닌 첫 번째 표현식을 반환하는 함수
*/
SELECT COALESCE(NULL, 1, 2) FROM DUAL; --1
SELECT COALESCE(NULL, NULL, 2) FROM DUAL; --2
SELECT COALESCE(NULL, NULL, NULL) FROM DUAL; -- NULL
--급여정산 쿼리2
SELECT EMPLOYEE_ID, SALARY, COMMISSION_PCT,
    COALESCE(SALARY + (SALARY * COMMISSION_PCT), SALARY) AS SALARY2 
FROM EMPLOYEES;

--조건식에서 NULL이 누락되는 사항을 꼭 확인
--커미션이 0.2보다 작은 데이터를 조회하라
SELECT EMPLOYEE_ID, COMMISSION_PCT
FROM EMPLOYEES
WHERE COMMISSION_PCT < 0.2; --출력결과에 커미션이 NULL(72건) 데이터가 포함 X

SELECT EMPLOYEE_ID, COMMISSION_PCT
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NULL;

--11건 + NULL을 0으로 변환하여 조건식에 적용 (72건) = 합이 83건
SELECT EMPLOYEE_ID, COMMISSION_PCT
FROM EMPLOYEES
WHERE NVL(COMMISSION_PCT, 0) < 0.2; --NULL(72건)을 0으로 변환하고 < 0.2 조건식 비교가 처리 -> NULL 데이터 포함

--COUNT(*) : 데이터 개수를 확인하는 함수
--1번과 2번이 같은 결과 출력
--1번
SELECT COUNT(*)
FROM EMPLOYEES
WHERE NVL(COMMISSION_PCT, 0) < 0.2;

/*
LNNVL(조건식)
매개변수로 들어오는 조건식의 결과가 FALSE나 UNKNOWN이면 TRUE를, TRUE이면 FALSE를 반환
*/
--2번
SELECT COUNT(*)
FROM EMPLOYEES
WHERE LNNVL(COMMISSION_PCT >= 0.2);

/*
3)NULLIF (expr1, expr2)
NULLIF 함수는 expr1과 expr2을 비교해 같으면 NULL을, 같지 않으면 expr1을 반환
*/
--같은 값
SELECT NULLIF(1, 1) FROM DUAL; --NULL
SELECT NULLIF('김지원', '김지원') FROM DUAL; --NULL
--다른 값
SELECT NULLIF(1, 2) FROM DUAL; --1

/*
JOB_HISTORY 테이블에서 
START_DATE와 END_DATE의 연도만 추출해 두 년도가 같으면 NULL을,
같지 않으면 종료년도를 출력
*/
--년도만 필요하기 때문에 앞의 4자리만 가져오기
SELECT TO_CHAR(START_DATE, 'YYYY'), TO_CHAR(END_DATE, 'YYYY') FROM JOB_HISTORY;
SELECT TO_CHAR(START_DATE, 'YYYY') AS START_YESR,
       TO_CHAR(END_DATE, 'YYYY') AS END_YEAR,
       NULLIF(TO_CHAR(END_DATE, 'YYYY'), TO_CHAR(START_DATE, 'YYYY')) AS NULLIF_YEAR
FROM JOB_HISTORY;

/*
GREATEST(expr1, expr2, …), LEAST(expr1, expr2, …)
GREATEST는 매개변수로 들어오는 표현식에서 가장 큰 값을, LEAST는 가장 작은 값을 반환
*/
    SELECT GREATEST(1, 2, 3, 2),
           LEAST(1, 2, 3, 2)
      FROM DUAL;
      
    SELECT GREATEST('이순신', '강감찬', '세종대왕'),
           LEAST('이순신', '강감찬', '세종대왕')
      FROM DUAL;
      
/*
DECODE (expr, search1, result1, search2, result2, …, default)
DECODE는 expr과 search1을 비교해 두 값이 같으면 result1을, 
같지 않으면 다시 search2와 비교해 값이 같으면 result2를 반환하고, 
이런 식으로 계속 비교한 뒤 최종적으로 같은 값이 없으면 default 값을 반환
*/
--쿼리
/*
CHANNEL_ID 컬럼의 값이 3이면 'Direct' 출력
                     9이면, 'Direct' 
                     5이면 'Indirect'
                     4이면 'Indirect'
                     나머지는 'Others'
다음과 같이 출력하자
*/
--가독성 있는 코딩
SELECT CHANNEL_ID, DECODE(CHANNEL_ID, 3, 'Direct',
                                      9, 'Direct',
                                      5, 'Indirect',
                                      4, 'Indirect',
                                     'Others') AS DECODES

FROM CHANNELS;

--가독성 없는 코딩
SELECT CHANNEL_ID, DECODE(CHANNEL_ID, 3, 'Direct', 9, 'Direct', 5, 'Indirect', 4, 'Indirect', 'Others') AS DECODES
FROM CHANNELS;

/*
기본 집계함수
집계함수란 대상 데이터를 특정 그룹으로 묶은 다음 이 그룹에 대해 총합(SUM), 평균(AVG), 최댓값(MAX), 최솟값(MIN), 개수(COUNT) 등을 구하는 함수
NULL 데이터를 제외하고 기능이 적용
단일값을 반환
*/
SELECT * FROM EMPLOYEES;
/*
① COUNT (expr)
쿼리 결과 건수, 즉 전체 로우 수를 반환하는 집계 함수
테이블 전체 로우는 물론 WHERE 조건으로 걸러진 로우 수를 반환
특정 컬럼명의 건수를 조회할 때 NULL은 제외된다
*/

SELECT COUNT(*) FROM EMPLOYEES;

/*
잘못된 사용 (구조적으로 같이 사용할 수가 없도록 되어 있다.
COUNT(*) : 107 만 출력
EMPLOYEE_ID : 107건의 데이터행 출력
*/
SELECT COUNT(*), EMPLOYEE_ID, EMP_NAME FROM EMPLOYEES;

DESC EMPLOYEES; --테이블의 NULL 여부를 확인
SELECT COUNT(EMPLOYEE_ID) FROM EMPLOYEES; --EMPLOYEE_ID컬럼은 PRIMARY KEY 설정되어 있으므로 NOT NULL이기 때문에 107 출력

--NULL데이터는 제외
SELECT COUNT(DEPARTMENT_ID) FROM EMPLOYEES; --DEPARTMENT_ID 컬럼은 NULL이고 NULL이 데이터에 포함되어 있으면 제외되고 출력
--NULL인 데이터 확인
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID IS NULL;

/*
DISTINCT : 중복된 데이터 행을 1개가 참조하고  나머지는 제외하는 기능
*/
--사원테이블을 참조하여 부서가 몇개인지 알고 싶다
SELECT COUNT(DISTINCT DEPARTMENT_ID) FROM EMPLOYEES;
--어떤 부서가 있는지 확인(중복 제거)
SELECT DISTINCT DEPARTMENT_ID FROM EMPLOYEES;
--정렬시 컬럼명 대신 숫자 사용 가능
SELECT DISTINCT DEPARTMENT_ID FROM EMPLOYEES
ORDER BY 1;
-- 여러개의 컬럼 중 동시에 만족하는 데이터를 1개만 참조하고 나머지는 제외
SELECT DISTINCT EMPLOYEE_ID, DEPARTMENT_ID FROM EMPLOYEES;

/*
② SUM(expr)
SUM은 expr의 전체 합계를 반환하는 함수로 매개변수 expr에는 숫자형만 
*/
--사원 테이블에서 급여가 숫자형이므로 전 사원의 급여 총액을 구해 보자.
SELECT SUM(SALARY) FROM EMPLOYEES; --집계함수는 컬럼의 널 데이터를 제외하고 함수가 사용
--현재 NULL값 있는지 조회하여 확인
SELECT SALARY FROM EMPLOYEES WHERE SALARY IS NULL;

--평균 : AVG 함수 사용
SELECT AVG(SALARY) FROM EMPLOYEES;
--소수 둘째자리까지만 출력
SELECT ROUND(AVG(SALARY), 2) FROM EMPLOYEES;

--가장 높은 연봉?
SELECT MAX(SALARY) FROM EMPLOYEES;
--가장 낮은 연봉
SELECT MIN(SALARY) FROM EMPLOYEES;

--합쳐서
SELECT COUNT(*), SUM(SALARY), AVG(SALARY), MAX(SALARY), MIN(SALARY) FROM EMPLOYEES;

/*
자격증 접수 : 30명
응시 이누언수 : 25명
미응시 인원수 : 5명

전체 30명의 평균을 구해야 함
*/
SELECT AVG(점수) FROM 자격증 접수;

--점수 컬럼에 NULL인 데이터를 0으로 변경하여 처리
SELECT AVG(NVL(점수,0)) FROM 자격증 접수;


/*
GROUP BY절
- 특정 그룹으로 묶어 데이터를 집계
- 그룹으로 묶을 컬럼명이나 표현식을 GROUP BY 절에 명시해서 사용
- WHERE와 ORDER BY절 사이에 위치

그룹화
- 컬럼의 동일한 데이터를 대상으로 하여 묶는 의미

GROUP BY 문법을 사용시에는 SELECT절에 사용하는 컬럼은 제한이 되어 있다.
- GROUP BY에 언급한 컬럼명과 집계함수만 SELECT절에 사용 가능

**특징
1) GROUP BY 절: 계층구조의 결과를 포함하지 않는다. (그룹화된 데이터의 내역만 보여줌)
2) GROUP BY ROLLUP 절 : 그룹화된 데이터의 내역, 내역을 대상으로 한 소계, 전체 합계(계층구조가 포함)
3) GROUP BY CUBE 절 : 그룹화된 데이터의 내역, 내역을 대상으로 한 소계, + 모든 조합수의 소계, 전체 합계(계층구조가 포함)
*/

/*
질문시, 그룹화 대상의 컬럼이 무엇인지 판단!!
사원 테이블에서 각 부서별 급여의 총액
*/
--부서 ID를 오름차순으로 정렬
SELECT DEPARTMENT_ID, SALARY
FROM EMPLOYEES
ORDER BY DEPARTMENT_ID; 
 --DEPARTMENT_ID의 동일한 데이터들을 묶어(그룹화) 부서별 합계를 구한다.
SELECT SUM(SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

--두 개 합침
SELECT DEPARTMENT_ID, SUM(SALARY)
FROM EMPLOYEES --전체 데이터 대상 작업
GROUP BY DEPARTMENT_ID --DEPARTMENT_ID의 동일한 데이터들을 묶는다
ORDER BY DEPARTMENT_ID; --오름차순 정렬

--GROUP BY 문법을 사용시에는 SELECT절에 사용하는 컬럼은 제한
SELECT EMPLOYEE_ID /* 107건 데이터 출력 */, DEPARTMENT_ID /*그룹화된 데이터만 출력 */, SUM(SALARY)
FROM EMPLOYEES 
GROUP BY DEPARTMENT_ID 
ORDER BY DEPARTMENT_ID;
--00979. 00000 -  "not a GROUP BY expression"
--EMPLOYEE_ID 컬럼 사용 X

/*
사원 테이블에서 각 부서별 인원수
*/
SELECT DEPARTMENT_ID, COUNT(EMPLOYEE_ID)NUMBER_OF_EMPLOYEES
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;

/*
사원 테이블에서 각 부서별 평균 연봉을 구하라
*/
SELECT DEPARTMENT_ID, ROUND(AVG(SALARY), 2)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;

--종합으로 집계함수를 모두 사용
--각 부서별 -> 급여합계 급여 평균, 사원 수, 부서별 가장 높은 금액, 부서별 가장 낮은 금액
SELECT DEPARTMENT_ID, COUNT(EMPLOYEE_ID), SUM(SALARY), ROUND(AVG(SALARY), 2), MAX(SALARY), MIN(SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;

/*
HAVING 절 : GROUP BY 문법과 함께 사용하며(단독 X), 발생된 데이터에 대하여 조건식을 사용
- GROUP BY절 다음에 위치해 GROUP BY한 결과를 대상으로 다시 필터를 거는 역할을 수행
- HAVING 필터 조건 형태로 사용
- 반드시 집계함수 형태로 사용

WHERE절은 FROM 뒤에 오며 전체 데이터를 대상으로 필터
*/
--사원 테이블에서 각 부서별 평균 연봉이 3000보다 큰 데이터를 출력하라
SELECT DEPARTMENT_ID, ROUND(AVG(SALARY), 2)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) > 5000
ORDER BY DEPARTMENT_ID;

--대출관련 테이블 : KOR_LOAN_STATUS
SELECT * FROM KOR_LOAN_STATUS;
DESC KOR_LOAN_STATUS; --데이터타입과 널 유무 확인

--2013년 지역별 가계대출 총 잔액
SELECT REGION, SUM(LOAN_JAN_AMT) TOT_LOAN
FROM KOR_LOAN_STATUS
WHERE PERIOD LIKE '2013%'
GROUP BY REGION
ORDER BY REGION;

/*
**특징
1) GROUP BY 절: 계층구조의 결과를 포함하지 않는다. (그룹화된 데이터의 내역만 보여줌)
2) GROUP BY ROLLUP 절 : 그룹화된 데이터의 내역, 내역을 대상으로 한 소계, 전체 합계(계층구조가 포함)
3) GROUP BY CUBE 절 : 그룹화된 데이터의 내역, 내역을 대상으로 한 소계, + 모든 조합수의 소계, 전체 합계(계층구조가 포함)
*/
--1) 2013년 지역별 가계대출별 총 잔액
--1레벨 데이터만 출력(ROLLUP 레벨 관점)
SELECT REGION, GUBUN, SUM(LOAN_JAN_AMT) TOT_LOAN
FROM KOR_LOAN_STATUS
WHERE PERIOD LIKE '2013%'
GROUP BY REGION, GUBUN
ORDER BY REGION;
--2) 2013년 지역별 합계도 보고 싶다면? ROLUP - 2레벨, 3레벨 추가
SELECT REGION, GUBUN, SUM(LOAN_JAN_AMT) TOT_LOAN
FROM KOR_LOAN_STATUS
WHERE PERIOD LIKE '2013%'
GROUP BY ROLLUP( REGION, GUBUN)
ORDER BY REGION;
--3) 2013년 지역별 합계 + 구분별 합계 보고싶다면? CUBE - 2의 컬럼갯수2승 = 4개유형
SELECT REGION, GUBUN, SUM(LOAN_JAN_AMT) TOT_LOAN
FROM KOR_LOAN_STATUS
WHERE PERIOD LIKE '2013%'
GROUP BY CUBE( REGION, GUBUN)
ORDER BY REGION;


--2013년 11월 데이터 한정 지역별 가계대출 총 잔액
SELECT REGION, SUM(LOAN_JAN_AMT) TOT_LOAN
FROM KOR_LOAN_STATUS
WHERE PERIOD LIKE '201311'
GROUP BY REGION
ORDER BY REGION;

--사원테이블의 부서ID와 JOBID별 평균 급여가 3000보다 큰 데이터를 조회하라
SELECT department_id, JOB_ID, COUNT(*), ROUND(AVG(SALARY),2) AVGSALARY
FROM EMPLOYEES --1)
GROUP BY department_id, JOB_ID --2)
HAVING AVG(SALARY) > 3000 --3)
ORDER BY department_id, JOB_ID; --4)

/*
ROLLUP 절과 CUBE 절
GROUP BY절에서 사용되어 그룹별 소계를 추가로 보여 주는 역할
*/
--ROLLUP을 적용하지 않은 상태
SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, gubun --2개 컬럼을 동시에 만족하는 데이터
ORDER BY period;
/*
PERIOD GUBUN                            TOTL_JAN
------ ------------------------------ ----------
201310 기타대출                           676078
201310 주택담보대출                     411415.9
201311 기타대출                         681121.3
201311 주택담보대출                     414236.9
*/

--ROLLUP 적용
--GROUP BY PERIOD, GUBUN 데이터를 내역으고 하여 중간소계, 최종소계 함께 출력
SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY ROLLUP(period, gubun) --컬럼 수 2 + 1 -> 3레벨
ORDER BY period;
/*
PERIOD GUBUN                            TOTL_JAN
------ ------------------------------ ----------
201310 기타대출                           676078 --내역 -3레벨
201310 주택담보대출                     411415.9 --내역 -3레벨
201310                                 1087493.9 --PERIOD 중간 소계 - 2레벨
201311 기타대출                         681121.3 --내역 -3레벨
201311 주택담보대출                     414236.9 --내역 -3레벨
201311                                 1095358.2 --PERIOD 중간 소계 - 2레벨
                                       2182852.1 --전체 집계 - 1레벨
*/
--PERIOD와 GUBUN 의 ROLLUP 순서를 바꾸면?
SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY ROLLUP(gubun, period) --컬럼 수 2 + 1 -> 3레벨, 전체집계, GUBUN중간 소계, 내역
ORDER BY period;
/*
PERIOD GUBUN                            TOTL_JAN
------ ------------------------------ ----------
201310 기타대출                           676078
201310 주택담보대출                     411415.9
201311 주택담보대출                     414236.9
201311 기타대출                         681121.3
       기타대출                        1357199.3 --GUBUN 집계
                                      2182852.1 --전체 집계
       주택담보대출                      825652.8 --GUBUN 집계
*/

SELECT period, gubun, SUM(loan_jan_amt) totl_jan
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period, ROLLUP(gubun); --전체 집계 제외한 출력모습, ROLLUP의 컬럼 1개 + 1 -> 2레벨
/*
PERIOD GUBUN                            TOTL_JAN
------ ------------------------------ ----------
201310 기타대출                           676078 --내역 - 2레벨
201310 주택담보대출                     411415.9 --내역 -2레벨
201310                                 1087493.9 --1레벨
201311 기타대출                         681121.3 --내역 -2레벨
201311 주택담보대출                     414236.9 --내역 -2레벨
201311                                 1095358.2--1레벨
*/

/*ROLLUP 실습 예제 - HR계정 */


--++++++++++++++++++++++++++++++++++++20220524+++++++++++++++++++++++++++++++++++++++++++++++
--=======집합 연산자==============
/*
BLOB, CLOB, BFILE 타입의 컬럼에 대해서는 집합 연산자를 사용할 수 없다
UNION, INTERSECT, MINUS 연산자는 LONG형 컬럼에는 사용할 수 없다
*/
------UNON은 합집합을 의미한다-----
--컬럼의 개수와 타입이 동일 혹은 호환이 가능해야 한다.

--한국, 일본의 주요 10대 수출품
CREATE TABLE exp_goods_asia (
       country VARCHAR2(10),
       seq     NUMBER,
       goods   VARCHAR2(80)
);

INSERT INTO exp_goods_asia VALUES ('한국', 1, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('한국', 2, '자동차');
INSERT INTO exp_goods_asia VALUES ('한국', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('한국', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('한국', 5,  'LCD');
INSERT INTO exp_goods_asia VALUES ('한국', 6,  '자동차부품');
INSERT INTO exp_goods_asia VALUES ('한국', 7,  '휴대전화');
INSERT INTO exp_goods_asia VALUES ('한국', 8,  '환식탄화수소');
INSERT INTO exp_goods_asia VALUES ('한국', 9,  '무선송신기 디스플레이 부속품');
INSERT INTO exp_goods_asia VALUES ('한국', 10,  '철 또는 비합금강');
INSERT INTO exp_goods_asia VALUES ('일본', 1, '자동차');
INSERT INTO exp_goods_asia VALUES ('일본', 2, '자동차부품');
INSERT INTO exp_goods_asia VALUES ('일본', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('일본', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('일본', 5, '반도체웨이퍼');
INSERT INTO exp_goods_asia VALUES ('일본', 6, '화물차');
INSERT INTO exp_goods_asia VALUES ('일본', 7, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('일본', 8, '건설기계');
INSERT INTO exp_goods_asia VALUES ('일본', 9, '다이오드, 트랜지스터');
INSERT INTO exp_goods_asia VALUES ('일본', 10, '기계류');

COMMIT;
--데이터 구성 살펴보기
SELECT * FROM exp_goods_asia;

--한국의 주요 수출품목을 조회하라
SELECT *
FROM exp_goods_asia
WHERE country = '한국'
ORDER BY SEQ;
--일본의 주요 수출품목을 조회하라
SELECT *
FROM exp_goods_asia
WHERE country = '일본'
ORDER BY SEQ;

--국가에 상관없이 모든 수출품목을 조회 (단, 품목은 한 번만 조회)
--1)두 결과를 합침 - UNION (ORDER BY절 삭제, 두 쿼리 사이에 UNION 삽입)
SELECT *
FROM exp_goods_asia
WHERE country = '한국'
UNION
SELECT *
FROM exp_goods_asia
WHERE country = '일본';
--2)품목만 조회
SELECT GOODS
FROM exp_goods_asia
WHERE country = '한국'
UNION
SELECT GOODS
FROM exp_goods_asia
WHERE country = '일본'; --전체 20건 중 중복된 데이터는 한 번만 조회하여 15건 출력
--3)전체 수출품목 조회(품목 중복 O)-> UNION ALL
SELECT GOODS
FROM exp_goods_asia
WHERE country = '한국'
UNION ALL
SELECT GOODS
FROM exp_goods_asia
WHERE country = '일본';

--UNION 사용 불가
--개수가 다름
--01789. 00000 -  "query block has incorrect number of result columns"
SELECT SEQ, GOODS
FROM exp_goods_asia
WHERE country = '한국'
UNION
SELECT GOODS
FROM exp_goods_asia
WHERE country = '일본';
--타입이 다름
--01790. 00000 -  "expression must have same datatype as corresponding expression"
SELECT SEQ
FROM exp_goods_asia
WHERE country = '한국'
UNION
SELECT GOODS
FROM exp_goods_asia
WHERE country = '일본';

--타입은 다르지만 굳이 출력 하겠다면? - 형변환
SELECT TO_CHAR(SEQ)
FROM exp_goods_asia
WHERE country = '한국'
UNION
SELECT GOODS
FROM exp_goods_asia
WHERE country = '일본';

--SELECT문 여러개 사용 가능
SELECT TO_CHAR(SEQ)AS "번호"
FROM exp_goods_asia
WHERE country = '한국'
UNION
SELECT GOODS
FROM exp_goods_asia
WHERE country = '일본'
UNION
SELECT TO_CHAR(SEQ)
FROM exp_goods_asia
WHERE country = '한국';

/*
INTERSECT
INTERSECT는 합집합이 아닌 교집합을 의미한다. 
즉 데이터 집합에서 공통된 항목만 추출해 낸다.
*/
SELECT * FROM exp_goods_asia;
--일본과 한국의 공통된 품목 출력
SELECT GOODS
FROM exp_goods_asia
WHERE country = '한국'
INTERSECT
SELECT GOODS
FROM exp_goods_asia
WHERE country = '일본';

/*
MINUS
MINUS는 차집합을 의미한다. 
즉 한 데이터 집합을 기준으로 다른 데이터 집합과 공통된 항목을 제외한 결과만 추출해 낸다.
*/
--한국입장에서 바라볼 때, 일본과 겹치지 않는 품목 조회
SELECT GOODS
FROM exp_goods_asia
WHERE country = '한국'
MINUS
SELECT GOODS
FROM exp_goods_asia
WHERE country = '일본';
--일본입장에서 바라볼 때, 한국과 겹치지 않는 품목 조회
SELECT GOODS
FROM exp_goods_asia
WHERE country = '일본'
MINUS
SELECT GOODS
FROM exp_goods_asia
WHERE country = '한국';

/*
집합 연산자로 SELECT 문을 연결할 때 ORDER BY절은 맨 마지막 SELECT 문장에서만 사용
*/
--1) 에러 발생
    SELECT goods
      FROM exp_goods_asia
     WHERE country = '한국'
     ORDER BY goods
     UNION
    SELECT goods
      FROM exp_goods_asia
     WHERE country = '일본';
--2)성공
    SELECT goods
      FROM exp_goods_asia
     WHERE country = '한국'
     UNION
    SELECT goods
      FROM exp_goods_asia
     WHERE country = '일본'
      ORDER BY goods; --앞 SELECT문의 결과를 전체적인 관점에서 정렬하는 의미로 사용
      
/*
GROUPING SETS
- ROLLUP이나 CUBE처럼 GROUP BY 절에 명시해서 그룹 쿼리에 사용되는 절
*/

SELECT period, gubun, SUM(loan_jan_amt) totl_jan
 FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY GROUPING SETS(period, gubun);
/*
아래 결과와 같은 의미
 SELECT period, SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%' 
 GROUP BY PERIOD
 UNION ALL
 SELECT gubun, SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%' 
 GROUP BY gubun;
 */
 
SELECT period, gubun, region, SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%' 
   AND region IN ('서울', '경기')
 GROUP BY GROUPING SETS(period, (gubun, region));

/*
아래 결과와 같은 결과
 SELECT period, SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%' 
    AND region IN ('서울', '경기')
 GROUP BY PERIOD
 UNION ALL
 SELECT gubun, SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%' 
    AND region IN ('서울', '경기')
 GROUP BY gubun,region;
 */
  SELECT period, SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%' 
    AND region IN ('서울', '경기')
 GROUP BY PERIOD
 UNION ALL
 SELECT gubun, SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%' 
    AND region IN ('서울', '경기')
 GROUP BY gubun,region;
 
 /*
 조인
 --테이블 2개에 존재하는 각 컬럼의 데이터를 비교하여 일치되는 데이터를 수평적 결합을 하는 형태
 */
 -- 사원테이블의 모든 데이터를 출력하는데 사원번호, 사원이름, 부서 ID대신 부서이름을 출력
 --1)
SELECT employee_id, EMP_NAME, DEPARTMENT_ID 
FROM EMPLOYEES
WHERE ROWNUM <= 10;
--2)
SELECT DEPARTMENT_ID, DEPARTMENT_NAME
FROM DEPARTMENTS;
--3) 결과
SELECT employee_id, EMP_NAME, departments.department_name 
FROM EMPLOYEES 
INNER JOIN DEPARTMENTS
ON EMPLOYEES.DEPARTMENT_ID = departments.department_id
WHERE ROWNUM <= 10;

--만약? 사원테이블의 모든 데이터를 출력하는데 사원번호, 사원이름, 부서 ID
SELECT employee_id, EMP_NAME, DEPARTMENT_ID FROM EMPLOYEES;

--모든 사원정보 데이터를 출력 (사원번호, 사원이름, 부서이름)
--사원번호, 사원이름 : EMPLOYEES
--부서이름 : DEPARTMNETS
--컬럼순서는 사원번호, 이름, 부서이름
--조인 한다 == 비교한다
--ON == WHERE
--INNER JOIN : 일치되는 데이터를 수평적 결합
--ANSI조인 (표준)
SELECT employee_id, EMP_NAME, departments.department_name
FROM EMPLOYEES INNER JOIN DEPARTMENTS --EMPLOYEES 테이블과 DEPARTMENTS테이블을 비교한다
ON employees.department_id = departments.department_id; 
--EMPLOYEES 테이블의 department_id와 DEPARTMENTS테이블의 department_id를 비교한다

--ORACLE 조인
--INNER JOIN 대신 콤마
--ON 대신 WHERE
SELECT *
FROM EMPLOYEES, DEPARTMENTS
WHERE employees.department_id = departments.department_id; 

--부서가 담당했던 JOB_ID 출력
-- 컬럼은 department_id, DEPARTMENT_NAME, JOB_ID
--주체는 부서
--JOB_HISTORY에 department_id와 JOB_ID 존재 -> 둘 다 FK로 존재 가능
--JOB_HISTORY에 있는 부서만 조회됨
--ANSI JOIN
SELECT DEPARTMENTS.department_id, DEPARTMENT_NAME, JOB_ID
FROM DEPARTMENTS INNER JOIN JOB_HISTORY
ON departments.department_id = job_history.department_id;
--ORACLE
SELECT DEPARTMENTS.department_id, DEPARTMENT_NAME, JOB_ID
FROM DEPARTMENTS, JOB_HISTORY
WHERE departments.department_id = job_history.department_id;

--JOB_HISTORY에 없어도 모든 부서도 출력하고 싶다면?
--부서 테이블 중 JOB_HISTORY 테이블에 데이터가 존재하지 않는 부서 포함 출력
--> OUTER JOIN
/* OUTER JOIN: 일치 하는 데이터(INNER JOIN) + 일치 되지 않는 데이터도 출력
--LEFT OUTER JOIN, RIGHT OUTER JOIN, FULL OUTER JOIN
*/
--1) LEFT OUTER JOIN
--LEFT : 일치되지 않는 데이터로 좌측 테이블을 가리킴
SELECT DEPARTMENTS.department_id, DEPARTMENT_NAME, JOB_ID
FROM DEPARTMENTS LEFT OUTER JOIN JOB_HISTORY
ON departments.department_id = job_history.department_id;
--2) RIGHT
--RIGHT : 일치되지 않는 데이터로 우측 테이블을 가리킴
SELECT DEPARTMENTS.department_id, DEPARTMENT_NAME, JOB_ID
FROM job_history RIGHT OUTER JOIN DEPARTMENTS
ON departments.department_id = job_history.department_id;
--3) OUTER JOIN을 썼지만 INNER JOIN과 같은 결과가 나옴 어쩌다보니!
--JOB_HISTORY에 일치하지 않는 데이터는 없어서( 다 일치함)
SELECT DEPARTMENTS.department_id, DEPARTMENT_NAME, JOB_ID
FROM job_history LEFT OUTER JOIN DEPARTMENTS
ON departments.department_id = job_history.department_id;

--ORACLE LEFT OUTER JOIN (+) : 조인 조건에서 데이터가 없는 테이블의 컬럼에 사용
SELECT DEPARTMENTS.department_id, DEPARTMENT_NAME, JOB_ID
FROM DEPARTMENTS, job_history
WHERE departments.department_id = job_history.department_id(+);

--ORACLE RIGHT OUTER JOIN (+)
SELECT DEPARTMENTS.department_id, DEPARTMENT_NAME, JOB_ID
FROM job_history,DEPARTMENTS
WHERE departments.department_id = job_history.department_id(+);
/*
LEFT OUTER JOIN에서 조건이 추가될 경우 (+)도 추가
*/
--1) 잘못된 경우
    select a.employee_id, a.emp_name, b.job_id, b.department_id
      from employees a,
           job_history b
     where a.employee_id  = b.employee_id(+)
       and a.department_id = b.department_id;
--2) 올바른 경우
    select a.employee_id, a.emp_name, b.job_id, b.department_id
      from employees a,
           job_history b
     where a.employee_id  = b.employee_id(+)
       and a.department_id = b.department_id(+);

--ANSI: FULL OUTER JOIN (LEFT OUTER JOIN + RIGHT OUTER JOIN)
--JOB_HISTORY테이블의 부서코드 컬럼의 데이터가 DEPARTMENTS테이블에 부분집합.
--즉, 종속적인 관계로 인하여 1번과 2번은 결과가 동일
--1)
SELECT DEPARTMENTS.department_id, DEPARTMENT_NAME, JOB_ID
FROM DEPARTMENTS FULL OUTER JOIN JOB_HISTORY --JOB_HISTORY에 일치하지 않는 데이터 X
ON departments.department_id = job_history.department_id;
--2) 1과 같은 결과
SELECT DEPARTMENTS.department_id, DEPARTMENT_NAME, JOB_ID
FROM DEPARTMENTS LEFT OUTER JOIN JOB_HISTORY
ON departments.department_id = job_history.department_id;

--ORACLE FULL OUTER JOIN은 지원 X
--조인 조건 하나에 (+) 2개를 좌, 우측에 사용하는 문법 X
SELECT DEPARTMENTS.department_id, DEPARTMENT_NAME, JOB_ID
FROM job_history,DEPARTMENTS
WHERE departments.department_id(+) = job_history.department_id(+);

/*
카타시안 조인
카타시안 조인(CATASIAN PRODUCT)은 WHERE 절에 조인 조건이 없는 조인을 말한다. 
즉 FROM 절에 테이블을 명시했으나, 두 테이블 간 조인 조건이 없는 조인
*/
--107 * 27 데이터행 출력
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
FROM employees a,
     departments b;
--WHERE절이 없는 형태

SELECT COUNT(*) FROM EMPLOYEES; -- 107건
SELECT COUNT(*) FROM DEPARTMENTS; --27건


--2013년 1월 1일 이후에 입사한 사원번호, 사원명, 부서번호, 부서명을 조회하는 쿼리를 비교해 보자.
--<ORACLE 문법>
    SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
      FROM employees a,
           departments b
     WHERE a.department_id = b.department_id
       AND a.hire_date >= TO_DATE('2003-01-01','YYYY-MM-DD');
       
--<ANSI 문법>
    SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
      FROM employees a
     INNER JOIN departments b
        ON (a.department_id = b.department_id )
     WHERE a.hire_date >= TO_DATE('2003-01-01','YYYY-MM-DD');

--ON 대신 USING 사용
--<잘못된 경우>
--SELECT문의 b.department_id 에 별칭을 사용해서 에러가 남
   SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
      FROM employees a
     INNER JOIN departments b
     USING (department_id) -- = ON employees.department_id = department.department_name
     WHERE a.hire_date >= TO_DATE('2003-01-01','YYYY-MM-DD');
--SQL 오류: ORA-25154: USING 절의 열 부분은 식별자를 가질 수 없음.

--<잘 된 경우>
 SELECT a.employee_id, a.emp_name, department_id, b.department_name
      FROM employees a --테이블 별칭 a
     INNER JOIN departments b --테이블 별칭 b
     USING (department_id)
     WHERE a.hire_date >= TO_DATE('2003-01-01','YYYY-MM-DD');
     
--ON절 사용시 SELECT절에 조건에 사용하는 중복된 컬럼명은 별칭을 사용
   SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
      FROM employees a
     INNER JOIN departments b
     ON a.department_id = department.department_name;

--테이블 별칭 사용 안한 경우
   SELECT employees.employee_id, employees.emp_name, departments.department_id, departments.department_name
      FROM employees
     INNER JOIN departments
     ON employees.department_id = department.department_name;
     
--<기존 ORACLE 문법>
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
FROM employees a,
    departments b;

--<ANSI 문법>
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
FROM employees a
CROSS JOIN departments b;

/*
FULL OUTER JOIN 예제
*/
CREATE TABLE HONG_A  (EMP_ID INT);
CREATE TABLE HONG_B  (EMP_ID INT);

INSERT INTO HONG_A VALUES ( 10);
INSERT INTO HONG_A VALUES ( 20);
INSERT INTO HONG_A VALUES ( 40);
INSERT INTO HONG_B VALUES ( 10);
INSERT INTO HONG_B VALUES ( 20);
INSERT INTO HONG_B VALUES ( 30);

COMMIT;
--오라클 FULL OUTER JOIN 지원 X

--ANSI FULL OUTER JOIN
SELECT a.emp_id, b.emp_id
FROM hong_a a
FULL OUTER JOIN hong_b b
ON ( a.emp_id = b.emp_id);

--출력시 테이블에 데이터가 존재하지 않는 NULL과 조인 시 일치되지 않은 상태에서 결합된 모습의 NULL(OUTER JOIN) 구분


/*
서브 쿼리
SQL 문장 안에서 보조로 사용되는 또 다른 SELECT문을 의미
*/

/*
연관성 없는 서브 쿼리
메인 쿼리와의 연관성이 없는 서브 쿼리
메인 테이블과 조인 조건이 걸리지 않는 서브 쿼리
- 서브쿼리인 SELECT문을 실행됐을 때 결과나오는 쿼리
*/
--유형1>
--전 사원의 평균 급여 이상을 받는 사원 수를 조회
--1) 전 사원의 평균 급여
SELECT AVG(SALARY) FROM EMPLOYEES;
--2) 조건식 : 전 사원의 평균 급여 < 급여 인 인원수
SELECT count(*) --메인 쿼리
FROM employees
WHERE salary >=  (SELECT AVG(SALARY) FROM EMPLOYEES); --서브쿼리()안의 SELECT문

--유형2>
--부서 테이블에서 parent_id가 NULL인 부서번호를 가진 사원의 총 건수를 반환
--1) 부서 테이블에서 PARENT_ID가 NULL인 부서번호
SELECT department_id
FROM departments
WHERE parent_id IS NULL;
--2) 조건식 : 부서 테이블에서 PARENT_ID가 NULL인 부서번호
--IN 사용 시, 서브쿼리의 결과값이 여러개 값일 경우 사용
--EX) IN (값1, 값2, 값3, ...)
    SELECT count(*)
      FROM employees
     WHERE department_id IN ( SELECT department_id
                                FROM departments
                               WHERE parent_id IS NULL);
--IN 대신 = 써도 이 경우엔 같은 결과 출력
-- 관계연산자(> ,<, >=, <=, =, !=) 사용 시 서브쿼리 결과 값이 단일값이어야 한다(값이 하나를 의미)
--서브쿼리 값이 여러개로 반환되면 에러 발생
    SELECT count(*)
      FROM employees
     WHERE department_id = ( SELECT department_id
                                FROM departments
                               WHERE parent_id IS NULL);
                               
--유형3> 서브쿼리의 결과가 동시에 2개 이상의 컬럼 값을 갖는 경우 
--비교시 2개의 컬럼 값은 동시에 만족이 되어야 함, 컬럼의 개수와 타입 일치(호환) 필요
-- job_history 테이블에 있는 employee_id, job_id 두 값과 같은 건을 사원 테이블에서 찾는 쿼리
    SELECT employee_id, emp_name, job_id
      FROM employees
     WHERE (employee_id, job_id ) IN ( SELECT employee_id, job_id
                                        FROM job_history);

--서브 쿼리는 SELECT문 뿐만 아니라 다음과 같이 UPDATE문, DELETE문에서도 사용할 수 있다.
--<전 사원의 급여를 평균 금액으로 갱신>
 UPDATE employees
SET salary = ( SELECT AVG(salary) FROM employees );

--<평균 급여보다 많이 받는 사원 삭제> 실행 X
DELETE employees
WHERE salary >= ( SELECT AVG(salary) FROM employees );


/*
연관성 있는 서브 쿼리
메인 쿼리와의 연관성이 있는 서브 쿼리, 즉 메인 테이블과 조인 조건이 걸린 서브 쿼리
*/
--메인 쿼리(27개 데이터) -> 서브 쿼리의 조건식에 참조 (a)
--EXISTS(SELECT문) : ()안의 SELECT문의 결과가 존재 하면 TRUE, 존재하지 않으면 FALSE
--메인쿼리의 테이블의 a.department_id컬럼의 데이터 27개를 서브 쿼리에서 하나씩 비교하여 
--EXISTS(SELECT문)데이터 존재하면 메인 쿼리로 데이터행 반환
--                      존재하지 않으면 버려진다
--메인 쿼리에서 돌려받은 데이터행으로 결과 출력
--1의 의미는 EXISTS의 조건식이 TRUE일 경우 데이터 존재한다는 의미로 EXISTS()함수에서 사용시 TRUE로 해석
/*
메인 쿼리에서 사용된 부서 테이블의 부서번호와 job_history 테이블의 부서번호가 같은 건을 조회하고 있다. 
또한 EXISTS 연산자를 사용해서 서브 쿼리 내에 조인 조건이 포함되어 있다. 
따라서 결과는 job_history 테이블에 있는 부서만 조회
*/
SELECT a.department_id, a.department_name
      FROM departments a
     WHERE EXISTS ( SELECT 1 --데이터가 존재한다는 의미로 작성
                      FROM job_history b
                     WHERE 50 = b.department_id ); --()안에는 a가 없음-> 에러-> 메인 쿼리에서 참조하고 조건이 포함
                     
                     
--1) SELECT절의 컬럼 위치에 서브쿼리가 존재
SELECT a.employee_id,
       ( SELECT b.emp_name
           FROM employees b
           WHERE a.employee_id = b.employee_id) AS emp_name,
       a.department_id,
       ( SELECT b.department_name
            FROM departments b
            WHERE a.department_id = b.department_id) AS dep_name
FROM job_history a;
/*
SELECT a.employee_id,
       a.department_id,
FROM job_history a;
이게 메인쿼리
( SELECT b.emp_name
    FROM employees b
  WHERE a.employee_id = b.employee_id) AS emp_name,
  위에서 일치하는 것만,
( SELECT b.department_name
    FROM departments b
  WHERE a.department_id = b.department_id) AS dep_name
  위에서 일치하는 것만
  전체적으로 출력
  */
  
--2)WHERE절에 서브쿼리가 사용
SELECT a.department_id, a.department_name
FROM departments a
WHERE EXISTS 
    ( SELECT 1
      FROM employees b
      WHERE a.department_id = b.department_id --→ ①
       AND b.salary > ( SELECT AVG(salary)-- → ②
       FROM employees )
      );
     
     
--보충
/*테이블 조인 3개*/
--오라클 INNER JOIN
SELECT *
FROM EMPLOYEES E, DEPARTMENTS D, JOB_HISTORY JH
WHERE d.department_id = e.department_id
AND d.department_id = jh.department_id;

--ANSI INNER JOIN
SELECT *
FROM EMPLOYEES E INNER JOIN DEPARTMENTS D ON d.department_id = e.department_id
                 INNER JOIN JOB_HISTORY JH ON d.department_id = jh.department_id;
                 
                 
--3) FROM절에 서브쿼리가 사용 : 연관성이 없는 서브쿼리 : 인라인 뷰
/*
인라인 뷰
FROM 절에 사용하는 서브 쿼리를 인라인 뷰InlineView 라고 한다. 
원래 FROM 절에는 테이블이나 뷰가 오는데, 
서브 쿼리를 FROM 절에 사용해 하나의 테이블이나 뷰처럼 사용할 수 있다.
*/
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
FROM employees a,
    departments b,
    ( SELECT AVG(c.salary) AS avg_salary
       FROM departments b,
            employees c
        WHERE b.parent_id = 90  -- 기획부
            AND b.department_id = c.department_id ) d
WHERE a.department_id = b.department_id
   AND a.salary > d.avg_salary;

--2번예제- 테이블 또는 뷰 생성 안돼서 실행 X 구조만 보기  
SELECT a.*
FROM ( SELECT a.sales_month, ROUND(AVG(a.amount_sold)) AS month_avg
       FROM sales a,
             customers b,
             countries c
        WHERE a.sales_month BETWEEN '200001' AND '200012'
          AND a.cust_id = b.CUST_ID
          AND b.COUNTRY_ID = c.COUNTRY_ID
          AND c.COUNTRY_NAME = 'Italy' -- 이탈리아
        GROUP BY a.sales_month
           )  a,
      ( SELECT ROUND(AVG(a.amount_sold)) AS year_avg
        FROM sales a,
             customers b,
             countries c
        WHERE a.sales_month BETWEEN '200001' AND '200012'
          AND a.cust_id = b.CUST_ID
          AND b.COUNTRY_ID = c.COUNTRY_ID
          AND c.COUNTRY_NAME = 'Italy' -- 이탈리아
           ) b
WHERE a.month_avg > b.year_avg ;

/*
셀프 조인
서로 다른 두 테이블이 아닌 동일한 한 테이블을 사용해 조인하는 방법
*/
SELECT a.employee_id, a.emp_name, b.employee_id, b.emp_name, a.department_id
FROM employees a,
     employees b --같은 테이블이지만 별칭이 다르기 때문에 메모리 상에선 각각 a, b로 관리하여 문제 X
WHERE a.employee_id < b.employee_id......①
   AND a.department_id = b.department_id
   AND a.department_id = 20;