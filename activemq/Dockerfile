FROM openjdk:8-jre-alpine
MAINTAINER yookien <yookien@gmail.com>


ADD ./apache-activemq-5.15.3-bin.tar.gz /
ADD ./start.sh /apache-activemq-5.15.3/
RUN rm -rf /apache-activemq-5.15.3-bin.tar.gz

EXPOSE 8161 61616

ENTRYPOINT ["bin/sh", "/apache-activemq-5.15.3/start.sh"]
