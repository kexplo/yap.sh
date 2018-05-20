ARG UBUNTU_VERSION
FROM ubuntu:$UBUNTU_VERSION

LABEL maintainer "Chanwoong Kim <chanwoong@chanwoong.kim>"

RUN useradd -ms /bin/bash kexplo
#            │└─ Set user's login shell to '/bin/bash'
#            └─ Create home directory

# ubuntu 16.04 docker image doesn't have sudo command
RUN apt-get update && apt-get install -y sudo locales
RUN rm -rf /var/lib/apt/lists/*

# Set locale
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Make kexplo user as sudoer
RUN echo "kexplo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER kexplo
WORKDIR /home/kexplo

ENV USER kexplo

