/*
    * GROUP BY 절 : 그룹 기준을 제시할 수 있는 부분
*/

-- * 전체 직원의 급여 총 합 조회
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- * 부서별 급여 총 합 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- * 부서별 직원 수 조회
SELECT DEPT_CODE, COUNT(*) 
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- * 부서코드가 D6, D9, D1인 각 부서별 급여 총합, 직원 수 조회
SELECT DEPT_CODE, SUM(SALARY), COUNT(*)     -- 4
FROM EMPLOYEE                               -- 1
WHERE DEPT_CODE IN ('D6', 'D9', 'D1')       -- 2
GROUP BY DEPT_CODE;                         -- 3

-- * 직급 별 총 직원수, 보너스를 받은 직원수, 급여 총합, 평균 급여, 최저 급여, 최고 급여 조회 (직급코드 오름차순 정렬)
SELECT JOB_CODE, COUNT(*) "총 직원수", COUNT(BONUS) "보너스를 받는 직원수"
        , SUM(SALARY) "급여 총합", FLOOR(AVG(SALARY)) "평균 급여", MIN(SALARY) "최저급여", MAX(SALARY) "최고급여"
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- * 부서 내 직급별로 직원 수, 급여 총합 조회
SELECT DEPT_CODE, JOB_CODE, COUNT(*) "직원 수", SUM(SALARY) "급여 총합"
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE, JOB_CODE;
--------------------------------------------------------------------------------
/*
    * HAVING : 그룹에 대한 조건을 제시할 때 사용하는 부분
*/
-- 각 부서별 평균 급여가 300만원 이상인 부서만 조회

-- * 부서별 평균 급여 조회
SELECT DEPT_CODE, FLOOR(AVG(SALARY)) "평균 급여"
FROM EMPLOYEE
GROUP BY DEPT_CODE;


SELECT DEPT_CODE, FLOOR(AVG(SALARY)) "평균 급여"
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING FLOOR(AVG(SALARY)) >= 3000000;       
-- => 전 직원을 부서별로 묶어서 평균 급여가 300만원 이상인 데이터를 추려내서 조회

SELECT DEPT_CODE, FLOOR(AVG(SALARY)) "평균 급여"
FROM EMPLOYEE
WHERE SALARY >= 3000000         -- 직원의 급여가 300만원 이상인 데이터만 추려내서 조회
GROUP BY DEPT_CODE;

-- 직급 별 급여 총합 조회 (급여 총합이 1000만원 이상인 직급만 조회)
SELECT JOB_CODE, SUM(SALARY) "급여 총합"
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000;

-- 보너스를 받는 직원이 없는 부서 정보 조회
SELECT DEPT_CODE, COUNT(BONUS)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;




