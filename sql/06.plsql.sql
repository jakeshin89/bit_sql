SET SERVEROUTPUT ON ;

Create Procedure SALARY_CAL
    실행가능한 모듈이 데이터베이스에 만들어진다.  
   
##############################
   Procedure (DML)
##############################
create or replace procedure update_sal(v_empno in number)
is
begin
 update emp
 set sal=sal*1.1
 where empno=v_empno;
end;
/

--이 procedure는 begin부터 end까지야.
--파라미터에 정수가 들어오고, 그걸 v_empno라 할거야. 들어오면 begin-end 사이 일 할거야.

drop procedure update_sal;

--다시 생성
create or replace procedure update_sal(v_empno in number)
is
begin
 update emp
 set sal=sal*1.1
 where empno=v_empno;
end;
/

select * from emp;
7369
update_sal

--procedure 실행
execute update_sal(7369);
--우린 이 procedure를 자바에서 실행;;;
--무튼 이렇게 하면 20번부서 평균급여도 증가했을 것이고..
--각 연관된 table에 영향을 줄거야
--하지만 아직 commit 안했으니 SQL Developer에는 안뜸.
--commit 할건지 rollback 할건지.

--같은 변수명 써버리면 replace 되겠지
create or replace procedure update_sal(v_deptno in number)
is
begin
 update emp
 set sal=sal*2
 where deptno=v_deptno;
end;
/

execute update_sal(20);




*******************

Drop table book;

CREATE TABLE Book (
  bookid      NUMBER(2) PRIMARY KEY,
  bookname    VARCHAR2(40),
  publisher   VARCHAR2(40),
  price       NUMBER(8) 
);


CREATE OR REPLACE PROCEDURE InsertBook(
    myBookID IN NUMBER,
    myBookName IN VARCHAR2,
    myPublisher IN VARCHAR2,
    myPrice IN NUMBER)
 AS
 BEGIN
      INSERT INTO Book(bookid, bookname, publisher, price)
      VALUES(myBookID, myBookName, myPublisher, myPrice);
 END;
/

execute InsertBook(1, 'Java Programming', '한빛', 27000);
execute InsertBook(2, 'Java Do It', '이지스', 25000);
rollback;


--질문... is as 차이?


**********************************
동일한 도서가 있는지 점검한 후 
삽입하는 프로시저(BookInsertOrUpdate)
**********************************

CREATE OR REPLACE PROCEDURE BookInsertOrUpdate(
    myBookID NUMBER,
    myBookName VARCHAR2,
    myPublisher VARCHAR2,
    myPrice INT)
 AS
    mycount NUMBER; --myPrince INT 변수선언
 BEGIN
   SELECT COUNT(*) INTO mycount FROM Book
     WHERE bookname LIKE myBookName;
   IF mycount!=0 THEN
     UPDATE Book SET price = myPrice
       WHERE bookname LIKE myBookName;
   ELSE
     INSERT INTO Book(bookid, bookname, publisher, price)
       VALUES(myBookID, myBookName, myPublisher, myPrice);
   END IF;
 END;
/

--int 써도 돼.
--COUNT를 mycount 변수에 넣어
--IF 시ㅇ작, END IF 끝 확실하게 BLOCK 처리해야 함.

exec BookInsertOrUpdate(1, 'DB', 'BIT', 0);
--체크조건 없으니 0원해도 됨.

--생성하고 select로 확인
select * from book;

--똑같은 구문이지만 가격만 변경함.
exec BookInsertOrUpdate(1, 'DB', 'BIT', 2000);
--어?! 에러 안나고 실행되네? INSERT가 아니라 UPDATE로 되어서 실행됨.





ㄴㄷ
########################################
FUNCTION, 사용자 정의 함수
########################################
CREATE OR REPLACE FUNCTION fn1(price NUMBER) RETURN INT
  IS
     myInterest NUMBER;
  BEGIN
  /* price가 30,000원 이상이면 10%, 30,000원 미만이면 5% */
    IF Price >= 30000 THEN myInterest := Price * 0.1;
    ELSE myInterest := Price * 0.05;
   END IF;
   RETURN myInterest;
  END;
/
대입문이 := 조금 특이하네?




--function은 반드시 return type이 있어야 함. void가 안됨.

**사용자 정의 함수 실행*********************
select empno, ename, sal, fn1(sal) from emp;



####################################
trigger
####################################
데이터의 변경문(insert, delete, update)이 실행될 때 자동으로 같이 실행

drop table book;

create table item(
  code char(6) primary key, --물품 코드
  name varchar2(15) not null,
  company varchar2(15),
  price number(8),
  cnt number default 0 -- 재고 수량  
);


create table warehouse(
   num number(6) primary key, --입고 번호
   code char(6) references item(code),
   indate date default sysdate, --입고날짜
   incnt number(6),
   inprice number(6),
   totalprice number(8)
);

insert into item(code, name, company, price)
values('c0001', '에어콘', '삼성', 1000000);

insert into item(code, name, company, price)
values('c0002', '선풍기', 'LG', 50000);

commit;

SELECT * FROM item;

--재고수량 갱신하기위한 트리거 생성
create or replace trigger cnt_add
after insert on warehouse
for each row
  begin
     update item set cnt = cnt+:new.incnt
     where code=:new.code; --new 선언은 insert문, update문에서만 사용
end;
/


insert into warehouse(num, code, incnt, inprice, totalprice)
values(1,'c0001',10, 900000, 9000000 );

SELECT * FROM item;
SELECT * FROM warehouse;

#################################################
trigger  book  p270
################################################
set serveroutput on;


--비우고 시작하자
drop table book;
drop table book_log;

CREATE TABLE Book (
  bookid      NUMBER(2) PRIMARY KEY,
  bookname    VARCHAR2(40),
  publisher   VARCHAR2(40),
  price       NUMBER(8) 
);

CREATE TABLE Book_log(
    bookid_l NUMBER,
    bookname_l VARCHAR2(40),
    publisher_l VARCHAR2(40),
    price_l NUMBER
);

트리거 문법
CREATE OR REPLACE TRIGGER trigger_name
BEFORE | AFTER
 trigger_event(insert, update, delete 중 1개 이상) ON table_name
 FOR EACH ROW (이 옵션은 행 트리거) 
 --행 트리거 : column의 각 행의 데이터 행 변화가 생길때마다 실행, 그 데이터행 실제값 제어가능. 
 DECLARE (변수선언)
 variable_name 변수타입
 
 
 
 
CREATE OR REPLACE TRIGGER AfterInsertBook
	AFTER INSERT ON Book FOR EACH ROW
	DECLARE
         
	BEGIN
	 INSERT INTO Book_log
	  VALUES(:new.bookid, :new.bookname, :new.publisher, :new.price);
	   DBMS_OUTPUT.PUT_LINE('Book_log 테이블에 백업..');
	END;
/

insert into book values(1, 'Java Programming', 'HANBIT_Media', 9500);
--어? 근데 저 글자창 안나왔는데?

set serveroutput on;

insert into book values(2, 'SQL_Mannual', 'BIT', 750000);
--엇 메세지 뜨네


         
######################################################################
CURSOR 
######################################################################

drop PROCEDURE Interest;
CREATE OR REPLACE PROCEDURE Interest
 AS
    myInterest NUMERIC;
    Price NUMERIC;
    CURSOR InterestCursor IS SELECT saleprice FROM Orders;
 BEGIN
   myInterest := 0.0;
   OPEN InterestCursor;
   LOOP
       FETCH InterestCursor INTO Price;
       EXIT WHEN InterestCursor%NOTFOUND;
       IF Price >= 30000 THEN
           myInterest := myInterest + Price * 0.1;
       ELSE
           myInterest := myInterest + Price * 0.05;
       END IF;
    END LOOP;
    CLOSE InterestCursor;
    DBMS_OUTPUT.PUT_LINE(' 전체 이익 금액 = ' || myInterest);
 END;
 /