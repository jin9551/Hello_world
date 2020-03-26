





-- db 생성
create database haksa;
-- 테이블 접근
use 테이블명; 

-- 유저 생성 및 권한 부여
create user jin@localhost identified by '1111';



-- grant all privileges(이거 말고도 select,insert,update,등등) on (*은 모든 DB, 혹은 db명).(*은 모든 테이블, 혹은 테이블명) to '사용자명'@'호스트';
-- 모든 권한 삭제 REVOKE ALL PRIVILEGES ON *.* FROM 사용자명@호스트;
-- 권한 확인 SHOW GRANTS FOR 사용자명;
grant all privileges on haksa.* to jin@localhost;





-- 유저 삭제
DELETE FROM user WHERE user='username';
flush PRIVILEGES;
 
-- 기본적인 sql 명령문
-- create, drop / db 혹은 table 생성 및 삭제
-- update, delete / 정보 변경 혹은 삭제

-- alter은 테이블 변경에서는 아래의 일을 할 수 있다.
-- 테이블 이름 변경 (RENAME)
-- 테이블 칼럼 , 제약조건 추가 (ADD)
-- 테이블 변경 (CHANGE, MODIFY)
-- 테이블 제약 조건 제거 (DROP)

-- update는 특정정보를 where절로 골라서 변경한다.

-- insert into 테이블명 (칼럼명,칼럼명/이거 없어도 된다 values랑 칼럼수가 맞기만 하면 된다.) values(정보,정보,...)

insert into student values ('20141001', 'John', 'Sierra117', 10, 4, 1, 'd', '1990501', '1', '01066', '101-203', '010', '4503', '7570', '010-4053-7570');

insert into fee values ('20141001', '2020', 1, 1, 200, 200, 'jg', 200, 50, 'y', '2020-02-01');


insert into attend values ('20141001', '2020', 1, 1, 'hi', '1', 3, 3, '1', '1', '2020-03-01');

insert into professor values('1', 'Elizabeth', 'Ellie', '2020-03-26');

insert into subject values('1', 'nursing', 'nursing', '1990');

insert into department values(10, 'Ganho', 'Dept. of Nursing', '1991-02-01');



-- rollback;
-- savepoint aa; 저장지점 설정
-- truncate table; 
-- set autocommit = 0; 자동 커밋 막기
-- commit; 

-- 1.Delete
-- - 데이터만 삭제 되며 테이블 용량은 줄어 들지 않는다. 또한 삭제후 잘못 삭제한 것을 되돌릴 수 있다.
-- - TABLE이나 CLUSTER에 행이 많으면 행이 삭제될 때마다 많은 SYSTEM 자원이 소모 된다.
-- - Commit이전에는 Rollback이 가능하다.
-- - 롤백정보를 기록 하므로 Truncate에 비해서 느리다.
-- - 전체 또는 일부만 삭제 가능 하다.
-- - 삭제 행수를 반환 한다.
-- - 데이터를 모두 Delete해도 사용했던 Storage는 Release 처리 되지 않는다.

 

 

-- 2.Truncate - 테이블의 모든 로우를 제거하는 Truncate Table
-- - 테이블을 최초 생성된 초기상태로 만든다.
-- - 용량이 줄어들고, 인덱스 등도 모두 삭제 된다.
-- - Rollback 불가능 하다.
-- - 무조건 전체 삭제만 가능 하다.
-- - 삭제 행수를 반환 하지 않는다.
-- - 테이블이 사용했던 Storage중 최초 테이블 생성시 할당된 Storage만 남기고 Release 처리 된다.

 

 

-- 3. Drop table - 테이블 구조를 제거
-- 기존 테이블의 존재를 제한다. (테이블의 정의 자체를 완전히 삭제한다)
-- Rollback 불가능 하다.
-- 테이블이 사용했던 Storage는 모두 Release 처리 된다.





-- mysql db 확인
use mysql;
-- mysql 테이블들 확인
show tables;
-- user 테이블 칼람확인
desc user;
-- 비밀번호 설정상태 확인
select host,user,plugin,authentication_string, password_last_changed from user;

-- 유저 비밀번호 바꾸기 1
 alter user 'jin'@'localhost' identified with mysql_native_password by '0000';
 flush privileges;
-- 유저 비밀번호 바꾸기 2
set password = '1111';

-- 다른 유저 비밀번호 바꾸기 3
set password for 'root'@'localhost' = '0000';



-- 테이블 생성
create table department(
    dept_code int(2) Not null,
    dept_name char(30) Not null,
    dept_ename varchar(50),
    create_date date default null,
    primary key (dept_code)
) engine = innoDB;

create table student(
    stu_no char(10) Not null,
    stu_name char(10) Not null,
    stu_ename varchar(30),
    dept_code int(2) Not null,
    garde int(1) Not null,
    class int(1) Not null,
    juya char(2),
    birthday varchar(8) Not null,
    gender varchar(1) Not null,
    post_no varchar(5) Not null,
    address varchar(100),
    tel1 varchar(3),
    tel2 varchar(4),
    tel3 varchar(5),
    mobile varchar(14),
    primary key(stu_no),

    -- 외래키 선언
    -- constraint 이름 foreign key(칼럼명)
    -- references 테이블명(칼럼명)
    constraint s_dp_fk foreign key(dept_code)
    references department(dept_code)
) engine = innoDB;

create table fee(
    stu_no varchar(10) Not null,
    fee_year varchar(4) Not null,
    fee_term int(1) Not null,
    fee_enter int(7),
    fee_price int(7) Not null,
    fee_total int(7) Default '0' Not null,
    jang_code char(2) Null,
    jang_total int(7),
    fee_pay int(7) Default '0' Not null,
    fee_div char(1) Default 'N' Not null,
    fee_date date Not null,
    primary key (stu_no,fee_year,fee_term)
 ) engine = innoDB;

 create table score(
     stu_no char(10) Not null,
     sco_year char(4) Not null,
     sco_term int(1) Not null,
     req_point int(2),
     take_point int(2),
     exam_avg float(2,1),
     exam_total int(4),
     sco_div char(1),
     sco_date date,
     primary key (stu_no,sco_year,sco_term)
 ) engine = innoDB;

 create table subject(
     sub_code char(5) Not null,
     sub_name varchar(50) Not null,
     sub_ename varchar(50),
     create_year char(4),
     primary key (sub_code)
 ) engine = innoDB;

 create table professor(
     prof_code char(4) Not null,
     prof_name char(10) Not null,
     prof_ename varchar(30),
     create_date date default null,
     primary key (prof_code)
 ) engine = innoDB;

 create table circle(
     cir_num int(4) Not null auto_increment,
     cir_name char(30) Not null,
     stu_no char(10) Not null,
     stu_name char(10) Not null,
     president char(1) default '2' Not null,
     primary key (cir_num)
 ) engine = innoDB;

 create table post(
     post_no varchar(6) Not null,
     sido_name varchar(20) Not null,
     sido_eng varchar(40) Not null,
     sigun_name varchar(20) Not null,
     sigun_eng varchar(40) Not null,
     rowtown_name varchar(20) Not null,
     rowtown_eng varchar(40) Not null,
     road_code varchar(12),
     road_name varchar(80),
     road_eng varchar(80),
     underground_gubun varchar(1),
     building_bon int(5),
     building_boo int(5),
     management_no varchar(25) Not null,
     baedal varchar(40),
     town_building varchar(200),
     row_code varchar(10) Not null,
     row_dongname varchar(10) Not null,
     ri_name varchar(20),
     administration_name varchar(40),
     mountain_gubun varchar(1),
     bungi int(4),
     town_no varchar(2),
     ho int(4),
     gu_post_no varchar(6),
     post_seq varchar(3),
     primary key (management_no)
 ) engine = innoDB;



-- view 생성

create view view_name(column1,column2,column3) AS
select (column1,column2,calculations)
from tbl_selected_db;

--mysql 종료

quit;