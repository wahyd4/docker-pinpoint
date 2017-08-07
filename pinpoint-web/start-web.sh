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

MAIL_ENABLE=${MAIL_ENABLE:-false}
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

cp /assets/pinpoint-web.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/pinpoint-web.properties
cp /assets/hbase.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/hbase.properties

sed -i "s/cluster.enable=true/cluster.enable=${CLUSTER_ENABLE}/g" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/pinpoint-web.properties
sed -i "s/cluster.zookeeper.address=localhost/cluster.zookeeper.address=${CLUSTER_ZOOKEEPER_ADDRESS}/g" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/pinpoint-web.properties
if [ "$CLUSTER_WEB_TCP_PORT" != "" ]; then
    sed -i "/cluster.web.tcp.port=/ s/=.*/=${CLUSTER_WEB_TCP_PORT}/" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/pinpoint-web.properties
fi
if [ "$CLUSTER_CONNECT_ADDRESS" != "" ]; then
    sed -i "/cluster.connect.address=/ s/=.*/=${CLUSTER_CONNECT_ADDRESS}/" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/pinpoint-web.properties
fi

sed -i "s/admin.password=admin/admin.password=${ADMIN_PASSWORD}/g" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/pinpoint-web.properties

sed -i "s/hbase.client.host=localhost/hbase.client.host=${HBASE_HOST}/g" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/hbase.properties
sed -i "s/hbase.client.port=2181/hbase.client.port=${HBASE_PORT}/g" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/hbase.properties

if [ "$CONFIG_SENDUSAGE" != "" ]; then
    sed -i "/config.sendUsage=/ s/=.*/=${CONFIG_SENDUSAGE}/" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/pinpoint-web.properties
fi

if [ "$DISABLE_DEBUG" == "true" ]; then
    sed -i 's/level value="DEBUG"/level value="INFO"/' /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/log4j.xml
fi

if [ "$MAIL_ENABLE" == "true" ]; then
    sed -i 's/<\/beans>/<import resource="classpath:applicationContext-mail.xml" \/><\/beans>/' /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/applicationContext-web.xml
	
	if [ "$MAIL_HOST" != "" ]; then
        sed -i "s/smtp.gmail.com/${MAIL_HOST}/" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/applicationContext-mail.xml
	fi
	if [ "$MAIL_PORT" != "" ]; then
        sed -i "s/587/${MAIL_PORT}/" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/applicationContext-mail.xml
	fi
	if [ "$MAIL_USERNAME" != "" ]; then
        sed -i "s/UserName/${MAIL_USERNAME}/" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/applicationContext-mail.xml
	fi
	if [ "$MAIL_PASSWORD" != "" ]; then
        sed -i "s/PassWord/${MAIL_PASSWORD}/" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/applicationContext-mail.xml
	fi
	if [ "$MAIL_PROPERTIES_MAIL_TRANSPORT_PROTOCOL" != "" ]; then
	    sed -i "/mail.transport.protocol/ s/<\!-- //; s/ -->//; s/>.*</>${MAIL_PROPERTIES_MAIL_TRANSPORT_PROTOCOL}</" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/applicationContext-mail.xml
	fi
	if [ "$MAIL_PROPERTIES_MAIL_SMTP_PORT" != "" ]; then
		sed -i "/mail.smtp.port/ s/<\!-- //; s/ -->//; s/>.*</>${MAIL_PROPERTIES_MAIL_SMTP_PORT}</" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/applicationContext-mail.xml
	fi
	if [ "$MAIL_PROPERTIES_MAIL_SMTP_AUTH" != "" ]; then
		sed -i "/mail.smtp.auth/ s/<\!-- //; s/ -->//; s/>.*</>${MAIL_PROPERTIES_MAIL_SMTP_AUTH}</" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/applicationContext-mail.xml
	fi
	if [ "$MAIL_PROPERTIES_MAIL_SMTP_FROM" != "" ]; then
		sed -i "/mail.smtp.from/ s/<\!-- //; s/ -->//; s/>.*</>${MAIL_PROPERTIES_MAIL_SMTP_FROM}</" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/applicationContext-mail.xml
	fi
	if [ "$MAIL_PROPERTIES_MAIL_STARTTLS_ENABLE" != "" ]; then
		sed -i "/mail.smtp.starttls.enable/ s/<\!-- //; s/ -->//; s/>.*</>${MAIL_PROPERTIES_MAIL_STARTTLS_ENABLE}</" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/applicationContext-mail.xml
	fi
	if [ "$MAIL_PROPERTIES_MAIL_STARTTLS_REQUIRED" != "" ]; then
		sed -i "/mail.smtp.starttls.required/ s/<\!-- //; s/ -->//; s/>.*</>${MAIL_PROPERTIES_MAIL_STARTTLS_REQUIRED}</" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/applicationContext-mail.xml
	fi
	if [ "$MAIL_PROPERTIES_MAIL_DEBUG" != "" ]; then
		sed -i "/mail.debug/ s/<\!-- //; s/ -->//; s/>.*</>${MAIL_PROPERTIES_MAIL_DEBUG}</" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/applicationContext-mail.xml
	fi
	
fi

exec /usr/local/tomcat/bin/catalina.sh run