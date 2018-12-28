FROM httpd

ADD jdk-8u181-linux-x64.tar.gz /opt/
ENV JAVA_HOME=/opt/jdk1.8.0_181
ENV PATH=$PATH:$JAVA_HOME/bin

RUN apt-get update
RUN apt-get -y install unzip
RUN apt-get -y install vim

COPY gatling-bundle-2.3.1.zip /tmp/
RUN unzip /tmp/gatling-bundle-2.3.1.zip -d /usr/local/
RUN mv /usr/local/gatling-charts-highcharts-bundle-2.3.1 /usr/local/gatling-2.3.1

COPY simulations /usr/local/gatling-2.3.1/user-files/simulations/
RUN rm -rf /usr/local/gatling-2.3.1/user-files/simulations/computerdatabase
COPY run-test.sh /usr/local/gatling-2.3.1/bin/
RUN chmod +x /usr/local/gatling-2.3.1/bin/run-test.sh

EXPOSE 80