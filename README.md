docker-ionic
============

[![Docker Hub](https://img.shields.io/badge/docker-mkaag%2Fionic-008bb8.svg)](https://registry.hub.docker.com/u/mkaag/ionic/)
[![](https://images.microbadger.com/badges/image/mkaag/ionic.svg)](https://microbadger.com/images/mkaag/ionic "Get your own image badge on microbadger.com")

This repository contains the **Dockerfile** and the configuration files to build the [Ionic framework](http://ionicframework.com) for [Docker](https://www.docker.com/).

### Base Docker Image

* [phusion/baseimage](https://github.com/phusion/baseimage-docker), the *minimal Ubuntu base image modified for Docker-friendliness*...
* ...[including image's enhancement](https://github.com/racker/docker-ubuntu-with-updates) from [Paul Querna](https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/)
* and based on the ionic-framework image from [agileek](https://github.com/agileek/docker/tree/master/ionic-framework)

This image is using the following tools:

* latest node, ionic and cordova
* Android SDK Tools, revision 24.2
* Android SDK Build Tools, revision 22
* Android SDK Platform, x86 API level 22

### Installation

```bash
docker build -t mkaag/ionic github.com/mkaag/docker-ionic
```

### Usage

#### Basic usage

```
docker run -ti -p 8100:8100 -p 35729:35729 mkaag/ionic
```

If you have your own ionic sources, you can launch it with:

```
docker run -ti \
-v /path/to/your/ionic-project/:/myApp:rw \
-p 8100:8100 -p 35729:35729 \
mkaag/ionic
```

#### Automation

With this alias:

```
alias ionic="docker run -ti \
--privileged \
-v /dev/bus/usb:/dev/bus/usb \
-v \$PWD:/myApp:rw \
-p 8100:8100 -p 35729:35729 \
mkaag/ionic ionic"
```

you can follow the [Ionic tutorial](http://ionicframework.com/getting-started/) (except for the ios part...) without having to install ionic nor cordova nor nodejs on your computer.

```bash
ionic start myApp tabs
cd myApp
ionic serve
```
open http://localhost:8100 and everything works.

### Android tests

You can test on your android device, just make sure that debugging is enabled.

```bash
cd myApp
ionic platform add android
ionic platform build android
ionic platform run android
```

### Troubleshooting

### The application is not installed on my android device

Try running: 

```
docker run -ti \
--privileged \
-v /dev/bus/usb:/dev/bus/usb \
-v \$PWD:/myApp:rw \
-p 8100:8100 -p 35729:35729 \
mkaag/ionic adb list
```
