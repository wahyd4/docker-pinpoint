#!/bin/bash
set -e
set -x

CLUSTER_ENABLE=${CLUSTER_ENABLE:-false}
CLUSTER_ZOOKEEPER_ADDRESS=${CLUSTER_ZOOKEEPER_ADDRESS:-localhost}
CLUSTER_WEB_TCP_PORT=${CLUSTER_WEB_TCP_PORT:-9997}
CLUSTER_CONNECT_ADDRESS=${CLUSTER_CONNECT_ADDRESS:-}

ADMIN_PASSWORD=${ADMIN_PASSWORD:-admin}

HBASE_HOST=${HBASE_HOST:-localhost}
HBASE_PORT=${HBASE_PORT:-2181}

CONFIG_SENDUSAGE=${CONFIG_SENDUSAGE:-true}

DISABLE_DEBUG=${DISABLE_DEBUG:-true}

JDBC_DRIVER=${JDBC_DRIVER:-com.mysql.jdbc.Driver}
JDBC_URL=${JDBC_URL:-jdbc:mysql://localhost:13306/pinpoint?characterEncoding=UTF-8}
JDBC_USERNAME=${JDBC_USERNAME:-admin}
JDBC_PASSWORD=${JDBC_PASSWORD:-admin}

echo -e "
jdbc.driverClassName=${JDBC_DRIVER}
jdbc.url=${JDBC_URL}
jdbc.username=${JDBC_USERNAME}
jdbc.password=${JDBC_PASSWORD}
" > /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/jdbc.properties

BATCH_ENABLE=${BATCH_ENABLE:-false}
BATCH_SERVER_IP=${BATCH_SERVER_IP:-127.0.0.1}
MAIL_HOST=${MAIL_HOST:-}
MAIL_PORT=${MAIL_PORT:-}
MAIL_USERNAME=${MAIL_USERNAME:-}
MAIL_PASSWORD=${MAIL_PASSWORD:-}
MAIL_PROPERTIES_MAIL_TRANSPORT_PROTOCOL=${MAIL_PROPERTIES_MAIL_TRANSPORT_PROTOCOL:-smtp}
MAIL_PROPERTIES_MAIL_SMTP_AUTH=${MAIL_PROPERTIES_MAIL_SMTP_AUTH:-true}
MAIL_PROPERTIES_MAIL_SMTP_PORT=${MAIL_PROPERTIES_MAIL_SMTP_AUTH:-}
MAIL_PROPERTIES_MAIL_SMTP_FROM=${MAIL_PROPERTIES_MAIL_SMTP_FROM:-}
MAIL_PROPERTIES_MAIL_STARTTLS_ENABLE=${MAIL_PROPERTIES_MAIL_STARTTLS_ENABLE:-true}
MAIL_PROPERTIES_MAIL_STARTTLS_REQUIRED=${MAIL_PROPERTIES_MAIL_STARTTLS_REQUIRED:-}
MAIL_PROPERTIES_MAIL_DEBUG=${MAIL_PROPERTIES_MAIL_DEBUG:-}

#Manipuled files with SED
WEB_INF_CLASSES_DIR=/usr/local/tomcat/webapps/ROOT/WEB-INF/classes
BATCH_PROPERTIES_FILE=${WEB_INF_CLASSES_DIR}/batch.properties
HBASE_PROPERTIES_FILE=${WEB_INF_CLASSES_DIR}/hbase.properties
PINPOINT_WEB_PROPERTIES_FILE=${WEB_INF_CLASSES_DIR}/pinpoint-web.properties
APPLICATION_CONTEXT_WEB_FILE=${WEB_INF_CLASSES_DIR}/applicationContext-web.xml
APPLICATION_CONTEXT_MAIL_FILE=${WEB_INF_CLASSES_DIR}/applicationContext-mail.xml
LOG4J_FILE=${WEB_INF_CLASSES_DIR}/log4j.xml

cp /assets/pinpoint-web.properties ${PINPOINT_WEB_PROPERTIES_FILE}
cp /assets/hbase.properties ${HBASE_PROPERTIES_FILE}

sed -i "s/cluster.enable=true/cluster.enable=${CLUSTER_ENABLE}/g" ${PINPOINT_WEB_PROPERTIES_FILE}
sed -i "s/cluster.zookeeper.address=localhost/cluster.zookeeper.address=${CLUSTER_ZOOKEEPER_ADDRESS}/g" ${PINPOINT_WEB_PROPERTIES_FILE}
if [ "$CLUSTER_WEB_TCP_PORT" != "" ]; then
    sed -i "/cluster.web.tcp.port=/ s/=.*/=${CLUSTER_WEB_TCP_PORT}/" ${PINPOINT_WEB_PROPERTIES_FILE}
fi
if [ "$CLUSTER_CONNECT_ADDRESS" != "" ]; then
    sed -i "/cluster.connect.address=/ s/=.*/=${CLUSTER_CONNECT_ADDRESS}/" ${PINPOINT_WEB_PROPERTIES_FILE}
fi

sed -i "s/admin.password=admin/admin.password=${ADMIN_PASSWORD}/g" ${PINPOINT_WEB_PROPERTIES_FILE}

sed -i "s/hbase.client.host=localhost/hbase.client.host=${HBASE_HOST}/g" ${HBASE_PROPERTIES_FILE}
sed -i "s/hbase.client.port=2181/hbase.client.port=${HBASE_PORT}/g" ${HBASE_PROPERTIES_FILE}

if [ "$CONFIG_SENDUSAGE" != "" ]; then
    sed -i "/config.sendUsage=/ s/=.*/=${CONFIG_SENDUSAGE}/" ${PINPOINT_WEB_PROPERTIES_FILE}
fi

if [ "$DISABLE_DEBUG" == "true" ]; then
    sed -i 's/level value="DEBUG"/level value="INFO"/' ${LOG4J_FILE}
fi

if [ "$BATCH_ENABLE" == "true" ]; then
    sed -i "/batch.enable=/ s/=.*/=${BATCH_ENABLE}/" ${BATCH_PROPERTIES_FILE}
    
    if [ "$BATCH_SERVER_IP" != "" ]; then
        sed -i "/batch.server.ip=/ s/=.*/=${BATCH_SERVER_IP}/" ${BATCH_PROPERTIES_FILE}
    fi
    
    sed -i 's/<\/beans>/<import resource="classpath:applicationContext-mail.xml" \/><\/beans>/' ${APPLICATION_CONTEXT_WEB_FILE}
	
    if [ "$MAIL_HOST" != "" ]; then
        sed -i "s/smtp.gmail.com/${MAIL_HOST}/" ${APPLICATION_CONTEXT_MAIL_FILE}
    fi
    if [ "$MAIL_PORT" != "" ]; then
        sed -i "s/587/${MAIL_PORT}/" ${APPLICATION_CONTEXT_MAIL_FILE}
    fi
    if [ "$MAIL_USERNAME" != "" ]; then
        sed -i "s/UserName/${MAIL_USERNAME}/" ${APPLICATION_CONTEXT_MAIL_FILE}
    fi
    if [ "$MAIL_PASSWORD" != "" ]; then
        sed -i "s/PassWord/${MAIL_PASSWORD}/" ${APPLICATION_CONTEXT_MAIL_FILE}
    fi
    if [ "$MAIL_PROPERTIES_MAIL_TRANSPORT_PROTOCOL" != "" ]; then
    	PATTERN="mail.transport.protocol"
        sed -i "/${PATTERN}/ s/<\!-- \| -->//g;/${PATTERN}/ s/>.*</>${MAIL_PROPERTIES_MAIL_TRANSPORT_PROTOCOL}</" ${APPLICATION_CONTEXT_MAIL_FILE}
    fi
    if [ "$MAIL_PROPERTIES_MAIL_SMTP_PORT" != "" ]; then
    	PATTERN="mail.smtp.port"
        sed -i "/${PATTERN}/ s/<\!-- \| -->//g;/${PATTERN}/ s/>.*</>${MAIL_PROPERTIES_MAIL_SMTP_PORT}</" ${APPLICATION_CONTEXT_MAIL_FILE}
    fi
    if [ "$MAIL_PROPERTIES_MAIL_SMTP_AUTH" != "" ]; then
    	PATTERN="mail.smtp.auth"
        sed -i "/${PATTERN}/ s/<\!-- \| -->//g;/${PATTERN}/ s/>.*</>${MAIL_PROPERTIES_MAIL_SMTP_AUTH}</" ${APPLICATION_CONTEXT_MAIL_FILE}
    fi
    if [ "$MAIL_PROPERTIES_MAIL_SMTP_FROM" != "" ]; then
    	PATTERN="mail.smtp.from"
        sed -i "/${PATTERN}/ s/<\!-- \| -->//g;/${PATTERN}/ s/>.*</>${MAIL_PROPERTIES_MAIL_SMTP_FROM}</" ${APPLICATION_CONTEXT_MAIL_FILE}
    fi
    if [ "$MAIL_PROPERTIES_MAIL_STARTTLS_ENABLE" != "" ]; then
    	PATTERN="mail.smtp.starttls.enable"
        sed -i "/${PATTERN}/ s/<\!-- \| -->//g;/${PATTERN}/ s/>.*</>${MAIL_PROPERTIES_MAIL_STARTTLS_ENABLE}</" ${APPLICATION_CONTEXT_MAIL_FILE}
    fi
    if [ "$MAIL_PROPERTIES_MAIL_STARTTLS_REQUIRED" != "" ]; then
    	PATTERN="mail.smtp.starttls.required"
        sed -i "/${PATTERN}/ s/<\!-- \| -->//g;/${PATTERN}/ s/>.*</>${MAIL_PROPERTIES_MAIL_STARTTLS_REQUIRED}</" ${APPLICATION_CONTEXT_MAIL_FILE}
    fi
    if [ "$MAIL_PROPERTIES_MAIL_DEBUG" != "" ]; then
    	PATTERN="mail.debug"
        sed -i "/${PATTERN}/ s/<\!-- \| -->//g;/${PATTERN}/ s/>.*</>${MAIL_PROPERTIES_MAIL_DEBUG}</" ${APPLICATION_CONTEXT_MAIL_FILE}
    fi
	
fi

exec /usr/local/tomcat/bin/catalina.sh run