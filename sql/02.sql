--테이블  SELECT해서 가져오기
--테이블 characters 모두 소문자로 변경하기 lower(a column)
select dname, lower(dname), loc, lower(loc) from dept;
select * from employees;

-- *는 all을 의미함
select * from emp;
select * from dept;

--원하는 column 추출, column name은 대소문자 구분 안함. 하지만 계정은 구분함.
select ename, hiredate from emp;
select ENAME, HIREDATE from emp;
select ENAME, HIREDATE FROM EMP;
select ename, sal from emp;

--연산도 가능하네, comm null과 0은 큰 차이
select ename, sal, sal*12, comm from emp;

--dept table description좀..
desc dept;

--column 제목 바꾸기, 오라클에서 문자열은 ''
select ename, sal, sal*12 as 연봉, comm from emp;

--column name alias 시킬때만 "" 사용
select ename, sal, sal*12 as "연   봉", comm from emp;

--column name에서 as 생략가능
select ename, sal, sal*12 "연   봉", comm from emp;
select dname, loc from dept;

--hr 계정은 table이 많음
conn hr/hr
select * from employees;
select first_name, job_id, department_id from employees;

conn SCOTT/TIGER
select empno, ename, sal, comm from emp;

--sal+comm 합한 real 급여 계산해주고 싶
select empno, ename, sal, comm, sal+comm 
from emp;
select empno, ename, sal, comm, sal+comm 월급여 
from emp;
--연산식에 null을 포함하면 null값이 출력, 즉 null이 포함된 계산식(연산식)은 계산이 안됨

--안찍히면 안되니 null을 함수처리 해보자
select empno, ename, sal, comm, nvl(comm, 0) 
from emp;
--nvl(comm, 0) -> 'comm열'에서 값이 null이면 '0'으로 바꿔줘
select empno, ename, sal, comm, nvl(comm, 0), sal+nvl(comm, 0) 월급여 
from emp;
--서로 연산하려는 값이 동일한 데이터타입이어야 가능

--괄호()로 우선순위 처리 가능
select empno, ename, sal, comm, (sal+nvl(comm, 0))*12 연봉 
from emp;
select empno, ename, mgr, deptno 
from emp;

--Oracle에선 String이 ''
select empno, ename, nvl(mgr, 'CEO'), deptno 
from emp;
--mgr과 'CEO' 간 데이터타입이 일치하지 않아 에러 발생. 형변환 필요.
select empno, ename, nvl(to_char(mgr), 'CEO') as mgr, deptno 
from emp;

--문자열 연결 연산자 ||
select empno, ename, deptno from emp;
select empno||ename||deptno from emp;
--결과값이 구분(쪼개짐) 없이 한뭉테기로 나옴.
select empno||'  '||ename||'  '||deptno from emp;
select empno, ename, sal||'원'from emp;

--연산값이 궁굼한데 연산하면 각 row 갯수만큼 출력.
select 10*24*24 from emp;
select 10*24*24 from dept;
--dual 가상테이블 설정하면 원하는 갯수만큼 (1개) 출력. 연산값이 궁굼할 땐 dual 사용.
select 10*24*24 from dual;
--sysdate를 이용해 시스템날짜 출력. ; 입력해야 명령
select sysdate from dual;

--중복제거(distinct) ; 나는 이 회사에 어떤 job이 있는지 궁굼한데..
select job from emp;
select distinct job from emp;
select deptno from emp;
select distinct deptno from emp;

--row(항목, 개별값) 제한(필터) where절 사용. where절은 별칭사용 불가. where은 '경우'란 뜻도 있음.
select * from emp where deptno=20;
select * from emp where deptno=40;
select * from emp where deptno=30;
select * from emp where deptno=10;
--
select ename, sal, comm, sal+nvl(comm, 0) total 3
from emp 1
where sal+nvl(comm, 0) > 3000; 2
--where total>3000;
--보이지 않는(select 하지 않은) column도 where로 추출 가능
select ename, sal, comm, sal+nvl(comm, 0) total
from emp
where deptno=20;

--문자열로 찾을 경우에는 대소문자 반드시 구분함.
--column은 대소문자 신경 안쓴다고 위에서 분명히 얘기했음;;
-- where coloumn='찾고자 하는 단어';
select * from emp where job='salesman';
select * from emp where job='SALESMAN';
--근데 대소문자 구분 안하고 싶어. 그러면 어떡함?
select * from emp where upper(job)=upper('salesman');

--입사연도
select * from emp where hiredate=sysdate;
select * from emp where hiredate='81/09/28';
select * from emp where hiredate > '81/09/28'; 	--기준일보다 나중에
select * from emp where hiredate < '81/09/28';	--기준일보다 이전에
select * from emp where hiredate <> '81/09/28';	--기준일 빼고 전부
select * from emp where hiredate != '81/09/28'; --기준일 빼고 전부
--81년도에 입사한 사람?

--급여가 3천 이상인 사람?
select * from emp where sal > 3000;

--급여가 3천~5천 인 사람?
select * 
from emp 
--where sal >= 3000 and sal <= 5000;
select * 
from emp 
where sal between 3000 and 5000;
-- between and는 기준 값들을 포함한 범위 내로 인식

select * 
from emp 
where sal between 5000 and 3000;
-- between and는 역순 안됨. 적은수부터 먼저 기술해야 함.

select * 
from emp 
where sal not between 3000 and 5000;
-- 3000 제외한 나머지범위

select * 
from emp 
where deptno=10 or deptno=20;
-- deptno가 10 또는 20인 row

--집합연산자 / in 합집합
--위랑 같음
select * 
from emp 
where deptno in(10, 20);
--항상 where 다음엔 column이 먼저 오고 그 다음에 함수따위가 진행되는군

--위와 반대 / not in 역집합?
select * 
from emp
where deptno not in(10, 20);
--복합집합연산자, 컴마(,)는 or로 인식

select * 
from dept
where (deptno, loc) in((10, 'DALLAS'), (30, 'CHICAGO'));
--dept 테이블에서 (deptno, loc)값이 (10, 'DALLAS') 이거나 (30, 'CHICAGO)인걸 걸러줘.

--like 연산자 ; 완전 일치가 아닌 닮은 애
select * from emp where ename like 'ALLEN';
select * from emp where ename like 'A%';
select * from emp where ename like '%R%';
--%는 뿅뿅. %R% 경우는 앞/뒤 상관없이 이름 스펠링에 R만 있는애를 다 끌어모았네
 
--내가 누군가를 찾고있는데 이름이 가물가물치해
select * from emp where ename like '%M_T%';
--언더바(_) 1개는 Spelling 1개를 의미

--81년도에 입사한 사람들?
select * from emp where hiredate between '81/01/01' and '81/12/31';
select * from emp where hiredate like '81%';

--사원 이름이 A, B, C, D로 시작하는 사원들을 찾고싶어
select * from emp where ename like 'A%' or ename like 'B%' or ename like 'C%' or ename like 'D%' or ename like 'E%';
--가독성 별로니 정규식(Regular Expression, 특정한 규칙을 가진 문자열의 집합)...
select * from emp where regexp_like(ename, 'A|B|C|D');
--이름에 A, B, C, D만 있으면 다 나오네;; 이건 내가 원하는게 아닌데..
--꺽새(^)는 시작
select * from emp where regexp_like(ename, '^[A-D]');
--달러($)는 끝
select * from emp where regexp_like(ename, '[A-D]$');

--null
select *
from emp
where comm = null;
--이건 틀렸다

--null 비교는 is로 합니다.
select *
from emp
where comm is null;

--null 비교 반대는 in not으로 합니다.
select *
from emp
where comm is not null;

--정렬하기 'order by 기준 column(ascending)' <- default
select ename, sal, comm, sal+nvl(comm, 0) total, deptno
from emp
order by deptno;

--'order by 기준 column desc(decending)'
select ename, sal, comm, sal+nvl(comm, 0) total, deptno
from emp
order by deptno desc;

--order by는 별칭어 사용 가능
select ename, sal, comm, sal+nvl(comm, 0) total, deptno
from emp
order by total;

--n번째 column으로, 즉 column 숫자로도 정렬 가능
select ename, sal, comm, sal+nvl(comm, 0) total, deptno
from emp
order by 2;

--각 부서 내림차순 기준으로 total 올림차순 정렬
select ename, sal, comm, sal+nvl(comm, 0) total, deptno
from emp
order by deptno desc, total;
-- deptno 30, 20, 10 순으로 정렬한 후, 각 deptno 내 total을 올림차순 정렬

--where(필터)가 있는 order by
select *			--the last
from emp			--first
where deptno = 30	--second
order by sal;		--third

###
select *
from emp
where deptno in(20, 30)
order by sal;

select * 
from emp 
where deptno = any(20, 30) 
order by sal;
###

###
select *
from emp
where deptno != all(20, 30)
order by sal;

select *
from emp
where deptno <> all(20, 30)
order by sal;
###

--내장함수 p204 single row function
select * from dept;
select dname, lower(dname), loc, lower(loc) from dept;

select 45.5678, 45.5678 from dual;
select round(45.5678, 2), trunc(45.5678, 2) from dual;
--turnc는 cut해버리네

--날짜로 연산가능 ex)쇼핑몰 환불, 반품, 교환 유효일 확인
select sysdate, sysdate+7 from dual;

--SUBSTR 오라클은  index가 무조건 1부터 시작
--substr는 sub뺀다 str스트링을. 뒤에 숫자는 어디서부터 어디까지 남겨둘건지. 그리고 나머지 sub.
select ename, hiredate from emp;
select ename, hiredate, substr(hiredate, 1, 2) 입사연도
from emp;

--daytime의 주요 인자, 212p
select sysdate, to_char(sysdate,'yyyy') from dual;
select sysdate, to_char(sysdate,'yy') from dual;
select sysdate, to_char(sysdate,'day') from dual;
select sysdate, to_char(sysdate,'d') from dual;

--emp테이블에서 사원들의 입사월
select ename, to_char(hiredate, 'mm') 입사월
from emp;

--타입을 todate로 변경해서 뭐 연산하는건가
select sysdate, '2019/08/14' from dual;
select sysdate, to_date('2019/08/14') from dual;
--select sysdate, to_date('2019/08/14')+7 from dual;

뭐가 뭔지 오해하지 않게 
select sysdate, to_date('08/14/2019') from dual;
select sysdate, to_date('08/04/19', 'mm/dd/yy') from dual;

--nvl(a, b) 함수
select ename, mgr, nvl(to_char(comm), '_') from emp;
select ename, mgr, nvl(comm, 0) from emp;

--nvl2(a, b, c) 함수
select ename, nvl2(mgr, 'o', 'x'), nvl(comm, 0) from emp;
--nvl2는 (mgr에, 내용 있으면' ', 없으면 ' ')이거네

--decode 함수
select ename, sal, deptno, decode(deptno, 10, sal*1
										  20, sal*2 
										  30, sal*3,
										  sal) 계산 from emp;
											
--decode(column, 조건1, 결과1, 조건2, 결과2, 조건3, 결과3....)