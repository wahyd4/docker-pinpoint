# DESCRIPTION       joinjaces-example + pinpoint-agent
# TO_BUILD          docker build -t joinfaces-exemple-with-pinpoint-agent .
# TO_RUN            docker run -it \
#                       -e COLLECTOR_IP="198.162.0.18" \
#                       -e PROFILER_APPLICATIONSERVERTYPE="TOMCAT" \
#                       -e PROFILER_TOMCAT_CONDITIONAL_TRANSFORM="false" \
#                       -e PROFILER_SAMPLING_RATE="1" \
#                       -e PROFILER_JSON_JSONLIB="true" \
#                       -e PROFILER_JSON_JACKSON="true" \
#                       -e PROFILER_JSON_GSON="true" \
#                       -v /home/marcosamm/.m2/repository:/root/.m2/repository \
#                       joinfaces-exemple-with-pinpoint-agent \
#                       /bin/sh -c "xvfb-run mvn -DwebDriverType=chrome install verify"

FROM marcosamm/pinpointagent-chrome-maven-oraclejdk:latest

WORKDIR /opt

RUN wget https://github.com/marcosamm/joinfaces-example/archive/master.zip \
    && unzip master.zip \
    && mv joinfaces-example-master joinfaces-example \
    && rm master.zip

WORKDIR /opt/joinfaces-example
