#!/bin/sh

# Required ENV variables:
# * ADVERTISED_HOST: the external ip for the container, e.g. `boot2docker ip`
# * ZOOKEEPER: the zookeeper connection string of the zookeeper server, e.g. host, or host:port

# Optional ENV variables:
# * ADVERTISED_PORT: the external port for Kafka, e.g. 9092
# * LOG_RETENTION_HOURS: the minimum age of a log file in hours to be eligible for deletion (default is 168, for 1 week)
# * LOG_RETENTION_BYTES: configure the size at which segments are pruned from the log, (default is 1073741824, for 1GB)

# Set the external host and port
if [ ! -z "$ADVERTISED_HOST" ]; then
    echo "advertised host: $ADVERTISED_HOST"
    sed -r -i "s/#(advertised.host.name)=(.*)/\1=$ADVERTISED_HOST/g" $KAFKA_HOME/config/server.properties
else 
    echo "ADVERTISED_HOST must be set"
    exit 1
fi
if [ ! -z "$ADVERTISED_PORT" ]; then
    echo "advertised port: $ADVERTISED_PORT"
    sed -r -i "s/#(advertised.port)=(.*)/\1=$ADVERTISED_PORT/g" $KAFKA_HOME/config/server.properties
fi
if [ ! -z "$ZOOKEEPER" ]; then
    echo "zookeeper: $ZOOKEEPER"
    sed -r -i "s/(zookeeper.connect)=(.*)/\1=$ZOOKEEPER/g" $KAFKA_HOME/config/server.properties
else 
    echo "ZOOKEEPER must be set"
fi

# Allow specification of log retention policies
if [ ! -z "$LOG_RETENTION_HOURS" ]; then
    echo "log retention hours: $LOG_RETENTION_HOURS"
    sed -r -i "s/(log.retention.hours)=(.*)/\1=$LOG_RETENTION_HOURS/g" $KAFKA_HOME/config/server.properties
fi
if [ ! -z "$LOG_RETENTION_BYTES" ]; then
    echo "log retention bytes: $LOG_RETENTION_BYTES"
    sed -r -i "s/#(log.retention.bytes)=(.*)/\1=$LOG_RETENTION_BYTES/g" $KAFKA_HOME/config/server.properties
fi

# Run Kafka
$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
