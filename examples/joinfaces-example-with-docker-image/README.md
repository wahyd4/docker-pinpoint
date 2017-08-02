# Monitoring joinfaces-example application with docker image
This example shows how to run and monitor the joinfaces-example application with pinpoint-agent

### To build the image
```
docker build -t joinfaces-example-with-pinpoint-agent .
```

### To run container
```
docker run -d -p 8080:8080 joinfaces-example-with-pinpoint-agent
```

### To access
http://localhost:8080


### Note
* The following environment variables can be used to set pinpoint-agent configuration properties (pinpoint.config):
   - COLLECTOR_IP
   - PROFILER_APPLICATIONSERVERTYPE
   - PROFILER_TOMCAT_CONDITIONAL_TRANSFORM
   - PROFILER_SAMPLING_RATE
   - PROFILER_JSON_JSONLIB
   - PROFILER_JSON_JACKSON
   - PROFILER_JSON_GSON
* You can map a custom configuration file as a volume with the option: -v /path/to/pinpoint.config:/opt/pinpoint-agent/pinpoint.config:rw
* If the pinpoint.config file is mapped only with read permission (ro), do not use any environment variable to modify pinpoint-agent configuration parameters, this will cause errors.