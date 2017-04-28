# docker-pinpoint

This repo contains the docker images of Pinpoint, or you can just use the docker compose file run pinpoint in seconds.

### To build the images
* Go to a folder
* `docker build -t repo-name:latest .` to build the image

### To run all containers

```
docker-compose up -d
```

Open your browser and then go to <http://localhost:28080>


### Add your own Java based application to be monitored.

```shell
java  -javaagent:/some-absolute-path/pinpoint-agent-1.6.1/pinpoint-bootstrap-1.6.1.jar -Dpinpoint.agentId=some-union-id -Dpinpoint.applicationName=some-name -jar build/libs/wise-log-1.0.0-SNAPSHOT.jar

```


If you plan to use external volumes for hbase you should fill hbase first.
Please run this script inside hbase container
```
${HBASE_HOME}/bin/hbase shell /opt/hbase/hbase-create.hbase; ${HBASE_HOME}/bin/stop-hbase.sh
```
