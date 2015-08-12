FROM reideltj/hadoop
MAINTAINER reideltj

# install postgres to serve as hive metastore backend
RUN apt-get -yq install vim postgresql-9.3 libpostgresql-jdbc-java

# create metastore db, hive user and assign privileges
USER postgres
RUN /etc/init.d/postgresql start; psql --command "CREATE DATABASE metastore;"; psql --command "CREATE USER hive WITH PASSWORD 'hive';"; psql --command "ALTER USER hive WITH SUPERUSER;"; psql --command "GRANT ALL PRIVILEGES ON DATABASE metastore TO hive;"; 
USER root

# download and install hive
RUN wget -qO- http://www.us.apache.org/dist/hive/hive-1.2.1/apache-hive-1.2.1-bin.tar.gz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s ./apache-hive-1.2.1-bin hive

# configure hive environment variable
ENV HIVE_HOME /usr/local/hive
ENV HIVE_CONF $HIVE_HOME/conf
ENV PATH $HIVE_HOME/bin:$PATH

# add postgresql jdbc jar to classpath
RUN ln -s /usr/share/java/postgresql-jdbc4.jar $HIVE_HOME/lib/postgresql-jdbc4.jar

# to avoid psql asking password, set PGPASSWORD
ENV PGPASSWORD hive

# initialize hive metastore db
RUN /etc/init.d/postgresql start; sleep 1; cd $HIVE_HOME/scripts/metastore/upgrade/postgres; psql -h localhost -U hive -d metastore -f hive-schema-1.2.0.postgres.sql

# install hive config, sql, data files
ADD hive-site.xml $HIVE_CONF/hive-site.xml
ADD hive-log4j.properties $HIVE_CONF/hive-log4j.properties

# hive startup scripts
ADD start-hive.sh /usr/bin/start-hive.sh
ADD start-metadata.sh /usr/bin/start-metadata.sh

# Supervisor config
ADD hive.conf /etc/supervisor/conf.d/hive.conf

# Hive ports
EXPOSE 10000

CMD ["supervisord", "-n"]

