Docker JMX exporter for Prometheus
==================================

Essentially another dockerised JMX Exporter image, this uses alpine-java and dumb-init to provide a relatively small image (approx 130Mb) and includes a released version of jmx_exporter from the [maven central repository](https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_httpserver/)

Available on [Docker hub](https://hub.docker.com/r/reasland/jmx-prometheus-exporter/)

Building docker image
---------------------

```
docker build -t reasland/jmx-prometheus-exporter .
```

### Build Arguments

Additionally, the following build arguments can be defined

-	version - default 0.14.0 - what version of the jmx_exporter http server to use (if you are going to docker push, please tag prom_jmx:$VERSION)
-	jar - default jmx_prometheus_httpserver-$VERSION-jar-with-dependencies.jar - what jar file from the maven repo https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_httpserver/ to use

Running
-------

```
docker run --rm -p "5556:5556" reasland/jmx-prometheus-exporter
```

Then you can visit the metrics endpoint: [http://127.0.0.1:5556/metrics](http://127.0.0.1:5556/metrics) (assuming docker is running on localhost)

Configuration
-------------

By default, the jmx-exporter is configured to monitor it's own metrics (as per the main repo example). However, to provide your own configuration, mount the YAML file as a volume

```
docker run --rm -p "5556:5556" -v "$PWD/config.yml:/opt/jmx_exporter/config.yml" reasland/jmx-prometheus-exporter
```

The configuration options are documented: [https://github.com/prometheus/jmx_exporter](https://github.com/prometheus/jmx_exporter)

### Environment variables

Additionally, the following environment variables can be defined

-	SERVICE_PORT - what port to run the service (if you don't like 5556)
-	JVM_OPTS - any additional options, Xmx etc.
-	CONFIG_YML - override the location of config.yaml (default: /opt/jmx_exporter/config.yml which monitors jmx exporter's jvm)

Using with Prometheus
---------------------

Minimal example config:

```
global:
 scrape_interval: 10s
 evaluation_interval: 10s
scrape_configs:
 - job_name: 'jmx'
   static_configs:
    - targets:
      - 127.0.0.1:5556
```
