#!/bin/sh

/usr/bin/java -Djava.library.path=/opt/DynamoDBLocal_lib -jar /opt/DynamoDBLocal.jar -sharedDb -dbPath /var/local 
