###################
Table 생성 DDL(Data Definition Language)
DDL 명령은 auto commit? 이기 때문에 취소가 안됨.
테이블은 실제로 데이터들이 저장되는 곳이라 생각하면 쉽게 이해할 수 있으며;
CREATE TABLE 명령어를 이용해서 테이블을 생성할 수 있다.
###################

##DDL문 : create, alter, drop, rename, truncate
	rollback o (취소완가) :
	rollback x (취소불가) : drop

Table 생성시 column은 변수 개념으로 이해
()안 숫잔 byte

--table 만들기
create table book(
	bookno 	number(5),
	title 	varchar2(30),
	author 	varchar2(30),
	pubdate date
);

--table 삭제하기
drop table book;
--앗, 취소하고싶어;;; 는 불가능

select * from book;


###############
DML(Data Manipulation Language)
###############
	rollback o (취소완가) : insert, delete, update, 
	rollback x (취소불가) : alter, rename,


--Table에 정보 넣기
insert into book values(1, 'java', 'shin', sysdate);
--Dos창에선 보이는데 SQL Developer에선 안보여. 왜? 데이터 입력하긴 했지만 확정(commit) 안했기 때문.
commit;
이클립스에서 하지 말란 이유는, 어떤 상황이든 auto commit하기 때문.
이클립스에서 사용하려면 환경설정 바꾸어야 하는데, 이건 어제 나눠준 hr 파일 참고.

insert into book values(2, 'jsp', 'hong', sysdate);

내린 명령 취소는 rollback;
일단 테이블이 만들어지면 어떤 dos창에서 만들든지 상관없음

--insert 한 번에 2개 넣기
insert into book values(1, 'java', 'shin', sysdate);
insert into book values(2, 'jsp', 'hong', sysdate);
insert into book values(2, 'jsp', 'hong', sysdate);
insert into book values(2, 'jsp', 'hong', '19/02/02');

이 상태에서 rollback하면 어떻게 될까? insert만 지워질까?
auto commit 이후부터 다 지워짐

--넣고싶은 column 선택해서 넣기
insert into book (bookno, title) values(3, 'db')
insert into book (bookno, title, author, pubdate) values(4, 'db', null, null);

--data 지우기
delete from book;
--조건 걸지 않았고, commit 날리지 않았기 때문에 아직임.
--조건 안 걸면 다 날리기
--rollback하면 다시 돌아옴.

--data 조건세워 ㅈㅣ우기
delete from book where title='db';
delete from book where author is null;


desc book; // 테이블 구조

alter table book add(price number(7)); //구조 변경 column 추가
자동으로 commit처리 됨. 왜냐,

insert into book (bookno, title, author, pubdate) values(4, 'db', null, null);
insert into book (bookno, title, author, pubdate) values(4, 'db', null, null);

이거 2개를 넣었고, commit 기다리고 있는데, alter table 해서 저것들까지 auto commit이 됨.

insert into book (bookno, title, author, pubdate, price) values(4, 'db', null, null, 900);

--수정하기(update), price column null에 값 넣기
update book set price = 10;
rollback;

--가격에 소숫점 넣어보기
update book set price = 1000.99;
--테이블엔 1001이 뜨네;; 정수형이라 반올림 해서 이렇게 나왔나 봄

update book 
set price=900 
where title='db';

update book 
set author = '~~', price=900, pubdate=sysdate
where bookno=4;

price column 실수가 나오게 하고 싶어 (column 형변환?)
alter table book modify(price number(7, 2));
--얜 auto commit
--근데 에러메시지 뜨네 column to be modified must be empty to decrease precision or scale
--null값으로 넣고 다시 해보자

update book set price=null;

alter table book modify(price number(7, 2));

update book set price=1000.99;
commit;


테이블 column 삭제 (테이블 구조 변경)
alter table book drop column price;
rollback; --해봤지만 빠꾸없이 안됨.

테이블 이름 바꾸기
rename book to book2;
rollback; --롤백 빠꾸 없음;

rename book2 to book;

delete from book;

select * from book;
rollback; --빠꾸가능

delete from book;		rollback;
truncate table book;		x (auto commit)
drop table book;			x (auto commit)s

select * from emp;
select * from dept;

--as 이하 테이블 기반으로 테이블 새로 만들기
create table emp2 as select * from emp;
create table dept2 as select * from dept;
--대신 제약조건은 copy가 안 됨.


dept, dept2 테이블에 insert
insert into dept values(50, 'EDU', 'SEOUL');
insert into dept2 values(50, 'EDU', 'SEOUL');
commit;
--제약조건 없기 때문에, 50번 부서 없기 때문에 성공.

insert into dept values(10, 'EDU', 'SEOUL');	--실패, 제약조건(데이터 유지 위해) 있기 때문. pk이기때문
insert into dept2 values(10, 'EDU', 'SEOUL');	--성공.


--emp2 table에 insert하기
insert into emp (empno, ename, hiredate, sal, deptno) 
			values(9999, '홍길동', sysdate, 0, 90);			
--에러; 90번 부서 없어. integrity constraint (SCOTT.FK_DEPTNO) violated - parent key not found.
--제약조건이 있기 때문.

insert into emp (empno, ename, hiredate, sal, deptno) 
			values(9999, '홍길동', sysdate, 0, 40);			
--이건 돼. 40번 부서 있으니.
	
emp에 같은값 한 번 더 넣어보기
insert into emp (empno, ename, hiredate, sal, deptno) 
			values(9999, '홍길동', sysdate, 0, 40);			
--제약조건(사원번호 같으면 안돼) 때문에 에러 unique constraint (SCOTT.PK_EMP) violated
			
insert into emp2 (empno, ename, hiredate, sal, deptno) 
			values(9999, '홍길동', sysdate, 0, 90);


back to the book table

drop table book;

create table book(
	bookno 	number(5),
	title 	varchar2(30),
	author 	varchar2(30),
	price 	number(7, 2),
	pubdate date
);


--제약조건 거는 방법 3가지, column에 바로, table column작성 끝나고(괄호 안), 괄호 밖 

1번 방법으로 꼼꼼하게 제약조건 걸어보자
create table book2(
	bookno 	number(5) constraint scott_book_pk primary key,
	title 	varchar2(30) constraint scott_book_title_unique unique,
	author 	varchar2(30),
	price 	number(7, 2) constraint book_price_check check (price>0),
	pubdate date default sysdate
);		
			
--1번방법 : constraint name primary key, scott_book_pk 이 이름은 내맘대로.			
--primary key는 null 허용 안함, unique(중복안돼)는 null 허용함			
--check는 유효성검사
--default는 따로 적지 않으면 기본값으로 sysdate 출력
			
insert into book (bookno, title, author, price, pubdate)
			values(1, 'db', 'Shin', 900, sysdate);

한 번 더 넣어보자
insert into book(bookno, title, author, price, pubdate)
			values(1, 'db', 'Shin', 900, sysdate);
--에러 : unique constraint (SCOTT.SCOTT_BOOK_PK) violated			

insert into book(bookno, title, author, price, pubdate)
			values(2, 'db', 'Shin', 900, sysdate);
--에러 : unique constraint (SCOTT.SCOTT_BOOK_TITLE_UNIQUE) violated 이름같아			
			
insert into book(bookno, title, author, price, pubdate)
			values(2, 'db', 'Shin', -900, sysdate);
--에러 : check constraint (SCOTT.BOOK_PRICE_CHECK) violated 0보다 작잖아

insert into book(bookno, title, author, price, pubdate)
			values(2, 'db', 'Shin', 0, sysdate);
--에러 : check constraint (SCOTT.BOOK_PRICE_CHECK) violated 0보다 크다고 했잖아
			
insert into book(bookno, title, author, price, pubdate)
			values(2, 'jsp', 'Shin', 22000, sysdate);
			
insert into book(bookno, title, author, price, pubdate)
			values(3, 'java', 'Hong', 32000, default);
			
여기에서 commit;

제약조건 검색하기
select CONSTRAINT_name
from user_cons_columns
where table_name='BOOK';
			
			
제약조건 대충 걸어보기
create table book(
	bookno 	number(5)		primary key,
	title 	varchar2(30)	unique,
	author 	varchar2(30),
	price 	number(7, 2)	check (price>0),
	pubdate date default sysdate
);		

insert into book(bookno, title, author, price, pubdate)
			values(1, 'db', 'Shin', 900, sysdate);

한 번 더 넣어보자
insert into book(bookno, title, author, price, pubdate)
			values(1, 'db', 'Shin', 900, sysdate);
--에러 : unique constraint (SCOTT.SYS_C007051) violated. 아까랑 달라진 점?
--아까는 이름이 있었지만 (scott_book_pk), 지금은 이름이 없으니 내부적으로 생성(SYS_C007051)

...

동작은 똑같이 하지만 이름이 없으니 이름만 다름.


--primary key 설정 외부에서 하기
drop table book;
create table book(
 bookno 	number(5),
 title 	varchar2(30)	unique,
 author 	varchar2(30),
 price 	number(7, 2)	check (price>0),
 pubdate date default sysdate
);

alter table book add CONSTRAINT book_bookno_pk primary key (bookno);
alter table book add CONSTRAINT book_bookno_pk primary key (bookno, author);
--복합키도 존재. 즉, bookno가 1이 2개여도 author만 다르면 된다.

--제약조건 삭제
alter table book drop CONSTRAINT book_bookno_pk;
			
			
insert into book (bookno, title, author, price, pubdate)
			values(1, null, 'Shin', 900, sysdate);
--unique 속성은 null 허용하는구나. 근데 primary key는 안되네

insert into book (bookno, title, author, price)
			values(1, null, 'Shin', 32000);


###########################################################
emp dept
###########################################################

drop table dept2;
drop table emp2;
delete from dept where deptno=50;
commit;

create table dept2 as select * from dept;
create table emp2 as select * from emp;

alter table dept2 add CONSTRAINT PK_DEPT2 primary key (deptno);			

alter table emp2 add CONSTRAINT PK_EMP2 primary key (empno);
alter table emp2 add CONSTRAINT FK_MGR_EMP2 foreign key (mgr) references emp2;
alter table emp2 add CONSTRAINT FK_DEPTNO_EMP2 foreign key (deptno) references dept2;

alter table emp2 drop CONSTRAINT FK_DEPTNO_EMP2;
			
delete from dept2 where deptno=20;
--에러뜸 integrity constraint (SCOTT.FK__DEPTNO_EMP2) violated - child record found

--fk 설정 할 때 어떻게 해줄지는 on delete로.
alter table emp2 
add CONSTRAINT FK_DEPTNO_EMP2 foreign key(deptno) 
references dept2 
on delete set null;
--예를 들어, dept테이블 deptno 20번 지우면 어떻게 반응하게 할거냐, 
--연동된 emp테이블  deptno만 null로 할거냐, 아니면 그 row 다 지울거냐

alter table emp2 
drop CONSTRAINT FK_DEPTNO_EMP2;


alter table emp2
add CONSTRAINT FK_DEPTNO_EMP2
foreign key(deptno) references dept2 on delete cascade;
select * from emp2;
--확인하고

delete from dept2 where deptno=20;
--지우고
select * from emp2;
--확인 한 번 더 하고 됐다면
rollback;

--ON DELETE CASCADE 옵션은 참조되어있는 값을 변경하거나 삭제할때 참조되어진 모든 값을 같이 지워버릴 때 사용할 수 있습니다.

alter table emp2
add CONSTRAINT FK_DEPTNO_EMP2
foreign key(deptno) references dept2 on delete from emp2 where deptno=20;





--다시 지우기 시도
delete from dept2 where deptno=20;
select * from emp2;
--오... 지워진거 확인 했으니
rollback;
--제대로 복구 됐는지 확인
select * from emp2;











select * from dept2;
insert into dept2 values(50, 'EDU', 'SEOUL');

select * from emp2;
			
insert into emp2 (empno, ename,  hiredate, sd
al, deptno)
		values (9999, '홍길동', sysdate, 0, 50);

insert into emp2 (empno, ename,  hiredate, sal, deptno)
		values (7777, '고길동', sysdate, 0, null);

insert into emp2 (empno, ename,  hiredate, sal, deptno, mgr)
		values (8888, '이길동', sysdate, 0, null, 10);


drop table emp2; cascade CONSTRAINT;
drop table dept2; cascade CONSTRAINT;


###########################################################
트랜젝션
###########################################################

create table emp2 as select * from emp;
select * from emp2;

창1
delete from emp2 where deptno=10;

창2
update emp2 set comm=0 where deptno=10;
--헐 명령내렸더니 block됨;;, 마치 multi thread 블락발생한 것과 같음
--창1에서 delete 명령 내렸지만 commit할지 안하지 아직 안정했기 때문에, 다른 창에서의 접근을 막음.
--그래서 창1 어떻게 할지 고민하다 rollback; 선택

창1
rollback;

창2
--블락에서 자동으로 빠져나와 3 rows updated. 결과 나옴
3 rows updated.


