/*
    * DCL (DATA CONTROL LANGUAGE, 데이터 제어어)
     : 사용자 계정에 시스템 권한/객체 권한을 부여(GRANT)하거나, 회수(REVOKE)하는 구문
     
     - 시스템 권한 : DB에 접근하는 권한, 객체를 생성하는 권한
     - 객체 권한  : 특정 객체들을 조작할 수 있는 권한
*/
---------------------------------------------------------
/*
    * 사용자 계정 생성 *
        CREATE USER 사용자명 IDENTIFIED BY 비밀번호;
        
        - 사용자명: Oracle 12c 버전 이후로 C##이 앞에 붙어야 함!
        - 비밀번호: 대소문자를 구분하므로 잘 작성해줘야 함!
        
    * 권한 부여 *
        GRANT 권한_또는_역할 TO 사용자명;
        
        - 권한 종류 -
        + CREATE SESSION  : 접속 권한
        + CREATE TABLE    : 테이블 생성 권한
        + CREATE VIEW     : 뷰 생성 권한
        + CREATE SEQUENCE : 시퀀스 생성 권한
        ...
*/
-- 사용자 계정 생성 : SAMPLE / SAMPLE
CREATE USER C##SAMPLE IDENTIFIED BY SAMPLE;
--> 현재 계정(KH)은 사용자 생성 권한이 없으므로, 관리자 계정으로 생성해야 함!

--> 접속 시도 시 권한이 부여되어 있지 않아, CREATE SESSION 권한이 없다고 오류 발생!!
--=> SAMPLE 계정에 CREATE SESSION 권한 부여
GRANT CREATE SESSION TO C##SAMPLE;

--> 접속 성공 후 테이블을 생성하려고 했으나, 권한이 불충분하다고 실패 (오류 발생!)
--=> SAMPLE 계정에 CREATE TABLE 권한 부여
GRANT CREATE TABLE TO C##SAMPLE;

--> 테이블 생성 후 데이터를 추가하려고 했으나, 테이블 스페이스 관련 권한이 없다고 실패 (오류 발생!)
--=> SAMPLE 계정에 테이블 스페이스 할당
ALTER USER C##SAMPLE QUOTA 2M ON USERS;         --> 2M 정도 테이블 스페이스 공간 할당
--------------------------------------------------------------------------------






