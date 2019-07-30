FROM ubuntu

WORKDIR /home/pentaho

ADD . /home/pentaho

#Install curl and unzip for download and extracting required files
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install unzip

#Download Java and extract files
RUN curl -o /java.tar.gz https://libraries.doc.com/java/djre-8u211-linux-x64.tar.gz
#RUN mv /home/pentaho/lib/jre-8u211-linux-x64.tar.gz /java.tar.gz
RUN mkdir /home/java
RUN tar -xzvf /java.tar.gz -C /home/java
RUN rm /java.tar.gz

#Set Java variables
ENV JAVA_HOME="/home/java/jre1.8.0_211"
ENV PATH="${PATH}:$JAVA_HOME/bin"

#Download Pentaho Server and extract files
RUN curl -o /pentaho-server-ce-8.3.0.0-371.zip https://libraries.doc.com/pentaho/pentaho-server-ce-8.3.0.0-371.zip
RUN unzip /pentaho-server-ce-8.3.0.0-371.zip -d /home/pentaho

#Download and Install Athena Driver in tomcat lib directory
RUN curl -o /home/pentaho/pentaho-server/tomcat/lib/AthenaJDBC42_2.0.7.jar https://libraries.doc.com/athena/AthenaJDBC42_2.0.7.jar
#RUN mv /home/pentaho/lib/AthenaJDBC42_2.0.7.jar /home/pentaho/pentaho-server/tomcat/lib

#Replace startup.sh with our own to use "run" command instead of "start"
RUN mv /home/pentaho/startup/startup.sh /home/pentaho/pentaho-server/tomcat/bin/startup.sh
RUN mv /home/pentaho/startup/start-pentaho.sh /home/pentaho/pentaho-server/start-pentaho.sh

#Delete jackrabbit repository directory to avoid an error when starting pentaho
RUN rm -rf /home/pentaho/pentaho-server/pentaho-solutions/system/jackrabbit/repository

EXPOSE 8080

#Run start-pentaho.sh to start Pentaho Server
CMD ["/home/pentaho/pentaho-server/start-pentaho.sh"]