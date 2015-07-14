#!/bin/bash

# get the IP address of the docker interface
PUBLIC_INTERFACE=`ifconfig docker0 | awk -F"[: ]+" '/inet addr:/ {print $4}'`

# start the container
docker run --hostname `hostname` -p 9092:9092 -e ADVERTISED_HOST=`hostname` -e ZOOKEEPER=$PUBLIC_INTERFACE:2181 reideltj/kafka
