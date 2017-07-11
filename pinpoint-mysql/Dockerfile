FROM mysql:5.7

ENV PINPOINT_VERSION=1.6.2

ADD https://raw.githubusercontent.com/naver/pinpoint/$PINPOINT_VERSION/web/src/main/resources/sql/CreateTableStatement-mysql.sql /docker-entrypoint-initdb.d
ADD https://raw.githubusercontent.com/naver/pinpoint/$PINPOINT_VERSION/web/src/main/resources/sql/SpringBatchJobReositorySchema-mysql.sql /docker-entrypoint-initdb.d