# docker-openjdk

This project create docker images for `OpenJDK 1.8.0_40-b25`.

There is an image for each "compact profile" (see [JEP 161](http://openjdk.java.net/jeps/161) ) : `compact1`, `compact2`, `compact3` and `jre` (=full SE)

These JREs *are very small* because they're made for embedded system.

## Supported tags and respective `Dockerfile` links

There are a tagged image for each "compact profile" :

-	[`8-jre`, `latest` (*openjdk/Dockerfile*)](https://github.com/ofayau/docker-openjdk/blob/master/openjdk-jre/Dockerfile)
-	[`8-compact3` (*openjdk/Dockerfile*)](https://github.com/ofayau/docker-openjdk/blob/master/openjdk-compact3/Dockerfile)
-	[`8-compact2` (*openjdk/Dockerfile*)](https://github.com/ofayau/docker-openjdk/blob/master/openjdk-compact2/Dockerfile)
-	[`8-compact1` (*openjdk/Dockerfile*)](https://github.com/ofayau/docker-openjdk/blob/master/openjdk-compact1/Dockerfile)

## Details

### What are these?

tl;dr : Busybox + libc 64bit + libc 32 bits + Embedded JRE = Small Java Container

All image are based on Busybox with 32 bits (and 64 bits) libs (see [docker-busybox-jvm](https://github.com/ofayau/docker-busybox-jvm) and [docker-busybox-lib32](https://github.com/ofayau/docker-busybox-lib32) ).

The overhead on top of a JRE is around 8 MB.

JVM aren't statically linked so you can still navigate inside container or use some shell scripting.

JRE are always installed in `/usr/lib/jvm` and link to `/usr/lib/jvm/jre`.

Sample :

```sh
/ # ls -l /usr/lib/jvm/
total 4
drwxr-xr-x    4 root     root          4096 Jul 15 23:03 java-se-8u40-ri-compact1
lrwxrwxrwx    1 root     root            34 Jul 15 23:03 jre -> /usr/lib/jvm/java-se-8u40-ri-compact1
```

### Size matters

The biggest advantage of these image are their size : only 47 MB for a "compact" edition and 115 MB for a full SE JRE.

It's 6 or 12 times smaller than the official java image (cause it's headfull and based on a full Debian) !

Here is a list of some java image.

```sh
REPOSITORY                  TAG          IMAGE ID        CREATED         VIRTUAL SIZE
ofayau/j2me                 latest       f56c31b1cc20    26 hours ago    21.73 MB
ofayau/ejre                 8-compact1   824a6f1a0ade    4 minutes ago   39.31 MB
ofayau/ejre                 8-compact2   9da39771057a    4 minutes ago   44.85 MB
ofayau/ejre                 8-compact3   a9fbe6b90034    4 minutes ago   48.79 MB
ofayau/ejre                 8-jre        d5ed29a4bf44    4 minutes ago   80.66 MB
ofayau/openjdk              8-compact1   f258bd30ec46    5 days ago      47.08 MB
ofayau/openjdk              8-compact2   dc125eeac09b    5 days ago      59.82 MB
ofayau/openjdk              8-compact3   b10fc16f53ea    5 days ago      66.38 MB
ofayau/openjdk              8-jre        fded935a77ed    5 days ago      115.1 MB
frolvlad/alpine-oraclejdk8  latest       8e87306ea37d    7 weeks ago     170.4 MB
jeanblanchard/busybox-java  8            f9b532dbdd9f    3 months ago    162 MB
java                        8-jre        b0f21df5333b    5 months ago    478.7 MB
```

### Drawback

- truncated JRE : "compact profiles" doesn't contain every java package. Only `8-jre` is considered as full SE (but still headless).

- 32 bits only : you can't run 64 bits code.

- JRE, not JDK : hence there is no compiler (`javac`) included, only runtime executor (`java`). You have to compile somewhere else (i.e. a standard jdk 8).


## License

- *Busybox* : see [license information](http://www.busybox.net/license.html).

- *Debian libc-i386* : see [licence](http://ftp-master.metadata.debian.org/changelogs/main/g/glibc/glibc_2.19-18_copyright) of [debian package](https://packages.debian.org/jessie/libc6-i386).

- *Oracle and Java* : see [OTN licence](http://www.oracle.com/technetwork/licenses/standard-license-152015.html).

Oracle and Java are registered trademarks of Oracle and/or its affiliates.

## Installation & Usage

Download or update tagged images :

```sh
docker pull ofayau/openjdk:8-compact1
docker pull ofayau/openjdk:8-compact2
docker pull ofayau/openjdk:8-compact3
docker pull ofayau/openjdk:8-jre
docker pull ofayau/openjdk:latest
```

Showing java version of every image :

```sh
# docker run --rm -it ofayau/openjdk:8-compact1
openjdk version "1.8.0_40"
OpenJDK Runtime Environment (build 1.8.0_40-b25, profile compact1)
OpenJDK Server VM (build 25.40-b25, mixed mode)

# docker run --rm -it ofayau/openjdk:8-compact2
openjdk version "1.8.0_40"
OpenJDK Runtime Environment (build 1.8.0_40-b25, profile compact2)
OpenJDK Server VM (build 25.40-b25, mixed mode)

# docker run --rm -it ofayau/openjdk:8-compact3
openjdk version "1.8.0_40"
OpenJDK Runtime Environment (build 1.8.0_40-b25, profile compact3)
OpenJDK Server VM (build 25.40-b25, mixed mode)

# docker run --rm -it ofayau/openjdk:8-jre
openjdk version "1.8.0_40"
OpenJDK Runtime Environment (build 1.8.0_40-b25)
OpenJDK Server VM (build 25.40-b25, mixed mode)
```

Simple runs

```sh
# Run a fat jar from current dir with full JRE
docker run --rm -v "$PWD":/tmp/myapp -w /tmp/myapp ofayau/openjdk java -jar myFatJar.jar
```

Compile and run for compact1

```sh
# Compile with jdk 8 (outside of this container)
javac -profile compact1 HelloWorld.java
# Run a "HelloWorld" class from current dir
docker run --rm -v "$PWD":/tmp/myapp -w /tmp/myapp ofayau/openjdk:8-compact1 java HelloWorld.class
```

