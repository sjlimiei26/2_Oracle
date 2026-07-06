/*
    * 함수 (FUNCTION) : 전달된 값(컬럼값)을 실행한 결과를 반환
    
    - 단일 행 함수  : N개의 값을 읽어서 N개의 결과값으로 반환
      => 행마다 함수의 실행한 결과를 반환
    - 그룹 함수    : N개의 값을 읽어서 1개의 결과값으로 반환
      => 그룹을 지어 그룹 별로 함수의 결과를 반환
      
    => 함수식을 사용할 수 있는 위치: SELECT절, WHERE절, ORDER BY절, GROUP BY절, HAVING절
    
    => SELECT절에 단일 행 함수와 그룹 함수를 함께 사용할 수 없음!!
*/
-- ====================== 단일 행 함수 ================================
/*
    * 문자 타입의 데이터 처리 함수 *
    
    - 문자 타입 : CHAR, VARCHAR2
    
    * LENGTH(값) : 값의 길이를 반환 (글자수)
    * LENGTHB(값) : 값의 바이트수를 반환
    
    => 영문자, 숫자, 특수문자 글자당 1BYTE, 한글은 3BYTE
*/
-- 오라클 이라는 단어의 글자수, 바이트 수를 확인
SELECT LENGTH('오라클') 글자수, LENGTHB('오라클') 바이트수
FROM DUAL;

SELECT LENGTH('ORACLE') 글자수, LENGTHB('ORACLE') 바이트수
FROM DUAL;

-- 직원명, 직원명(글자수), 직원명(바이트수),
--      이메일, 이메일(글자수), 이메일(바이트수) 조회
SELECT EMP_NAME, LENGTH(EMP_NAME) "직원명(글자수)", LENGTHB(EMP_NAME) "직원명(바이트수)"
            , EMAIL, LENGTH(EMAIL) "이메일(글자수)", LENGTHB(EMAIL) "이메일(바이트수)"
FROM EMPLOYEE;
-------------------------------------------------------------------------------
/*
    * INSTR : 문자열로부터 특정 문자의 시작 위치를 반환
    
    INSTR(문자열, '특정문자'[, 찾을 위치의 시작값, 순번]) => 결과는 숫자 타입
*/

SELECT INSTR('AABAACAABBAA', 'B') FROM DUAL; -- 앞에서부터 첫번째 B의 위치: 3
SELECT INSTR('AABAACAABBAA', 'B', 1) FROM DUAL; -- 찾을 위치의 시작값을 1로 지정 => 결과는 위와 동일
SELECT INSTR('AABAACAABBAA', 'B', -1) FROM DUAL; -- 시작값을 음수로 지정하면 뒤에서부터 찾음!
SELECT INSTR('AABAACAABBAA', 'B', 1, 2) FROM DUAL; -- 앞에서부터 두번째로 찾은 위치
SELECT INSTR('AABAACAABBAA', 'B', -1, 2) FROM DUAL;

-- 직원 정보 중 이메일의 _의 첫번째 위치, @의 첫번째 위치 조회 (이메일, _의 위치, @의 위치)
SELECT EMAIL, INSTR(EMAIL, '_', 1, 1) "_의 위치", INSTR(EMAIL, '@') "@의 위치"
FROM EMPLOYEE;
-------------------------------------------------------------------------------
/*
    * SUBSTR : 문자열에서 특정 문자열을 추출해서 반환 => 결과는 문자 타입
    
    SUBSTR(문자열, 시작위치[, 길이])
    => 길이를 지정하지 않으면 문자열 끝까지 추출함!
*/

SELECT SUBSTR('ORACLE SQL DEVELOPER', 10) FROM DUAL;

-- SQL 부분만 추출
SELECT SUBSTR('ORACLE SQL DEVELOPER', 8, 3) FROM DUAL;

SELECT SUBSTR('ORACLE SQL DEVELOPER', -3) FROM DUAL; 
-- => 끝에서 3번째 위치부터 문자열 끝까지 추출!

-- 직원들의 이름, 주민번호 조회
SELECT EMP_NAME, EMP_NO
FROM EMPLOYEE;

-- 여직원 정보만 조회 (이름, 주민번호)
SELECT EMP_NAME, EMP_NO
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('2', '4');

-- 남직원 정보만 조회 (이름, 주민번호)
SELECT EMP_NAME, EMP_NO
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1', '3')
ORDER BY EMP_NAME ASC; -- 이름 가나다 순으로 정렬


-- 직원 정보를 조회 (이름, 이메일, 아이디)
-- * 함수를 중첩해서 사용 *
--   [1] 이메일에서 @ 위치를 찾기 => INSTR
--   [2] 이메일에서 첫번째 위치부터 @ 위치까지만 추출 => SUBSTR
SELECT EMP_NAME, EMAIL, INSTR(EMAIL, '@') "@ 위치"
FROM EMPLOYEE;

SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1) "ID"
FROM EMPLOYEE;
-------------------------------------------------------------------------------
/*
    * LPAD / RPAD : 문자열을 조회할 때 통일감있게 조회하고자 할 때 사용
                    문자열에 덧붙이고자 하는 문자를 왼쪽 또는 오른쪽에 붙여서 최종 길이만큼 문자열을 반환
                    => 결과는 문자 타입
                    
      LPAD(문자열, 최종길이[, 덧붙일문자]) => 왼쪽에 덧붙일문자를 채움
      RPAD(문자열, 최종길이[, 덧붙일문자]) => 오른쪽에 덧붙일문자를 채움
      => 덧붙일문자가 생략될 경우 공백으로 채움!
*/
SELECT EMP_NAME, LPAD(EMP_NAME, 20) "이름"
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMP_NAME, 20) "이름"
FROM EMPLOYEE;

-- 이메일
SELECT EMAIL, LPAD(EMAIL, 20) "이메일"
FROM EMPLOYEE;


-- 주민번호 뒷자리를 숨겨서 조회
SELECT RPAD('050706-3', 14, '*') FROM DUAL;

-- 직원 정보 중 주민번호 뒷자리를 *로 표시하여 조회 (이름, 주민번호)
-- [1] 주민번호에서 8자리를 추출 (XXXXXX-X)
-- [2] 나머지 길이만큼은 *로 채움
SELECT EMP_NAME, SUBSTR(EMP_NO, 1, 8) 
FROM EMPLOYEE;

SELECT EMP_NAME, SUBSTR(EMP_NO, 1, 8) || '******'
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*') "EMP_NO"
FROM EMPLOYEE;
--------------------------------------------------------------------------------
/*
    * LTRIM / RTRIM : 문자열에서 특정 문자를 제거한 후 나머지를 반환
                      => 결과는 문자 타입
                      
      LTRIM(문자열[, 제거하고자하는문자들]) => 왼쪽에서 제거
      RTRIM(문자열[, 제거하고자하는문자들]) => 오른쪽에서 제거
      => 제거할문자 생략 시 공백을 제거함!
*/

SELECT LTRIM('      H I') FROM DUAL;  --> 왼쪽 공백들이 모두 제거!
SELECT RTRIM('      H I      ') FROM DUAL;  --> 오른쪽 공백들이 모두 제거!

SELECT LTRIM('123123H123', '123') FROM DUAL;
SELECT LTRIM('123123H123', '321') FROM DUAL;

SELECT RTRIM('123123H123', '321') FROM DUAL;
SELECT RTRIM('123123H123', '123') FROM DUAL;
SELECT RTRIM('123123H123', '213') FROM DUAL;

/*
    * TRIM : 문자열 앞/뒤/양쪽에 있는 지정한 문자들을 제거한 후 반환 
             => 결과는 문자타입
             
      TRIM([LEADING 또는 TRAILING 또는 BOTH] [제거할문자 FROM] 문자열)
      => 제거할문자 생략 시 공백 제거
      => 위치 옵션 생략 시 양쪽에서 제거
*/
SELECT TRIM('      H I      ') "값" FROM DUAL;
SELECT TRIM('L' FROM 'LLLLLHLLLLLL') FROM DUAL;

SELECT TRIM(LEADING 'L' FROM 'LLLLLHLLLLLL') FROM DUAL;  --> LTRIM 과 유사함!
SELECT TRIM(TRAILING 'L' FROM 'LLLLLHLLLLLL') FROM DUAL; --> RTRIM 과 유사함!
SELECT TRIM(BOTH 'L' FROM 'LLLLLHLLLLLL') FROM DUAL;
--------------------------------------------------------------------------------
/*
    * LOWER / UPPER / INITCAP
    
    LOWER(문자열)  : 알파벳을 모두 소문자로 변환 
    UPPER(문자열)  : 알파벳을 모두 대문자로 변환
    INITCAP(문자열): 공백(띄어쓰기)을 기준으로 첫 글자마다 대문자로 변경해서 반환
*/
-- No pain, no Gain.
SELECT LOWER('No pain, no Gain.') FROM DUAL;

SELECT UPPER('No pain, no Gain.') FROM DUAL;

SELECT INITCAP('No pain, no Gain.') FROM DUAL;
--------------------------------------------------------------------------------
/*
    * CONCAT : 문자열 두 개를 하나의 문자열로 합쳐서 반환
    
    CONCAT(문자열1, 문자열2)
*/
SELECT 'KH' || ' C 강의장' FROM DUAL;

SELECT CONCAT('KH', ' C 강의장') FROM DUAL;

-- 2층 KH C 강의장 
SELECT CONCAT('2층', CONCAT('KH', ' C 강의장')) FROM DUAL;

-- 직원 정보를 조회 ( * 출력 형식 : {직원번호}{직원명}님 ) --> 200선동일님
SELECT CONCAT(EMP_ID, EMP_NAME)
FROM EMPLOYEE;

SELECT CONCAT(CONCAT(EMP_ID, EMP_NAME), '님') 직원정보
FROM EMPLOYEE;
--------------------------------------------------------------------------------
/*
    * REPLACE : 문자열에서 특정 부분을 다른 값으로 교체하여 반환
    
    REPLACE(문자열, 특정부분(문자열), 교체할값(문자열)
*/
SELECT REPLACE('서울시 강남구 역삼동', '역삼동', '삼성동') FROM DUAL;

-- 직원들의 이메일에서 '@kh.or.kr' 부분을 '@gmail.com' 으로 변경하여 조회 (이메일, 변경된 이메일)
SELECT EMAIL, REPLACE(EMAIL, '@kh.or.kr', '@gmail.com') "변경된 이메일"
FROM EMPLOYEE;
--==============================================================================
/*
    * 숫자 타입의 데이터 처리 함수 *
*/
/*
    * ABS : 숫자의 절대값을 반환
    
    ABS(숫자)
*/
SELECT ABS(-10) FROM DUAL;
SELECT ABS(-12.34) FROM DUAL;

SELECT ABS(12.34) FROM DUAL;
----------------------------------------------
/*
    * MOD : 두 수를 나눈 나머지 값을 구해주는 함수
    
    MOD(숫자1, 숫자2) --> 숫자1 % 숫자2
*/
SELECT MOD(10, 3) FROM DUAL;

SELECT MOD(10.9, 3) FROM DUAL;
----------------------------------------------
/*
    * ROUND : 반올림한 결과를 반환
    
    ROUND(숫자[, 위치])
    => 위치 생략 시 소숫점 첫째자리에서 반올림
*/
SELECT ROUND(123.456) FROM DUAL;            -- 123
SELECT ROUND(123.456, 1) FROM DUAL;         -- 123.5
SELECT ROUND(123.456, 2) FROM DUAL;         -- 123.46

SELECT ROUND(123.456, -1) FROM DUAL;        -- 120. 일의 자리에서 반올림
SELECT ROUND(123.456, -2) FROM DUAL;        -- 100. 십의 자리에서 반올림
--------------------------------------------------------
/*
    * CEIL : 올림처리
    
    CEIL(숫자)
*/
SELECT CEIL(123.456) FROM DUAL;

/*
    * FLOOR : 버림처리
    
    FLOOR(숫자)
*/
SELECT FLOOR(123.456) FROM DUAL;

/*
    * TRUNC : 버림처리 (위치 지정 가능)
    
    TRUNC(숫자[, 위치])
*/
SELECT TRUNC(123.456) FROM DUAL;            -- 123
SELECT TRUNC(123.456, 1) FROM DUAL;         -- 123.4
SELECT TRUNC(123.456, -1) FROM DUAL;        -- 120
--========================================================================
/*
    * 날짜 타입의 데이터 처리 함수 *
*/

SELECT SYSDATE FROM DUAL; -- 시스템 기준 현재 날짜 시간 정보

/*
    * MONTHS_BETWEEN : 두 날짜의 개월 수를 반환
    
    MONTHS_BETWEEN(날짜1, 날짜2) : 날짜1 - 날짜2 => 개월 수
*/
-- * 직원의 근속 개월 수 조회 (이름, 입사일, 근속 개월 수)
--   437 -> 437 개월차
SELECT EMP_NAME, HIRE_DATE, CONCAT(CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)), '개월차') "근속 개월 수"
FROM EMPLOYEE;

-- * 공부 시작한 지 몇 개월차? '26/06/11'
SELECT CEIL(MONTHS_BETWEEN(SYSDATE, '26/06/11')) FROM DUAL;

-- * 수료까지 몇 개월 남았는지? '26/12/16'
SELECT FLOOR(MONTHS_BETWEEN('26/12/16', SYSDATE)) FROM DUAL;
----------------------------------------------------------------
/*
    * ADD_MONTHS : 특정 날짜에 N개월 수를 더해서 반환
    
    ADD_MONTHS(날짜, 더할 개월 수)
*/

-- * 현재 날짜 기준으로 3개월 후 조회
SELECT ADD_MONTHS(SYSDATE, 3) FROM DUAL;


-- * 직원들의 "수습 종료일" 조회 (이름, 입사일, 입사일+3개월)
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 3) "수습 종료일"
FROM EMPLOYEE;
--------------------------------------------------------------------
/*
    * NEXT_DAY : 특정 날짜 이후로 지정한 요일의 가장 가까운 날짜를 반환
    
    NEXT_DAY(날짜, 요일)
    => 요일 : 문자 또는 숫자
            1: 일, 2: 월, ... 7: 토
*/
-- 현재 날짜 기준으로 가장 가까운 금요일의 날짜 조회
SELECT SYSDATE, NEXT_DAY(SYSDATE, 6) FROM DUAL;

ALTER SESSION SET NLS_LANGUAGE = KOREAN;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금') FROM DUAL;

ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRI') FROM DUAL;
---------------------------------------------------------------
/*
    * LAST_DAY : 해당 월의 마지막 날짜를 구해주는 함수
    
    LAST_DAY(날짜)
*/
-- 이번 달의 마지막 날짜 조회
SELECT LAST_DAY(SYSDATE) FROM DUAL;

-- 직원 정보 조회 (이름, 입사일, 입사한 달의 마지막 날짜, 입사한 달의 근무일수)
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE) "입사한 달의 마지막 날짜"
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE) "입사한 달의 마지막 날짜"
        , LAST_DAY(HIRE_DATE) - HIRE_DATE + 1 "근무일수"
FROM EMPLOYEE;
-------------------------------------------------------------------------
/*
    * EXTRACT : 특정 날짜로부터 연도/월/일 값을 추출해서 반환
    
    EXTRACT(YEAR FROM 날짜) : 연도 추출
    EXTRACT(MONTH FROM 날짜) : 월 추출
    EXTRACT(DAY FROM 날짜)  : 일 추출
*/
-- * 현재 날짜를 기준으로 연도/월/일 추출
SELECT EXTRACT(YEAR FROM SYSDATE) "연도"
    ,   EXTRACT(MONTH FROM SYSDATE) "월"
    ,   EXTRACT(DAY FROM SYSDATE) "일"
FROM DUAL;

-- 직원 정보 조회 (이름, 입사년도, 입사월, 입사일) 정렬 오름차순 - 입사년도>입사월>입사일
SELECT EMP_NAME, EXTRACT(YEAR FROM HIRE_DATE) "입사년도"   
                , EXTRACT(MONTH FROM HIRE_DATE) "입사월"
                , EXTRACT(DAY FROM HIRE_DATE) "입사일"
FROM EMPLOYEE
-- ORDER BY EXTRACT(YEAR FROM HIRE_DATE), EXTRACT(MONTH FROM HIRE_DATE), EXTRACT(DAY FROM HIRE_DATE);
-- ORDER BY 입사년도, 입사월, 입사일;
ORDER BY 2, 3, 4;
--=============================================================================






