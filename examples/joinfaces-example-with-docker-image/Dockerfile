# DESCRIPTION       Monitoring JoinFaces-example with pinpoint-agent
# TO_BUILD          docker build -t joinfaces-example-with-pinpoint-agent .
# TO_RUN            docker run -d -p 8080:8080 joinfaces-example-with-pinpoint-agent
FROM marcosamm/pinpointagent-oraclejre:latest

COPY app/joinfaces-example/ /opt/joinfaces-example
COPY app/pinpoint-agent/ /opt/pinpoint-agent

EXPOSE 8080

ENTRYPOINT ["java", "-javaagent:/opt/pinpoint-agent/pinpoint-bootstrap.jar", "-Dpinpoint.agentId=dockerfile",  "-Dpinpoint.applicationName=joinfaces-example", "-jar", "/opt/joinfaces-example/joinfaces-example-2.4.0-SNAPSHOT.jar"]
