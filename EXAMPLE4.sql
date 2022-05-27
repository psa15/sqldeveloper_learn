-- 관리자(sys, system ) 으로 접속하여, 학습용 계정인 scott 계정을 비밀번호및 활성화 적용 후

-- scott계정 접속 후 사용
-- 사용문법이 대부분 JOIN, SUB QUERY 문법위주 연습.
-- 1. 최소급여를 받는 사원과 같은 부서에서 근무하는 모든 사원명, 부서명을 출력
--최소급여를 받는 사원
SELECT MIN(SAL) FROM EMP;

--최소급여를 받는 사원과 같은 부서에서 근무하는 모든 사원명, 부서명을 출력
SELECT ENAME, DNAME
FROM EMP, DEPT
WHERE EMP.DEPTNO = dept.deptno
AND emp.deptno = (SELECT DEPTNO FROM EMP WHERE SAL = (SELECT MIN(SAL) FROM EMP)
                  );

-- 2. CLARK보다 입사일이 늦은 사원과 같은 부서에서 근무하는 사원들의 부서명, 이름, 급여를 출력 
--CLARK보다 입사일이 늦은 사원
SELECT ENAME, HIREDATE  FROM EMP WHERE HIREDATE > (SELECT HIREDATE FROM EMP WHERE ENAME = 'CLARK');
​
--CLARK보다 입사일이 늦은 사원과 같은 부서에서 근무하는 사원들의 부서명, 이름, 급여를 출력 
SELECT DNAME, ENAME, SAL
FROM EMP, DEPT
WHERE EMP.DEPTNO = dept.deptno
AND EMP.DEPTNO IN (SELECT DEPTNO  FROM EMP 
                    WHERE HIREDATE > (SELECT HIREDATE FROM EMP 
                                        WHERE ENAME = 'CLARK'));

-- 3. 이름에 'K'자가 들어가는 사원들 중 급여가 가장 적은 사원의 부서명, 사원명, 급여를 출력 
--이름에 'K'자가 들어가는 사원
SELECT ENAME FROM EMP WHERE ENAME LIKE '%K%';

SELECT DNAME, ENAME, SAL
FROM EMP INNER JOIN DEPT
ON EMP.DEPTNO = dept.deptno
WHERE SAL = (SELECT MIN(SAL) FROM EMP  
                WHERE ENAME IN (SELECT ENAME FROM EMP 
                                WHERE ENAME LIKE '%K%'));

-- 4. 커미션 계약이 없는 사원중 입사일이 가장 빠른 사원의 부서명, 사원명, 입사일을 출력
--커미션 계약이 없는 사원
SELECT ENAME FROM EMP WHERE COMM IS NULL;
​
SELECT DNAME, ENAME, HIREDATE
FROM EMP INNER JOIN DEPT
ON EMP.DEPTNO = dept.deptno
WHERE HIREDATE = (SELECT MIN(HIREDATE) FROM EMP 
                    WHERE ENAME IN (SELECT ENAME FROM EMP 
                                        WHERE COMM IS NULL));

-- 5. 위치가 시카고인 부서에 속한 사원들의 이름과 부서명을 출력.
SELECT ENAME, DNAME
FROM EMP, DEPT
WHERE EMP.DEPTNO = dept.deptno
AND EMP.DEPTNO = (SELECT DEPTNO FROM DEPT WHERE LOC = 'CHICAGO');
​
-- 6. KING의 급여에서 CLARK의 급여를 뺀 결과보다 적은 급여를 받는 사원의 부서명, 이름, 급여를 출력 
--KING의 급여에서 CLARK의 급여를 뺀 결과
SELECT DNAME, ENAME, SAL
FROM EMP INNER JOIN DEPT
ON EMP.DEPTNO = dept.deptno
WHERE SAL < (SELECT ((SELECT SAL FROM EMP WHERE ENAME = 'KING') - (SELECT SAL FROM EMP WHERE ENAME = 'CLARK')) AS SAL
             FROM EMP
             WHERE ROWNUM = 1);
​

​

-- 7. DALLAS에 위치한 부서에 속한 사원의 총사원수, 평균급여,전체급여,최고급여,최저급여를 구하세요. 
--DALLAS에 위치한 부서
SELECT DEPTNO FROM DEPT WHERE LOC = 'DALLAS';

SELECT COUNT(*) 총사원수, AVG(SAL) 평균급여, SUM(SAL) 전체급여, MAX(SAL) 최고급여, MIN(SAL)최저급여
FROM EMP, DEPT
WHERE EMP.DEPTNO = dept.deptno
AND EMP.DEPTNO = (SELECT DEPTNO FROM DEPT WHERE LOC = 'DALLAS');
​
-- 8. 커미션 계약조건이 있으며 이름에 'N'자가 들어가는 사원들 중 급여가 가장 적은 사원의 사원명, 급여,부서명을 출력
SELECT ENAME, SAL, DNAME
FROM EMP INNER JOIN DEPT
ON EMP.DEPTNO = dept.deptno
WHERE SAL = (SELECT MIN(SAL) FROM EMP
                WHERE ENAME IN (SELECT ENAME FROM EMP
                                    WHERE COMM IS NOT NULL AND ENAME LIKE '%N%'));
​

-- 9. ALLEN 보다 입사일이 빠른 사원의 부서명,사원명을 출력
SELECT DNAME, ENAME
FROM EMP INNER JOIN DEPT
ON EMP.DEPTNO = dept.deptno
WHERE HIREDATE < (SELECT HIREDATE FROM EMP WHERE ENAME = 'ALLEN');
​
-- 10. EMP 테이블에서 이름이 5글자인 사원중 급여가 가장 높은 사원의 이름, 급여 , 부서명을 출력
-- EMP 테이블에서 이름이 5글자인 사원
SELECT ENAME FROM EMP WHERE ENAME LIKE '_____';


​SELECT ENAME, SAL, DNAME
FROM EMP, DEPT
WHERE EMP.DEPTNO = dept.deptno
AND SAL = (SELECT MAX(SAL) FROM EMP
            WHERE ENAME LIKE '_____');

-- 11. CLARK 이 속한 부서의 평균 연봉보다 급여가 높은 사원중 입사일이 가장 빠른 사원의 부서명, 사원명, 급여를 출력
SELECT DNAME, ENAME, SAL
FROM EMP, DEPT
WHERE EMP.DEPTNO = dept.deptno
AND HIREDATE = (SELECT MIN(HIREDATE) FROM EMP
                    WHERE SAL > (SELECT AVG(SAL) FROM EMP
                                    WHERE DEPTNO = (SELECT DEPTNO FROM EMP 
                                                        WHERE ENAME = 'CLARK')
                                    )
                );
​

-- 12. ALLEN의 부서명을 출력
SELECT DNAME
F
​

​

-- 13. 이름에 J가 들어가는 사원들 중, 급여가 가장 높은 사원의 사원번호, 이름, 부서명, 급여, 부서위치를 출력

​

​

​

​

-- 14. 두번째로 많은 급여를 받는 사원의 이름과 부서명,급여를 출력

​

​

​

-- 15. 입사일이 2번째로 빠른 사원의 부서명과 이름, 입사일을 출력

​

​

-- 16. DALLAS에 위치한 부서의 사원 중 최대 급여를 받는 사원의 급여에서 최소 급여를 받는 사원의 급여를 뺀 결과를 출력
[출처] sql 기본쿼리 연습문제 4 (비공개 카페)