FROM ofayau/busybox-libc32

MAINTAINER Olivier Fayau

# Set environment
ENV JAVA_HOME /usr/lib/jvm/jre
ENV PATH $PATH:$JAVA_HOME/bin

#
# Download and install java : Openjdk - %JRE%.
# About Compact Profiles (JEP 161) : http://openjdk.java.net/jeps/161
# Official depo : https://jdk8.java.net/java-se-8-ri/
#
RUN mkdir /usr/lib/jvm \
  && cd /usr/lib/jvm \
  && wget %URL% -O - | gunzip | tar x \
  && ln -s /usr/lib/jvm/%JRE% /usr/lib/jvm/jre

