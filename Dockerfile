FROM ubuntu
RUN apt update && apt install default-jdk -y
RUN apt install wget -y
RUN wget https://downloads.apache.org/tomcat/tomcat-8/v8.5.66/bin/apache-tomcat-8.5.66.tar.gz
RUN tar -xf apache-tomcat-8.5.66.tar.gz
RUN mv apache-tomcat-8.5.66.tar.gz /etc/apache-tomcat
COPY $warfilepath/java-tomcat-maven-example.war /etc/apache-tomcat/webapps/
EXPOSE 8080
WORKDIR /etc/apache-tomcat/bin/
CMD ["/etc/apache-tomcat/bin/catalina.sh", "run"] && apachectl -D FOREGROUND