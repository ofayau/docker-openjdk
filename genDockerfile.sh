#!/bin/sh

# Version
jre=java-se-8u40-ri
url_p=http://download.java.net/openjdk/jdk8u40/ri/jre_ri-8u40-b25
url_s=-linux-i586-10_feb_2015.tar.gz

# Generate docker files
for profile in compact1 compact2 compact3 jre; do
	echo "Generate Dockerfile for $profile"
	mkdir -p "openjdk-$profile"
	# profile2 with "-"
	[ $profile = "jre" ] && p2="" || p2="-$profile"
	echo "=> url : ${url_p}${p2}${url_s}" 
	sed -e "s#%URL%#${url_p}${p2}${url_s}#g" -e "s/%JRE%/${jre}${p2}/g" Dockerfile.tpl > "openjdk-$profile/Dockerfile"
done

