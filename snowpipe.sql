create storage integration snowpipe_integration
type=external_stage
storage_provider='S3'
enabled=TRUE
STORAGE_AWS_ROLE_ARN='arn:aws:iam::500018074150:role/snowflake_snowpipe_role_practise'
storage_allowed_locations=('*')

DESC INTEGRATION snowpipe_integration;

create table employees(
    id          int,
    first_name   string,
    last_name string,
    email     string,
    location  string,
    department string
)

list @my_stage2
create or replace stage my_stage2
storage_integration=snowpipe_integration
url='s3://dw-course-snowflake/snowpipe-practise/'
file_format=csv_format


desc  my_stage2

list @my_stage2

copy into employees
from @my_stage2
file_format=csv_format

create pipe my_employees_pipe
auto_ingest=True
as
copy into employees
from @my_stage2
file_format=csv_format


select * from employees
where first_name='Gold'

show pipes

SELECT system$PIPE_STATUS('my_employees_pipe');
