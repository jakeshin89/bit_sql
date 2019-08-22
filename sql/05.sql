##################
p231 view
##################

뷰란?
- 뷰는 하나의 가상테이블.
- 뷰는 실제 데이터가 저장되는 것은 아니지만, 뷰를 통해 데이터를 관리할 수 있다.
- 뷰는 정석으로 작성한 복잡한 Query를 간단한 Query로 바꾸어 동일한 값을 얻을 수 있다.
- 한 개의 뷰로 여러 테이블에 대한 데이터를 검색할 수 있다.
- 특정 평가 기준에 따른 사용자 별로 다른 데이터를 엑세스할 수 있도록 한다.

select ename, sal, d.deptno, dname, loc
from emp e, dept d
where e.deptno = d.deptno;

--위 결과값 기반으로 가상테이블 만들고 싶어
create or replace view emp_dept
as
select ename, sal, d.deptno, dname, loc
from emp e, dept d
where e.deptno = d.deptno;
--에러? 권한없어 insufficient privileges

권한부여
conn system/1234
grant dba to SCOTT;
conn SCOTT/TIGER

--권한 부여하고 다시
create or replace view emp_dept
as
select ename, sal, d.deptno, dname, loc
from emp e, dept d
where e.deptno = d.deptno;
--create는 rollback 안되는 빠꾸없는 아이

--
select * from emp_dept;
--헐, 조인 한 번만 만들면 뷰로 엄청 간단하게 명령어 쓸 수 있네?

--지우자
drop view emp_dept;

--또 만들어보자
create or replace view emp_dept
as
select *
from emp e, dept d
where e.deptno = d.deptno;
--에러뜨네? duplicate column name
--drop했는데 왜 열 이름이 중복됐다고 나오지?

create or replace view emp_dept
as
select ename, sal, hiredate, d.deptno, dname, loc
from emp e, dept d
where e.deptno = d.deptno;

--이건 drop view 하고 또 생성해도 되네?

select * from emp_dept;
select * from tab;
select user from dual;


자기가 속한 부서의 평균 급여보다 많이 받는 사람들의 명단을 view로 만드세요. 
highsalavg / 상관관계 subquery

create or replace view highsalavg
as
select ename, sal, deptno
from emp outer
where sal > (select avg(sal) from emp where deptno = outer.deptno)
order by deptno;


select * from highsalavg;


select avg(sal) from emp;
select avg(sal) from emp where deptno=10;

ex)10번부서의 평균보다 많이 받는 사람은...
select avg(sal) from emp;
이걸로 봤더니 1명밖에 없네;;

select * from emp
where sal > (select avg(sal) from emp where deptno=10;);
--이건 10번부서 평균급여보다 많이 받는 사람. 이제 이걸 각 deptno화.

select * from emp outer
where sal > (select avg(sal) from emp where deptno=outer.deptno);
emp를 alias해서 진행

그리고 view를 만들었지



##################
sequence
##################
시퀀스?
- 유일(Unique)한 값을 생성해주는 오라클 객체. (오라클에서만 제공)
- 시퀀스를 생성하면 기본키와 같이 순차적으로 증가하는 컬럼을 자동적으로 생성할 수 있다.
- 보통 PK값을 생성하기 위해 사용.
- 메모리에 Cache되었을 때 시퀀스값의 엑세스 효율이 증가한다.
- 시퀀스는 테이블과는 독립적으로 저장되고 생성한다.

delete from dept2;
select * from dept2;
select * from emp2;
--아까 제약조건 안지워서 깔끔하게 연동되어 지워짐
--아, delete는 table data 지우는거야...

insert into dept2 (deptno, dname, loc) values (1, '인사부', '비트');
insert into dept2 (deptno, dname, loc) values (1, '인사부', '비트');
--에러 unique constraint (SCOTT.PK2_DEPT) violated
rollback;

insert into dept2 (deptno, dname, loc) values (1, '인사부', '비트');
--나는 저 1을 중북되지 않게 잘 사용하고 싶어.
--insert는 빠꾸 가능하네

create sequence deptno_seq;
insert into dept2 (deptno, dname, loc) values (deptno_seq.nextval, '인사부', '비트');

-- 확인하자
select * from dept2;

--앞으로 생성한다면 몇 번 째인지?
select deptno_seq.nextval from dual;

--현재 번호?
select deptno_seq.currval from dual;

drop sequence deptno_seq.nextval;

--한 번 넣어보자
insert into dept2 (deptno, dname, loc) values (deptno_seq.nextval, '인사부', '비트');
--에러 ; sequence does not exist

--또 만들어보자
create sequence deptno_seq start with 10 increment by 10;
insert into dept2 (deptno, dname, loc) values (deptno_seq.nextval, '인사부', '비트');
insert into dept2 (deptno, dname, loc) values (deptno_seq.nextval, '인사부', '비트');
insert into dept2 (deptno, dname, loc) values (deptno_seq.nextval, '인사부', '비트');
...
select * from dept2;

delete from dept2;
commit;

sequence 안쓰고 처리하는 방법
--subquery...로

insert into dept2 (deptno, dname, loc) 
values (????, '인사부', '비트');

select max(deptno)+10 from dept2;
--null이네;

select nvl(max(deptno), 0)+10 from dept2;
--이걸 넣어보자

insert into dept2 (deptno, dname, loc) 
values ((select nvl(max(deptno), 0)+10 from dept2), '인사부', '비트');

insert into dept2 (deptno, dname, loc) 
values ((select nvl(max(deptno), 0)+10 from dept2), '인사부', '비트');

insert into dept2 (deptno, dname, loc) 
values ((select nvl(max(deptno), 0)+10 from dept2), '인사부', '비트');




##################
index
##################
index 기반 : index를 보고 찾음 (주로 pk, fk)
full scan : 일일이 찾아야 함

select * from emp;
select * from dept;

set autotrace on;

select * from emp where empno = 7698;		//index 기반 (pk, fk되어있으면 자동으로 index 생성)
select * from emp where ename = 'FORD';		//full scan
--access full 

접근하는 동작(방식)이 다르다는 것을 확인

--이제 non pk, fk에 index를 생성해보자
create index emp_ename_index on emp (ename);

--그리고 다시 검색해보기
select * from emp where ename = 'FORD';
-- range scan으로 만들게

--삭제하자
drop index emp_ename_index;
--drop은 rollback x

index 안되어 있는 애들은 해야 할 필요가 있음.
아무나 안 해주되, 특히 검색을 많이 해야 하는 애들은 꼭 해주면 성능상 좋음.



select index_name, table_name from user_indexes;






