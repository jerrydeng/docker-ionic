FROM mkaag/baseimage
MAINTAINER Maurice Kaag <mkaag@me.com>

# -----------------------------------------------------------------------------
# Environment variables
# -----------------------------------------------------------------------------
ENV \
  IONIC_VERSION=1.7.12 \
  CORDOVA_VERSION=5.4.1 \
  ANDROID_HOME=/opt/android-sdk-linux \
  PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:/opt/tools
RUN echo ANDROID_HOME="${ANDROID_HOME}" >> /etc/environment

# -----------------------------------------------------------------------------
# Pre-install
# -----------------------------------------------------------------------------
RUN \
  apt-get update -qqy && \
  dpkg --add-architecture i386 && \
  apt-get update -qqy && \
  apt-get install -qqy \
    python-software-properties \
    software-properties-common \
    expect \
    ant \
    wget \
    libc6-i386 \
    lib32stdc++6 \
    lib32gcc1 \
    lib32ncurses5 \
    lib32z1 \
    qemu-kvm \
    kmod

RUN \
  add-apt-repository ppa:webupd8team/java -y && \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
  apt-get update -qqy && \
  apt-get install -qqy oracle-java7-installer

# -----------------------------------------------------------------------------
# Install
# -----------------------------------------------------------------------------
RUN \
  apt-get update -qqy &&  \
  apt-get install -y npm && \
  ln -s /usr/bin/nodejs /usr/local/bin/node && \
  npm install -g cordova@"$CORDOVA_VERSION" ionic@"$IONIC_VERSION" && \
  npm cache clean && \
  ionic start myApp sidemenu

WORKDIR /opt
RUN \
  wget --output-document=android-sdk.tgz --quiet http://dl.google.com/android/android-sdk_r24.2-linux.tgz && \
  tar xzf android-sdk.tgz && \
  rm -f android-sdk.tgz

# -----------------------------------------------------------------------------
# Post-install
# -----------------------------------------------------------------------------
ADD build/android-accept-licenses.sh /opt/tools/android-accept-licenses.sh
RUN chmod +x /opt/tools/android-accept-licenses.sh

RUN ["/opt/tools/android-accept-licenses.sh", "android update sdk --all --no-ui --filter platform-tools,build-tools-22.0.1,android-22,addon-google_apis_x86-google-22,extra-android-support,extra-android-m2repository,extra-google-m2repository,sys-img-x86-android-22"]

WORKDIR /myApp
EXPOSE 8100 35729
CMD ["ionic", "serve", "8100", "35729"]

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
