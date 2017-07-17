FROM marcosamm/pinpointagent-oraclejre:1.6.2-8u131

COPY app/joinfaces-example/ /opt/joinfaces-example
COPY app/pinpoint/ /opt/pinpoint

EXPOSE 8080

ENTRYPOINT ["java", "-javaagent:/opt/pinpoint/pinpoint-bootstrap.jar", "-Dpinpoint.agentId=dockerfile",  "-Dpinpoint.applicationName=joinfaces-example", "-jar", "/opt/joinfaces-example/joinfaces-example-2.4.0.jar"]
