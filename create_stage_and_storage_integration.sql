create database my_database

create schema external_stage

create table order_details(
 
   ORDER_ID     string,
   AMOUNT       int,
   PROFIT       int,
   QUANTITY     int,
   CATEGORY     string,
   SUBCATEGORy string
)

create table order_details1(
 
   ORDER_ID     string,
   AMOUNT       int,
   PROFIT       int,
   QUANTITY     int,
   CATEGORY     string,
   SUBCATEGORy string
)
create file format if not exists csv_format
type =csv
field_delimiter=','
file_extension='csv'
skip_header=1

copy into order_details
from 's3://dw-course-snowflake/order_details/OrderDetails.csv'
credentials=(AWS_KEY_ID='AKIAXI23GKITP4LFQYUP' AWS_SECRET_KEY='kt/gN5nQACwRfmiX/z1gZuS+84TNkbK4F9txxVC/')
file_format=(format_name=csv_format)

create or replace stage darshil_stage
url='s3://dw-course-snowflake/order_details/'
credentials=(AWS_KEY_ID='AKIAXI23GKITP4LFQYUP' AWS_SECRET_KEY='kt/gN5nQACwRfmiX/z1gZuS+84TNkbK4F9txxVC/')

desc stage darshil_stage

copy into order_details1
from @darshil_stage
file_format=(format_name=csv_format)
files=('OrderDetails.csv')

list @darshil_stage

select * from order_details
select * from order_details1

drop table order_details

show tables history

undrop table order_details
