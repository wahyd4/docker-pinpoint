# Monitoring joinfaces-example application with selenium tests
This example shows how to monitor the joinfaces-example application while running automated tests

## Running with [Dockerfile](Dockerfile)
### - To build the image
```
docker build -t joinfaces-exemple-with-pinpoint-agent .
```

### - To run container
```
docker run -it \
   -e COLLECTOR_IP="198.162.0.18" \
   -e PROFILER_APPLICATIONSERVERTYPE="TOMCAT" \
   -e PROFILER_TOMCAT_CONDITIONAL_TRANSFORM="false" \
   -e PROFILER_SAMPLING_RATE="1" \
   -e PROFILER_JSON_JSONLIB="true" \
   -e PROFILER_JSON_JACKSON="true" \
   -e PROFILER_JSON_GSON="true" \
   -v /home/marcosamm/.m2/repository:/root/.m2/repository \
   joinfaces-exemple-with-pinpoint-agent \
   /bin/sh -c "xvfb-run mvn -DwebDriverType=chrome install verify"
```

## Running without Dockerfile
```
docker run -it --rm \
   -e COLLECTOR_IP="192.168.0.18" \
   -e PROFILER_APPLICATIONSERVERTYPE="TOMCAT" \
   -e PROFILER_TOMCAT_CONDITIONAL_TRANSFORM="false" \
   -v /home/marcosamm/git/joinfaces-example/:/opt/app/ \
   -v /home/marcosamm/.m2/repository:/root/.m2/repository \
   marcosamm/pinpointagent-firefox-maven-oraclejdk \
   /bin/sh -c "cd /opt/app/; xvfb-run mvn clean install verify"
```
See too:
* [marcosamm/pinpointagent-chrome-maven-openjdk](https://hub.docker.com/r/marcosamm/pinpointagent-chrome-maven-openjdk/)
* [marcosamm/pinpointagent-chrome-maven-oraclejdk](https://hub.docker.com/r/marcosamm/pinpointagent-chrome-maven-oraclejdk/)
* [marcosamm/pinpointagent-chromium-maven-openjdk](https://hub.docker.com/r/marcosamm/pinpointagent-chromium-maven-openjdk/)
* [marcosamm/pinpointagent-chromium-maven-oraclejdk](https://hub.docker.com/r/marcosamm/pinpointagent-chromium-maven-oraclejdk/)
* [marcosamm/pinpointagent-firefox-maven-openjdk](https://hub.docker.com/r/marcosamm/pinpointagent-firefox-maven-openjdk/)
* [marcosamm/pinpointagent-firefox-maven-oraclejdk](https://hub.docker.com/r/marcosamm/pinpointagent-firefox-maven-oraclejdk/)

## Notes
* The following environment variables can be used to set pinpoint-agent configuration properties (pinpoint.config):
   - COLLECTOR_IP
   - PROFILER_APPLICATIONSERVERTYPE
   - PROFILER_TOMCAT_CONDITIONAL_TRANSFORM
   - PROFILER_SAMPLING_RATE
   - PROFILER_INCLUDE
   - PROFILER_ENTRYPOINT
   - PROFILER_JSON_JSONLIB
   - PROFILER_JSON_JACKSON
   - PROFILER_JSON_GSON
* You can map a custom configuration file as a volume with the option: -v /path/to/pinpoint.config:/opt/pinpoint-agent/pinpoint.config:rw
* If the pinpoint.config file is mapped only with read permission (ro), do not use any environment variable to modify pinpoint-agent configuration parameters, this will cause errors.