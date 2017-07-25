#!/bin/bash
set -e
set -x

PINPOINT_AGENT_HOME=${PINPOINT_AGENT_HOME:-/assets/pinpoint-agent}

COLLECTOR_IP=${COLLECTOR_IP:-127.0.0.1}
COLLECTOR_TCP_PORT=${COLLECTOR_TCP_PORT:-9994}
COLLECTOR_UDP_STAT_LISTEN_PORT=${COLLECTOR_UDP_STAT_LISTEN_PORT:-9995}
COLLECTOR_UDP_SPAN_LISTEN_PORT=${COLLECTOR_UDP_SPAN_LISTEN_PORT:-9996}

PROFILER_SAMPLING_RATE=${PROFILER_SAMPLING_RATE:-20}

PROFILER_APPLICATIONSERVERTYPE=${PROFILER_APPLICATIONSERVERTYPE:-}
PROFILER_TOMCAT_CONDITIONAL_TRANSFORM=${PROFILER_TOMCAT_CONDITIONAL_TRANSFORM:-true}

PROFILER_JSON_GSON=${PROFILER_JSON_GSON:-false}
PROFILER_JSON_JACKSON=${PROFILER_JSON_JACKSON:-false}
PROFILER_JSON_JSONLIB=${PROFILER_JSON_JSONLIB:-false}

DISABLE_DEBUG=${DISABLE_DEBUG:-true}

cp -f /assets/pinpoint.config ${PINPOINT_AGENT_HOME}/pinpoint.config

sed -i "s/profiler.collector.ip=127.0.0.1/profiler.collector.ip=${COLLECTOR_IP}/g" ${PINPOINT_AGENT_HOME}/pinpoint.config

sed -i "s/profiler.collector.tcp.port=9994/profiler.collector.tcp.port=${COLLECTOR_TCP_PORT}/g" ${PINPOINT_AGENT_HOME}/pinpoint.config
sed -i "s/profiler.collector.stat.port=9995/profiler.collector.stat.port=${COLLECTOR_UDP_STAT_LISTEN_PORT}/g" ${PINPOINT_AGENT_HOME}/pinpoint.config
sed -i "s/profiler.collector.span.port=9996/profiler.collector.span.port=${COLLECTOR_UDP_SPAN_LISTEN_PORT}/g" ${PINPOINT_AGENT_HOME}/pinpoint.config
sed -i "s/profiler.sampling.rate=20/profiler.sampling.rate=${PROFILER_SAMPLING_RATE}/g" ${PINPOINT_AGENT_HOME}/pinpoint.config
if [ "$PROFILER_APPLICATIONSERVERTYPE" != "" ]; then
    sed -i "s/#profiler.applicationservertype=TOMCAT/profiler.applicationservertype=${PROFILER_APPLICATIONSERVERTYPE}/g" ${PINPOINT_AGENT_HOME}/pinpoint.config
fi
sed -i "s/profiler.tomcat.conditional.transform=true/profiler.tomcat.conditional.transform=${PROFILER_TOMCAT_CONDITIONAL_TRANSFORM}/g" ${PINPOINT_AGENT_HOME}/pinpoint.config
sed -i "s/profiler.json.gson=false/profiler.json.gson=${PROFILER_JSON_GSON}/g" ${PINPOINT_AGENT_HOME}/pinpoint.config
sed -i "s/profiler.json.jackson=false/profiler.json.jackson=${PROFILER_JSON_JACKSON}/g" ${PINPOINT_AGENT_HOME}/pinpoint.config
sed -i "s/profiler.json.jsonlib=false/profiler.json.jsonlib=${PROFILER_JSON_JSONLIB}/g" ${PINPOINT_AGENT_HOME}/pinpoint.config

if [ "$DISABLE_DEBUG" == "true" ]; then
    sed -i 's/level value="DEBUG"/level value="INFO"/' ${PINPOINT_AGENT_HOME}/lib/log4j.xml
fi

exec tail -f /dev/null