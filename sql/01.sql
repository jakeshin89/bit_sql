
alter user hr identified by hr account unlock;

sqlplus hr/hr

seletc * from tab;

conn system/1234

-- tablespace 생성
create tablespace bit
datafile 'c:\lib\bit.dbf'
size 30M
autoextend on next 2M maxsize UNLIMITED;

--계정생성(대소문자 구분함)
create user test01 identified by 1234
default tablespace bit;

--ORA-01045: user TEST01 lacks CREATE SESSION privilege; logon denied
--그래서 이제 test01에게 권한부여
grant connect to test01;

--주었던 권한 뺏기
revoke connect from test01;

--다시 권한부여 (resource 핸들링 할 수 있는, dba)
grant connect, resource to test01;

--삭제
drop user test01 cascade;

--계정생성
create user SCOTT identified by TIGER
default tablespace bit;

GRANT CONNECT,RESOURCE TO SCOTT IDENTIFIED BY TIGER;

@c:\lib\scott.sql

show linesize;
set linesize 300;

show pagesize;
set pagesize 20

-- 오라클 휴지통 조회
SELECT *
FROM RECYCLEBIN
;

-- 휴지통 비우기
purge recyclebin;

select TABLESPACE_name from dba_TABLESPACE