FROM marcosamm/pinpointagent-chrome-maven-oraclejdk:1.6.2-58-3.5.0-8u131

WORKDIR /opt

RUN wget https://github.com/marcosamm/joinfaces-example/archive/master.zip \
    && unzip master.zip \
    && mv joinfaces-example-master joinfaces-example \
    && rm master.zip
    
COPY app/pinpoint/ /opt/pinpoint

WORKDIR /opt/joinfaces-example