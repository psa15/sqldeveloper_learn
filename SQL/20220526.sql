/* BOM : 계층형 쿼리 */
CREATE TABLE BOM (
     ITEM_ID INTEGER NOT NULL, -- 품목식별자
     PARENT_ID INTEGER, -- 상위품목 식별자
     ITEM_NAME VARCHAR2(20) NOT NULL, -- 품목이름
     ITEM_QTY INTEGER, -- 품목 개수
     PRIMARY KEY (ITEM_ID)
);

INSERT INTO BOM VALUES ( 1001, NULL, '컴퓨터', 1);
INSERT INTO BOM VALUES ( 1002, 1001, '본체', 1);
INSERT INTO BOM VALUES ( 1003, 1001, '모니터', 1);
INSERT INTO BOM VALUES ( 1004, 1001, '프린터', 1);

INSERT INTO BOM VALUES ( 1005, 1002, '메인보드', 1);
INSERT INTO BOM VALUES ( 1006, 1002, '랜카드', 1);
INSERT INTO BOM VALUES ( 1007, 1002, '파워서플라이', 1);
INSERT INTO BOM VALUES ( 1008, 1005, 'CPU', 1);
INSERT INTO BOM VALUES ( 1009, 1005, 'RAM', 1);
INSERT INTO BOM VALUES ( 1010, 1005, '그래픽카드', 1);
INSERT INTO BOM VALUES ( 1011, 1005, '기타장치', 1);

COMMIT;


/*
계층형 쿼리 명령어
*/
--1)정렬 : ORDER SIBLINGS BY - 레벨이 같은 형제 로우에 한해서 정렬
SELECT department_id, LPAD(' ' , 3 * (LEVEL-1)) || department_name, LEVEL
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id  = parent_id
ORDER SIBLINGS BY department_name;

--2)최상위(루트) 부서 : CONNECT_BY_ROOT
--CONNECT_BY_ROOT : 계층ㅇ형 쿼리에서 최상위 로우를 반환하는 연산자
SELECT department_id, LPAD(' ' , 3 * (LEVEL-1)) || department_name, LEVEL,
           CONNECT_BY_ROOT department_name AS root_name
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id  = parent_id;

--3)CONNECT_BY_ISLEAF
--조건에 정의된 관계에 따라 해당 로우가 최하위 자식 로우이면 1을, 그렇지 않으면 0을 반환
--LEAF NODE : 자식노드가 없는 노드
--NON LEAF NODE : 자식노드가 있는 노드
SELECT department_id, LPAD(' ' , 3 * (LEVEL-1)) || department_name, LEVEL, CONNECT_BY_ISLEAF
 FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id  = parent_id;

--4)SYS_CONNECT_BY_PATH (colm, char)
--계층형 쿼리에서만 사용할 수 있는 함수
--루트 노드에서 시작해 자신의 행까지 연결된 경로 정보를 반환
--함수의 첫 번째 파라미터로는 컬럼이, 두 번째 파라미터인 char은 컬럼 간 구분자를 의미
--※두 번째 매개변수인 구분자로 해당 컬럼 값에 포함된 문자는 사용 X
SELECT department_id, LPAD(' ' , 3 * (LEVEL-1)) || department_name, LEVEL,
           SYS_CONNECT_BY_PATH( department_name, '|')
 FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id  = parent_id;

--5)CPMMECT_BY_ISCYCLE : 데이터가 서로를 참조하여 무한루프가 발생이 되었을 때 원인이 되는 데이터를 찾을 때 사용
--루프 알고리즘에서 주의할 점은 조건을 잘못 주면 무한루프를 타게 된다는 점
--계층형 쿼리에서도 부모-자식 간의 관계를 정의하는 값이 잘못 입력되면 무한루프를 타고 오류가 발생
/*
시나리오
    : 생산팀(170)의 부모 부서는 구매/생산부(30)인데, 구매/생산부의 parent_id 값을 생산부로 변경
      두 부서가 상호 참조가 되어 무한루프가 발생
*/
--1)구매/생산부의 parent_id 값을 생산부로 변경
UPDATE DEPARTMENTS
    SET PARENT_ID = 170
WHERE department_id = 30;

--2)구매/생산부를 부모(루트)로 시작하여 자식으로 트리구조 형태를 출력하라
SELECT department_id, LPAD(' ', 3 * (LEVEL - 1)) || DEPARTMENT_NAME, LEVEL, PARENT_ID
FROM DEPARTMENTS
START WITH DEPARTMENT_ID = 30
CONNECT BY PRIOR DEPARTMENT_ID = PARENT_ID;

--3) 무한 루프 발생된 데이터 찾기
SELECT department_id, LPAD(' ', 3 * (LEVEL - 1)) || DEPARTMENT_NAME, LEVEL, CONNECT_BY_ISCYCLE AS ISLOOP, PARENT_ID
FROM DEPARTMENTS
START WITH DEPARTMENT_ID = 30
CONNECT BY NOCYCLE PRIOR DEPARTMENT_ID = PARENT_ID;

--4) 원인 데이터 수정
UPDATE DEPARTMENTS
    SET PARENT_ID = 10
WHERE department_id = 30;

--5) 쿼리 테스트
SELECT department_id, LPAD(' ', 3 * (LEVEL - 1)) || DEPARTMENT_NAME, LEVEL, PARENT_ID
FROM DEPARTMENTS
START WITH DEPARTMENT_ID = 30
CONNECT BY PRIOR DEPARTMENT_ID = PARENT_ID;

COMMIT;

/*
분석 함수AnalyticFunction 란 테이블에 있는 로우에 대해 특정 그룹별로 집계 값을 산출할 때 사용된다. 
집계 값을 구할 때 보통은 그룹 쿼리를 사용하는데, 이때 GROUP BY 절에 의해 최종 쿼리 결과는 그룹별로 로우 수가 줄어든다.
이에 반해, 집계 함수를 사용하면 로우의 손실 없이도 그룹별 집계 값을 산출해 낼 수 있다. 
분석 함수에서 사용하는 로우별 그룹을 윈도우(window)라고 부르는데, 
이는 집계 값 계산을 위한 로우의 범위를 결정하는 역할을 한다.

그럼 지금부터 분석 함수에 대해 자세히 알아보자. 분석 함수 구문은 다음과 같다.

    분석 함수(매개변수) OVER
       　　　(PARTITION BY expr1, expr2,...
                  ORDER BY expr3, expr4...
                window 절)
*/
--부서별 사원의 수
SELECT DEPARTMENT_ID, COUNT(EMPLOYEE_ID) AS 사원수
 FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;
--강사님
SELECT DEPARTMENT_ID, COUNT(*) AS 사원수
 FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;

/* 분석함수 : GROUP BY는 결과만 출력하지만 분석함수는 그룹화된 데이터 내역 그 자체를 출력
① ROW_NUMBER( )
ROW_NUMBER는 ROWNUM 의사 컬럼과 비슷한 기능을 하는데, 
파티션으로 분할된 그룹별로 각 로우에 대한 순번을 반환하는 함수다

SELECT department_id, EMP_NAME,
        ROW_NUMBER() OVER (PARTITION BY 그룹화컬럼명 ORDER BY 컬럼명) AS 별칭
FROM EMPLOYEES;
동작특징
1) PARTITION BY department_id : 부서별 동일한 데이터를 대상으로 선정
2) ORDER BY EMP_NAME : 그룹화된 데이터를 정렬
3) ROW_NUMBER() : 번호를 순차적으로 부여
*/
--사원 테이블에서 부서별 사원들의 로우 수를 출력
SELECT department_id, EMP_NAME,
        ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY EMP_NAME) AS DEP_ROWS
FROM EMPLOYEES;

/*
②-1) RANK( )
RANK 함수는 파티션별 순위를 반환
공동 순위의 개수를 참고하여 그 다음 순위가 정해짐

②-2) DENSE_RANK( )
DENSE_RANK 함수는 RANK와 비슷하지만 같은 순위가 나오면 다음 순위가 한 번 건너뛰지 않고 매겨진다
공동 순위의 개수를 참고 안하고 순서를 건너뛰지 않고 바로 다음 순위가 정해짐
*/
--RANK()
SELECT department_id, EMP_NAME, SALARY,
        RANK() OVER (PARTITION BY department_id ORDER BY SALARY) AS DEP_RANK
FROM EMPLOYEES;

--DENSE_RANK()
SELECT department_id, EMP_NAME, SALARY,
        DENSE_RANK() OVER (PARTITION BY department_id ORDER BY SALARY) AS DEP_RANK
FROM EMPLOYEES;

--응용
--부서별 급여가 상위 3위 안에 드는 데이터를 출력 (TOP N 쿼리)

--잘못된 코드
SELECT department_id, EMP_NAME, SALARY,
        DENSE_RANK() OVER (PARTITION BY department_id ORDER BY SALARY DESC) AS DEP_RANK
FROM EMPLOYEES
WHERE DEP_RANK <= 3;
--테이블에 존재하는 물리적인 컬럼은 조건식에 사용이 가능 하지만, 가공된 데이터를 컬럼으로 하여 사용 할 수 없다.
--DEP_RANK처럼 가공된 데이터는 사용 불가, ONLY 테이블에 있는 데이터만 사용 가능
-->서브쿼리 사용

--완성된 코드
SELECT * -- * : department_id, EMP_NAME, SALARY 를 의미
FROM (
        SELECT department_id, EMP_NAME, SALARY,
                DENSE_RANK() OVER (PARTITION BY department_id ORDER BY SALARY DESC) AS DEP_RANK
        FROM EMPLOYEES
    ) -- 이 서브 쿼리로 인해 DEP_RANK는 테이블에 존재하게 됨
WHERE DEP_RANK <= 3;
--FROM 절의 서브쿼리 : 인라인 뷰
--문법 : FROM 테이블 또는 뷰

/*
③-1) CUME_DIST( )
CUME_DIST 함수는 주어진 그룹에 대한 상대적인 누적분포도 값을 반환한다. 
분포도 값(비율)이므로 반환 값의 범위는 0 < X <= 1 사이의 값을 반환

③-2) PERCENT_RANK( )
PERCENT_RANK 함수는 해당 그룹 내의 백분위 순위Percentile Rank 를 반환
 PERCENT_RANK는 0 <= X <= 1 값을 반환
 백분위 순위란 그룹 안에서 해당 로우의 값보다 작은 값의 비율
*/
--CUME_DIST( )
SELECT department_id, emp_name,
       salary,
       CUME_DIST() OVER (PARTITION BY department_id ORDER BY salary ) dep_dist
  FROM employees;

--PERCENT_RANK( ) 
  SELECT department_id, emp_name,
       salary
      ,rank() OVER (PARTITION BY department_id
                    ORDER BY salary ) raking
      ,CUME_DIST() OVER (PARTITION BY department_id
                         ORDER BY salary ) cume_dist_value
      ,PERCENT_RANK() OVER (PARTITION BY department_id
                            ORDER BY salary ) percentile
 FROM employees
WHERE department_id = 60;


/*
④ NTILE(expr)
NTILE 함수는 파티션별로 expr에 명시된 값만큼 분할한 결과를 반환
한 그룹의 로우 수가 5이고 NITLE(5)라고 명시하면 정렬된 순서에 따라 1에서 5까지 숫자를 반환
- 주어진 그룹을 5개로 분리한다는 것인 데 여기서 분할하는 수를 버킷 수
만약 로우 수가 5인데 NITLE(4)를 명시한다면 이는 5개의 로우를 4개의 양동이에 담는다는 의미이므로, 
순서에 따라 처음 두 개의 로우는 1, 나머지 로우는 각각 2, 3, 4를 반환
*/
SELECT department_id, emp_name, salary,
        NTILE(4) OVER (PARTITION BY department_id ORDER BY salary) NTILES
  FROM employees
 WHERE department_id IN (30, 60) ;
 
 
 /*
  다중 테이블 INSERT
단 하나의 INSERT 문장으로 여러 개의 INSERT 문을 수행하는 효과를 낼 수 있을 뿐만 아니라 
특정 조건에 맞는 데이터만 특정 테이블에 입력되게 할 수 있는 문장이다.

    INSERT ALL| FIRST
    WHEN 조건1 THEN
    　INTO [스키마.]테이블명(컬럼1, 컬럼2, ...) VALUES(값1, 값2, ...)
    WHEN 조건2 THEN
    　INTO [스키마.]테이블명(컬럼1, 컬럼2, ...) VALUES(값1, 값2, ...)
        ...
     ELSE
    　 INTO [스키마.]테이블명(컬럼1, 컬럼2, ...) VALUES(값1, 값2, ...)
    SELECT 문;
• ALL: 디폴트 값으로 이후 WHEN 조건절을 명시했을 때 각 조건이 맞으면 INSERT를 모두 수행하라는 의미다.

• FIRST: 이후 WHEN 절 조건식에 따른 INSERT문을 수행할 때, 서브 쿼리로 반환된 로우에 대해 조건이 참인 WHEN 절을 만나면 해당 INSERT문을 수행하고 나머지에 대해서는 조건 평가를 하지 않고 끝낸다.

• WHEN 조건 THEN … ELSE: 특정 조건에 따라 INSERT를 수행할 때 해당 조건을 명시.

• SELECT 문: 다중 테이블 INSERT 구문에서는 반드시 서브 쿼리가 동반되어야 하며, 서브 쿼리의 결과를 조건에 따라 평가해 데이터를 INSERT 한다.
*/
CREATE TABLE EX7_3 (
    EMP_ID  NUMBER,
    EMP_NAME    VARCHAR2(100)
);
CREATE TABLE EX7_4 (
    EMP_ID  NUMBER,
    EMP_NAME    VARCHAR2(100)
);
INSERT INTO EX7_3 VALUES(101, '김지원');
INSERT INTO EX7_3 VALUES(102, '염미정');
--각각 작업이 처리

--다중 테이블 INSERT ALL
INSERT ALL
    INTO  EX7_3 VALUES(103, '이은오')
    INTO EX7_3 VALUES (104, '탄야')
SELECT * FROM DUAL; --서브쿼리가 와야 한다. 지금은 의미없는 문법 형식을 맞추기 위하여 DUAL 사용
--테이블 하나에 데이터를 입력하는 것이므로 
--SELECT문에 적을 것이 없어 그냥 문법을 맞추기 위해 SELECT * FROM DUAL 작성
-- * 는 전부를 뜻하는게 아니라 그냥 문자 그 자체임
--2개 행 이(가) 삽입되었습니다. -> 일괄처리, 큰 작업이라는 하나의 타이틀에서 2개가 처리

/*
전에 했음
찾아보기
--1)
--테이블 복사 : PRIMARY KEY는 복사대상에서 제외
CREATE TABLE 신규테이블명
AS
SELECT 문;
--2) --찾아보기
INSERT 기존테이블명 VALUES (컬럼1, 컬럼2)
SELECT 문;
*/

INSERT ALL
    INTO EX7_3 VALUES(EMP_ID, EMP_NAME)
SELECT 103 EMP_ID, '윤명주' EMP_NAME FROM DUAL
UNION ALL
SELECT 104 EMP_ID, '김희진' EMP_NAME FROM DUAL;
/*
INSERT ALL
    INTO  EX7_3 VALUES(103, '이은오')
    INTO EX7_3 VALUES (104, '탄야')
SELECT * FROM DUAL;
와 같은 의미
*/

--테이블 명이 EX7_3, EX7_4 다르다
INSERT ALL
    INTO EX7_3 VALUES(105, '월영')
    INTO EX7_4 VALUES(105, '유라헬')
SELECT * FROM DUAL;

--조건에 따른 다중 INSERT
TRUNCATE TABLE EX7_3;
TRUNCATE TABLE EX7_4;

/* 시나리오
서브 쿼리를 사용할 것이므로 
사원 테이블에서 부서번호가 30번과 90번에 속하는 사원의 사번과 이름을 선택해 
30번 부서 사원들은 ex7_3 테이블에, 
90번 부서 사원들은 ex7_4 테이블에 INSERT 하는 구문을 만들어 보자.
*/
--SELECT 서브쿼리의 결과 데이터를 WHEN 조건식에 일치되는 데이터를 참조하여 INSERT 데이터로 사용홤
INSERT ALL
    WHEN department_id = 30 THEN
        INTO EX7_3 VALUES(EMPLOYEE_ID, EMP_NAME) --EMPLOYEE_ID, EMP_NAME 정보를 넣겠다
    WHEN department_id = 90 THEN
        INTO EX7_4 VALUES(EMPLOYEE_ID, EMP_NAME)
SELECT department_id, EMPLOYEE_ID, EMP_NAME --WHEN절과 INTO 절에서 참조한 컬럼명
FROM EMPLOYEES;

SELECT * FROM EX7_3;
SELECT * FROM EX7_4;

TRUNCATE TABLE EX7_3;
TRUNCATE TABLE EX7_4;

--ELSE 기능 사용 목적으로 만든 테이블
CREATE TABLE EX7_5 (
    EMP_ID  NUMBER,
    EMP_NAME    VARCHAR2(100)
);

INSERT ALL
    WHEN department_id = 30 THEN
        INTO EX7_3 VALUES(EMPLOYEE_ID, EMP_NAME) --EMPLOYEE_ID, EMP_NAME 정보를 넣겠다
    WHEN department_id = 90 THEN
        INTO EX7_4 VALUES(EMPLOYEE_ID, EMP_NAME)
    ELSE
        INTO EX7_5 VALUES(EMPLOYEE_ID, EMP_NAME) --30, 90제외 나머지는 EX7_5에 하겠다
SELECT department_id, EMPLOYEE_ID, EMP_NAME --WHEN절과 INTO 절에서 참조한 컬럼명
FROM EMPLOYEES; --107건 삽입

SELECT * FROM EX7_3; --6건
SELECT * FROM EX7_4; --3건
SELECT * FROM EX7_5; --98건

--INSERT FIRST 문
--데이터 모두 삭제
TRUNCATE TABLE EX7_3;
TRUNCATE TABLE EX7_4;
TRUNCATE TABLE EX7_5;

--연습용으로 사용할 데이터 조회
SELECT department_id, employee_id, emp_name,  salary
   FROM employees
 WHERE department_id = 30;
/*
위의 데이터 중 1) 사번이 116번 보다 작은 사원은 ex7_3 테이블에, 
2) 급여가 5000보다 작은 사원은 ex7_4 테이블에 삽입
INSERT ALL VS. INSERT FIRST
*/
--1)INSERT ALL 로 하는 경우
INSERT ALL
    WHEN employee_id < 116 THEN
        INTO EX7_3 VALUES(employee_id, emp_name)
    WHEN salary < 5000 THEN
        INTO EX7_4 VALUES(employee_id, emp_name)
SELECT department_id, employee_id, emp_name,  salary
   FROM employees
 WHERE department_id = 30;
--7개 행 이(가) 삽입되었습니다.

SELECT * FROM EX7_3; --2건
SELECT * FROM EX7_4; --5건

TRUNCATE TABLE EX7_3;
TRUNCATE TABLE EX7_4;
--2) INSERT FIRST로 하는 경우
-- 조건식(WHEN 조건식 THEN INTO 실행문) 중에 TRUE가 처음인 경우만 실행
INSERT FIRST
    WHEN employee_id < 116 THEN
        INTO EX7_3 VALUES(employee_id, emp_name)
    WHEN salary < 5000 THEN
        INTO EX7_4 VALUES(employee_id, emp_name)
SELECT department_id, employee_id, emp_name,  salary
   FROM employees
 WHERE department_id = 30;
 --6개 행 이(가) 삽입되었습니다.
SELECT * FROM EX7_3; --2건
SELECT * FROM EX7_4; --4건

/*****************************************************************************/
/*PL/SQL : 오라클에서 만든 비즈니스 로직작업을 하기 위한 데이터베이스 프로그래밍 언어*/
/*****************************************************************************/
--PL/SQL : SQL 포함하는 의미

--익명 블록
DECLARE
    변수선언;
BEGIN --{ 의 의미

END; --} 의 의미

--DBMS_OUTPUT.PUT_LINE() 명령어가 먹기 위해 아래 구문 먼저 실행 스크립트를 콘솔처럼 사용하기 위해
SET SERVEROUTPUT ON;

DECLARE
    VI_NUM NUMBER; --변수 선언(정의)
BEGIN
    VI_NUM := 100;  --변수에 값을 줄 때 ':=' 사용
    
    DBMS_OUTPUT.PUT_LINE(VI_NUM); --System.out.println()과 유사
END;

/*
변수선언
    변수명 데이터타입 := 초기값;
참고> 초기값을 사용하지 않으면, 변수의 초기값을 NULL로 처리

상수 선언
   상수명 CONSTANT 데이터타입 := 상수값;
참고> 상수 선언시 반드시 초기화 해야한다. 값 변경 X
*/

--2의 3제곱
DECLARE
    a   INTEGER := 2**2 * 3**2;
BEGIN
    DBMS_OUTPUT.PUT_LINE('a= ' || TO_CHAR(a)); -- || 는 문자 연결 연산자
END;

--사원 테이블에서 특정 사원의 이름과 부서명을 변수에 저장하고 출력하는 예제
--SQL구문
SELECT EMP_NAME, DEPARTMENT_NAME
FROM EMPLOYEES a,DEPARTMENTS b
WHERE a.department_id = b.department_id
AND EMPLOYEE_ID = 100;

--PL/SQL구문
DECLARE
    VS_EMP_NAME VARCHAR2(80); --사원테이블 EMP_NAME 데이터타입과 똑같이
    VS_DEPT_NAME VARCHAR2(80); 
BEGIN
    --SQL 구문에 INTO절 추가
    SELECT EMP_NAME, DEPARTMENT_NAME
    INTO VS_EMP_NAME, VS_DEPT_NAME --두 변수의 컬럼의 값이 저장
    FROM EMPLOYEES a,DEPARTMENTS b
    WHERE a.department_id = b.department_id
    AND EMPLOYEE_ID = 100;
    
    dbms_output.put_line(VS_EMP_NAME || ' - ' || VS_DEPT_NAME);
    --DBMS_OUTPUT 패키지
	--기능 구현이 아니라 그저 데이터가 잘 입력됐는지 확인용도
END;

--%TYPE 키워드
/*
컬럼에 정의된 데이터타입을 변수에서 참조
    변수명 테이블명.컬럼명%TYPE
테이블의 컬럼의 데이터타입이 변경되면 자동으로 변수에 참조가 되게
*/
DECLARE
    VS_EMP_NAME EMPLOYEES.EMP_NAME%TYPE; 
    --EMPLOYEES 테이블의 EMP_NAME 컬럼의 데이터타입이 변경되어도 자동으로 VS_EMP_NAME의 데이터타입도 변경
    VS_DEPT_NAME DEPARTMENTS.department_name%TYPE; 
BEGIN
    SELECT EMP_NAME, DEPARTMENT_NAME
    INTO VS_EMP_NAME, VS_DEPT_NAME
    FROM EMPLOYEES a,DEPARTMENTS b
    WHERE a.department_id = b.department_id
    AND EMPLOYEE_ID = 100;
    
    dbms_output.put_line(VS_EMP_NAME || ' - ' || VS_DEPT_NAME);
END;

--SQL과 PL/SQL 데이터 타입별 길이
--예를 들어, VARCHAR2 타입은 SQL에서는 최대 크기가 4000 byte였다. 
--하지만 PL/SQL에서는 VARCHAR2 타입을 32KB(32, 767 byte)까지 사용할 수 있다.

--1) 4000 OVER로 에러 발생
--ORA-00910: specified length too long for its datatype
CREATE TABLE CH08_VARCHAR2 (
    VAR1 VARCHAR2(5000) --
);

--1-1) 4000바이트로 수정
CREATE TABLE CH08_VARCHAR2 (
    VAR1 VARCHAR2(4000) --
);
INSERT INTO ch08_varchar2 (VAR1)
VALUES ('tQbADHDjqtRCvosYCLwzbyKKrQCdJubDPTHnzqvjRwGxhQJtrVbXsLNlgeeMCemGMYpvfoHUHDxIPTDjleABGoowxlzCVipeVwsMFRNzZYgHfQUSIeOITaCKJpxAWwydApVUlQiKDgJlFIOGPOKoJsoemqNbOLdZOBcQhDcMLXuYjRQZDIpgpmImgiwzcLkSilCmLrSbmFNsKEEpzCHDylMvkYPKPNeuJxLvJiApNCYzrMcflECbxwNTKSxaEwVvCYnTnFfMFgDqxobWcSmMJrNTQIVOeWlPaMTfRHsrlFSukppmljmOojPSgJiSbQcgtWWOwUNNYFGtgCGBsIcTGAiHWBxtYVXecoJgJCAJptIVmVTZSKliRLoPYTIUpksBuQaqFHLhCkosWChoMjbqgLtBIRBynsKjKiLrdeHVvZanNVElDjLWwlCDhbpsAVQMTzjzhoKIJBdthynMBMVjeNmsKAjdAYhPZKmuKOuMloQdkqPjoKbfjDEeATciMrXiMQorMhYmBlMODBbyLLIkbmtZdPcWGSuxFEUwXnWpvnunEgcLelSneRIpgRNTzTkHqgLbpxoHzCYgSWlIAvKljCnmWiPWGGwlUFOudRSdoqUxntyhNYEiVXtMObywEltTImawnElpmeiWwlTjGTFceqyjhNqiDLxwduubykWzDmFSJNvVvDZibrCpAReqQjlQZcxuVqjKGKvoDuEcQPQeDzmdMYSOTIQdPDNfDffCOUWflHSQhvVTiYumBQIoyznWNITGZkefknJpGEutUnhBgLPQTWTBeTYccqlLrxvRjfJpdpfVDqqfKCngemIEDDHNdvBxCqKDTrrJAumXMKgpWLIHctQuACeNaKnffpYXiioLxZDrxpuZPPUGpRsCtoQuBfogkKuusVATkMyajKTPSyTQbfhZepRjNdrhkymqKvsAcThYbMSMnkKcLWFPAMeGysBVKkQtFMPvRBoDszlSZcMYzwxkKQwJnuVnDxShYiHFlzgDWqhZoqeypyFVBNDtHkiVzHkQisYLbsbVneJyHbHdtaIFLVbfTqbkGQTEjFlPiGUddPUIoLWALrbKcLwBizwhJvaXkvOphcGWpdNAhxgehCvjcQFSFhxrBuANKjyWncWAUpKKJcfQCsQlLfpqdMhjWGkAMMWUaDfCrGtmtkiIZOdNapEnvfFKiHAhBhejgKSuyKXFQXyCaLwwvonHsceJKgjtnYVZvBCYYBSqNCqVqCGewootJJsqrCnmiteMZBbyMPnIrdcielnGUYmwiOPmEqKGvxDmDRTDRumnSRcnvgxLbaiQIuzdslEIMquvvwmvgaumqPkduNyfRtXErCPvDYLelhjNNOjbGryRpTtDHxIJebMEtKryUyZRIdADeTEBExwHMRHzAYFizYiesaMhNIsOUzUTmyEMuFQrsUEtjwhUWIvADNlrcxPZwRazPMMvdVZssmXbXuCkRoPYNGLPwUmrWrrIgQoMSGMPvTcbHnbtleyKYmOMgymANQBZDMoqAOzMHrAVunIiykCudFVNObNgXOoyfQRICbFsWygSZXufipvrWWmRnBWYdoKmIRewOObUjiNDdQsxQIXtlbPSSngfQPfeQKOolVASXIuAmeODKtSOPaEaFKcedGzzsbrPlsPnRRuYFeVdhyufpjFVVrTPczSQkmPYXercLMmVEaDmJXKTqEVNSKeOshDCDJwdINFsLhAuKIIfOdjSEndDwumQLvePVjzNoIfUELOANeshoNgwVhFADjtUIjIhQAIyRnzSoxSRSWklITMgdjQZTthwsnBVLWyfSsAdLzOnEqmMCGBlTYGjtqvKbBoATRwkPkOTSbUhZClVzjiLLIFEMuptuodeRKXUaBfUhVTtasFsZdVnKtEfLldJYsxjlrBADRqhEBEmBKxlXKgEhiKcwAdztcETMUteJwadfaZLEBRjwJOGaIMhsfAxtuBQWyQLGXPDlFQmkcMsKsGUlQBEAubDqbuBYqXLZgmhPftLkYaCYGReLCVXssOxzJFJwnxKJzaaYzfVpbHYBtiBeQZRilJZqrrMTrVtYAcwGxAAddwtlxzdZebfZHjzqRmrrBPNbkVHqjCHtVKUjIDPVSrtyEsPRPoyyPOFOSBcgClTzlAIPmPMkdlpFHctzKGpyQMInMwPKojVErCOrHbCsZoEXqyOcHReSybmxwYabyioVnDxPEvskutVHLWQTNudmKICoaoSGKqONrBmvtGNBKAaJxCRKTDOIqrJOsQVOmGxmuIDEddVYvDwILTyushOAiXbkRIKgNLnFJdOagmiOHKRBKIIkxkOUeZWMRNlqpJdFgKjrGhIzrgBtgjVOtZAskKRbqzRVwLUoUAtRpRkoRQNLIrbLmmjZTugXJBNCscnMguKVAFDKpODtCsmdlBvQGALeBGUitYBxLYhJxeVcAnTWmTAvCITzdzqiBfEudEIBmkDAXIFmoOmsTMZDOnhXYrgMDlDbjednYWWJbGhrXFrxMQmQSmRBwoOqWGbGmjZNlJCvSHvmtZUkIScWXVdfSsdvdyQNpGFIOuteXhCMLmmEHrMucEmFbCIOHTJINAuIUOPfAfijIPkZjppGCCSRJNXWNCmliwUgABkHWuelUWeLsyVKVcZWOSeiQBQibCQJQUgGkTrXZxdBLsgjeMIwOyORDBpywuvlrLScRNhvaCYaKKRvOZeqBebUWWFhNnIRJvedFNfFPgWZJgNRaUpyYWFNiXJfAqNjyCEQYwAdFBQKKolwrufmJOfrToJFEsoNjaphcNvfWGIjKrKZSoSJEsbRqNVcoprpcGrnBgcNAnWUFpRldcPJkPfaoLKRCmVyMAWMXmnScodKisCTqllZEWQQSCFETxLNntgdcFEFRsTSIhuewwrHIlOeCcRqkzgQhKnKyHZHdFsMEKvPywLbjaspVxUMEkVzCGcGoTmaBjUMwJuAYdSTaYGDHHWDrvGgMVTtehpzfgofkmqtamffJbCKOzJgPsHNEnFarjADJGyKLwwitCiBXIraUdZtZwNjUtGbWqxksepVYztIBrimByoYQfUQgOndzFmhnuSmhYWvHliWUHgbvBIkYasDElNsjcCLtMvjQEhJjWvlnAscPwOYfelrfgfRAZGBxdFlMNkfYEWLbkfUhbRPHoDZsaAQdoKhAAWzOcHoAkkHPQMNIxgHNJaqEFBqCuMYEtLpMnIiMCWWEPnBYgYrxlXFGYpQWUNFevwcEUvUzDeSZNrdmahAfjeLSAGjHVnqyTzJkiVXjDJXzOiszXQCErQwwDMMqjLxWebJwNAVdrXeyMDRYXmLMDnuWLVaShVGhlgvbjOdOnhCDTNVazYDnzstqxjOuWbLcDaavRumKUOQXBQwKtdFgOzXiQKWFporrIcylIHlTmTKAIpBqNUbkajLTlwAHieCcqPIJYhegwQhWpYZdfxpQXDKtYzsrmnvdiTKgXfXKlIHPHlxQtqXGhMVPOBAKVZJfkrDNEwnQFwgfoHJSqQxTzRswVLrtFgpVzKcLilgznElWUfhERyeUrCcFCuGJddlFHJrXsqRdUjqUwaBmJVNwjRbCFiVMOSFuNctNVzhmhUpoddsMPUFMvNIMsMjHIWYiLjhSajZqpDkMvUOUCbYKfNHGpdUeWGUtDXHDNSCEXqYrhWhvnISnjfoBMCwwptksarPImRZaRxBMjoBdlmRGlIuQZDzCLnxxioATnGVFFTATUpeypOCaCeJAvPLxEXYzlCgXvXirGSZFyZPPSCdOSHxeELRsetFrWgqPNNpwgbgBEYPOSpLWeVdqOxPaQnidyPVMmELzeJPWgNsWBdPJPjhkdGpeAYZfrBNqdbOwzbtLiWMPafjgWQNcWKqmcleWLcMJoGSAEIUyFuzElZKXonHOMDdGMtSKEFUWdfPfnDecKNhIjAKRYmkXgpPAzlKIOpViZPkZdozzAoWwDnXkfDikvkXcQaoBtzKkcRhNpJRYaGTkdnlfotsJZsLqpYaWoK')
;
--정확히 4000바이트

COMMIT;
SELECT * FROM ch08_varchar2;

--2) PL/SQL 익명 블록을 만들어 VARCHAR2 타입의 최대 길이를 살펴 보자
DECLARE
    VS_SQL_VARCHAR2     VARCHAR2(4000);
    VS_PLSQL_VARCHAR2   VARCHAR2(32767);
BEGIN
    SELECT VAR1
    INTO VS_SQL_VARCHAR2 --VAR1의 값을 VS_SQL_VARCHAR2에 대입
    FROM CH08_VARCHAR2;
    
    VS_PLSQL_VARCHAR2 := VS_SQL_VARCHAR2 || ' - ' || VS_SQL_VARCHAR2 || ' - ' ||VS_SQL_VARCHAR2;
    --12006(12000 + - - )문자열 길이를 VS_PLSQL_VARCHAR2에 대입
    
    dbms_output.put_line('SQL VARCHAR2 길이 : ' || LENGTHB(VS_SQL_VARCHAR2));
    dbms_output.put_line('PL/SQL VARCHAR2 길이 : ' || LENGTHB(VS_PLSQL_VARCHAR2));
END;

/*
IF문
특정 조건에 따라 처리를 하는 것을 조건문이라 하는데 그 대표적인 것이 바로 IF 문이며 그 구조는 다음과 같다.

    <조건이 1개일 경우>
    IF 조건 THEN
       조건 처리;
    END IF;
     
    <조건이 2개일 경우>
    IF 조건 THEN
       조건 처리 1;
    ELSE
      조건 처리2;
    END IF;
     
    <조건이 n개일 경우>
    IF 조건1 THEN
       조건 처리1;
    ELSIF 조건2 THEN
      조건 처리2;
      ...
    ELSE
       조건 처리n;
    END IF;
*/
DECLARE
    VN_NUM1 NUMBER := 1;
    VN_NUM2 NUMBER :=2;
BEGIN
    IF VN_NUM1 >= VN_NUM2 THEN
        DBMS_OUTPUT.PUT_LINE(VN_NUM1 || '이 큰 수');
    ELSE
        DBMS_OUTPUT.PUT_LINE(VN_NUM2 || '이 큰 수');
    END IF;
END;

DECLARE
    vn_salary   NUMBER := 0;
    vn_department_id NUMBER :=0;
BEGIN
    vn_department_id := ROUND(DBMS_RANDOM.VALUE(10, 120), -1); 
    --DBMS_RANDOM.VALUE(10, 120) : 10 ~ 120에 해당하는 실수값을 무작위로 리턴
    --ROUND(실수값, -1) : 1의 자리에서 반올림하여 10단위로 반환
    
    SELECT SALARY
    INTO vn_salary
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = vn_department_id
    AND ROWNUM = 1; -- 하나의 부서 안에 여러명이 있으니까 그 중 첫번째 값
    
    DBMS_OUTPUT.PUT_LINE(vn_salary);
    
    IF vn_salary BETWEEN 1 AND 3000 THEN
        DBMS_OUTPUT.PUT_LINE('낮음');
    ELSIF vn_salary BETWEEN 3001 AND 6000 THEN
        DBMS_OUTPUT.PUT_LINE('중간');
    ELSIF vn_salary BETWEEN 6001 AND 10000 THEN
        DBMS_OUTPUT.PUT_LINE('높음');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('최상위');
    END IF;
END;