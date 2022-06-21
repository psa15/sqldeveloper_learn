-- 1. 업무(JOB)가 MANAGER 인 사원의 이름, 입사일 출력
SELECT ename, HIREDATE FROM EMP
WHERE job = 'MANAGER'
​
-- 2. 사원명이 WARD 인 사원의 급여, 커미션을 출력
SELECT sal, COMM FROM EMP
WHERE ename = 'WARD';

-- 3. 30번 부서에 속하는 사원의 이름, 부서번호를 출력
SELECT ename, DEPTNO FROM EMP
WHERE deptno = 30;

-- 4-1. 급여가 1250을 초과, 3000이하인 사원의 이름, 급여를 출력
SELECT ename, SAL
FROM EMP
WHERE SAL > 1250 AND SAL <= 3000;
​
-- 4-2. 급여가 1250이상이고, 3000이하인 사원의 이름, 급여를 출력(범위가 포함됨)
SELECT ename, SAL
FROM EMP
WHERE SAL >= 1250 AND SAL <= 3000;​

-- 5. 커미션이 0 인 사원이 이름, 커미션을 출력
SELECT ename, COMM FROM EMP
WHERE COMM = 0;
​
-- 6-1. 커미션 계약을 하지 않은 사원의 이름츨 출력
SELECT ENAME FROM EMP
WHERE COMM IS NULL;
​
-- 6-2. 커미션 계약을 한 사원의 이름을 출력
SELECT ENAME FROM EMP
WHERE COMM IS NOT NULL;
​
-- 7. 입사일이 81/06/09 보다 늦은 사원이 이름, 입사일 출력(입사일을 기준으로 오름차순.)
SELECT ename, HIREDATE FROM EMP
WHERE HIREDATE > '1981-06-09'
ORDER BY HIREDATE;
​
-- 8. 모든 사원의 급여마다 1000을 더한 급여를 출력
SELECT ename, SAL, SAL + 1000 FROM EMP;
​
-- 9. FORD 의 입사일, 부서번호를 출력
SELECT hiredate, DEPTNO FROM EMP
WHERE ename = 'FORD';​

-- 10. 사원명이 ALLEN인 사원의 급여를 출력하세요.
SELECT SAL FROM EMP 
WHERE ENAME = 'ALLEN';
​
-- 11. ALLEN의 급여보다 높은 급여를 받는 사원의 사원명, 급여를 출력
SELECT ename, SAL FROM EMP
WHERE SAL > (SELECT SAL FROM EMP WHERE ENAME = 'ALLEN');
​
-- 12. 가장 높은/낮은 커미션을 구하세요.(최대값/최소값)
SELECT MAX(COMM)AS "가장 높은 커미션", MIN(COMM) AS "가장 낮은 커미션" FROM EMP;

-- 13. 가장 높은 커미션을 받는 사원의 이름을 구하세요.
SELECT ENAME FROM EMP
WHERE COMM = (SELECT MAX(COMM) FROM EMP);

-- 14. 가장 높은 커미션을 받는 사원의 입사일보다 늦은 사원의 이름 입사일을 출력 
SELECT ENAME, HIREDATE FROM EMP
WHERE HIREDATE > (SELECT HIREDATE FROM EMP 
                    WHERE COMM = (SELECT MAX(COMM) FROM EMP));
​
-- 15. JOB이 CLERK 인 사원들의 급여의 합을 구하세요.
SELECT SUM(SAL) FROM EMP
WHERE JOB = 'CLERK';
​
-- 16. JOB 이 CLERK 인 사원들의 급여의 합보다 급여가 많은 사원이름을 출력.
SELECT ENAME FROM EMP
WHERE SAL > (SELECT SUM(SAL) FROM EMP
                WHERE JOB = 'CLERK');
​

-- 17. JOB이 CLERK 인 사원들의 급여와 같은 급여를 받는 사원의 이름, 급여를 출력(급여 내림차순으로)
--1300, 950, 800
/*
IN 사용
IN : 서브 쿼리의 결과값이 여러개 값일 경우 사용
*/
SELECT ENAME, SAL FROM EMP
WHERE SAL IN (SELECT SAL FROM EMP
                WHERE JOB = 'CLERK')
ORDER BY SAL DESC;
​​

-- 18. EMP테이블의 구조출력
DESC EMP;