#!/bin/bash

echo "Starting postgresql server..."
service postgresql start

# start hive metastore server
$HIVE_HOME/bin/hive --service metastore
