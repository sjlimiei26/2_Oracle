/* 
    * 서브쿼리 : 하나의 쿼리문 내에서 사용되는 또 다른 쿼리문
                메인 쿼리문의 조건이나 결과를 위해 먼저 실행되어 값을 제공 (보조 역할)
*/

-- 노옹철 직원과 같은 부서에 속한 직원 정보를 조회

-- 1) 노옹철 직원의 부서코드를 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';         --> D9

-- 2) 부서코드가 D9인 직원들의 정보 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- * 1), 2) 하나로 합쳐보기! --> 서브쿼리 적용!
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = (
    SELECT DEPT_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME = '노옹철'
);

-- 전체 직원의 평균 급여보다 더 많은 급여를 받는 직원 정보를 조회

-- 1) 전체 직원의 평균 급여 조회
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE;          --> 3047663

-- 2) 평균 급여보다 더 많이 받는 직원 조회
SELECT * 
FROM EMPLOYEE
WHERE SALARY > 3047663;

-- * 1), 2) 쿼리문을 하나로 합치기!!
SELECT * 
FROM EMPLOYEE
WHERE SALARY > (
    SELECT ROUND(AVG(SALARY))
    FROM EMPLOYEE
);
-------------------------------------------------------------------------------
/*
    * 서브쿼리의 종류 *
     : 서브쿼리를 수행한 결과의 "행"과 "열" 수에 따라 분류
     
    - 단일행 서브쿼리  : 수행 결과가 오로지 1개일 때 (1행 1열)
    - 다중행 서브쿼리  : 수행 결과가 여러 행일 때 (N행 1열)
    - 다중열 서브쿼리  : 수행 결과가 한 행이고, 여러 개의 컬럼일 때 (1행 N열)
    - 다중행 다중열 서브쿼리 : 수행 결과가 여러 행이고, 여러 컬럼일 때 (N행 M열)
    
    => 종류에 따라 서브쿼리 앞에 사용되는 연산자가 달라질 수 있음!
*/

/*
    * 단일행 서브쿼리 => 비교연산자 사용 가능! ( = != > < >= <= ..)
*/

-- 최저 급여를 받는 직원의 이름, 급여, 입사일 조회
-- 1) 최저 급여 조회
SELECT MIN(SALARY)
FROM EMPLOYEE;

-- 2) 최저 급여를 받는 직원 정보 조회
SELECT *
FROM EMPLOYEE
WHERE SALARY = 1380000;

-- 서브쿼리 적용 **
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (
    SELECT MIN(SALARY)
    FROM EMPLOYEE
);

-- 노옹철 직원보다 급여를 더 많이 받는 직원 정보 조회(이름, 부서코드, 급여)
-- 1) 노옹철 직원의 급여
SELECT SALARY
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';

SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (
    SELECT SALARY
    FROM EMPLOYEE
    WHERE EMP_NAME = '노옹철'
);

-- => 부서코드가 아닌 부서명으로 조회
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE SALARY > (
    SELECT SALARY
    FROM EMPLOYEE
    WHERE EMP_NAME = '노옹철'
);

-- 부서 별 총 급여 기준으로 가장 큰 부서의 부서코드, 총 급여 조회
-- 1) 부서 별 총 급여가 가장 큰 부서
-- 1-1) 부서 별 급여 합
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 1-2) 급여 합들 중 가장 큰 값
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 2) 급여 합이 가장 큰 값인 부서의 부서코드, 급여합을 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = 17700000;

SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (
    SELECT MAX(SUM(SALARY))
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
);


-- 전지연 직원과 같은 부서인 직원들의 직원번호, 직원명, 연락처, 입사일, 부서명을 조회
-- (단, 조회 결과에서 전지연 직원 정보는 제외!)

-- 1) 전지연 직원의 부서코드 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '전지연';

-- 2) 1) 쿼리문을 서브쿼리로 사용하여 같은 부서의 직원 정보 조회
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME != '전지연'
    AND DEPT_CODE = (
        SELECT DEPT_CODE
        FROM EMPLOYEE
        WHERE EMP_NAME = '전지연'
    );


-- 3) 부서명으로 조회 --> 조인
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE EMP_NAME != '전지연'
    AND DEPT_CODE = (
        SELECT DEPT_CODE
        FROM EMPLOYEE
        WHERE EMP_NAME = '전지연'
    );
--==============================================================================
/*
    * 다중행 서브쿼리 : 서브쿼리의 결과가 여러 행인 경우 (N행 1열)
    
    IN (서브쿼리)   : 여러 개의 결과값 중에서 하나라도 일치하는 값이 있다면 결과로 표시
    => 비교대상 = 결과값1 OR 비교대상 = 결과값2 OR ...
    
    > ANY (서브쿼리)    : 여러 개의 결과값 중에서 하나라도 크면 결과로 표시
    < ANY (서브쿼리)    : 여러 개의 결과값 중에서 하나라도 작으면 결과로 표시
    => 비교대상 > 결과값1 OR 비교대상 > 결과값2 OR ...
    
    > ALL (서브쿼리)    : 모든 결과값보다 크면 결과로 표시
    < ALL (서브쿼리)    : 모든 결과값보다 작으면 결과로 표시
    => 비교대상 > 결과값1 AND 비교대상 > 결과값2 AND ...
*/
-- 유재식 직원 또는 윤은해 직원과 같은 직급인 직원들의 정보 조회 (직원번호, 이름, 직급코드, 급여)

-- 1) 유재식 직원 또는 윤은해 직원의 직급 코드를 조회
SELECT JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME IN ('유재식', '윤은해');
--> J3, J7

-- 2) 직급 코드가 J3 또는 J7인 직원 정보 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN ('J3', 'J7');
--> 7명

-- * 서브쿼리를 적용하여 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (
    SELECT JOB_CODE
    FROM EMPLOYEE
    WHERE EMP_NAME IN ('유재식', '윤은해')
);

-- 대리 직급인 직원들 중 과장 직급인 직원의 최소 급여보다 많이 받는 직원 조회 (직원번호, 이름, 직급명, 급여)

-- 1) 과장 직급인 직원의 최소 급여 조회
SELECT SALARY
FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장';

SELECT MIN(SALARY)
FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장';

-- 2) 대리 직급인 직원들 중 (376만원, 220만원, 250만원) 보다 많이 받는 직원 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
    JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리'
    AND SALARY > ANY (3760000, 2200000, 2500000);

-- * 서브쿼리 적용 *
-- * 다중행 서브쿼리 *
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
    JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리'
    AND SALARY > ANY (
            SELECT SALARY
            FROM EMPLOYEE
                JOIN JOB USING(JOB_CODE)
            WHERE JOB_NAME = '과장'
    );

-- * 단일행 서브쿼리 *
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
    JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리'
    AND SALARY > (
        SELECT MIN(SALARY)
        FROM EMPLOYEE
            JOIN JOB USING(JOB_CODE)
        WHERE JOB_NAME = '과장'
    );
--==============================================================================
/*
    * 다중열 서브쿼리 : 서브쿼리의 결과가 한 행이고, 여러 개의 컬럼(열)인 경우
    
    (컬럼1, 컬럼2, ..) = ( 서브쿼리 )
*/
-- 하이유 직원과 같은 부서, 같은 직급에 해당하는 직원 정보 조회 (이름, 부서코드, 직급코드, 급여)
-- 1) 하이유 직원의 부서코드, 직급코드 조회
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '하이유';
--> D5, J5

--- * 단일행 서브쿼리  => 컬럼(열) 1개씩 조회하도록
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
    AND JOB_CODE = 'J5';

SELECT EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = ( SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '하이유' )
    AND JOB_CODE = ( SELECT JOB_CODE FROM EMPLOYEE WHERE EMP_NAME = '하이유' );

-- * 다중열 서브쿼리
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = ( SELECT DEPT_CODE, JOB_CODE
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '하이유' );

-- 박나라 직원과 같은 직급이고, 같은 사수를 가지고 있는 직원의 정보 조회 (이름, 직급코드, 사수번호)

-- 1) 박나라 직원의 직급코드, 사수번호 조회
SELECT JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE EMP_NAME = '박나라';
--> J7, 207

-- 2) 해당 직급코드와 사수번호가 동일한 직원 조회
SELECT EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) = ( SELECT JOB_CODE, MANAGER_ID
                                 FROM EMPLOYEE
                                 WHERE EMP_NAME = '박나라' )
    AND EMP_NAME != '박나라';
--==============================================================================
/*
    * 다중행 다중열 서브쿼리 : 서브쿼리의 결과가 여러 행, 여러 열인 경우 (N행 M열)
*/

-- 각 직급별 최소 급여를 받는 직원 정보 조회
-- 1) 직급별 최소 급여 조회
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;
/*
J1	8000000
J2	3700000
J4	1550000
J3	3400000
J7	1380000
J5	2200000
J6	2000000
*/
-- 2) 각 직급별로 최소 급여를 받는 직원 조회 (직원번호, 이름, 직급코드, 급여)
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE = 'J1' AND SALARY = 8000000
    OR JOB_CODE = 'J2' AND SALARY = 3700000;
    -- OR ...

-- * 서브 쿼리 적용 *
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (
    SELECT JOB_CODE, MIN(SALARY)
    FROM EMPLOYEE
    GROUP BY JOB_CODE
);

-- 각 직급별 최고 급여를 받은 직원 정보 조회 ( 직원번호, 이름, 직급코드, 급여 )
-- 1) 직급별 최고 급여 조회
SELECT JOB_CODE, MAX(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

-- 2) 해당 직원 정보 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (
    SELECT JOB_CODE, MAX(SALARY)
    FROM EMPLOYEE
    GROUP BY JOB_CODE
);
--==============================================================================
/*
    * 인라인뷰 : 서브쿼리를 FROM절에 작성하여 마치 테이블처럼 활용
                ( 서브쿼리의 결과를 임시 테이블처럼 활용 )
*/
-- 직원들의 직원번호, 이름, 보너스 포함 연봉, 부서코드를 조회
--     * 보너스 포함 연봉이 3000만원 이상인 직원들만 조회
--     * 보너스 포함 연봉 내림차순 정렬

SELECT EMP_ID, EMP_NAME, (SALARY + (SALARY*NVL(BONUS, 0))) * 12 "보너스 포함 연봉", DEPT_CODE
FROM EMPLOYEE
-- WHERE (SALARY + (SALARY*NVL(BONUS, 0))) * 12 >= 30000000
ORDER BY 3 DESC;

-- * 인라인뷰 적용
SELECT EMP_ID, EMP_NAME, "보너스 포함 연봉", 부서코드
FROM (
    SELECT EMP_ID, EMP_NAME, (SALARY + (SALARY*NVL(BONUS, 0))) * 12 "보너스 포함 연봉", DEPT_CODE 부서코드
    FROM EMPLOYEE
    ORDER BY 3 DESC
)
WHERE "보너스 포함 연봉" >= 30000000;


-- * TOP-N 분석 *
--  : 상위 N개를 조회
--  - ROWNUM : 조회된 행에 대하여 순서대로 1부터 순번을 부여해주는 가상 컬럼
SELECT EMP_ID, EMP_NAME, "보너스 포함 연봉", 부서코드
FROM (
    SELECT EMP_ID, EMP_NAME, (SALARY + (SALARY*NVL(BONUS, 0))) * 12 "보너스 포함 연봉", DEPT_CODE 부서코드
    FROM EMPLOYEE
    ORDER BY 3 DESC
)
WHERE "보너스 포함 연봉" >= 30000000
    AND ROWNUM <= 5;            -- 상위 5개(명)


-- 가장 최근에 입사한 직원 5명을 조회 ( 직원번호, 이름, 입사일 )
-- 1) 입사일 내림차순 정렬하여 조회 (인라인뷰)
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
ORDER BY HIRE_DATE DESC;


-- 2) 상위 5개만 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM (
    SELECT EMP_ID, EMP_NAME, HIRE_DATE
    FROM EMPLOYEE
    ORDER BY HIRE_DATE DESC
)
WHERE ROWNUM <= 5;
-------------------------------------------------------------------------------
/*
    * 순서를 매기는 함수 (윈도우 함수, WINDOW FUNCTION)
    
    - RANK() OVER(정렬기준)         : 동일한 순위 이후의 등수를 동일한 순위의 개수만큼 건너뛰고 순위 계산
        1
        1
        1
        4
        
    - DENSE_RANK() OVER(정렬기준)   : 동일한 순위가 있더라도 그 다음 등수는 +1 해서 순위 계산
        1
        1
        1
        2
    
    => SELECT 절에서만 사용 가능
*/

-- 급여가 높은 순서대로 순위를 매겨서 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "순위"
FROM EMPLOYEE;

SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) "순위"
FROM EMPLOYEE;

--> 5위까지만 조회 (상위 5명)
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "순위"
FROM EMPLOYEE;
-- WHERE 순위 <= 5; --> WHERE절에서 사용 불가!!

SELECT *
FROM (
    SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "순위"
    FROM EMPLOYEE
)
WHERE 순위 <= 5;

-- 3위 ~ 5위까지 조회
SELECT *
FROM (
    SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "순위"
    FROM EMPLOYEE
)
WHERE 순위 BETWEEN 3 AND 5;
--==============================================================================
-- [1] ROWNUM을 활용하여 급여가 가장 높은 5명을 조회하려고 했으나, 제대로 조회가 되지 않았다.
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 5
ORDER BY SALARY DESC;
/*
선동일	8000000
송종기	6000000
정중하	3900000
대북혼	3760000
노옹철	3700000
*/

-- * 문제점: 정렬되기 전에 5명이 추려짐
-- * 해결: 정렬을 먼저 한 후에 5명을 추려내야 함!
SELECT ROWNUM, E.*
FROM (
    SELECT EMP_NAME, SALARY
    FROM EMPLOYEE
    ORDER BY SALARY DESC
) E
WHERE ROWNUM <= 5;

-- [2] 부서별 평균 급여가 270만원을 초과하는 부서에 해당하는 부서코드, 부서별 총 급여합, 부서별 평균급여, 부서별 직원 수를 조회
--     제대로 조회가 되지 않았다.
SELECT DEPT_CODE, SUM(SALARY) "총합", FLOOR(AVG(SALARY)) "평균급여", COUNT(*) "직원 수"
FROM EMPLOYEE
WHERE SALARY > 2700000
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- * 문제점: 부서별 평균 급여가 아닌 각 직원의 급여를 기준으로 조건을 제시함!
-- * 해결:
SELECT DEPT_CODE, SUM(SALARY) "총합", FLOOR(AVG(SALARY)) "평균급여", COUNT(*) "직원 수"
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING FLOOR(AVG(SALARY)) > 2700000
ORDER BY DEPT_CODE;

-- * 인라인뷰 적용
SELECT *
FROM ( 
    SELECT DEPT_CODE, SUM(SALARY) "총합", FLOOR(AVG(SALARY)) "평균급여", COUNT(*) "직원 수"
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
)
WHERE 평균급여 > 2700000;











