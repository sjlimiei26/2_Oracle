/*
    * PL/SQL : PROCEDURE LANGUAGE EXTENSION TO SQL
    
    - 오라클 자체에 내장되어 있는 절차적 언어
    - SQL(PL/SQL) 문장 내에 변수 정의, 조건문, 반복문 등을 지원
    
    [구조]
    
        [선언부]       : DECLARE 로 시작. 변수나 상수를 선언하고 초기화하는 부분. (생략 가능)
        실행부         : BEGIN 으로 시작. SQL문 또는 제어문(조건문, 반복문) 등의 로직을 작성하는 부분. (필수 항목!)
        [예외처리부]   : EXCEPTION 으로 시작. 실행 중 예외(오류) 발생 시 해결하기 위한 부분. (생략 가능)
*/

-- * 화면에 출력하기 위한 설정 (DBMS_OUTPUT) *
--   => 접속할 때마다, 새로운 워크시트 창을 열 때 실행해야 함!
SET SERVEROUTPUT ON;

-- * HELLO ORACLE 출력
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/
--> 자바의 System.out.println() 과 같은 역할!
--------------------------------------------------------------------------------
/*
    * 선언부 (DECLARE) *
      : 변수 또는 상수를 선언하는 부분 (선언과 동시에 초기화도 가능)
*/

/*
    * 일반 타입 변수 *
    
        변수명 [CONSTANT] 데이터타입 [:= 값];
        
    * 자바와의 차이점
      1) 자바에서는 데이터타입 변수명; 이지만, PL/SQL 에서는 변수명 데이터타입; 이다.
      2) 자바에서는 대입 연산자가 = 이지만, PL/SQL 에서는 := 이다. (SQL 에서 = 는 비교 연산자!)
      3) 상수 선언 시 자바에서는 final 이지만, PL/SQL 에서는 CONSTANT 이다.
*/

DECLARE
    NAME VARCHAR2(10);
    AGE NUMBER;
    CLASS CONSTANT CHAR(1) := 'C';
BEGIN
    NAME := '임수진';
    AGE := 20;
    
    DBMS_OUTPUT.PUT_LINE('이름 : ' || NAME);
    DBMS_OUTPUT.PUT_LINE('나이 : ' || AGE);
    DBMS_OUTPUT.PUT_LINE('강의장 : ' || CLASS);
END;
/

-- 값을 입력 받아 변수에 대입
-- => &이름 과 같이 작성 시 값을 입력받을 수 있음
DECLARE
    EID NUMBER;
    ENAME VARCHAR2(10);
BEGIN
--    ENAME := '임수진';
    ENAME := '&이름';
    --> 만약 입력받을 값이 문자타입의 변수에 저장된다면, '&이름' 처럼 작은 따옴표로 감싸주어야 함!
    
--     EID := &직원번호;
    EID := 999;
    
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('직원번호 : ' || EID);
END;
/
--------------------------------------------------------------------------------
/*
    * 참조(레퍼런스) 타입 변수 *
    [ %TYPE ]
    : 특정 테이블의 특정 컬럼 데이터 타입을 그대로 가져와서 변수로 선언
      => 컬럼 타입이 나중에 바뀌어도 코드 수정이 필요 없음!
      
        변수명 테이블명.컬럼명%TYPE;
*/  
-- EMPLOYEE 테이블의 EMP_ID 컬럼, EMP_NAME 컬럼, SALARY 컬럼을 참조하여
--                      EID,    ENAME,  SAL 변수 선언
DECLARE
    -- 정의 해보기 ***
BEGIN

END;
/










