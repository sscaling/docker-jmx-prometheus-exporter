FROM openjdk:8-jre

ARG buildversion=0.14.0
ARG buildjar=jmx_prometheus_httpserver-$buildversion-jar-with-dependencies.jar

ENV version $buildversion
ENV jar $buildjar
ENV SERVICE_PORT 5556
ENV CONFIG_YML ~/jmx_exporter/config.yml

RUN useradd -ms /bin/bash prom_exporter
USER prom_exporter
WORKDIR /home/prom_exporter

RUN mkdir -p ~/jmx_exporter
RUN curl -L https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_httpserver/$version/$jar -o ~/jmx_exporter/$jar
COPY config.yml ~/jmx_exporter/

CMD ["sh", "-c", "java $JVM_OPTS -jar ~/jmx_exporter/$jar $SERVICE_PORT $CONFIG_YML" ]