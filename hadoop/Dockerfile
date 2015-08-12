FROM reideltj/base
MAINTAINER reideltj

# install openssh 
RUN apt-get install -y openssh-server openssh-client libselinux1

# configure passwordless sshd
RUN rm -f /etc/ssh/ssh_host_dsa_key; ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN rm -f /etc/ssh/ssh_host_rsa_key; ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
ADD ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config
EXPOSE 22

# download and install hadoop
RUN wget -qO- http://www.us.apache.org/dist/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s ./hadoop-2.6.0 hadoop

# configure hadoop environment variables
ENV HADOOP_PREFIX /usr/local/hadoop
ENV HADOOP_COMMON_HOME /usr/local/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop
ENV HADOOP_MAPRED_HOME /usr/local/hadoop
ENV HADOOP_YARN_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV PATH $HADOOP_COMMON_HOME/bin:$PATH

# setup hadoop environment script
RUN sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME='"$JAVA_HOME"'\nexport HADOOP_PREFIX=/usr/local/hadoop\nexport HADOOP_HOME=/usr/local/hadoop\n:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
RUN sed -i '/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

# create hadoop folders
RUN mkdir $HADOOP_PREFIX/input
RUN cp $HADOOP_PREFIX/etc/hadoop/*.xml $HADOOP_PREFIX/input

# pseudo distributed
ADD core-site.xml.template $HADOOP_PREFIX/etc/hadoop/core-site.xml.template
RUN sed s/HOSTNAME/localhost/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml
ADD hdfs-site.xml $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
ADD mapred-site.xml $HADOOP_PREFIX/etc/hadoop/mapred-site.xml
ADD yarn-site.xml $HADOOP_PREFIX/etc/hadoop/yarn-site.xml

# format the HDFS volume 
RUN $HADOOP_PREFIX/bin/hdfs namenode -format

# replace hadoop's native libraries with 64-bit pre-built native libraries 
RUN rm  /usr/local/hadoop/lib/native/*; wget -qO- http://dl.bintray.com/sequenceiq/sequenceiq-bin/hadoop-native-64-2.6.0.tar | tar -x -C /usr/local/hadoop/lib/native/

# add the hadoop startup script
ADD start-hadoop.sh /usr/bin/start-hadoop.sh

# work around for docker.io build error
RUN ls -la /usr/local/hadoop/etc/hadoop/*-env.sh
RUN chmod +x /usr/local/hadoop/etc/hadoop/*-env.sh
RUN ls -la /usr/local/hadoop/etc/hadoop/*-env.sh

# fix the 254 error code
RUN sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config
RUN echo "UsePAM no" >> /etc/ssh/sshd_config
RUN echo "Port 2122" >> /etc/ssh/sshd_config

# initialize hadoop directories in HDFS
RUN service ssh start; $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh; $HADOOP_PREFIX/sbin/start-dfs.sh; $HADOOP_PREFIX/bin/hdfs dfs -mkdir -p /user/root; $HADOOP_PREFIX/bin/hdfs dfs -put $HADOOP_PREFIX/etc/hadoop/ input

# HDFS ports
EXPOSE 50010 50020 50070 50075 50090
# MAP-REDUCE ports
EXPOSE 19888
#YARN ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088
#other ports
EXPOSE 49707 2122   

# Supervisor config
ADD hadoop.conf /etc/supervisor/conf.d/hadoop.conf

CMD ["supervisord", "-n"]



