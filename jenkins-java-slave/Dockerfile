FROM ubuntu:trusty

# Make sure the package repository is up to date.
RUN apt-get update
RUN apt-get -y upgrade

# Install a basic SSH server
RUN apt-get install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Install JDK 7 (latest edition)
RUN apt-get install -y openjdk-7-jdk

# Install docker.io
RUN apt-get install -y docker.io

# Install git
RUN apt-get install -y git

# Install gradle 
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:cwchien/gradle
RUN apt-get update
RUN apt-get install -y gradle-2.3

# Add user jenkins to the image
RUN adduser --quiet jenkins
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

# Add docker-user group to match the host's docker user
RUN addgroup --quiet --gid 498 docker-user 

# Add user jenkins to the docker-user group
RUN usermod -a -G docker-user jenkins

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]



