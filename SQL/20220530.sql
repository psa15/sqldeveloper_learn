--+++++++++++예외(Exception)+++++++++++++++++

SET SERVEROUTPUT ON;
--세션 수준 설정 명령어

DECLARE
    vi_num NUMBER := 0;
BEGIN
    vi_num := 10 / 0; --에러 ORA-01476: divisor is equal to zero
    
    DBMS_OUTPUT.PUT_LINE(vi_num); --정상적인 실행이 되지 못함
END;

--예외 처리
--익명 블록
--1) OTHERS 예외 사용
DECLARE
    vi_num NUMBER := 0;
BEGIN
    vi_num := 10 / 0; --에러 ORA-01476: divisor is equal to zero
    
    DBMS_OUTPUT.PUT_LINE('SUCCESS'); --정상적인 실행이 되지 못함
    
EXCEPTION WHEN OTHERS THEN --OHTERS 키워드 : 기타 등등 예외처리
    dbms_output.put_line('오류가 발생했습니다.');
END;

--2)ZERO_DIVIDE
DECLARE
    vi_num NUMBER := 0;
BEGIN
    vi_num := 10 / 0; --에러 ORA-01476: divisor is equal to zero
    
    DBMS_OUTPUT.PUT_LINE('SUCCESS'); --정상적인 실행이 되지 못함
    
EXCEPTION WHEN ZERO_DIVIDE THEN 
    dbms_output.put_line('오류가 발생했습니다.');
END;

--예외처리가 안되어 있는 프로시저 정의
CREATE OR REPLACE PROCEDURE ch10_no_exception_proc
IS
    vi_num NUMBER := 0;
BEGIN
    vi_num := 10 / 0;
    
    DBMS_OUTPUT.PUT_LINE('SUCCESS!');
END;
--테스트
DECLARE
    vi_num NUMBER := 0;
BEGIN
    --EXEC 생략
    ch10_no_exception_proc();
    
    DBMS_OUTPUT.PUT_LINE('SUCCESS!');
END;

--예외처리 되어 있는 프로시저 정의
CREATE OR REPLACE PROCEDURE ch10_exception_proc
IS
    vi_num NUMBER := 0;
BEGIN
    vi_num := 10 / 0;
    
    DBMS_OUTPUT.PUT_LINE('SUCCESS!');
    
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다.');
END;
--테스트
DECLARE
    vi_num NUMBER := 0;
BEGIN
    --EXEC 생략
    ch10_exception_proc;
    
    DBMS_OUTPUT.PUT_LINE('SUCCESS!_TEST');
END;

--예외처리구문 사용시 사용 명령어
-- SQLCODE, SQLERRM을 이용한 예외정보 참조
CREATE OR REPLACE PROCEDURE ch10_exception_proc
IS
    vi_num NUMBER := 0;
BEGIN
    vi_num := 10 / 0;
    
    DBMS_OUTPUT.PUT_LINE('SUCCESS!');
    
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다.');
    DBMS_OUTPUT.PUT_LINE('SQL ERROR CODE: ' || SQLCODE);
    DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: ' || SQLERRM); --매개변수 없는 형태
    DBMS_OUTPUT.PUT_LINE(SQLERRM(SQLCODE)); --매개변수 있는 형태
        
END;
--테스트
DECLARE
    vi_num NUMBER := 0;
BEGIN
    --EXEC 생략
    ch10_exception_proc;
    
    DBMS_OUTPUT.PUT_LINE('SUCCESS!_TEST');
END;

--NO_DATA_FOUND 예외처리 구문 : SELECT 시 조회결과가 없을 경우
--NO_DATA_FOUND예외처리를 사용하는 것이 더 좋다라는 의미로 비권장 예에 해당하는 프로시저
CREATE OR REPLACE PROCEDURE ch10_upd_jobid_proc
(
    p_employee_id EMPLOYEES.EMPLOYEE_ID%TYPE,
    p_job_id      EMPLOYEES.JOB_ID%TYPE
)
IS
    vn_cnt NUMBER := 0;
BEGIN
    --p_job_id 유무 체크
    SELECT COUNT(*)
    INTO vn_cnt
    FROM EMPLOYEES
    WHERE JOB_ID = p_job_id;
    
    IF vn_cnt = 0 THEN
        DBMS_OUTPUT.PUT_LINE('JOB_ID가 없습니다.');
        RETURN; --프로그램 종료
    ELSE 
        UPDATE EMPLOYEES
            SET JOB_ID = p_job_id
        WHERE EMPLOYEE_ID = p_employee_id;
    END IF;
    
END;
--테스트
EXEC ch10_upd_jobid_proc(200, 'SM_JOB2');

--NO_DATA_FOUND예외처리 프로시저
CREATE OR REPLACE PROCEDURE ch10_upd_jobid_proc
(
    p_employee_id EMPLOYEES.EMPLOYEE_ID%TYPE,
    p_job_id      EMPLOYEES.JOB_ID%TYPE
)
IS
    vn_cnt NUMBER := 0;
BEGIN
    --p_job_id 유무 체크
    SELECT 1
    INTO vn_cnt
    FROM EMPLOYEES
    WHERE JOB_ID = p_job_id; --일치하는 데이터가 없으면 NO_DATA_FOUND 예외 발생
    
    UPDATE EMPLOYEES
        SET JOB_ID = p_job_id
    WHERE EMPLOYEE_ID = p_employee_id;
    
    COMMIT;
    
    --예외처리 추가
    EXCEPTION WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(p_job_id || '에 해당하는 JOB_ID가 없습니다.');
              WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('기타 에러: ' || SQLERRM);
END;
--테스트
EXEC ch10_upd_jobid_proc(200, 'SM_JOB2');

SELECT 1 FROM JOBS WHERE JOB_ID = 'SM_JOB1'; --1
SELECT 1 FROM JOBS WHERE JOB_ID = 'SM_JOB2'; --NULL (데이터가 없는 상태)

--테이블의 데이터를 조회하는 일반쿼리문을 프로시저 내용으로 사용 X
--(MS SQL에서는 가능하나 오라클 X)
CREATE OR REPLACE PROCEDURE UDP_EMPLOYEES_ALL_SELECT
IS
BEGIN
    SELECT * FROM EMPLOYEES;
END;

--+++++++++++11장 커서++++++++++++++
/*
커서(CURSOR)
특정 SQL 문장을 처리한 결과를 담고 있는 영역(PRIVATE SQL이라는 메모리 영역)을 가리키는 일종의 포인터로, 
 커서를 사용하면 처리된 SQL 문장의 결과 집합에 접근할 수 있다.
 커서의 종류에는
    1) 묵시적 커서
    2) 명시적 커서
 */
 SELECT * FROM EMPLOYEES;
 --위 문장을 실행된 결과를 메모리상에서 관리하는 포인터의 개념
 --포인터 : 특정한 자원의 위치를 가리킴
 
 --1)묵시적 커서]
 /*
 오라클 내부에서 자동으로 생성되어 사용하는 커서로, 
 SQL 문장(INSERT, UPDATE, MERGE, DELETE, SELECT INTO)이 실행될 때마다 자동으로 만들어져 사용
 개발자가 관여 불가능,
 커서에 대한 여러가지 정보 확인
 */
 --묵시적 커서(SQL커서)와 커서 속성
 DECLARE
    vn_department_id EMPLOYEES.DEPARTMENT_ID%TYPE := 80;
--      변수명              변수타입                   초기값;
 BEGIN
    --부서ID가 80인 데이터를 자신의 이름으로 수정
    --의미 자체는 없음,  SQL문장이 실행되었을 때 생성되는 커서 확인 용
    UPDATE EMPLOYEES
        SET EMP_NAME = EMP_NAME
    WHERE DEPARTMENT_ID = vn_department_id; 
    
    --업데이트 했던 데이터 변경이 몇 건이 발생했는지 확인
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);
    --SQL: 커서 이름
    --ROWCOUNT : 영향 받은 결과 집합의 로우 수 반환, 없으면 0을 반환
    
    COMMIT;
 END;
 
 --명시적 커서
 /*
 형태
    1) 익명블록 : 일회성
    2) 프로시저
*/
--준비 : 커서의 내용
SELECT EMP_NAME
FROM EMPLOYEES;
WHERE DEPARTMENT_ID = 50;
--부서아이디를 파라미터로 받아 해당 부서에 해당되는 데이터를 받아 커서로 사용하겠다 

--1) 익명 블록
DECLARE
    --변수, 상수
    vs_emp_name EMPLOYEES.EMP_NAME%TYPE;
    
    --1)커서 선언
    CURSOR 커서이름 (매개변수 선언)
    IS 
    SELECT문
    
BEGIN
    --2) 커서 오픈(실행) : DECLARE의 SELECT문이 실행된 결과
    OPEN 커서이름 (매개변수 값); --매개변수는 생략 가능
    
    --3) 커서 패치작업 : 패치(메모리상의 데이터를 읽어오는 의미)
    LOOP
        FETCH 커서이름 INTO 변수명;
        EXIT WHEN 커서명%NOTFOUND;
    END LOOP;
    
    --4)커서 닫기
    CLOSE 커서명;
END;

DECLARE
    --변수, 상수 선언
    vs_emp_name EMPLOYEES.EMP_NAME%TYPE;
    vn_cnt NUMBER := 0;
    
    --1) 커서 선언
    CURSOR cur_emp_dep (cp_department_id EMPLOYEES.DEPARTMENT_ID%TYPE)
    IS 
    SELECT EMP_NAME
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = cp_department_id;
    
BEGIN
    --2) 커서 오픈(실행)
    OPEN cur_emp_dep (90);
    
    --3) 커서 패치작업
    LOOP
    --데이터가 존재하지 않을 때가지 읽어와야 해서 LOOP문 사용
        FETCH cur_emp_dep INTO vs_emp_name;
        
        --LOOP문이 몇 번 돌았는지 확인 용 변수
        vn_cnt := vn_cnt + 1;
        DBMS_OUTPUT.PUT_LINE(vn_cnt);

        --커서영역에 현재의 포인터가 더이상 참조할 데이터 행이 없는 경우 LOOP 탈출
        EXIT WHEN cur_emp_dep%NOTFOUND;
        --현재 FETCH의 상태를 확인
        
        DBMS_OUTPUT.PUT_LINE(vs_emp_name);
        
    END LOOP;
    
    --4)커서 닫기
    CLOSE cur_emp_dep;
END;

/*
커서와 FOR문
9장에서 FOR문의 기본 형태와 사용법에 대해 배웠는데, 
FOR문은 커서와 함께 또 다른 형태로 사용할 수 있다. 

기본 FOR문 구문 형식

    FOR 인덱스 IN [REVERSE]초깃값..최종값
    LOOP
      처리문;
    END LOOP;
커서와 함께 FOR문을 사용할 때는, “초깃값..최종값” 대신 커서가 위치한다.

커서와 함께 사용될 경우 FOR문 구문 형식

    FOR 레코드 IN 커서명(매개변수1, 매개변수2, ...)
    LOOP
      처리문;
    END LOOP;
*/
DECLARE
    --커서 선언
    
BEGIN
    --내부적으로 커서 OPEN이 사용
    --FOR문을 통한 커서 패치작업
    FOR 레코드명 IN 커서이름
    --1) OPEN 커서 2) 데이터행을 레코드변수가 참조
    
    LOOP
    
    END LOOP;
END;

--1)FOR문으로 패치, 레코드명 사용, <레코드명.컬럼명>
DECLARE
    --커서 선언
    CURSOR cur_emp_dep (cp_department_id EMPLOYEES.DEPARTMENT_ID%TYPE)
    IS
    SELECT EMPLOYEE_ID, EMP_NAME FROM EMPLOYEES
    WHERE DEPARTMENT_ID = cp_department_id;
    
BEGIN
    --내부적으로 커서 OPEN이 사용
    --FOR문을 통한 커서 패치작업
    FOR emp_rec IN cur_emp_dep(90)
    --1) OPEN 커서 2) 데이터행을 emp_rec레코드변수가 참조
    LOOP
        DBMS_OUTPUT.PUT_LINE('사원번호: ' || emp_rec.EMPLOYEE_ID);
        DBMS_OUTPUT.PUT_LINE('사원 이름: ' || emp_rec.EMP_NAME);
    END LOOP;
END;

--2)FOR문으로 패치(커서의 내용을 포함), 레코드명 사용, <레코드명.컬럼명>
DECLARE
    
BEGIN
    --내부적으로 커서 OPEN이 사용
    --FOR문을 통한 커서 패치작업
    FOR emp_rec IN (
                    SELECT EMPLOYEE_ID, EMP_NAME FROM EMPLOYEES
                    WHERE DEPARTMENT_ID = 90
                    )

    LOOP
        DBMS_OUTPUT.PUT_LINE('사원번호: ' || emp_rec.EMPLOYEE_ID);
        DBMS_OUTPUT.PUT_LINE('사원 이름: ' || emp_rec.EMP_NAME);
    END LOOP;
END;

/*
커서 변수를 선언하는 방법
첫 번째는 참조용 커서 타입을 생성하고 나서 이 타입에 대한 커서 변수를 선언하는 방법이다.

    ⓐ TYPE 커서_타입명 IS REF CURSOR [ RETURN 반환 타입 ] ;
    ⓑ 커서_변수명 커서_타입명;
    
커서 변수를 정의하기 위한 데이터타입
    - 약한 커서타입 정의
        TYPE 약한커서타입이름 IS REF CURSOR;
    - 강한 커서타입 정의
        TYPE 약한커서타입이름 IS REF CURSOR RETURN 반환타입;
*/
--커서변수
--변수에 들어오는 내용이 커서인데 이 커서의 내용을 얼만든지 변경하여 할당할 수 있다
--변수가 커서를 데이터로 사용
--현재 아래구문은 일반 명시적 커서와 동일
DECLARE
    vs_emp_name EMPLOYEES.EMP_NAME%TYPE;
    
    --약한 커서타입 선언
    TYPE emp_dep_curtype IS REF CURSOR;
    --커서 변수 선언 예> 커서변수명 커서약한(혹은 강한)데이터타입;
    emp_dep_curvar emp_dep_curtype;
BEGIN
    OPEN emp_dep_curvar FOR SELECT EMP_NAME
                            FROM EMPLOYEES
                            WHERE DEPARTMENT_ID = 90;
    
    LOOP
        FETCH emp_dep_curvar INTO vs_emp_name;
        
        EXIT WHEN emp_dep_curvar%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(vs_emp_name);
    END LOOP;
END;

/*
강한커서타입의 커서변수 선언 : 커서변수가 갖게 되는 SELECT문의 범위를 지정
    TYPE test_curtype IS REF CURSOR RETURN departments%ROWTYPE;
    --DEPARTMENTS 테이블의 모든 컬럼이 있어야 한다는 뜻
    test_curvar test_curtype;
    
    OPEN test_curvar FOR SELECT * FROM departments;             -- (O) 정상
    OPEN test_curvar FOR SELECT department_id FROM departments; -- (X) department_id만 선택 했기 때문
    OPEN test_curvar FOR SELECT * FROM employees;               -- (X) 전혀 다른 사원 테이블을 조회
*/

/*
약한 커서타입의 커서변수 선언
    --REF CURSOR : 약한 커서타입을 선언하는 키워드, 내장 명령어
    TYPE test_curtype IS REF CURSOR;
    test_curvar test_curtype;

    OPEN test_curvar FOR SELECT * FROM departments;             -- (O) 정상
    OPEN test_curvar FOR SELECT department_id FROM departments; -- (O) 정상
    OPEN test_curvar FOR SELECT * FROM employees;               -- (O) 정상
*/

--커서 변수를 매개변수로 전달하기(커서변수의 응용예제)
DECLARE
    emp_dep_curvar SYS_REFCURSOR; 
    --SYS_REFCURSOR : 약한커서타입의 커서변수 선언
    
    --사원명을 받아오기 위한 변수 선언
    vs_emp_name EMPLOYEES.EMP_NAME%TYPE;
    
    --임시 프로시저 선언(정의)
    PROCEDURE test_cursor_argu(p_curvar IN OUT SYS_REFCURSOR)
    IS
        c_temp_curvar SYS_REFCURSOR;
    BEGIN
        OPEN c_temp_curvar FOR 
                            SELECT EMP_NAME
                            FROM EMPLOYEES
                            WHERE DEPARTMENT_ID = 90;
        p_curvar := c_temp_curvar;
    END;
BEGIN
    --프로시저 호출 : emp_dep_curvar매개변수로 제공한 커서변수가 3) 임시프로시저 내부의 커서변수 c_temp_curvar의 내용을 참조
    test_cursor_argu(emp_dep_curvar);
    
    LOOP
        FETCH emp_dep_curvar INTO vs_emp_name;
        EXIT WHEN emp_dep_curvar%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(vs_emp_name);
    END LOOP;
END;