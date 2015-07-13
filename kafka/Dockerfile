FROM ubuntu:trusty
MAINTAINER reideltj
RUN apt-get update; apt-get install -y unzip openjdk-7-jre-headless wget supervisor docker.io openssh-server
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64/
RUN echo 'root:root' | chpasswd
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 22

# Install Kafka
RUN wget -q http://apache.mirrors.spacedump.net/kafka/0.8.2.1/kafka_2.10-0.8.2.1.tgz -O /tmp/kafka_2.10-0.8.2.1.tgz && \
    tar xfz /tmp/kafka_2.10-0.8.2.1.tgz -C /opt && \
    rm /tmp/kafka_2.10-0.8.2.1.tgz

ENV KAFKA_HOME /opt/kafka_2.10-0.8.2.1
ADD start-kafka.sh /usr/bin/start-kafka.sh

# Supervisor config
ADD kafka.conf /etc/supervisor/conf.d/kafka.conf

# 9092 is kafka
EXPOSE 9092

CMD ["supervisord", "-n"]
