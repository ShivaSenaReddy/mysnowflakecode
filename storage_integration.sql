create or replace storage integration my_init
type='external_stage'
storage_provider='s3'
enabled=True
storage_aws_role_arn='arn:aws:iam::500018074150:role/snowflake_role_jssr2'
storage_allowed_locations=('*')

describe integration my_init

show file formats

create or replace stage my_stage1
storage_integration=my_init
url='s3://dw-course-snowflake/instacart/'
file_format=csv_format

list @my_stage1/aisles.csv

create table aisles(
id int,
aisle string)


copy into aisles
from @my_stage1/aisles.csv
file_format=(format_name=csv_format)
-- files=('aisles.csv')

select * from aisles