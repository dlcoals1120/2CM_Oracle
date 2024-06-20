-- 6일차 서브쿼리

-- -- 1.2.5. 상(호연)관 서브쿼리
-- - 메인 쿼리의 값이 서브쿼리에 사용되는 것
-- - 메인쿼리의 값을 서브쿼리에 주고 서브쿼리를 수행한 다음 그 결과를 다시 메인 쿼리로 반환해서 수행하는 것
-- - 상호연관 관계를 가지고 실행하는 쿼리이다.

SELECT * FROM EMPLOYEE E WHERE NOT EXISTS (SELECT 1 FROM EMPLOYEE WHERE SALARY > E.SALARY);

-- @실습문제4
-- 직급이 J1, J2, J3이 아닌 사원중에서 자신의 부서별 평균급여보다 많은 급여를 받는
-- 직원의 부서코드, 사원명, 급여, (부서별 급여평균) 정보를 출력하시오.
SELECT DEPT_CODE, EMP_NAME, SALARY, (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE)
FROM EMPLOYEE E
WHERE JOB_CODE NOT IN ('J1', 'J2', 'J3') 
AND SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE);

SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = 'D6';

SELECT DEPT_CODE, EMP_NAME, SALARY, SALARY
FROM EMPLOYEE
WHERE JOB_CODE NOT IN ('J1', 'J2', 'J3') AND DEPT_CODE = 'D5' 
AND SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = 'D5');

SELECT DEPT_CODE, EMP_NAME, SALARY, SALARY
FROM EMPLOYEE
WHERE JOB_CODE NOT IN ('J1', 'J2', 'J3') AND DEPT_CODE = 'D1' 
AND SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = 'D1');

SELECT DEPT_CODE, EMP_NAME, SALARY, SALARY
FROM EMPLOYEE
WHERE JOB_CODE NOT IN ('J1', 'J2', 'J3') AND DEPT_CODE = 'D2' 
AND SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = 'D2');

SELECT DEPT_CODE, EMP_NAME, SALARY, SALARY
FROM EMPLOYEE
WHERE JOB_CODE NOT IN ('J1', 'J2', 'J3') AND DEPT_CODE = 'D8' 
AND SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = 'D8');

-- 1.2.6 스칼라 서브쿼리
-- 결과값니 1개인 상관서브쿼이, SELECT문 뒤에 사용됨.
-- SQL애서 단일값을 스칼라값이라고 함.

-- @실습문제1
-- 사원명, 부서명, 부서의 평균임금(자신이 속한 부서의 평균임금)을 스칼라 서브쿼리를 이용해서
-- 출력하세요.
SELECT EMP_NAME, DEPT_TITLE, (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE) "부서 평균임금"
FROM EMPLOYEE E
LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

SELECT AVG(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = 'D2';

-- @실습문제2
-- 모든 직원의 사번, 이름, 소속부서를 조회한 후 부서명을 오름차순으로 정렬하시오.
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
-- 스칼라
SELECT EMP_ID, EMP_NAME, (SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_ID = DEPT_CODE) "DEPT_TITLE"
FROM EMPLOYEE E;

-- @실습문제3
-- 직급이 J1이 아닌 사원 중에서 자신의 부서 평균급여보다 적은 급여를 받는 사원출력하시오
-- 부서코드, 사원명, 급여, 부서의 급여평균을 출력하시오.
SELECT DEPT_CODE, EMP_NAME, SALARY
, (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE) "AVG(SALARY)"
FROM EMPLOYEE E
WHERE JOB_CODE != 'J1'
AND SALARY < (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = E.DEPT_CODE);

-- @실습문제4
-- 자신이 속한 직급의 평균급여보다 많이 받는 직원의 이름, 직급, 급여를 출력하시오.
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE SALARY > (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE WHERE JOB_CODE = E.JOB_CODE);









