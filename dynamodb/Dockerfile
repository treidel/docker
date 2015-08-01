FROM reideltj/base 
MAINTAINER reideltj

# install pip and then use pip to install the aws cli
RUN apt-get update; apt-get install -y python-pip; pip install awscli

# download + install dynamodb local
RUN wget -q -O - http://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_latest.tar.gz | tar -xzf - -C /opt

# insert the startup script
ADD start-dynamodb.sh /usr/bin/start-dynamodb.sh 

# expose the dynamodb local port
EXPOSE 8000

# supervisor config
ADD dynamodb.conf /etc/supervisor/conf.d/dynamodb.conf

# add dynamodb data file
ADD shared-local-instance.db /var/local/shared-local-instance.db

# start supervisord 
CMD ["supervisord", "-n"]

