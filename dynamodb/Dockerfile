FROM reideltj/base 
MAINTAINER reideltj

RUN wget -q -O - http://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_latest.tar.gz | tar -xzf - -C /opt

ADD start-dynamodb.sh /usr/bin/start-dynamodb.sh 
EXPOSE 8000

# Supervisor config
ADD dynamodb.conf /etc/supervisor/conf.d/dynamodb.conf

CMD ["supervisord", "-n"]

