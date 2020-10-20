FROM openjdk:8-jre

ARG buildversion=0.13.0
ARG buildjar=jmx_prometheus_httpserver-$buildversion-jar-with-dependencies.jar

ENV version $buildversion
ENV jar $buildjar
ENV SERVICE_PORT 5556
ENV CONFIG_YML /opt/jmx_exporter/config.yml
ENV JVM_OPTS -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=5555 

RUN mkdir -p /opt/jmx_exporter
RUN useradd -ms /bin/bash prom_exporter
RUN chown prom_exporter:prom_exporter /opt/jmx_exporter

USER prom_exporter

RUN curl -L https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_httpserver/$version/$jar -o /opt/jmx_exporter/$jar
COPY config.yml /opt/jmx_exporter/

CMD ["sh", "-c", "java $JVM_OPTS -jar /opt/jmx_exporter/$jar $SERVICE_PORT $CONFIG_YML" ]