
FROM centos
MAINTAINER Michał Kurzeja accesto.com

ENV OPENMEETINGS_VERSION 3.0.7
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
ADD http://archive.apache.org/dist/openmeetings/${OPENMEETINGS_VERSION}/bin/apache-openmeetings-${OPENMEETINGS_VERSION}.tar.gz /opt/apache-openmeetings
RUN tar -zxvf apache-openmeetings-${OPENMEETINGS_VERSION}.tar.gz && rm -rf apache-openmeetings-${OPENMEETINGS_VERSION}.tar.gz

# run
EXPOSE 5080 1935 8088
#VOLUME /opt/apache-openmeetings/conf
#VOLUME /opt/apache-openmeetings/openmeetings
CMD ["/opt/apache-openmeetings/red5.sh"]

