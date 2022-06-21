--중첩 IF문
/*
사원 테이블에서 커미션까지 가져와 커미션이 0보다 클 경우, 
다시 조건을 걸어 커미션이 0.15보다 크면 ‘급여*커미션’ 결과를 출력하고, 
커미션이 0보다 작으면 급여만 출력

*/

--익명 블록 - 코드에 이름이 없다(함수명, 메소드명 같은 이름이 없고 BEGIN-END가 블록)

--스크립트를 콘솔처럼 사용하여 DBMS_OUTPUT.PUT_LINE()의 출력결과를 확인하기 위해 사전에 먼저 실행
SET SERVEROUTPUT ON;

DECLARE
    vn_salary   NUMBER := 0;
    vn_department_id    NUMBER := 0;
    vn_commission    NUMBER := 0;
BEGIN
    vn_department_id := ROUND(DBMS_RANDOM.VALUE(10, 120), -1);
    --랜덤으로 10 ~120 범위의 부서코드 대입
    
    SELECT salary, COMMISSION_PCT
    INTO vn_salary, vn_commission
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = vn_department_id
    AND ROWNUM = 1;
    
    DBMS_OUTPUT.PUT_LINE(vn_salary);
    
    IF vn_commission > 0 THEN
        IF vn_commission > 0.15 THEN
            DBMS_OUTPUT.PUT_LINE(vn_salary * vn_commission);
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE(vn_salary);
    END IF;
END;

/*
CASE문
PL/SQL 프로그램 내에서도 CASE문을 사용

    <유형 1>
    CASE 표현식
        WHEN 결과1 THEN
             처리문1;
        WHEN 결과2 THEN
             처리문2;
        ...
        ELSE
             기타 처리문;
    END CASE;
     
    <유형 2>
    CASE WHEN 표현식1 THEN
             처리문1;
        WHEN 표현식2 THEN
             처리문2;
        ...
        ELSE
             기타 처리문;
    END CASE;
*/

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
    
    /*
    IF vn_salary BETWEEN 1 AND 3000 THEN
        DBMS_OUTPUT.PUT_LINE('낮음');
    ELSIF vn_salary BETWEEN 3001 AND 6000 THEN
        DBMS_OUTPUT.PUT_LINE('중간');
    ELSIF vn_salary BETWEEN 6001 AND 10000 THEN
        DBMS_OUTPUT.PUT_LINE('높음');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('최상위');
    END IF;
    */
    --다중 IF문 -> CASE문으로 변경
    
    CASE WHEN vn_salary BETWEEN 1 AND 3000 THEN
            DBMS_OUTPUT.PUT_LINE('낮음');
        WHEN vn_salary BETWEEN 3001 AND 6000 THEN
            DBMS_OUTPUT.PUT_LINE('중간');
        WHEN vn_salary BETWEEN 6001 AND 10000 THEN
            DBMS_OUTPUT.PUT_LINE('높음');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('최상위');
    END CASE;
END;

/*
LOOP문
LOOP문은 루프를 돌며 반복해서 로직을 처리하는 반복문이다. 
LOOP문 외에도 WHILE문, FOR문이 있는데, 
먼저 가장 기본적인 형태의 반복문인 LOOP문에 대해 살펴 보자.

    LOOP
      처리문;
      EXIT [WHEN 조건];
    END LOOP;
*/

DECLARE
    vn_base_num NUMBER := 3;
    vn_cnt      NUMBER := 1;
BEGIN
    LOOP
        --3 * 1 = 3
        DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || vn_cnt || '=' || vn_base_num * vn_cnt);
        --PL/SQL은 증감 연산자 X
        vn_cnt := vn_cnt + 1;
        
        EXIT WHEN vn_cnt > 9; --vn_cnt변수의 값이 9보다 크면 종료        
    END LOOP;
END;

/*
WHILE문
일반적인 프로그래밍 언어에서 대표적인 반복문을 꼽으라면 WHILE문과 FOR문을 들 수 있다. 
오라클에서도 역시 이 두 문장을 제공하는데, 먼저 WHILE문에 대해 살펴 보자.

    WHILE 조건
     LOOP
      처리문;
    END LOOP;
*/
DECLARE
    vn_base_num NUMBER := 3;
    vn_cnt      NUMBER := 1;
BEGIN
    WHILE  vn_cnt < 10 --vn_cnt 가 10보다 작을동안
        LOOP
            --3 * 1 = 3
            DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || vn_cnt || '=' || vn_base_num * vn_cnt);
            --PL/SQL은 증감 연산자 X
            vn_cnt := vn_cnt + 1;     
        END LOOP;
END;

/*
FOR문
FOR문도 다른 프로그래밍 언어에서 사용하는 것과 비슷한 형태이다

    FOR 인덱스 IN [REVERSE]초깃값..최종값
    LOOP
      처리문;
    END LOOP;
*/
--1)
DECLARE
    vn_base_num NUMBER := 3;
BEGIN
    FOR i IN 1..9 --1이 초기값, 9가 최종값 - i를 1에서 9까지 사용
        LOOP
            DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || i || '=' || vn_base_num * i);
        END LOOP;
END;

--2)REVERSE : 9에서 1까지
DECLARE
    vn_base_num NUMBER := 3;
BEGIN
    FOR i IN REVERSE 1..9 --1이 초기값, 9가 최종값 - i를 1에서 9까지 사용
        LOOP
            DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || i || '=' || vn_base_num * i);
        END LOOP;
END;

/*
CONTINUE문
CONTINUE문은 FOR나 WHILE 같은 반복문은 아니지만, 
반복문 내에서 특정 조건에 부합할 때 처리 로직을 건너뛰고 
상단의 루프 조건으로 건너가 루프를 계속 수행할 때 사용한다. 
EXIT는 루프를 완전히 빠져 나오는데 반해, 
CONTINUE는 제어 범위가 조건절로 넘어간다
*/
DECLARE
    vn_base_num NUMBER := 3;
BEGIN
    FOR i IN 1..9 --1이 초기값, 9가 최종값 - i를 1에서 9까지 사용
        LOOP
            CONTINUE WHEN i = 5; --i가 5면 밑의 코드가 진행 X, FOR문으로 다시 넘어감 -> i가 5였을 땐 출력 X
            DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || i || '=' || vn_base_num * i);
        END LOOP;
END;

/*
GOTO문
PL/SQL 코드 상에서 GOTO문을 만나면 GOTO문이 지정하는 라벨로 제어가 넘어간다
*/
DECLARE
       vn_base_num NUMBER := 3;
BEGIN
       <<third>>  --LABEL
       FOR i IN 1..9
       LOOP
          DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= ' || vn_base_num * i);
          IF i = 3 THEN
             GOTO fourth; -- i가 3이면 FOURTH 라벨로 넘어간다
          END IF;
       END LOOP;

       <<fourth>>  --LABEL
       vn_base_num := 4;
       FOR i IN 1..9
       LOOP
          DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= ' || vn_base_num * i);
       END LOOP;
END;


/*
NULL문
PL/SQL에서는 NULL문을 사용할 수 있다. NULL문은 아무것도 처리하지 않는 문장이다
*/
--1)
IF vn_variable = 'A' THEN
       처리로직1;
ELSIF vn_variable = 'B' THEN
       처리로직2;
       ...
ELSE NULL; --분법의 구조를 맞추기 위해 ELSE문 빼도 상관 없음
END IF;
--2)
CASE WHEN vn_variable = 'A' THEN
          처리로직1;
     WHEN vn_variable = 'B' THEN
          처리로직2;
     ...
     ELSE NULL;
END CASE;

/*
PL/SQL 문법을 이용하여 사용자 정의 함수, 사용자 정의 프로시저를 생성해서 사용하게 된다
*/

--++++++함수 생성+++++++
/*
CREATE OR REPLACE FUNCTION 함수 이름 (매개변수1, 매개변수2, ...)
    RETURN 데이터타입;
    IS[AS]
      변수, 상수 등 선언
    BEGIN
      실행부
    　
      RETURN 반환값;
    [EXCEPTION
      예외 처리부]
    END [함수 이름];
• CREATE OR REPLACE FUNCTION: CREATE OR REPLACE 구문을 사용해 함수를 생성한다. 최초 함수를 만들고 나서 수정을 하더라도 이 구문을 사용해 계속 컴파일할 수 있고 마지막으로 수정된 최종본이 반영된다.

• 매개변수: 함수로 전달되는 매개변수로, “매개변수명 데이터 타입” 형태로 명시한다. 매개변수는 생략할 수 있다.

• RETURN 데이터 타입: 함수가 반환할 데이터 타입을 지정한다.

• RETURN 반환값: 매개변수를 받아 특정 연산을 수행한 후 반환할 값을 명시한다.
*/
--나머지 구하는 함수(mod()를 흉내내보자)
--DECLARE 키워드 사용 X -> DECLARE는 익명블록에서만 사용
CREATE OR REPLACE FUNCTION my_mod(num1  NUMBER, num2 NUMBER) --매개변수의 타입에는 길이 사용 X
    RETURN NUMBER
IS
    --변수, 상수 선언
    vn_remainder    NUMBER := 0; --반환할 나머지
    vn_quotient     NUMBER := 0; --몫
BEGIN
    vn_quotient := FLOOR(num1 / num2);
    vn_remainder := num1 - (num2 * vn_quotient);
    
    RETURN vn_remainder; 
    --vn_remainder가 값으로 넘어올 때의 데이터타입이 RETURN NUMBER의 NUMBER이다
END;

--++++++함수 사용+++++++
--사용자 정의 함수
SELECT my_mod(10,3) FROM DUAL;
-- == 기존 내장함수
SELECT MOD(10,3) FROM DUAL;

--국가(countries) 테이블을 읽어 국가번호를 받아 국가명을 반환하는 함수를 만들어보자.
--함수 정의
CREATE OR REPLACE FUNCTION fn_get_country_name(p_country_id NUMBER)
    RETURN VARCHAR2
IS
    vs_country_name COUNTRIES.COUNTRY_NAME%TYPE;
BEGIN
    SELECT COUNTRY_NAME
    INTO vs_country_name --vs_country_name에 COUNTRIES테이블의 COUNTRY_NAME이 대입
    FROM COUNTRIES
    WHERE COUNTRY_ID = p_country_id;
    
    RETURN vs_country_name;
END;

--함수 사용
--52775 : 브라질의 코드
SELECT fn_get_country_name(52775), fn_get_country_name(10000) FROM DUAL;
--10000번 코드에 해당하는 국가가 없어서 NULL 출력
--따라서, 해당 국가가 없으면 NULL 대신 ‘없음’ 이란 문자열을 반환하도록 함수 수정

--함수 수정
CREATE OR REPLACE FUNCTION fn_get_country_name(p_country_id NUMBER)
    RETURN VARCHAR2
IS
    vs_country_name COUNTRIES.COUNTRY_NAME%TYPE;
    vn_count NUMBER := 0;
BEGIN
    SELECT COUNT(*) --p_country_id 가 있으면 1이 출력되고 없으면 0이 출력될 것이다
    INTO vn_count   --데이터가 존재하면 1이되고 없으면 0
    FROM COUNTRIES
    WHERE COUNTRY_ID = p_country_id; 
    
    IF vn_count = 0 THEN
        vs_country_name := '해당 국가 없음';
    ELSE --데이터가 존재 한다면
        SELECT COUNTRY_NAME
        INTO vs_country_name --vs_country_name에 COUNTRIES테이블의 COUNTRY_NAME이 대입
        FROM COUNTRIES
        WHERE COUNTRY_ID = p_country_id;    
    END IF;
    
    RETURN vs_country_name;
END;

--함수 사용
SELECT fn_get_country_name(52775), fn_get_country_name(10000) FROM DUAL;

--매개변수가 없는 함수 정의
CREATE OR REPLACE FUNCTION fn_get_user
    RETURN VARCHAR2
IS
    vs_user_name    VARCHAR2(80);
BEGIN
    SELECT USER --USER : 오라클의 키워드로 현재 로그인 된 사용자 정보를 반환
    INTO vs_user_name
    FROM DUAL;
    
    RETURN vs_user_name;
END;

SELECT fn_get_user(), fn_get_user FROM DUAL;


/*
프로시저
프로시저 생성
함수나 프로시저 모두 DB에 저장된 객체이므로 프로시저를 스토어드(Stored, 저장된) 프로시저라고 부르기도 함 

프로시저의 생성 구문은 다음과 같다.

    CREATE OR REPLACE PROCEDURE 프로시저 이름
        (매개변수명1[IN |OUT | IN OUT] 데이터타입[:= 디폴트 값],
         매개변수명2[IN |OUT | IN OUT] 데이터타입[:= 디폴트 값],
         ...
        )
    IS[AS]
      변수, 상수 등 선언
    BEGIN
      실행부
    　
    [EXCEPTION
      예외 처리부]
    END [프로시저 이름];
• CREATE OR REPLACE PROCEDURE: 함수와 마찬가지로 CREATE OR REPLACE 구문을 사용해 프로시저를 생성한다.

• 매개변수: IN은 입력, OUT은 출력, IN OUT은 입력과 출력을 동시에 한다는 의미다. 
아무것도 명시하지 않으면 디폴트로 IN 매개변수임을 뜻한다. 
OUT 매개변수는 프로시저 내에서 로직 처리 후, 
해당 매개변수에 값을 할당해 프로시저 호출 부분에서 이 값을 참조할 수 있다. 
그리고 IN 매개변수에는 디폴트 값 설정이 가능하다.
*/
/*
jobs 테이블에 신규 JOB을 넣는 프로시저를 만들어 보자. 
jobs 테이블에는 
job 번호, job명, 최소, 최대 금액, 생성일자, 갱신일자 컬럼이 있는데, 
생성일과 갱신일은 시스템 현재일자로 등록할 것이므로 (DEFAULT 처리-SYSDATE)
매개변수는 총 4개를 받도록 하자.
*/
--프로시저 생성
--기본 뼈대
CREATE OR REPLACE PROCEDURE 프로시저이름
(
    
)
IS 
    --변수, 상수 선언
BEGIN
    --실행 문장

END;

CREATE OR REPLACE PROCEDURE my_new_job_proc
(
    p_job_id    IN  JOBS.JOB_ID%TYPE,
    p_job_title IN  JOBS.JOB_TITLE%TYPE,
    p_min_salary IN JOBS.MIN_SALARY%TYPE,
    p_max_salary IN JOBS.MAX_SALARY%TYPE
)
IS 
    --변수, 상수 선언
BEGIN
    --실행 문장
    INSERT INTO JOBS(job_id, JOB_TITLE, MIN_SALARY, MAX_SALARY, create_date, UPDATE_DATE)
    VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary, SYSDATE, SYSDATE);
    
    COMMIT;
END;

/*
프로시저 실행
<프로시저 실행1>
    EXEC 혹은 EXECUTE 프로시저명(매개변수1 값, 매개변수2 값, ...);
*/
EXEC my_new_job_proc('SM_JOB1','Sample JOB1', 1000, 5000);

--한 번 더 실행시 jobs테이블의 primary key 제약조건에 위배로 에러
--00001. 00000 -  "unique constraint (%s.%s) violated"
EXEC my_new_job_proc('SM_JOB1','Sample JOB1', 1000, 5000);

--중복된 데이터를 확인하여 존재하면 수정, 존재하지 않으면 삽입으로 코드 수정
CREATE OR REPLACE PROCEDURE my_new_job_proc
(
    p_job_id    IN  JOBS.JOB_ID%TYPE,
    p_job_title IN  JOBS.JOB_TITLE%TYPE,
    p_min_salary IN JOBS.MIN_SALARY%TYPE,
    p_max_salary IN JOBS.MAX_SALARY%TYPE
)
IS 
    --변수, 상수 선언
    vn_cnt NUMBER := 0;
BEGIN
    --실행 문장
    --JOB_ID 값 중복체크, 일치하면 1, 없으면 0
    SELECT COUNT(*)
    INTO vn_cnt --COUNT(*)값 대입
    FROM JOBS
    WHERE JOB_ID = p_job_id;
    
    IF vn_cnt = 0 THEN
        INSERT INTO JOBS(job_id, JOB_TITLE, MIN_SALARY, MAX_SALARY, create_date, UPDATE_DATE)
        VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary, SYSDATE, SYSDATE);
    ELSE
        UPDATE JOBS
            SET JOB_TITLE = p_job_title,
                MIN_SALARY = p_min_salary,
                MAX_SALARY = p_max_salary,
                UPDATE_DATE = SYSDATE --입력일말고 수정일만 변경하면 됨
            WHERE JOB_ID = p_job_id;
    END IF;
    
    COMMIT;
END;

--수정된 프로시저 확인
EXEC my_new_job_proc('SM_JOB1','Sample JOB1', 2000, 6000);

--데이터 조회
SELECT * FROM JOBS WHERE JOB_ID = 'SM_JOB1';

/*
 <프로시저 실행2>
EXEC 혹은 EXECUTE 프로시저명(매개변수1 => 매개변수1 값,
    　　　　　　　　　　  　　　　　매개변수2 => 매개변수2 값, ...);
*/
EXEC my_new_job_proc(p_job_id => 'SM_JOB1', p_job_title => 'Sample JOB1', p_min_salary => 2000, p_max_salary => 7000);
--매개변수 순서 바꿔도됨 근데 잘 안바꿈

--매개변수에 디폴트 값 설정
EXEC my_new_job_proc('SM_JOB1','Sample JOB1'); --에러, 매개변수 4개인데 값은 2개만 줌
--프로시저에 매개변수 기본값 설정하기로 수정
CREATE OR REPLACE PROCEDURE my_new_job_proc
(
    p_job_id    IN  JOBS.JOB_ID%TYPE,
    p_job_title IN  JOBS.JOB_TITLE%TYPE,
    p_min_salary IN JOBS.MIN_SALARY%TYPE := 10, --기본값 설정
    p_max_salary IN JOBS.MAX_SALARY%TYPE := 100 --기본값 설정
)
IS 
    vn_cnt NUMBER := 0;
BEGIN
    --실행 문장
    --JOB_ID 값 중복체크, 일치하면 1, 없으면 0
    SELECT COUNT(*)
    INTO vn_cnt --COUNT(*)값 대입
    FROM JOBS
    WHERE JOB_ID = p_job_id;
    
    IF vn_cnt = 0 THEN
        INSERT INTO JOBS(job_id, JOB_TITLE, MIN_SALARY, MAX_SALARY, create_date, UPDATE_DATE)
        VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary, SYSDATE, SYSDATE);
    ELSE
        UPDATE JOBS
            SET JOB_TITLE = p_job_title,
                MIN_SALARY = p_min_salary,
                MAX_SALARY = p_max_salary,
                UPDATE_DATE = SYSDATE --입력일말고 수정일만 변경하면 됨
            WHERE JOB_ID = p_job_id;
    END IF;
    
    COMMIT;
END;

--수정된 매개변수 기본값 프로시저 테스트
EXEC my_new_job_proc('SM_JOB1','Sample JOB1'); 
--기본값이 적용

/*
OUT, IN OUT 매개변수
 OUT 매개변수란 프로시저 실행 시점에 OUT 매개변수를 변수 형태로 전달하고, 
 프로시저 실행부에서 이 매개변수에 특정 값을 할당한다. 
 그리고 나서 실행이 끝나면 전달한 변수를 참조해 값을 가져올 수 있는 것이다. 
 프로시저 생성 시 매개변수명과 데이터 타입만 명시하면 디폴트로 IN 매개변수가 되지만 
 OUT 매개변수는 반드시 OUT 키워드를 명시해야 한다.
*/
--JOBS 테이블 데이터 입력/수정 시 작업한 날자정보를 OUT 출력매개변수를 사용하여 외부로 내보내는 기능
CREATE OR REPLACE PROCEDURE my_new_job_proc
(
    p_job_id    IN  JOBS.JOB_ID%TYPE,
    p_job_title IN  JOBS.JOB_TITLE%TYPE,
    p_min_salary IN JOBS.MIN_SALARY%TYPE := 10, --기본값 설정
    p_max_salary IN JOBS.MAX_SALARY%TYPE := 100, --기본값 설정
    p_upd_date  OUT JOBS.UPDATE_DATE%TYPE
)
IS 
    vn_cnt NUMBER := 0;
    vn_cur_date JOBS.UPDATE_DATE%TYPE := SYSDATE;
BEGIN
    --JOB_ID 값 중복체크, 일치하면 1, 없으면 0
    SELECT COUNT(*)
    INTO vn_cnt --COUNT(*)값 대입
    FROM JOBS
    WHERE JOB_ID = p_job_id;
    
    IF vn_cnt = 0 THEN
        INSERT INTO JOBS(job_id, JOB_TITLE, MIN_SALARY, MAX_SALARY, create_date, UPDATE_DATE)
        VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary, vn_cur_date, vn_cur_date);
    ELSE
        UPDATE JOBS
            SET JOB_TITLE = p_job_title,
                MIN_SALARY = p_min_salary,
                MAX_SALARY = p_max_salary,
                UPDATE_DATE = vn_cur_date 
            WHERE JOB_ID = p_job_id;
    END IF;
    
    --OUT매개변수에 현재날짜 값을 할당
    p_upd_date := vn_cur_date;
    
    COMMIT;
END;

--OUT매개변수의 프로시저 테스트 -> 익명블록 구문 이용
-- p_upd_date  OUT JOBS.UPDATE_DATE%TYPE 로 인한 p_upd_date안의 값을 받기 위한 변수 선언
DECLARE
    --p_upd_date와 데이터타입이 같음
    --프로시저의 out매개변수의 값을 받고자하는 변수
    vd_cur_date JOBS.UPDATE_DATE%TYPE;
BEGIN
    --('SM_JOB1', 'SAMPLE JOB1', 2000, 6000) 4개는 IN 으로 선언된 변수에 들어감 -> 외부에서 입력한 값
    --vd_cur_date : 외부로 내보내 값을 받아 오는 것임
    --익명블록 프로시저를 실행 시 EXEC 키워드를 생략해야 한다
    --EXEC my_new_job_proc ('SM_JOB1', 'SAMPLE JOB1', 2000, 6000, vd_cur_date);
    my_new_job_proc ('SM_JOB1', 'SAMPLE JOB1', 2000, 6000, vd_cur_date);
    
    DBMS_OUTPUT.PUT_LINE(vd_cur_date);
END;

/*
IN OUT 매개변수가 있는데, 이렇게 선언하면 입력과 동시에 출력용으로 사용할 수 있다.
프로시저 실행 시 OUT 매개변수에 전달할 변수에 값을 할당해서 넘겨줄 수 있지만 큰 의미는 없는 일
*/
--IN, OUT, IN OUT 이해
CREATE OR REPLACE PROCEDURE my_parameter_test_proc
(
    --함수 또는 프로시저 생성 시 매개변수의 타입 NUMBER, VARCHAR2 등의 길이는 설정하면 안된다.
    p_var1  VARCHAR2, --기본값이 IN으로 IN 생략 가능
    p_var2 OUT VARCHAR2,
    p_var3 IN OUT VARCHAR2
)
IS

BEGIN
    --패키지.프로시저()
    
    DBMS_OUTPUT.PUT_LINE('p_var1 value = ' || p_var1); --입력 받은 값이 출력
    DBMS_OUTPUT.PUT_LINE('p_var2 value = ' || p_var2); --OUT여서 널(공백) 모습이 출력
    DBMS_OUTPUT.PUT_LINE('p_var3 value = ' || p_var3); --입력 받은 값이 출력, 일단 값은 받고 나중에 p_var3값이 내보내짐
    
    p_var2 := 'B2';
    p_var3 := 'C2'; --위에서 입력받은 값에서 'C2'로 할당
END;

--프로시저 테스트 - 익명 블록
DECLARE
    v_var1  VARCHAR2(10) := 'A';
    v_var2  VARCHAR2(10) := 'B';
    v_var3  VARCHAR2(10) := 'C';
BEGIN
    --EXEC 생략 my_parameter_test_proc프로시저 호출
    my_parameter_test_proc(v_var1, v_var2, v_var3);
    --v_var2는 'B'값이 의미가 없다 - OUT이기 때문에 
    
    DBMS_OUTPUT.PUT_LINE('v_var2 value =' || v_var2); --p_var2변수의 값을 출력
    DBMS_OUTPUT.PUT_LINE('v_var3 value =' || v_var3); --C라는 값을 제공했으나 새로운 값이 있다면 p_var3을 출력
END;
/*
    p_var1  VARCHAR2, 
    --'A'
    p_var2 OUT VARCHAR2,
    --'B'값을 받지 못함
    p_var3 IN OUT VARCHAR2
    --'C'
*/

/*
매개변수에 대해 꼭 알아두어야 할 사항을 정리하면 다음과 같다.

❶ IN 매개변수는 참조만 가능하며 값을 할당할 수 없다. (프로시저내부)
❷ OUT 매개변수에 값을 전달할 수는 있지만 의미는 없다.
❸ OUT, IN OUT 매개변수에는 디폴트 값을 설정할 수 없다.
❹ IN 매개변수에는 변수나 상수, 각 데이터 유형에 따른 값을 전달할 수 있지만, OUT, IN OUT 매개변수를 전달할 때는 반드시 변수 형태로 값을 넘겨줘야 한다.
*/

/*
RETURN
- 함수에서는 일정한 연산을 수행하고 결과 값을 반환하는 역할을 했지만, 
- 프로시저에서는 RETURN문을 만나면 이후 로직을 처리하지 않고 수행을 종료, 
- 즉 프로시저를 빠져나가 버린다. 
- 반복문에서 일정 조건에 따라 루프를 빠져나가기 위해 EXIT를 사용하는 것과 유사하다.

*/
CREATE OR REPLACE PROCEDURE my_new_job_proc
(
    p_job_id    IN  JOBS.JOB_ID%TYPE,
    p_job_title IN  JOBS.JOB_TITLE%TYPE,
    p_min_salary IN JOBS.MIN_SALARY%TYPE := 10, --기본값 설정
    p_max_salary IN JOBS.MAX_SALARY%TYPE := 100
)
IS 
    vn_cnt NUMBER := 0;
    vn_cur_date JOBS.UPDATE_DATE%TYPE := SYSDATE;
BEGIN

    IF p_min_salary < 1000 THEN
        DBMS_OUTPUT.PUT_LINE('최소 급여값은 1000이상이어야 한다.');
        RETURN; --프로시저 종료, 반환값 의미 X
    END IF;
    
    --JOB_ID 값 중복체크, 일치하면 1, 없으면 0
    SELECT COUNT(*)
    INTO vn_cnt
    FROM JOBS
    WHERE JOB_ID = p_job_id;
    
    IF vn_cnt = 0 THEN
        INSERT INTO JOBS(job_id, JOB_TITLE, MIN_SALARY, MAX_SALARY, create_date, UPDATE_DATE)
        VALUES(p_job_id, p_job_title, p_min_salary, p_max_salary, vn_cur_date, vn_cur_date);
    ELSE
        UPDATE JOBS
            SET JOB_TITLE = p_job_title,
                MIN_SALARY = p_min_salary,
                MAX_SALARY = p_max_salary,
                UPDATE_DATE = vn_cur_date 
            WHERE JOB_ID = p_job_id;
    END IF;    
    COMMIT;
END;

--RETURN 키워드 프로시저 테스트
EXEC my_new_job_proc('SM_JOB1', 'SAMPLE JOB1', 500, 6000);

/*프로시저 실습 */
--게시판 테이블
CREATE TABLE BOARD
(
    IDX     NUMBER  PRIMARY KEY,      --글 번호
    TITLE   VARCHAR2(100)   NOT NULL, --글제목
    CONTENT VARCHAR2(1000)  NOT NULL, --글내용
    WRITER  VARCHAR2(50)    NOT NULL, --작성자
    REGDATE DATE    DEFAULT SYSDATE   --등록/수정일
);

--IDX 컬럼 : SEQ_BOARD_IDX 시퀀스 사용 - 프로시저 내부 INSERT문에 적용
/*
1. BOARD 테이블에 데이터 삽입하는 프로시저 생성 및 테스트 UDP_BOARD_INSERT
    입력 데이터: 
        UDP_BOARD_INSERT('프로시저 연습1','프로시저 코딩실습1','홍길동1',SYSDATE);
        UDP_BOARD_INSERT('프로시저 연습2','프로시저 코딩실습2','홍길동2',SYSDATE);
        
2. BOARD테이블에 데이터 수정하는 프로시저 생성 UDP_BOARD_UPDATE
    수정 데이터:
        UDP_BOARD_UPDATE(글번호, '프로시저 연습수정1','프로시저 코딩실습수정1',SYSDATE);
        
3. BOARD테이블에 데이터 삭제하는 프로시저 생성 UDP_BOARD_DELETE
    삭제 데이터:
        UDP_BOARD_DELETE(글번호)

4. BOARD 테이블에 글번호를 이용하여 작성자 조회하는 프로시저 (OUT 출력매개변수 사용)UDP_GET_WRITER
    UDP_GET_WRITER(글번호)
*/
--IDX 컬럼 : SEQ_BOARD_IDX 시퀀스 사용
CREATE SEQUENCE SEQ_BOARD_IDX; --생성 완
--나중에 프로시저 내부에 INSERT문에 삽입
INSERT INTO BOARD(IDX) VALUES(SEQ_BOARD_IDX.NEXTVAL);


CREATE TABLE BOARD
(
    IDX     NUMBER  PRIMARY KEY,      --글 번호
    TITLE   VARCHAR2(100)   NOT NULL, --글제목
    CONTENT VARCHAR2(1000)  NOT NULL, --글내용
    WRITER  VARCHAR2(50)    NOT NULL, --작성자
    REGDATE DATE    DEFAULT SYSDATE   --등록/수정일
);
DROP TABLE BOARD;
--1. BOARD 테이블에 데이터 삽입하는 프로시저 생성 및 테스트 UDP_BOARD_INSERT
--프로시저 생성
CREATE OR REPLACE PROCEDURE UDP_BOARD_INSERT
(
    v_idx   IN  BOARD.IDX%TYPE,
    v_title IN  BOARD.TITLE%TYPE,
    v_content   IN BOARD.CONTENT%TYPE,
    v_writer    IN BOARD.WRITER%TYPE,
    v_regdate   IN BOARD.REGDATE%TYPE
)
IS

BEGIN
    --INSERT INTO BOARD(IDX) VALUES(SEQ_BOARD_IDX.NEXTVAL);
    INSERT INTO BOARD(IDX, TITLE, CONTENT, WRITER, REGDATE) 
        VALUES(v_idx, v_title, v_content, v_writer, v_regdate);
   COMMIT; 
END;

--프로시저 테스트
EXEC UDP_BOARD_INSERT(SEQ_BOARD_IDX.NEXTVAL,'프로시저 연습1','프로시저 코딩실습1','홍길동1',SYSDATE);
EXEC UDP_BOARD_INSERT(SEQ_BOARD_IDX.NEXTVAL,'프로시저 연습2','프로시저 코딩실습2','홍길동2',SYSDATE);

--1-1) 강사님 답
CREATE OR REPLACE PROCEDURE UDP_BOARD_INSERT1
(
    v_title     IN  BOARD.TITLE%TYPE,
    v_content   IN  BOARD.CONTENT%TYPE,
    v_writer    IN  BOARD.WRITER%TYPE,
    v_regdate   IN  BOARD.REGDATE%TYPE
)
IS

BEGIN
    INSERT INTO BOARD(IDX, TITLE, CONTENT, WRITER, REGDATE) 
        VALUES(SEQ_BOARD_IDX.NEXTVAL, v_title, v_content, v_writer, v_regdate);
   COMMIT; 
END;
--TEST
EXEC UDP_BOARD_INSERT1('프로시저 연습1','프로시저 코딩실습1','홍길동1',SYSDATE);
EXEC UDP_BOARD_INSERT1('프로시저 연습2','프로시저 코딩실습2','홍길동2',SYSDATE);


--2. BOARD테이블에 데이터 수정하는 프로시저 생성 UDP_BOARD_UPDATE
CREATE OR REPLACE PROCEDURE UDP_BOARD_UPDATE
(
    v_idx   IN  BOARD.IDX%TYPE,
    v_title IN  BOARD.TITLE%TYPE,
    v_content   IN BOARD.CONTENT%TYPE,
    v_writer    IN BOARD.WRITER%TYPE,
    v_regdate   IN BOARD.REGDATE%TYPE
)
IS
    vn_cnt  NUMBER :=0;
BEGIN
    SELECT COUNT(*)
    INTO vn_cnt
    FROM BOARD
    WHERE idx = v_idx;
    
    IF vn_cnt = 0 THEN
        INSERT INTO BOARD(IDX, TITLE, CONTENT, WRITER, REGDATE) 
            VALUES(v_idx, v_title, v_content, v_writer, v_regdate);
    ELSE
        UPDATE BOARD
            SET IDX = v_idx,
                TITLE = v_title,
                CONTENT = v_content,
                WRITER = v_writer,
                REGDATE = v_regdate
            WHERE idx = v_idx;
    END IF;
    
    COMMIT;
END;

--프로시저 테스트
EXEC UDP_BOARD_UPDATE(4, '프로시저 연습수정1','프로시저 코딩실습수정1','홍길동',SYSDATE);

--2-1 강사님 답
CREATE OR REPLACE PROCEDURE UDP_BOARD_UPDATE1
(
    v_idx       IN BOARD.IDX%TYPE,
    v_title     IN BOARD.TITLE%TYPE,
    v_content   IN BOARD.CONTENT%TYPE,
    v_regdate   IN BOARD.REGDATE%TYPE
)
IS
    vn_cnt  NUMBER :=0;
BEGIN
    SELECT COUNT(*)
    INTO vn_cnt
    FROM BOARD
    WHERE idx = v_idx;
    
    UPDATE BOARD
        SET TITLE = v_title,
            CONTENT = v_content,
            REGDATE = v_regdate
        WHERE idx = v_idx;
        
    COMMIT;
END;
--TEST
EXEC UDP_BOARD_UPDATE1(1, '프로시저 연습수정1','프로시저 코딩실습수정1',SYSDATE);

--3. BOARD테이블에 데이터 삭제하는 프로시저 생성 UDP_BOARD_DELETE
CREATE OR REPLACE PROCEDURE UDP_BOARD_DELETE
(
    v_idx   IN  BOARD.IDX%TYPE
)
IS

BEGIN
    DELETE FROM BOARD
    WHERE IDX = v_idx;
    
    COMMIT;
END;

--프로시저 테스트
EXEC UDP_BOARD_DELETE(5);

--3-1. 강사님 답
CREATE OR REPLACE PROCEDURE UDP_BOARD_DELETE1
(
    v_idx   IN  BOARD.IDX%TYPE
)
IS

BEGIN
    DELETE BOARD
    WHERE IDX = v_idx;
    
    COMMIT;
END;

--프로시저 테스트
EXEC UDP_BOARD_DELETE1(1);

--4-1. 강사님 답
CREATE OR REPLACE PROCEDURE UDP_GET_WRITER
(
    v_idx   IN  BOARD.IDX%TYPE,
    v_writer OUT BOARD.WRITER%TYPE
)
IS
    vs_writer BOARD.WRITER%TYPE;
BEGIN
    SELECT WRITER
    INTO vs_writer
    FROM BOARD
    WHERE IDX = v_idx;
    
    v_writer := vs_writer;
    
    COMMIT;
END;
--TEST
DECLARE
    vs_writer BOARD.WRITER%TYPE;
BEGIN
    UDP_GET_WRITER(2, vs_writer);
    --DBMS_OUPUT.PUT_LINE('WRITER: ' || vs_writer);
    DBMS_OUTPUT.PUT_LINE('writer: ' || vs_writer);
END;