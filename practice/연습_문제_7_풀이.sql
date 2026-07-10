-- * KH_연습 문제 *
-- * 연습용 계정 생성 후 아래 문제를 풀어봅시다 *
-- * 계정 정보 : C##TEST / TEST *
-- * 테이블이 존재하지 않을 경우, [연습 문제 6]을 참고하여 생성해 주세요. *


-- 1. TB_DEPT 테이블에 아래 3개의 부서 데이터를 삽입하는 SQL을 작성하세요.
--    10번: '인사팀'
--    20번: '개발팀'
--    30번: '디자인팀'
-- * TB_DEPT 테이블 생성 *
CREATE TABLE TB_DEPT (
    DEPT_CD NUMBER CONSTRAINT PK_TD PRIMARY KEY,
    DEPT_NAME VARCHAR2(30) CONSTRAINT NN_TD NOT NULL
);

-- * 데이터 추가 : DML (INSERT) * --
INSERT INTO TB_DEPT VALUES (10, '인사팀');
INSERT INTO TB_DEPT VALUES (20, '개발팀');
INSERT INTO TB_DEPT VALUES (30, '디자인팀');

SELECT * FROM TB_DEPT;

COMMIT;


-- 2. TB_EMP 테이블에 아래의 사원 정보를 삽입하는 SQL을 작성하세요.
--    사원번호: 1001, 이름: '홍길동', 성별: (기본값 설정 적용), 부서코드: 10, 연락처: '010-1111-2222'
--    사원번호: 1002, 이름: '김철수', 성별: 'M', 부서코드: 20, 연락처: '010-3333-4444'
--    사원번호: 1003, 이름: '이영희', 성별: 'F', 부서코드: 20, 연락처: '010-5555-6666'
-- * TB_EMP 테이블 생성 *
DROP TABLE TB_EMP;
CREATE TABLE TB_EMP (
    EMP_NO NUMBER CONSTRAINT PK_TE PRIMARY KEY,
    EMP_NAME VARCHAR2(20) CONSTRAINT NN_TE NOT NULL,
    GENDER CHAR(1) DEFAULT 'M' CONSTRAINT CK_TE CHECK(GENDER IN ('M', 'F')),
    DEPT_CD NUMBER, -- REFERENCES TB_DEPT(DEPT_CD)
    CONTACT VARCHAR2(15) CONSTRAINT UQ_TE UNIQUE,
    
    CONSTRAINT FK_TE FOREIGN KEY(DEPT_CD) REFERENCES TB_DEPT(DEPT_CD)
);

INSERT INTO TB_EMP (EMP_NO, EMP_NAME, DEPT_CD, CONTACT) VALUES (1001, '홍길동', 10, '010-1111-2222');
SELECT * FROM TB_EMP;
INSERT INTO TB_EMP VALUES (1002, '김철수', 'M', 20, '010-3333-4444');
INSERT INTO TB_EMP VALUES (1003, '이영희', 'F', 20, '010-5555-6666');

COMMIT;

-- 3. 아래의 SQL을 실행했을 때 에러가 발생하는 원인을 제약조건과 연결 지어 설명하고, 정상적으로 삽입되도록 SQL을 수정하세요.
/*
    INSERT INTO TB_EMP (EMP_NO, EMP_NAME, GENDER, DEPT_CD, CONTACT)
    VALUES (1004, '박민수', 'X', 40, '010-1111-2222');
*/
-- 원인 1) GENDER 컬럼은 CHECK 제약조건으로 'M' 또는 'F' 값만 입력될 수 있는데, 'X' 값이 입력되어 위배되었다.
/*
    INSERT INTO TB_EMP (EMP_NO, EMP_NAME, GENDER, DEPT_CD, CONTACT)
    VALUES (1004, '박민수', NULL, 40, '010-1111-2222');
*/
-- 원인 2) CONTACT 컬럼이 UNIQUE 제약조건이 설정되어 있어, 기존에 동일한 값이 존재하므로 위배되었다.
    SELECT * FROM TB_EMP WHERE CONTACT = '010-1111-2222';
/*    
    INSERT INTO TB_EMP (EMP_NO, EMP_NAME, GENDER, DEPT_CD, CONTACT)
    VALUES (1004, '박민수', NULL, 40, NULL);    
*/
-- 원인 3) DEPT_CD 컬럼은 외래키로 설정되어 있는데, 참조하고 있는 TB_DEPT 테이블의 값이 40이 존재하지 않아, 위배되었다.    
    SELECT * FROM TB_DEPT;
    INSERT INTO TB_EMP (EMP_NO, EMP_NAME, GENDER, DEPT_CD, CONTACT)
    VALUES (1004, '박민수', NULL, NULL, NULL);    
    
    SELECT * FROM TB_EMP;
    COMMIT;

-- 4. '개발팀'의 부서코드(DEPT_CD)가 20번에서 50번으로 변경되어야 합니다. 아래 작업 항목에 따라 SQL문을 작성하세요.
--    * TB_DEPT 테이블에서 개발팀의 부서코드를 50으로 변경하는 SQL을 작성하세요.
--    * 부서코드가 변경됨에 따라 TB_EMP 테이블에서 개발팀(기존 20번) 소속이었던 사원들의 부서코드도 50으로 일괄 변경하는 SQL을 작성하세요.
-- * 간단한 방법 *
--> 1) TB_DEPT 테이블에 데이터 추가 (50번 '개발팀')
INSERT INTO TB_DEPT VALUES (50, '개발팀');
SELECT * FROM TB_DEPT;

--> 2) TB_EMP 테이블에서 부서코드가 20번인 직원들의 코드를 50번으로 변경
UPDATE TB_EMP
   SET DEPT_CD = 50
 WHERE DEPT_CD = 20;
 
SELECT * FROM TB_EMP WHERE DEPT_CD = 20;
SELECT * FROM TB_EMP;

--> 3) TB_DEPT 테이블에서 데이터 삭제 (20번)
DELETE FROM TB_DEPT WHERE DEPT_CD = 20;
SELECT * FROM TB_DEPT WHERE DEPT_CD = 20;

ROLLBACK;
-- * 복잡한 방법 * --> 만약... TB_DEPT 테이블의 DEPT_NAME 컬럼에 UNIQUE 가 설정되어 있다면..?
SELECT * FROM TB_DEPT;
SELECT * FROM TB_EMP;

ALTER TABLE TB_DEPT ADD CONSTRAINT UQ_TD UNIQUE(DEPT_NAME);
-- * 테이블 복제 --> 구조 + NOT NULL 제약 조건만 복제 ( 다른 제약조건은 복제되지 않음! )

UPDATE TB_DEPT
   SET DEPT_CD = 50
 WHERE DEPT_CD = 20;
 
-- * 해당 직원 데이터를 백업(복제) --> 부서코드가 20번 직원
SELECT * FROM TB_EMP WHERE DEPT_CD = 20;

CREATE TABLE TB_EMP_20
AS ( SELECT * FROM TB_EMP WHERE DEPT_CD = 20 );
SELECT * FROM TB_EMP_20;

-- * 해당 직원 데이터를 삭제
DELETE FROM TB_EMP WHERE DEPT_CD = 20;
SELECT * FROM TB_EMP;

-- * 부서코드 변경 (20 -> 50)
UPDATE TB_DEPT
   SET DEPT_CD = 50
 WHERE DEPT_CD = 20;
SELECT * FROM TB_DEPT;

-- * 백업해둔 직원 정보 복원(추가)
--   직원 정보에서 부서코드 변경 (20 -> 50)
UPDATE TB_EMP_20
   SET DEPT_CD = 50
 WHERE DEPT_CD = 20;

SELECT * FROM TB_EMP_20;

--    직원 정보 복원
INSERT INTO TB_EMP (EMP_NO, EMP_NAME, GENDER, DEPT_CD, CONTACT)
( SELECT * FROM TB_EMP_20 );

SELECT * FROM TB_EMP;
SELECT * FROM TB_DEPT;

COMMIT;
DROP TABLE TB_EMP_20;

-- 5. TB_DEPT 테이블에서 10번 부서('인사팀')를 삭제하려고 합니다. 
--    하지만 현재 10번 부서에는 '홍길동' 사원이 소속되어 있어 외래키 무결성 에러가 발생합니다. 
--    에러를 내지 않고 10번 부서를 안전하게 삭제하기 위한 SQL을 작성하세요.
DELETE FROM TB_DEPT WHERE DEPT_CD = 10;  --> 외래키로 사용 시 삭제 불가 (RESTRICTED)

--  1) CASCADE (전체 삭제 -> 부모테이블(TB_DEPT)/자식테이블(TB_EMP)) 
--  2) NULL ( 부모 테이블에서만 삭제하고, 자식 테이블에서는 해당 값을 NULL로 변경) *
--     => ON DELETE SET NULL
-- * 외래키 설정 변경 (삭제 -> 생성)
--   [1] 삭제
ALTER TABLE TB_EMP DROP CONSTRAINT FK_TE;
--   [2] 생성
ALTER TABLE TB_EMP ADD CONSTRAINT FK_TE FOREIGN KEY(DEPT_CD) REFERENCES TB_DEPT(DEPT_CD) ON DELETE SET NULL;

-- * 해당 부서 삭제
DELETE FROM TB_DEPT WHERE DEPT_CD = 10;
SELECT * FROM TB_DEPT WHERE DEPT_CD = 10;

SELECT * FROM TB_DEPT;
SELECT * FROM TB_EMP;










