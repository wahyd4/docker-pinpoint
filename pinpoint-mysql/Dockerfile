FROM mysql:5.7

ENV PINPOINT_VERSION=1.6.2

ADD CreateTableStatement-mysql.sql /docker-entrypoint-initdb.d
ADD SpringBatchJobReositorySchema-mysql.sql /docker-entrypoint-initdb.d