
## JOIN문 쉽게 만들기

1. 검색 대상과 조건을 찾는다.
	- 검색대상 : column에 넣기 (first_name, department_name, city)
	- 조건 : where (사원번호가 200번 이하)

select first_name, department_name, city
from
where employee_id < 200


2.검색 대상(column)이 있는 table을 파악한다.
	-select와 where에서 사용할 column이 포함된 table 찾기
	-찾았다면 from에 넣기
	
select first_name, department_name, city
from employees, departments, locations
where employee_id < 200


3.테이블 간 관계(연결고리)를 찾는다.
	- employees (department_id) departments (location_id) locations
	
4.JOIN 조건(where)을 기술한다
	- 테이블 간 연결고리 이용해 JOIN 조건 기술
	- from에서 table명이 너무 길다면 alias 해주자	

select first_name, department_name, city
from employees e, departments d, locations l
where e.department_id = d.department_id
	and d.location_id = l.location_id
	and employee_id < 200

5. 전체 문장을 다듬는다.

select first_name, department_name, city
from employees e, departments d, locations l
where e.department_id = d.department_id
	and d.location_id = l.location_id
	and employee_id <= 200;

	
##Outer Join?

select d.department_id 부서번호, department_name 부서명, first_name 사원이름
from departments d, employees e
where d.department_id = e.department_id
order by 1 desc;
--row 106개

select d.department_id 부서번호, department_name 부서명, first_name 사원이름
from departments d, employees e
where d.department_id = e.department_id(+)
order by 1 desc;	
--row 122개 (사원이 없는 부서까지 출력)
--왜 이렇게까지 해야하나?
--사원이 없는 부서들이 내년에 새로 만들어질 부서인 경우, 일반 join으로 검색해서 제출하면 
--120~270번 부서는 없는 부서로 인식되어 예산이 확보되지 않아 업무상 오류 발생할 경우 있음.
--Outer Join은 데이터가 부족한 쪽 Join조건에 '(+)'기호 추가.
--위에선 사원이 없는 부서, 즉 부서가 사원보다 많이 출력될 것이기 때문에 where조건 사원쪽 column에 (+)추가.

select d.department_id 부서번호, department_name 부서명, first_name 사원이름
from departments d, employees e
where d.department_id(+) = e.department_id
order by 1 desc;	
--이번엔 반대로 departments쪽 데이터 부족하다 생각해서 (+) 추가.
--아까완 다르게 부서가 없는 사원까지 검색.

즉, 데이터가 부족한 쪽에 (+) 기호 추가하면 부족하지 않은쪽 데이터는 모두 검색, 매칭되지 않은 행은 null로 설정.
단, (+) 기호는 Join조건 양쪽에 동시에 기술할 수 없다.
	
	
#####################
2019.08.22.목요일 Test
#####################

create table Customer(
 custid number PRIMARY KEY,
 name varchar2(40),
 address varchar2(40),
 phone varchar2(30)
);

create table Orders(
 orderid number primary key,
 custid number not null, foreign key(custid) references Customer on delete cascade,
 bookid number not null,
 saleprice number, 
 orderdate date
);












	