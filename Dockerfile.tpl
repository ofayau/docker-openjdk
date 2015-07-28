FROM ofayau/busybox-jvm

MAINTAINER Olivier Fayau

#
# Download and install java : OpenJDK - %JRE%.
# About Compact Profiles (JEP 161) : http://openjdk.java.net/jeps/161
# Official depo : https://jdk8.java.net/java-se-8-ri/
#
RUN mkdir /usr/lib/jvm \
  && cd /usr/lib/jvm \
  && wget %URL% -O - | gunzip | tar x \
  && ln -s /usr/lib/jvm/%JRE% /usr/lib/jvm/jre

CMD ["java", "-version"]

