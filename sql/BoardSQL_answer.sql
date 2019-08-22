##########################
게시판 관련 SQL 작성
##########################

create table users(
	id varchar2(10) CONSTRAINT users_id_pk primary key,
	password varchar2(15) CONSTRAINT users_pw_nn not null,
	name varchar2(15) CONSTRAINT users_name_nn not null,
	role char(9) CONSTRAINT users_role_nn not null
	-- user인지 admin인지 둘 만.
); 

create table board(
	seq number(10) CONSTRAINT board_nb_pk primary key,
	title varchar2(20) DEFAULT '제목없음', --제목 없으면 안되지
	content varchar2(4000), --냉무;
	regdate date default sysdate,
	cnt number(10) default 0,
	id varchar2(10) CONSTRAINT board_id_fk references users(id) on delete set null
);
--아이디 지워져도 글을 올렸다는 흔적 남겨야지
--굳이 foreign key라고 남기지 않아도 references 자체가 FK라는 것을;;

role char(3)으로 했다가 (9)으로 변경
--에러 ; value too large for column "MADANG"."USERS"."ROLE" (actual: 9, maximum: 6)
alter는 테이블 자체 환경설정을 관리 (Da이블 Definition Language)
alter table users modify(role char(9))


###



##회원등록 (비밀번호는 대/소문자 구분)
insert into users values('jakeshin', 'bit', 'Shin', '관리자');
insert into users values('ronaldo7', 'juventus', 'Ronaldo', '일반인');
insert into users values('messi10', 'barcelona', 'Messi', '일반인');
insert into users values('hazard7', 'RealMardrid', 'Hazard', '일반인');

##회원정보수정 (비밀번호만)
update users 
set password = 'realmardrid'
where id = 'ronaldo7';

##로그인
select *
from users
where id = 'jakeshin' and password = 'bit';

#아이디 존재
select *
from users
where lower(id) = lower('ronaldo7');

#비밀번호 확인
select password
from users
where id ='ronaldo7';


##게시판 글 등록
(cnt, id) 미정
create sequence seq_seq;
insert into board values(seq_seq.nextval, 'Heart Shaker', '어쩔 수 없어 반했으니까!', default, default, 'ronaldo07');

##추가참고
insert into board (seq, title, content, id)
values ()nvl(max(seq), 0)+1 from board), 'sql 더쉽게, 더 깊게',


##게시판 글 수정
update board
set content ='';

##게시판 글 삭제
delete from board
where title = '';

##데이터검색
select *
from board
where title = '' or id = '';

(1차수정)
select *
from board
where lower(title) = lower('') or lower(id) = lower('');

(2차수정)
select *
from board
where (lower(title) like lower('%blah%')) or lower(id) = lower('%blah%');

##전체 등록글 갯수
select count(title)
from board;

##사용자별 등록글 갯수
select id, count(title)
from board
group by id;

##월별 게시글 갯수
select to_char(regdate, 'mm') 월별, count(to_char(regdate, 'mm'))
from board
group by to_char(regdate, 'mm')
order by to_char(regdate, 'mm')

##사용자별 게시글 검색
select id, title
from board
group by id, title
order by id

##제목으로 게시글 검색
select title, content
from board
where title = ''; 

