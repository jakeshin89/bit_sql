1. employee_id, first_name(직원), department_name, first_name(매니저)

select e.employee_id, e.first_name, department_name, m.first_name
from employees e, departments d, employees m
where e.department_id = d.department_id
	and e.employee_id = m.manager_id;
	
--ansi st가 깔끔하게 출력되네 확실히
	
select e.employee_id 사번, e.first_name 직원, department_name 부서, m.first_name 상사
from employees e 
	join departments d
		on e.department_id = d.department_id
	join employees m
		on e.employee_id = m.manager_id;

		
2.자신의 매니저보다 연봉 많이 받는 직원들의 성, 연봉 출력

select e.last_name, e.salary
from employees e 
	join employees m
		on e.manager_id = m.employee_id
where e.salary > m.salary;

--뽑아낼 column은 저 두개. 근데 이 두 개가 employees 테이블에 동시애 있음.
--employees 테이블을 하나는 사원쪽, 하나는 매니저쪽이라 생각을 함.
--join할 걸 찾아보니, 사원쪽 manager_id와 매니저님들의 사원번호가 같!
--조건식 만들어주고, 바로 비교 들어감


3.업무명(job_title)이 'Sales Representative'인 직원 중, 연봉(salary)이 9,000 이상 10,000 이하인
직원들 이름(first_name), 성(last_name)과 연봉(salary)을 출력하시오.

select first_name, last_name, salary
from employees e
	join jobs j
		on e.job_id = j.job_id
where upper(job_title) = upper('Sales Representative')
and salary between 9000 and 10000; 


4.자신의 매니저보다 채용일(hire_date)이 빠른 사원의
  사번(employee_id), 성(last_name)과 채용일(hire_date)을 조회하라.

select e.employee_id, e.last_name, e.hire_date
from employees e
 join employees m
  on e.manager_id = m.employee_id
where e.hire_date < m.hire_date;

--  < 기준일 : 기준일보다 이전인 날짜


5.각 업무(job_title)가 어느 부서(department_name)에서 수행되는지 조회해라. (중복제외)

select distinct job_title, department_name
from jobs j
 join employees e
  on j.job_id = e.job_id
 join departments d
  on e.department_id = d.department_id
order by job_title;

--선생님, order by 안하셨어요;


6. 월 별 입사자 수를 조회하세요. 월 순으로요.
  
select to_char(hire_date, 'mm') 월별, count(to_char(hire_date,'mm')) 입사원수
from employees
group by to_char(hire_date, 'mm')
order by to_char(hire_date, 'mm');


7. 08년도에 입사한 직원의 이름(first_name), 입사일(hire_date), 관리자사번(employee_id),
  관리자 이름(first_name)을 조회합니다. 관리자가 없는 사원정보도 출력결과에 포함되어야 합니다.
  
select first_name, hire_date, employee_id, first_name
from employees
where hire_date like '08%';

--관리자가 없는 사원정보도 출력..해야 한다면

select e.first_name, e.hire_date, m.employee_id, m.first_name
from employees e
  left join employees m
   on e.manager_id = m.employee_id
where e.hire_date like '08%';

--마지막 where절도 다르긴 한데... 선생님 이것도 맞나요..?


8.'Sales' 부서에 속한 직원의 이름(first_name), 급여(salary), 부서이름(department_name)을 조회해라.

select first_name, salary, department_name
from employees e
 join departments d
  on e.department_id = d.department_id
where lower(department_name) = lower('Sales');


9. 2004년에 입사한(hire_date) 직원들의 사번(employee_id), 이름(first_name), 성(last_name),
 부서명(department_name)을 조회해라. 이 때, 부서에 배치되지 않은 직원의 경우, '<NOT ASSIGNED>'로 보여줘라.

select employee_id, first_name, last_name, nvl2(department_name, department_name, '<NOT ASSIGNED>') department_name
from employees e
 join departments d
  on e.department_id = d.department_id(+)
where to_char(hire_date, 'yyyy') = '2004';



10. 2003년에 입사한 직원의 이름(first_name), 입사일(hire_date), 관리사번(employee_id),
 관리자 이름(first_name)을 조회해라. 단, 관리자가 없는 사원정보도 출력결과에 포함시켜야 한다.
  
select e.first_name, e.hire_date, m.employee_id, nvl(m.first_name, '(null)')
from employees e
 join employees m
  on e.manager_id = m.employee_id(+)
where to_char(e.hire_date, 'yyyy') = '2003';
 
 
