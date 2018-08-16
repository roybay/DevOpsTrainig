FROM httpd

COPY sampleApp/htdocs/* /usr/local/apache2/htdocs/
COPY sampleApp/IG-sample-application-6.0.0.jar /tmp/

ADD jdk-8u181-linux-x64.tar.gz /opt/
ENV JAVA_HOME=/opt/jdk1.8.0_181
ENV PATH=$PATH:$JAVA_HOME/bin

RUN java -jar /tmp/IG-sample-application-6.0.0.jar &