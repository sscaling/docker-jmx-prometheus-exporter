# Docker JMX exporter for Prometheus

Essentially another dockerised JMX Exporter image, this uses alpine-java and dumb-init to provide a relatively small image (approx 130Mb) and includes a released version of jmx_exporter from the [maven central repository](https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_httpserver/)

## Building docker image

	docker build -t sscaling/jmx-exporter .

## Running

	docker run --rm -p "5556:5556" sscaling/jmx-exporter

Then you can visit the metrics endpoint: [http://127.0.0.1:5556/metrics]() (assuming docker is running on localhost)

## Configuration

By default, the jmx-exporter is configure to monitor it's own metrics (as per the main repo example). However, to provide your own configuration, mount the YAML file as a volume

	docker run --rm -p "5556:5556" -v "$PWD/config.yml:/opt/jmx_exporter/config.yml" sscaling/jmx-exporter

The configuration options are documented: [https://github.com/prometheus/jmx_exporter](https://github.com/prometheus/jmx_exporter)

### Environment variables

Additionally, the following environment variables can be defined

* SERVICE_PORT - what port to run the service (if you don't like 5556)
* JVM_OPTS - any additional options, Xmx etc.

## Using with Prometheus

Minimal example config:

	global:
	 scrape_interval: 10s
	 evaluation_interval: 10s
	scrape_configs:
	 - job_name: 'jmx'
	   static_configs:
	    - targets:
	      - 127.0.0.1:5556
