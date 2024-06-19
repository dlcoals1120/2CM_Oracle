-- 5일차 서브쿼리(SubQuery)
-- 하나의 SQL문 안에 포함되어 있는 또 다른 SQL문
-- 메인 쿼리가 서브 쿼리를 포함하는 종속적인 관계
-- 서브쿼리는 반드시 소괄호로 묶어야 함
-- 서브쿼리 안에 ORDER BY는 지원 안 됨 주의

-- 예제1
-- 전지연 직원의 관리자 이름을 출력하세요.
SELECT * FROM EMPLOYEE
WHERE EMP_NAME = '전지연';

SELECT EMP_NAME FROM EMPLOYEE
WHERE EMP_ID = 214;

-- 서브쿼리로 만들어보세요~
SELECT * FROM EMPLOYEE
WHERE EMP_ID = (SELECT MANAGER_ID FROM EMPLOYEE
WHERE EMP_NAME = '전지연');

-- [전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의 사번, 이름, 직급코드, 급여를 조회하세요.]
-- 서브쿼리를 쓰지 않는 경우
SELECT AVG(SALARY) FROM EMPLOYEE; -- 3047663

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3047663;

-- 서브쿼리를 쓰는 경우
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);

-- 1.2 서브쿼리의 종류
-- 1.2.1. 단일행 서브쿼리
-- 1.2.2. 다중행 서브쿼리
-- 1.2.3. 다중열 서브쿼리
-- 1.2.4. 다중행 다중열 서브쿼리
-- 1.2.5. 상(호연)관 서브쿼리
-- 1.2.6. 스칼라 서브쿼리

-- 1.2.2. 다중행 서브쿼리
-- 송종기나 박나라가 속한 부서에 속한 직원들의 전체 정보를 출력하세요
SELECT DEPT_CODE FROM EMPLOYEE
WHERE EMP_NAME = '송중기'; -- D9

SELECT DEPT_CODE FROM EMPLOYEE
WHERE EMP_NAME = '박나라'; -- D5

SELECT * FROM EMPLOYEE
WHERE DEPT_CODE IN ('D9', 'D5');

-- 서브쿼리를 사용하는 경우
SELECT * FROM EMPLOYEE
    WHERE DEPT_CODE IN (
    SELECT DEPT_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME IN ('송종기', '박나라'));

-- @실습문제1
-- 차태연, 전지연 사원의 급여등급과 같은 사원의 직급명, 사원명을 출력하세요.
SELECT JOB_NAME, EMP_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE SAL_LEVEL IN (SELECT SAL_LEVEL FROM EMPLOYEE WHERE EMP_NAME IN ('차태연', '전지연'));

-- @실습문제2
-- Asia1지역에 근무하는 직원의 정보(부서코드, 사원명)를 출력하세요.
SELECT DEPT_CODE, EMP_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE LOCAL_NAME = UPPER('Asia1');

-- 서브쿼리를 쓰는 경우
SELECT DEPT_CODE, EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE IN (
SELECT DEPT_CODE FROM DEPARTMENT 
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE LOCAL_NAME = UPPER('Asia1'));

-- 서브쿼리 안에 서브쿼리 쓰는 경우
SELECT DEPT_CODE, EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE IN (
SELECT DEPT_CODE FROM DEPARTMENT 
WHERE LOCATION_ID = (
SELECT LOCAL_CODE 
FROM LOCATION
WHERE LOCAL_NAME = UPPER('Asia1')));

-- 1.2.5. 상(호연)관 서브쿼리
-- - 메인 쿼리의 값이 서브쿼리에 사용되는 것
-- - 메인쿼리의 값을 서브쿼리에 주고 서브쿼리를 수행한 다음 그 결과를 다시 메인 쿼리로 반환해서 수행하는 것
-- - 상호연관 관계를 가지고 실행하는 쿼리이다.
SELECT * FROM EMPLOYEE WHERE EMP_ID = '2000';

SELECT * FROM EMPLOYEE WHERE 1=0;
SELECT * FROM EMPLOYEE WHERE 1=1;

SELECT * FROM EMPLOYEE WHERE EXISTS (SELECT 1 FROM EMPLOYEE);   -- 뭐라도 나오면 참

SELECT * FROM EMPLOYEE E WHERE EXISTS (SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = E.EMP_ID);  -- 안 나오면 거짓

-- SELECT 실행순서
-- FROM - WHERE - SELECT
--     GROUP BY - HAVING
--                      ORDER BY

-- 실습예제1
-- 부하직원이 한 명이라도 있는 직원의 정보를 출력하시오
SELECT * FROM EMPLOYEE;
-- EMP_ID가 200인 경우 부하직원이 있나?
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '200'; -- O
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '201'; -- O
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '202'; -- X
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '203'; -- X
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '204'; -- O
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '205'; -- X
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '206'; -- X
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '207'; -- O
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '208'; -- X
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '209'; -- X
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '210'; -- X
SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '211'; -- O

SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = '100'; -- O

SELECT * FROM EMPLOYEE WHERE EMP_ID IN ('200', '201', '204', '207', '211', '214', '100');

SELECT * FROM EMPLOYEE E WHERE EXISTS (SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = E.EMP_ID); 

SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = EMP_ID;

-- @실습문제1
-- 가장 많은 급여를 받는 직원을 출력하시오.
SELECT MAX(SALARY) FROM EMPLOYEE; -- 8000000
SELECT * FROM EMPLOYEE WHERE SALARY = 8000000;
SELECT * FROM EMPLOYEE WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE);
-- 단일행 서브쿼리로 구한 것임
-- 상관쿼리로는 어떻게?
SELECT 1 FROM EMPLOYEE WHERE SALARY > '8000000'; -- 0 
SELECT 1 FROM EMPLOYEE WHERE SALARY > '6000000'; -- 1
SELECT 1 FROM EMPLOYEE WHERE SALARY > '3700000'; -- 4
SELECT 1 FROM EMPLOYEE WHERE SALARY > '2800000'; -- 9
SELECT 1 FROM EMPLOYEE WHERE SALARY > '3400000'; -- 7
SELECT 1 FROM EMPLOYEE WHERE SALARY > '3900000'; -- 2
SELECT 1 FROM EMPLOYEE WHERE SALARY > '1800000'; -- 20
SELECT 1 FROM EMPLOYEE WHERE SALARY > '2200000';
SELECT 1 FROM EMPLOYEE WHERE SALARY > '2500000';
SELECT 1 FROM EMPLOYEE WHERE SALARY > '3500000';
SELECT 1 FROM EMPLOYEE WHERE SALARY > '2000000';
SELECT 1 FROM EMPLOYEE WHERE SALARY > '2550000';
SELECT 1 FROM EMPLOYEE WHERE SALARY > '2320000';
SELECT 1 FROM EMPLOYEE WHERE SALARY > '1380000';

SELECT * FROM EMPLOYEE E WHERE NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE SALARY > E.SALARY);

-- @실습문제2
-- 가장 적은 급여를 받는 직원을 출력하시오.
SELECT * FROM EMPLOYEE WHERE SALARY = (SELECT MIN(SALARY) FROM EMPLOYEE);
SELECT * FROM EMPLOYEE E WHERE NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE SALARY < E.SALARY);

-- @실습문제3
-- 심봉선과 같은 부서의 사원의 부서코드, 사원명, 월평균급여를 조회하시오.
SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '심봉선'; -- D5, 1번

SELECT AVG(SALARY) FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING DEPT_CODE = 'D5'; -- D5부서의 월평균급여, 2번

SELECT DEPT_CODE, EMP_NAME, (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING DEPT_CODE = 'D5') "월평균급여"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'; -- 메인 쿼리 SELECT 뒤에 월평균 급여 서브쿼리 사용, 3번

-- D5를 구하는 부부을 모두 서브쿼리로 변경, 4번
SELECT DEPT_CODE, EMP_NAME, (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '심봉선')) "월평균급여"
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '심봉선');

-- 1. 심봉선과 같은 부서코드를 가진 행만 출력
-- - 검증쿼리
SELECT 1 FROM EMPLOYEE WHERE DEPT_CODE = 'D1' AND EMP_NAME = '심봉선'; -- X
SELECT 1 FROM EMPLOYEE WHERE DEPT_CODE = 'D2' AND EMP_NAME = '심봉선'; -- X
SELECT 1 FROM EMPLOYEE WHERE DEPT_CODE = 'D3' AND EMP_NAME = '심봉선'; -- X
SELECT 1 FROM EMPLOYEE WHERE DEPT_CODE = 'D4' AND EMP_NAME = '심봉선'; -- X
SELECT 1 FROM EMPLOYEE WHERE DEPT_CODE = 'D5' AND EMP_NAME = '심봉선'; -- O
SELECT 1 FROM EMPLOYEE WHERE DEPT_CODE = 'D6' AND EMP_NAME = '심봉선'; -- X
SELECT 1 FROM EMPLOYEE WHERE DEPT_CODE = 'D7' AND EMP_NAME = '심봉선'; -- X

-- - 메인쿼리
SELECT DEPT_CODE, EMP_NAME
FROM EMPLOYEE E 
WHERE EXISTS (SELECT 1 FROM EMPLOYEE 
WHERE DEPT_CODE = E.DEPT_CODE AND EMP_NAME = '심봉선');

-- 2. 월평균급여 출력
-- - 메인쿼리에 월평균급여 추가
SELECT DEPT_CODE, EMP_NAME
, (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE 
WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '심봉선')) "월평균급여"
FROM EMPLOYEE E 
WHERE EXISTS (SELECT 1 FROM EMPLOYEE 
WHERE DEPT_CODE = E.DEPT_CODE AND EMP_NAME = '심봉선');

-- @실습문제4
-- 직급이 J1, J2, J3이 아닌 사원중에서 자신의 부서별 평균급여보다 많은 급여를 받는
-- 직원의 부서코드, 사원명, 급여, (부서별 급여평균) 정보를 출력하시오.
SELECT DEPT_CODE, EMP_NAME, SALARY, ;














































































-- 1.2.6 스칼라 서브쿼리
















