#!/bin/sh

# Generate docker images
for profile in compact1 compact2 compact3 jre; do
	docker build -t "openjdk-compact:8-$profile" openjdk-$profile
done

