create tablespace 
zgq_space1
datafile 'D:/ORACLE/ORADATA/ZGQORCL/zgq_space1.dbf' 
size 20M 
autoextend on next 5m
maxsize unlimited;

create tablespace zgq_space2 DATAFILE
'D:/ORACLE/ORADATA/ZGQORCL/zgq_space2.bdf' SIZE 50M
AUTOEXTEND ON NEXT 5M MAXSIZE 100M;

create tablespace zgq_space3 DATAFILE
'D:/ORACLE/ORADATA/ZGQORCL/zgq_space3.bdf' SIZE 50M
AUTOEXTEND ON NEXT 5M MAXSIZE 100M;

create tablespace zgq_space4 DATAFILE
'D:/ORACLE/ORADATA/ZGQORCL/zgq_space4.bdf' SIZE 50M
AUTOEXTEND ON NEXT 5M MAXSIZE 100M;

create table goods (
    goods_no char(5) not null primary key,
    goods_name char(20) not null,
    goods_class char(8),
    goods_spec char(10),
    goods_brand char(10),
    intake_price float not null CHECK(intake_price > 0),
    outtake_price float not null CHECK(outtake_price > 0)
)TABLESPACE zgq_space1;

create table stock (
    goods_no char(5) not null,
    stock_no char(20) not null,
    size_ char(10),
    position_ char(20),
    store_time date not null,
    take_time date not null,
    outtake_size char(10),
    CONSTRAINT stock_goods_fk1 FOREIGN KEY (goods_no) REFERENCES goods (goods_no)
)TABLESPACE zgq_space1;

create table agents (
    agent_no char(5) not null primary key,
    office_name char(10) not null,
    agent_name char(10) not null,
    telephone char(11),
    goods_no char(5),
    CONSTRAINT agents_goods_fk1 FOREIGN KEY (goods_no) REFERENCES goods (goods_no)
)TABLESPACE zgq_space1;

create table retailer (
    retailer_no char(5) not null primary key,
    retailer_name char(10) not null,
    categorys  char(10) not null,
    agent_no char(5) not null,
    title char(10),
    admission_time date not null,
    birthday date not null,
    CONSTRAINT retailer_agents_fk1 FOREIGN KEY (agent_no) REFERENCES agents (agent_no)
)TABLESPACE zgq_space1;

create table registration_form 
(
registration_no char(5 byte) not null primary key
, agent_no char(5 byte) not null 
, registration_class char(15 byte) not null 
, exit_ char(2 byte) 
, price float(126) 
, registration_date date not null 
, constraint registration_form_agent_fk1 foreign key (agent_no) references agents (agent_no)
) partition by range (registration_date)
(
    partition p1 values less than (to_date(' 2018-01-01 00:00:00', 'syyyy-mm-dd hh24:mi:ss', 'nls_calendar=gregorian')) tablespace zgq_space1,

    partition p2 values less than (to_date(' 2019-01-01 00:00:00', 'syyyy-mm-dd hh24:mi:ss', 'nls_calendar=gregorian')) tablespace zgq_space2,

    partition p3 values less than (to_date(' 2020-01-01 00:00:00', 'syyyy-mm-dd hh24:mi:ss', 'nls_calendar=gregorian')) tablespace zgq_space3,
    
    partition p4 values less than (maxvalue) tablespace zgq_space4
)

create table customer (
    customer_no char(5) not null primary key,
    customer_name char(10) not null,
    goods_class char(10) not null,
    class char(10) not null,
    tel  char(11),
    retailer_num char(5),
    address char(20),
    registration_no char(5)
)TABLESPACE zgq_space1;

create user zgq_user1 IDENTIFIED by 123;
create user zgq_user2 IDENTIFIED by 123;
alter user zgq_user1 quota unlimited on zgq_space1;
alter user zgq_user2 quota unlimited on zgq_space1;

create role zgq_role1;
create role zgq_role2;
grant select any table to zgq_role1;
grant select any table to zgq_role2;
grant update any table to zgq_role2;

grant zgq_role1 to zgq_user1;
grant zgq_role2 to zgq_user2;

grant create session,resource to zgq_user1,zgq_user2;

declare
dt date;
registration_no char(5);
agent_no char(5);
registration_class char(15);
exit_  char(2);
price float;
begin


insert into goods (goods_no,goods_name,goods_class,goods_spec,goods_brand,intake_price,outtake_price) values ('1','冰箱','家电','100L','美的',1500.0,2000.0);
insert into goods (goods_no,goods_name,goods_class,goods_spec,goods_brand,intake_price,outtake_price) values ('2','电视机','家电','24英寸','乐视',2000.0,3000.0);
insert into goods (goods_no,goods_name,goods_class,goods_spec,goods_brand,intake_price,outtake_price) values ('3','优酸乳','饮料','450g/瓶','伊利',1.5,2.5);
insert into goods (goods_no,goods_name,goods_class,goods_spec,goods_brand,intake_price,outtake_price) values ('4','水杯','家用','500ml/个','乐扣',65.0,80.0);
insert into goods (goods_no,goods_name,goods_class,goods_spec,goods_brand,intake_price,outtake_price) values ('5','乐事','视频','500g/袋','乐事',2.5,5.0);

insert into agents (agent_no,office_name,agent_name,telephone,goods_no) values ('1001','沃尔玛','小王','110','1');
insert into agents (agent_no,office_name,agent_name,telephone,goods_no) values ('1002','好乐购','小李','119','2');
insert into agents (agent_no,office_name,agent_name,telephone,goods_no) values ('1003','伊藤洋','小高','120','3');
insert into agents (agent_no,office_name,agent_name,telephone,goods_no) values ('1004','千盛','小曾','999','4');
insert into agents (agent_no,office_name,agent_name,telephone,goods_no) values ('1005','百家乐','小肖','111','5');
for i in 1..50000
loop
    if i mod 3 =0 then
    dt:=to_date('2018-01-01','yyyy-mm-dd')+(i mod 60); 
--PARTITION_2018
    elsif i mod 6 =1 then
    dt:=to_date('2019-01-01','yyyy-mm-dd')+(i mod 60); 
--PARTITION_2019
    elsif i mod 6 =2 then
    dt:=to_date('2020-01-01','yyyy-mm-dd')+(i mod 60); 
--PARTITION_2020
    end if;
    --插入挂号单
    registration_no := i;
    agent_no := case i mod 6 when 0 then '1001' when 1 then '1002' when 2 then '1003' when 4 then '1004' else '1005'end;
registration_class := CASE i MOD 6 WHEN 0 THEN '零售' WHEN 1 THEN '批发' WHEN 2 THEN'少量批'WHEN 3 THEN '网络' WHEN 4 THEN '换货' ELSE '折扣' END;
    exit_ := case i mod 2 when 0 then 'Y' ELSE 'N' end;
    price := dbms_random.value(5,30);
    insert /*+append*/ into registration_form (registration_no,agent_no,registration_class,exit_,price,registration_date)
values (registration_no,agent_no,registration_class,exit_,price,dt);

end loop;
end;

select count(*) from zgq.REGISTRATION_FORM PARTITION(p2);
select count(*) from REGISTRATION_FORM PARTITION(p3);
select count(*) from REGISTRATION_FORM PARTITION(p4);

create or replace PACKAGE MyPack IS
  FUNCTION Get_TOTAL(dt1 char,dt2 char) RETURN NUMBER;
  PROCEDURE get_people(dt1 char,dt2 char);
END MyPack;
/
create or replace PACKAGE BODY MyPack IS
FUNCTION Get_TOTAL(dt1 char,dt2 char) RETURN NUMBER
  AS
    N  NUMBER;
    BEGIN
     select sum(price) into N from REGISTRATION_FORM where REGISTRATION_DATE >= to_date(dt1,'yyyy-mm-dd hh24:mi:ss')
     and REGISTRATION_DATE <= to_date(dt2,'yyyy-mm-dd hh24:mi:ss');
       RETURN N;
    END;

PROCEDURE get_people(dt1 char,dt2 char)
  AS
    a1 NUMBER;
    b1 NUMBER;
    c1 NUMBER;
    d1 NUMBER;
    e1 NUMBER;
    f1 NUMBER;
    cursor cur is
      select * from REGISTRATION_FORM where REGISTRATION_DATE >= to_date(dt1,'yyyy-mm-dd hh24:mi:ss')
      and REGISTRATION_DATE <= to_date(dt2,'yyyy-mm-dd hh24:mi:ss');
    begin
      a1 := 0;
      b1 := 0;
      c1 := 0;
      d1 := 0;
      e1 := 0;
      f1 := 0;
      --使用游标
      for v in cur 
      LOOP
         if v.REGISTRATION_CLASS = '零售'
            then a1 := a1 + 1;
         elsif v.REGISTRATION_CLASS = '批发'
            then b1 := b1 + 1;
         elsif v.REGISTRATION_CLASS = '少量批'
            then c1 := c1 + 1;
         elsif v.REGISTRATION_CLASS = '网络'
            then d1 := d1 + 1;
         elsif v.REGISTRATION_CLASS = '换货'
            then e1 := e1 + 1;
         elsif v.REGISTRATION_CLASS = '折扣'
            then f1 := f1 + 1;
         end if;
     END LOOP;
        DBMS_OUTPUT.PUT_LINE('零售商品数为：' ||  a1);
        DBMS_OUTPUT.PUT_LINE('批发商品数为：' ||  b1);
        DBMS_OUTPUT.PUT_LINE('少量批商品数为：' ||  c1);
        DBMS_OUTPUT.PUT_LINE('网络数商品为：' ||  d1);
        DBMS_OUTPUT.PUT_LINE('换货商品数为：' ||  e1);
        DBMS_OUTPUT.PUT_LINE('折扣商品数为：' ||  f1);
    end;
END MyPack;

select MYPACK.GET_TOTAL('2018-03-21 12:00:00','2019-02-28 12:00:00') AS 总收入 FROM dual;

set SERVEROUTPUT ON
DECLARE
dt1 char(30);
dt2 char(30);
BEGIN
dt1 :='2018-03-21 12:00:00';
dt2 :='2019-02-28 12:00:00';
MYPACK.GET_PEOPLE(dt1,dt2);
END;