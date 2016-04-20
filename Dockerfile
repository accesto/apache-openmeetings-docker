
FROM centos
MAINTAINER Michał Kurzeja accesto.com

RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN yum -y update

# dependencies
RUN yum -y update && \
	yum -y install git java-1.7.0-openjdk ImageMagick ghostscript libreoffice ffmpeg swftools sox && \
	yum -y clean all
RUN curl -L http://jodconverter.googlecode.com/files/jodconverter-core-3.0-beta-4-dist.zip \
		-o /opt/jodconverter-core-3.0-beta-4-dist.zip && \
	unzip /opt/jodconverter-core-3.0-beta-4-dist.zip && \
	rm -f /opt/jodconverter-core-3.0-beta-4-dist.zip
RUN cd /opt && ln -s jodconverter-core-3.0-beta-4 jod

# openmeetings itself
RUN mkdir /opt/apache-openmeetings
WORKDIR /opt/apache-openmeetings

ADD http://archive.apache.org/dist/openmeetings/3.0.7/bin/apache-openmeetings-3.0.7.zip /opt/apache-openmeetings
RUN unzip apache-openmeetings-3.0.7.zip && rm apache-openmeetings-3.0.7.zip

ADD http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.38.zip /opt/apache-openmeetings
RUN unzip mysql-connector-java-5.1.38.zip && rm mysql-connector-java-5.1.38.zip
RUN mv mysql-connector-java-5.1.38/mysql-connector-java-5.1.38-bin.jar webapps/openmeetings/WEB-INF/lib/mysql-connector-java-5.1.38-bin.jar
RUN rm -R mysql-connector-java-5.1.38


# run
EXPOSE 5080 1935 8088 8443 5443

CMD ["/opt/apache-openmeetings/red5.sh"]

