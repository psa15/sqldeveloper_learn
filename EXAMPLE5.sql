--오라클 11g hr계정 연습문제

--1. 직책(Job Title)이 Sales Manager인 사원들의 입사년도와 입사년도(hire_date)별 평균 급여를 출력하시오. 
-- 출력 시 년도를 기준으로 오름차순 정렬하시오. 
SELECT TO_CHAR(HIRE_DATE, 'YYYY'), AVG(SALARY)
FROM EMPLOYEES
WHERE JOB_ID = (SELECT JOB_ID FROM JOBS WHERE JOB_TITLE = 'Sales Manager')
GROUP BY TO_CHAR(HIRE_DATE, 'YYYY')
ORDER BY TO_CHAR(HIRE_DATE, 'YYYY');

SELECT HIRE_DATE, SALARY FROM EMPLOYEES WHERE JOB_ID = 'SA_MAN';

--2. 각 도시(city)에 있는 모든 부서 직원들의 평균급여를 조회하고자 한다. 
-- 평균급여가 가장 낮은 도시부터 도시명(city)과 평균연봉, 해당 도시의 직원수를 출력하시오. 
-- 단, 도시에 근 무하는 직원이 10명 이상인 곳은 제외하고 조회하시오.
SELECT CITY, AVG(SALARY), COUNT(*)
FROM EMPLOYEES e, DEPARTMENTS d, LOCATIONS loc
WHERE e.department_id = d.department_id
AND d.location_id = loc.location_id
GROUP BY CITY
HAVING COUNT(*) < 10
ORDER BY AVG(SALARY);

--3. ‘Public Accountant’의 직책(job_title)으로 과거에 근무한 적이 있는 모든 사원의 사번과 이름을 출력하시오. 
-- (현재 ‘Public Accountant’의 직책(job_title)으로 근무하는 사원은 고려 하지 않는다.) 
-- 이름은 first_name, last_name을 아래의 실행결과와 같이 출력한다.
SELECT e.employee_id, (FIRST_NAME || ' ' || LAST_NAME) NAME
FROM EMPLOYEES e, JOB_HISTORY jh, JOBS j
WHERE e.employee_id = jh.employee_id
AND jh.job_id = j.job_id
AND jh.job_id = (SELECT job_id FROM JOBS 
                    WHERE JOB_TITLE = 'Public Accountant');

--4. 자신의 매니저보다 연봉(salary)를 많이 받는 직원들의 성(last_name)과 연봉(salary)를 출 력하시오.
SELECT a.EMPLOYEE_ID 사원아이디, a.LAST_NAME "사원이름(성)", a.SALARY 사원연봉, 
        b.EMPLOYEE_ID 매니저아이디, b.LAST_NAME 매니저이름, b.SALARY 매니저연봉
FROM EMPLOYEES a, EMPLOYEES b
WHERE a.MANAGER_ID = b.EMPLOYEE_ID
AND b.SALARY < a.SALARY;

--5. 2007년에 입사(hire_date)한 직원들의 사번(employee_id), 이름(first_name), 성(last_name), 부서명(department_name)을 조회합니다. 
-- 이때, 부서에 배치되지 않은 직원의 경우, ‘<Not Assigned>’로 출력하시오. 
SELECT employee_id, FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM EMPLOYEES e, DEPARTMENTS d
WHERE e.department_id = d.department_id
AND TO_CHAR(HIRE_DATE, 'YYYY') = 2007;

--=====================ANSWER===========
SELECT e.EMPLOYEE_ID , e.LAST_NAME , e.FIRST_NAME , 
        NVL(d.DEPARTMENT_NAME, '<Not Assigned>')
FROM EMPLOYEES e LEFT JOIN DEPARTMENTS d
ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
WHERE TO_CHAR(e.HIRE_DATE, 'YYYY') = '2007'
ORDER BY e.EMPLOYEE_ID ASC; 

--6. 업무명(job_title)이 ‘Sales Representative’인 직원 중에서 연봉(salary)이 9,000이상, 10,000 이하인 
-- 직원들의 이름(first_name), 성(last_name)과 연봉(salary)를 출력하시오
SELECT first_name, LAST_NAME, JOB_TITLE, SALARY
FROM EMPLOYEES E, JOBS J
WHERE E.JOB_ID = j.job_id
AND JOB_TITLE = 'Sales Representative'
AND SALARY BETWEEN 9000 AND 10000;

--7. 부서별로 가장 적은 급여를 받고 있는 직원의 이름, 부서이름, 급여를 출력하시오. 
-- 이름은 last_name만 출력하며, 부서이름으로 오름차순 정렬하고, 
-- 부서가 같은 경우 이름을 기준 으로 오름차순 정렬하여 출력합니다. 
SELECT LAST_NAME, DEPARTMENT_NAME, SALARY
FROM EMPLOYEES, DEPARTMENTS
WHERE SALARY IN(SELECT MIN(SALARY)FROM EMPLOYEES
                    GROUP BY DEPARTMENT_ID)
ORDER BY DEPARTMENT_NAME, LAST_NAME;

--===============ANSWER============
SELECT E.LAST_NAME, A.*
FROM EMPLOYEES E, 
(
    SELECT d.DEPARTMENT_NAME, MIN(e.SALARY) AS MIN_SALARY
    FROM EMPLOYEES e, DEPARTMENTS d 
    WHERE e.DEPARTMENT_ID = d.DEPARTMENT_ID 
    GROUP BY d.DEPARTMENT_NAME
) A 
WHERE E.SALARY = A.MIN_SALARY
ORDER BY A.DEPARTMENT_NAME ASC, E.LAST_NAME ASC;


--8. EMPLOYEES 테이블에서 급여를 많이 받는 순서대로 조회했을 때 결과처럼 6번째부터 10 번째까지 
-- 5명의 last_name, first_name, salary를 조회하는 sql문장을 작성하시오.
SELECT last_name, FIRST_NAME, SALARY
FROM EMPLOYEES
WHERE ROWNUM > 5
ORDER BY SALARY DESC
;

--================ANSWER
SELECT *
FROM (
        SELECT RANK() OVER(ORDER BY SALARY DESC) AS RANK,
        last_name, FIRST_NAME, SALARY
        FROM EMPLOYEES
    )
WHERE RANK BETWEEN 6 AND 10;

--9. 사원의 부서가 속한 도시(city)가 ‘Seattle’인 사원의 이름, 해당 사원의 매니저 이름, 사원 의 부서이름을 출력하시오. 
-- 이때 사원의 매니저가 없을 경우 ‘<없음>’이라고 출력하시오. 이름은 last_name만 출력하며, 
-- 사원의 이름을 오름차순으로 정렬하시오. 
SELECT e.LAST_NAME, c.MNAME
FROM EMPLOYEES e
(
    SELECT a.LAST_NAME AS ENAME, b.LAST_NAME AS MNAME
    FROM EMPLOYEES a, EMPLOYEES b, LOCATIONS loc, DEPARTMENTS d
    WHERE a.MANAGER_ID = b.EMPLOYEE_ID
    AND a.DEPARTMENT_ID = d.DEPARTMENT_ID
    AND d.LOCATION_ID = loc.LOCATION_ID
    AND loc.CITY = 'Seattle'
) c
;
--==========ANSWER=======
SELECT c.ENAME, NVL(c.MNAME, '<없음>'), DEPARTMENT_NAME
FROM
(
    SELECT a.LAST_NAME AS ENAME, b.LAST_NAME AS MNAME, a.DEPARTMENT_ID AS DEPT_ID
    FROM EMPLOYEES a LEFT JOIN EMPLOYEES b
    ON a.MANAGER_ID = b.EMPLOYEE_ID 
) c,
LOCATIONS loc, DEPARTMENTS dep
WHERE dep.LOCATION_ID = loc.LOCATION_ID
AND c.DEPT_ID = dep.DEPARTMENT_ID
AND loc.CITY = 'Seattle';



--10. 각 업무(job) 별로 연봉(salary)의 총합을 구하고자 한다. 연봉 총합이 가장 높은 업무부터 
-- 업무명(job_title)과 연봉 총합을 조회하시오. 단 연봉총합이 30,000보다 큰 업무만 출력하시오. 
SELECT EMPLOYEES.JOB_ID, SUM(SALARY)
FROM EMPLOYEES, JOBS
WHERE EMPLOYEES.JOB_ID = JOBS.JOB_ID
GROUP BY EMPLOYEES.JOB_ID
HAVING SUM(SALARY) > 30000;

--11. 각 사원(employee)에 대해서 사번(employee_id), 이름(first_name), 업무명(job_title), 
-- 부서 명(department_name)을 조회하시오. 
-- 단 도시명(city)이 ‘Seattle’인 지역(location)의 부서 (department)에 근무하는 직원을 사원번호 오름차순순으로 출력
SELECT employee_id, FIRST_NAME, JOB_TITLE
FROM EMPLOYEES e, JOBS j
WHERE e.job_id = j.job_id
AND DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM

--12. 2001~20003년사이에 입사한 직원의 이름(first_name), 입사일(hire_date), 관리자사번 (employee_id), 
-- 관리자 이름(fist_name)을 조회합니다. 단, 관리자가 없는 사원정보도 출력 결과에 포함시켜 출력한다.
first_name, HIRE_DATE, EMPLOYEE_ID
a.first_name 직원이름, a.HIRE_DATE 직원입사일, b.EMPLOYEE_ID 관리자사번, b.first_name 관리자 이름

SELECT a.first_name 직원이름, a.HIRE_DATE 직원입사일, b.EMPLOYEE_ID 관리자사번, b.first_name 관리자이름
FROM EMPLOYEES a LEFT JOIN EMPLOYEES b
ON a.MANAGER_ID = b.EMPLOYEE_ID
WHERE TO_CHAR(a.HIRE_DATE, 'YYYY') BETWEEN 2001 AND  2003;

--13. ‘Sales’ 부서에 속한 직원의 이름(first_name), 급여(salary), 부서이름(department_name)을 조회하시오. 
-- 단, 급여는 100번 부서의 평균보다 적게 받는 직원 정보만 출력되어야 한다. 
first_name, SALARY, DEPARTMENT_NAME

SELECT first_name, SALARY, DEPARTMENT_NAME
FROM EMPLOYEES e, DEPARTMENTS d
WHERE e.DEPARTMENT_ID = d.DEPARTMENT_ID
AND DEPARTMENT_NAME = 'Sales'
AND SALARY < (SELECT AVG(SALARY) FROM EMPLOYEES WHERE DEPARTMENT_ID = 100);
 

--14. Employees 테이블에서 입사한달(hire_date)별로 인원수를 조회하시오.
SELECT TO_CHAR(HIRE_DATE, 'MM'), COUNT(*)
FROM EMPLOYEES
GROUP BY TO_CHAR(HIRE_DATE, 'MM')
ORDER BY TO_CHAR(HIRE_DATE, 'MM');

--15. 부서별 직원들의 최대, 최소, 평균급여를 조회하되, 
-- 평균급여가 ‘IT’ 부서의 평균급여보다 많고, ‘Sales’ 부서의 평균보다 적은 부서 정보만 출력하시오. 
SELECT DEPARTMENT_ID, MAX(SALARY), MIN(SALARY), AVG(SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING (AVG(SALARY) > (SELECT AVG(SALARY)
                        FROM EMPLOYEES e, DEPARTMENTS d
                        WHERE e.DEPARTMENT_ID = d.DEPARTMENT_ID
                        AND DEPARTMENT_NAME = 'IT')
        AND AVG(SALARY) < (SELECT AVG(SALARY)
                        FROM EMPLOYEES e, DEPARTMENTS d
                        WHERE e.DEPARTMENT_ID = d.DEPARTMENT_ID
                        AND DEPARTMENT_NAME = 'Sales'));
--위처럼 코드 치면 부서가 NULL인 사원도 나옴

--NULL은 제외하려면 INNER JOIN 필요
SELECT DEPARTMENT_NAME, MAX(e.SALARY), MIN(e.SALARY), AVG(e.SALARY)
FROM EMPLOYEES e, DEPARTMENTS d
WHERE e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY DEPARTMENT_NAME
HAVING (AVG(SALARY) > (SELECT AVG(SALARY)
                        FROM EMPLOYEES e, DEPARTMENTS d
                        WHERE e.DEPARTMENT_ID = d.DEPARTMENT_ID
                        AND DEPARTMENT_NAME = 'IT')
        AND AVG(SALARY) < (SELECT AVG(SALARY)
                        FROM EMPLOYEES e, DEPARTMENTS d
                        WHERE e.DEPARTMENT_ID = d.DEPARTMENT_ID
                        AND DEPARTMENT_NAME = 'Sales'));

--16. 각 부서별로 직원이 한명만 있는 부서만 조회하시오. 
-- 단, 직원이 없는 부서에 대해서는 ‘<신생부서>’라는 문자열이 출력되도록 하고,
-- 출력결과는 다음과 같이 부서명이 내림차순 으로 정렬되어야한다. 
SELECT DEPARTMENT_NAME, COUNT(*)
FROM DEPARTMENTS d, EMPLOYEES e
WHERE e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY DEPARTMENT_NAME
HAVING COUNT(e.EMPLOYEE_ID) = 1;

--직원이 없는 부서를 출력하려면 LEFT JOIN 사용
SELECT DEPARTMENT_NAME, COUNT(*)
FROM DEPARTMENTS d RIGHT JOIN EMPLOYEES e
ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY DEPARTMENT_NAME;
--부서명이 NULL인 데이터도 출력됨

--부서명이 NULL인 데이터를 신생부서로
SELECT NVL(DEPARTMENT_NAME,'<신생부서>') AS DEPARTMENT_NAME, COUNT(*)
FROM DEPARTMENTS d RIGHT JOIN EMPLOYEES e
ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY DEPARTMENT_NAME;

--1명뿐인 부서 출력
SELECT NVL(DEPARTMENT_NAME,'<신생부서>') AS DEPARTMENT_NAME, COUNT(*)
FROM DEPARTMENTS d RIGHT JOIN EMPLOYEES e
ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY DEPARTMENT_NAME
HAVING COUNT(*) = 1
ORDER BY DEPARTMENT_NAME;

--=================ANSWER====================
SELECT NVL(D.DEPARTMENT_NAME, '<신생부서>') AS DEPARTMENT_NAME , COUNT(*)
FROM EMPLOYEES E LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME
HAVING COUNT(*) = 1
ORDER BY D.DEPARTMENT_NAME DESC;


--17. 부서별 입사월별 직원수를 출력하시오. 
-- 단, 직원수가 5명 이상인 부서만 출력되어야 하며 출력결과는 부서이름 순으로 한다.
SELECT DEPARTMENT_NAME 부서, TO_CHAR(HIRE_DATE, 'MM') 입사월, COUNT(*)
FROM EMPLOYEES e, DEPARTMENTS d
WHERE e.DEPARTMENT_ID = d.department_id
GROUP BY DEPARTMENT_NAME, TO_CHAR(HIRE_DATE, 'MM') 
HAVING COUNT(*) >= 5
ORDER BY DEPARTMENT_NAME;
--TO_CHAR(E.HIRE_DATE, 'MON', 'NLS_DATE_LANGUAGE=ENGLISH') -> 1월을 JAN으로, 3월을 MAR 로 출력


--18. 국가(country_name) 별 도시(city)별 직원수를 조회하시오. 
-- 단, 부서에 속해있지 않은 직원 이 있기 때문에 106명의 직원만 출력이 된다. 
-- 부서정보가 없는 직원은 국가명과 도시명 대신에 ‘<부서없음>’이 출력되도록 하여 107명 모두 출력되게 한다.
SELECT c.country_name 국가별, loc.CITY 도시별, COUNT(*)
FROM (SELECT EMPLOYEE_ID, NVL(DEPARTMENT_NAME, '<부서없음>'), NVL(LOCATION_ID, '<부서없음>')
        FROM EMPLOYEES e LEFT JOIN DEPARTMENTS d
            ON e.DEPARTMENT_ID = d.department_id) a,
    COUNTRIES c, 
    LOCATIONS loc
WHERE a.LOCATION_ID = loc.LOCATION_ID
AND loc.COUNTRY_ID = c.COUNTRY_ID
GROUP BY c.country_name, loc.CITY;

--19. 각 부서별 최대 급여자의 아이디(employee_id), 이름(first_name), 급여(salary)를 출력하시오. 
-- 단, 최대 급여자가 속한 부서의 평균급여를 마지막으로 출력하여 평균급여와 비교할 수 있게 할 것.


--20. 커미션(commission_pct)별 직원수를 조회하시오. 
-- 커미션은 아래실행결과처럼 0.2, 0.25는 모두 .2로, 0.3, 0.35는 .3 형태로 출력되어야 한다. 
-- 단, 커미션 정보가 없는 직원들도 있는 데 커미션이 없는 직원 그룹은 ‘<커미션 없음>’이 출력되게 한다.


--21. 커미션(commission_pct)을 가장 많이 받은 상위 4명의 부서명(department_name), 
-- 직원명 (first_name), 급여(salary), 커미션(commission_pct) 정보를 조회하시오. 
-- 출력결과는 커미션 을 많이 받는 순서로 출력하되 동일한 커미션에 대해서는 급여가 높은 직원이 먼저 출력 되게 한다.


