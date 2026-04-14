drop file format csv_format1
create file format  if not exists csv_format1
type=csv
skip_header=1
field_delimiter=','
field_optionally_enclosed_by='"'

drop file format csv_format2

create file format  if not exists csv_format2
type=csv
skip_header=1
field_delimiter='\t'
-- field_optionally_enclosed_by='"'

create  stage if not exists stage1
file_format=csv_format1
url='s3://news-bucket-jssr/transformed_data/news_data/'
credentials=(AWS_KEY_ID='AWS_KEY' AWS_SECRET_KEY ='AWS_SECRET'
)

list @stage1

drop storage integration news_init

create storage integration news_init
type=external_stage
enabled=true
storage_provider=s3
storage_aws_role_arn='arn:aws:iam::500018074150:role/news_role_for_snowflake'
storage_allowed_locations=('s3://news-bucket-jssr/transformed_data/news_data/')

-- drop stage stage2

create or replace stage stage2
file_format=csv_format1
url='s3://news-bucket-jssr/transformed_data/news_data/'
storage_integration=news_init

describe integration news_init

list @stage2


create or replace table news(
source_name varchar(255),
author varchar(255),
title	varchar(255),
description varchar(1000),
published_at timestamp_tz

)

copy into MY_DATABASE.EXTERNAL_STAGE.NEWS
from @stage2

select * from news


select * from @stage2
(file_format=>csv_format1)

list @stage2

SELECT $1, $2, $3, $4, $5, $6
FROM @stage2
(FILE_FORMAT => 'csv_format1')

desc file format csv_format2

copy into  news
from @stage2

select * from news

create pipe newspipe
auto_ingest=true
as copy into  news
from @stage2

show pipes