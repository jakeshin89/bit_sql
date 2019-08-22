select * from EMP;

select		4
from		1
where		2
order by	3

select ename, sal from EMP where deptno=10;
--필터 굳이 select에 안띄워도 필터되어서 출력됨.
--안보이지만 출력된 값은 deptno=10 인 값들만 나옴.

select ename, sal from EMP order by deptno;
select ename, sal, deptno from EMP order by deptno;

#######
Join : column이 서로 연관있는 테이블끼리 합치기
#######

--emp 테이블, dept 테이블에 있는 ename, dname 출력
select ename, dname
from emp, dept;
--출력했더니 emp*dept 결과값 나옴
--두 테이블에서 그냥 결과 선택하면 안 됨 그래서 join을 걸 떈 조건이 필요해

--emp테이블에 있는 deptno와 dept테이블에 있는 deptno가 같다고 조건을 걸어줘야 함
--테이블이 3개면 조건이 2개, 4개면 3개..
--오라클 전용 join방식을 사용
select ename, dname
from emp, dept
where emp.deptno = dept.deptno;

select ename, dname, deptno
from emp, dept
where emp.deptno = dept.deptno;
--이렇게 하면 emp, dept테이블 둘 다 속해있는 deptno이기 때문에, 어디 deptno인지 명확히 알려줘야 함
--ambiguously하게 defined, 즉 애매하게 둘 다 걸쳐있기 때문에 둘 중 정확한 곳을 정해달라 에러메세지 뜸

select ename, dname, dept.deptno
from emp, dept
where emp.deptno = dept.deptno;

--table alias 가능
--수행 1빠인 from에서 table을 alias 했다면, 나머지 겹치는 column 다 alis로 바꿔줘야 함.
select ename, d.deptno as 부서번호, dname, loc
from emp e, dept d
where e.deptno = d.deptno;
--d.deptno든 e.deptno든 결과값은 같네

select *
from emp e, dept d
where e.deptno = d.deptno;

select *
from emp e, dept d
where d.deptno = d.deptno and sal>2500;
--이거 결과값 약간 좀 그런데? 이거 물어봐야겠다

####
ANCI Join 표준 : from에 있는(, -> join), (where->on)
####

--oracle
select ename, d.deptno, dname, loc
from emp e, dept d
where e.deptno = d.deptno;

오라클 join ==> 안시 join

--inner는 양쪽에 값이 동일하게 있을때만 사용 가능
--즉, inner join은 양쪽 테이블에 동시에 모두 있는 내용 출력

--이게 중복 제거하고 정확하게 나오는데? inner 있어서 그런가
select ename, d.deptno, dname, loc
from emp e
	 inner join dept d
	 on e.deptno = d.deptno
where sal>2500;

##########################################
outer join
##########################################


--40번 부서가 출력이 안되네
select ename, sal, dname, loc, e.deptno
from emp e, dept d
where e.deptno(+) = d.deptno;
--null쪽에 (+) 마킹, 오라클방식 outer join
--BOSTON엔 OPERATIONS가 있지만, 여기서 일하고 있는 사원은 없음

--위 내용 ansi st
select ename, sal, dname, loc, e.deptno
from emp e outer join dept d
on e.deptno = d.deptno;
--이건 적용이 안됨

--dept가 master야
select ename, sal, dname, loc, e.deptno
from emp e right outer join dept d
on e.deptno = d.deptno;
--right outer join은 dept 다 까고, 여기에 해당하는 왼쪽 emp 없는건 null처리

select ename, sal, dname, loc, e.deptno
from emp e, dept d
where e.deptno(+) = d.deptno;
--이 2개가 같음
--right outer join이라 하면, right가 기준이기 때문에 왼쪽은 null이 나올 수 있음.
--따로 right outer join이라 안해줄거면, 왼쪽에 (+) 해줘야 함.
--master는 dept테이블의 기준
--즉, dept 테이블이 마스터 테이블이 되어 모두 출력


--left쪽이 마스터, 즉 emp 테이블이 마스터 테이블
select ename, sal, dname, loc, e.deptno
from emp e left outer join dept d
on e.deptno = d.deptno;

####
non-equi join
####

select * from salgrade;

--table 간 아무 관련이 없음
select ename, sal, grade
from emp e, salgrade s
where sal between losal and hisal;

--ansi st
select ename, sal, grade
from emp e join salgrade s
on sal between losal and hisal;

###########################################
3개의 테이블 join
###########################################

--중복데이터 회피하면서 사용하는게 정규화, from 테이블 갯수에서 조건은 from-1개(where = from - 1)
select ename, sal, dname, loc, grade
from emp, dept, salgrade
where emp.deptno = dept.deptno and sal between losal and hisal
order by emp.deptno;

select ename, sal, dname, loc, grade
from emp, dept, salgrade
where emp.deptno = dept.deptno 
	  and sal between losal and hisal 
	  and emp.deptno=20
order by emp.deptno;

--ansi st
select ename, sal, dname, loc, grade
from emp 
	 join dept
	 on emp.deptno = dept.deptno 
	 join salgrade
	 on sal between losal and hisal
order by emp.deptno;

--deptno가 10인 아이들

select ename, sal, dname, loc, grade
from emp 
	 join dept
	 on emp.deptno = dept.deptno 
	 join salgrade
	 on sal between losal and hisal
where emp.deptno=10
order by emp.deptno;


###########################################
Self Join
###########################################

--스스로 2개가 되어 합치는 것. empno와 mgr이 겹침. 한쪽이 empno, 다른 한쪽이 mgr역할
select e.empno, e.ename 사원명, e.mgr, m.ename 상사명, m.empno, m.ename 상사명
from emp e, emp m
where e.mgr = m.empno;


--outer join
select e.empno, e.ename 사원명, e.mgr, m.ename 상사명, m.empno, m.ename 상사명
from emp e, emp m
where e.mgr = m.empno(+);

--ansi st (inner) 양쪽에 공통적으로 있는애들
select e.empno, e.ename 사원명, e.mgr, m.ename 상사명, m.empno, m.ename 상사명
from emp e inner join emp m
on e.mgr = m.empno(+);

--ansi st (outer) 
select e.empno, e.ename 사원명, e.mgr, m.ename 상사명, m.empno, m.ename 상사명
from emp e outer join emp m
on e.mgr = m.empno(+);

select e.empno, e.ename 사원명, nvl(m.ename, 'CEO') 상사명, m.ename 상사명
from emp e left outer join emp m
on e.mgr = m.empno(+);

##상사보다 급여가 많은 사원의 목록 출력
select e.ename, e.sal, m.ename, m.sal
from emp e
	 join emp m
	 on e.mgr = m.empno
where e.sal > m.sal;

##위에서 출력해서 나온 사람의 부서를 알고싶어, table join 하나 더 걸기
select e.ename, e.sal, dname, loc, m.ename, m.sal
from emp e
	 join emp m
	 on e.mgr = m.empno
	 join dept
	 on e.deptno = dept.deptno
where e.sal > m.sal;


conn hr/hr

#############################################
집계함수
#############################################

select ename, round(sal) from emp;
select avg(sal) from emp;

--avg는 group function, ename은 개별펑션. 같이 나올 수 없음
--ename은 개별 row로 값이 나오는 것이고, avg는 개별 row를 하나로 퉁쳐서 나오기 때문에 안맞음.
select ename, avg(sal) from emp;

select round(avg(sal), 2) 평균급여 from emp;

--count는 총 몇 개가 나오는지
select count(empno), count(comm), count(*), count(mgr), round(avg(sal), 2) 평균급여 
from emp;
--해봤는데 null 은 집계 안하네;

--job의 갯수를 구하고 싶음
select count(job) from emp;
--얘는 중복까지 체크해서 null만 아닌것만 골라 집계함. 그래서
select count(distinct job) 부서명 from emp;

--회사 전체 평균급여
select sum(sal), count(*), round(avg(sal)), sum(sal)/count(*) from emp;
--10번 부서의 평균을 구하자
--집계함수는 group function
select sum(sal), count(*), round(avg(sal)), sum(sal)/count(*) from emp where deptno=10;
select sum(sal), count(*), round(avg(sal)), sum(sal)/count(*) from emp where deptno=20;
select sum(sal), count(*), round(avg(sal)), sum(sal)/count(*) from emp where deptno=30;
select sum(sal), count(*), round(avg(sal)), sum(sal)/count(*) from emp where deptno=40;

select round(avg(sal)) 평균급여 from emp;
select round(avg(sal)) 평균급여 from emp where deptno=10;
select round(avg(sal)) 평균급여 from emp where deptno=20;
select round(avg(sal)) 평균급여 from emp where deptno=30;
select round(avg(sal)) 평균급여 from emp where deptno=40;

select * from emp order by deptno;

--deptno 붙여서 group by 가능하네?
select deptno, round(avg(sal)) 평균급여 
from emp
group by deptno;
--group by는 집계함수를 쓴다고 깔고 감. '월별', '분기별', '년도별', 등 '~별' 구한다 하면 group by로 하면 됨
--group by에 참여한 column만 select에서 사용 가능.
--즉, group by에 어느 column을 넣어서 그 column 기준으로 group화 시켰다면, 그 group화 시킨 column을
--select에 넣어서 나오게 해야 함. 그리고 group by를 했다면, select는 group function들로 해야 함.
--group by에서 처리해준 건 이미 group화 되었으니 그냥 column 이름만 써주면 되고, 나머지 column들은 group화 해야함. 
--그렇게 안하면, 그냥 job을 넣었더니 not a GROUP BY expression 에러뜸

select
from
where
group by
order by

##부서 이름별 평균급여
select dname, round(avg(sal), 2)
from emp 
	 join dept 
	 on emp.deptno = dept.deptno 
group by dname;

--조금 더 자세하게 알고 싶어. deptno도 넣고싶어.
select emp.deptno, dname, round(avg(sal))
from emp, dept
where emp.deptno = dept.deptno 
group by dname, emp.deptno
order by 1;

--ansi 기반 (mysql)
select emp.deptno, dname, round(avg(sal))
from emp 
	 join dept
	 on emp.deptno = dept.deptno 
group by dname, emp.deptno
order by 1;

select max(sal), min(sal), count(*), avg(sal) from emp;
--이건 왜 돼냐면, 집계함수이기 때문이다. 위에는 다 집계함수. 저기에다가 sum(column)까지.

select deptno, max(sal), min(sal), count(*), avg(sal) 
from emp
group by deptno;


##부서별 평균 급여가 2000 이상인 부서 리스트
--group by 이후에 나온 결과를 가지고 조건처리(한번 더 걸러주기) 할 경우 having
select emp.deptno, dname, round(avg(sal)) 평균급여
from emp
	 join dept
	 on emp.deptno = dept.deptno 
group by dname, emp.deptno
having avg(sal) > 2000
order by 1;

#################
#	select		#6
#	from		#1
#	where		#2
#	group by	#3
#	having		#4
#	order by	#5
#################

select emp.deptno, dname, round(avg(sal))
from emp
	 join dept
	 on emp.deptno = dept.deptno
where sal > 1000
group by dname, emp.deptno
having avg(sal) > 2000
order by 1;


##
Sub Query (있으면 얘 먼저 실행)
##

##FORD보다 급여를 많이 받는 사원 리스트
--FORD가 얼마인지 확인
select sal from emp where ename='FORD';
select sal from emp where upper(ename)=upper('ford');
--얘 3천받네?

--그럼 3천보다 많이 받는 리스트 궈궈.
select * from emp where sal>3000;
--생각해보니... 이건 FORD의 sal값이 고정이네? 유동적일 수 있잖아!
--그 때도 이렇게 해야해? 번거롭네!

--근데 FORD가 SAL이 바뀌었어;
select *
from emp
where sal > (select sal from emp where ename='FORD');
--FORD의 구한 sal값 보다 많음 되지!

##평균 급여보다 적게 받는 사원 목록
select *
from emp
where sal < (select avg(sal) from emp);

##급여를 가장 적게 받는 사람 
select *
from emp
where sal = (select min(sal) from emp);

= 다음엔 하나만, in 다음엔 여러개 와도 괜찮음
###################################
스칼라 = 단일값(=)		벡터 = 다중값(in)
###################################
##각각의 부서에서 급여가 가장 높은 사원 리스트

select deptno, ename, sal
from emp
where sal in (select min(sal) from emp group by deptno);

select deptno, ename, sal
from emp
where sal in (select max(sal) from emp group by deptno);

--위에꺼랑 같은 결과
select deptno, ename, sal
from emp
where (deptno, sal)
in (select deptno, max(sal) from emp group by deptno);
--이건 뭘까?
--in은 마치 합집합 같은 것, where column in(condition1, 2, 3...)
--from에서 column에서 조건1이나, 2나 3...등등에 해당되는 column경우(where)
--deptno, sal column에서, deptno 그룹 중 가장 높은 연봉 받는 사람들을 걸러서
--select 뽑아줘

#############################################################
상관관계 서브쿼리 : outer 쿼리의 컬럼 중 하나가 inner 쿼리문에서 사용되는 쿼리문
#############################################################

##자신이 속한 부서의 평균 급여보다 적은 사원 리스트

select *
from emp outer 
where sal < (select avg(sal) from emp where deptno=outer.deptno);

#############
rownum 행(row)에 번호 매겨주는 역할.
#############

select rownum, ename, sal, hiredate
from emp;

##급여 top3 뽑아내고 싶어. sort해야지

-1-
select rownum 순서, ename, sal, hiredate
from emp
order by sal desc;

-2- 
--sort 한 다음에 rownum 하면 되려나 (sub query)
select rownum 순서, ename, sal, hiredate
from (select * from emp order by sal desc);
--정렬한 다음에 그 값을 가지고 rownum 뽑아낸다면 되겠지
--그러면 sql이 실행되는 구문 순서를 알아야겠다.

-3-
--top3니
select rownum 순서, ename, sal, hiredate
from (select * from emp order by sal desc)
where rownum < 4;

##CAUTION
select rownum 순서, ename, sal, hiredate
from (select * from emp order by sal desc)
where rownum > 4;
--rownum은 무조건 1부터 차례대로 생성되는 아이임. 

--1부터 4까지 
select rownum 순서, ename, sal, hiredate
from (select * from emp order by sal desc)
where rownum between 1 and 4;

--중간위치 접근 안됨, no rows selected
select rownum 순서, ename, sal, hiredate
from (select * from emp order by sal desc)
where rownum between 4 and 7;

--rownum으로 원하는(일정부분의) range값을 가져올 수 있어야 함


##################
page 처리
##################

select * from (
select rownum row#, ename, sal, hiredate
from (select * from emp order by sal desc)
)
where row# between 6 and 10;

				start			end
1page 1~5		5*0+1			+4
2page 6~10		5*1+1			+4
3page 11~15		5*2+1			+4



