
drop table users;
create table users(
	id varchar2(10) CONSTRAINT users_id_pk primary key,
	password varchar2(15) CONSTRAINT users_pw_nn not null,
	name varchar2(15) CONSTRAINT users_name_nn not null,
	role varchar2(10) default 'user' check(role in ('user','admin'))
); 

drop table board;
create table board(
	seq number(10) CONSTRAINT board_nb_pk primary key,
	title varchar2(20) DEFAULT '제목없음',
	content varchar2(4000),
	regdate date default sysdate,
	cnt number(10) default 0,
	id varchar2(10) CONSTRAINT board_id_fk references users(id) on delete set null
);


##회원 등록

insert into users values('admin', 'bit', 'Shin', 'admin');
insert into users values('ronaldo7', 'juventus', 'Ronaldo', 'user');
insert into users values('messi10', 'barcelona', 'Messi', 'user');
insert into users values('hazard7', 'RealMardrid', 'Hazard', 'user');

--해주고 commint 해야함

##게시글

create sequence board_seq;

insert into board 
values (board_seq.nextval, 'java의 정석','java for while loop', '19/05/05', default, 'ronaldo7');

--성공하기 전 에러가 몇 번 났다면, 등록이 안됐더라도 그것까지 count 해서 나옴.
--그러면 drop 시전

drop sequence board_seq;

insert into board 
values (board_seq.nextval, 'sql 더쉽게, 더 깊게', 'create grant select',
'19/02/24', default, 'messi10');

delete from board;
--이건 게시판 지우는게 아니라 게시판 초기화 싹 밀어버리기
commit;

--다시 시퀀스 생성

