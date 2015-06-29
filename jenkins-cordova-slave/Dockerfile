FROM ubuntu:trusty

# Make sure the package repository is up to date.
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get -y upgrade

# Install a basic SSH server
RUN apt-get install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# install android sdk dependencies
RUN apt-get install -y openjdk-7-jdk libncurses5:i386 libstdc++6:i386 zlib1g:i386 

# Install git
RUN apt-get install -y git

# Add user jenkins to the image
RUN adduser --quiet jenkins
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

# install npm and dependencies
RUN apt-get install -y npm nodejs curl wget

# install cordova 
RUN npm install -g n cordova
RUN n stable

# install android sdk
RUN cd /opt && wget -q http://dl.google.com/android/android-sdk_r24.2-linux.tgz
RUN cd /opt && tar xzf android-sdk_r24.2-linux.tgz
RUN cd /opt && rm -f android-sdk_r24.2-linux.tgz

# Other tools and resources of Android SDK
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
RUN echo y | android update sdk -a --filter platform-tools,build-tools-22.0.1,android-22,extra-android-support --no-ui --force

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]



