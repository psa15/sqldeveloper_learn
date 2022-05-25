-- 1. ALLEN 과 부서가 같은 사원들의 사원명, 입사일을 출력(급여 내림차순 정렬)
SELECT ename, HIREDATE, SAL FROM EMP
WHERE DEPTNO = (SELECT DEPTNO FROM EMP
                    WHERE ename = 'ALLEN') 
ORDER BY SAL DESC;

-- 2. 가장 높은 급여를 받는 사원보다 입사일이 늦은 사원의 이름, 입사일을 출력
--사원의 이름, 입사일을 출력
SELECT ename, HIREDATE FROM EMP
--입사일이 늦은 사원의 이름
WHERE HIREDATE > (SELECT hiredate FROM EMP --가장 높은 급여를 받는 사원의 입사일
                    WHERE SAL = (SELECT MAX(SAL) FROM EMP)); --가장 높은 급여를 받는 사원
                    
-- 3. 이름에 'T' 자가 들어가는 사원들의 급여의 합을 구하세요. (LIKE 사용)
SELECT SUM(SAL) FROM EMP
WHERE ENAME LIKE '%T%';​

-- 4. 모든 사원의 평균급여를 구하세요. 소수 둘째자리 반올림표현
SELECT ROUND(AVG(SAL),2) AS 평균급여 FROM EMP;
​
-- 5. 각 부서별 평균 급여를 구하세요. 소수 둘째자리 반올림표현 (GROUP BY)

​

​

-- 6. 각 부서별 평균급여, 전체급여, 최고급여, 최저급여를 구하여 평균급여가 높은 순으로 출력. 평균은 소수 둘째자리 반올림표현

​

​

-- 7. 20번 부서의 최고 급여보다 많은 사원의 사원번호, 사원명, 급여를 출력

​

​

-- 8. SMITH 와 같은 부서에 속한 사원들의 평균급여보다 큰 급여를 받는 모든 사원의 사원명, 급여를 출력

​

​

-- 9. 회사내의 최소급여와 최대급여의 차이를 구하세요. 

​

​

-- 10. SCOTT 의 급여에서 1000 을 뺀 급여보다 적게 받는 사원의 이름, 급여를 출력.

​

​

-- 11. JOB이 MANAGER인 사원들 중 최소급여를 받는 사원보다 급여가 적은 사원이름, 급여를 출력

​

​

-- 12. 이름이 S로 시작하고 마지막글자가 H인 사원의 이름을 출력

​

​

-- 13. WARD 가 소속된 부서 사원들의 평균 급여보다, 급여가 높은 사원의 이름,급여를 출력.

​

​

-- 14-1. EMP테이블의 모든 사원수를 출력

​

​

-- 15. 업무별(JOB) 사원수를 출력

​

​

-- 16. 최소급여를 받는 사원과 같은 부서의 모든 사원명을 출력
[출처] sql 기본쿼리 연습문제 2 (비공개 카페)