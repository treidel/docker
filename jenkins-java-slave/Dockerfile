FROM ubuntu:trusty

# Make sure the package repository is up to date and add the add-apt-repository tool
RUN apt-get update; apt-get -y upgrade; apt-get install -y software-properties-common apt-transport-https

# Install a basic SSH server
RUN apt-get install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Install JDK 7 (latest edition)
RUN apt-get install -y openjdk-7-jdk

# Install latest docker
RUN add-apt-repository 'deb https://get.docker.io/ubuntu docker main'; apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9; apt-get -y update; apt-get install -y lxc-docker

# Install git
RUN apt-get install -y git

# Install latest gradle 
RUN add-apt-repository ppa:cwchien/gradle; apt-get -y update; apt-get install -y gradle-2.5

# Add user jenkins to the image
RUN adduser --quiet jenkins
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

# Add user jenkins to the docker group
RUN usermod -a -G docker jenkins

# override the gid of the docker group
RUN groupmod -g 118 docker

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]



