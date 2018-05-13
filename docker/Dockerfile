FROM ubuntu:16.04

LABEL maintainer "Chanwoong Kim <chanwoong@chanwoong.kim>"

RUN useradd -ms /bin/bash kexplo
#            │└─ Set user's login shell to '/bin/bash'
#            └─ Create home directory

# ubuntu 16.04 docker image doesn't have sudo command
RUN apt update && apt install -y sudo
RUN rm -rf /var/lib/apt/lists/*

# Make kexplo user as sudoer
RUN echo "kexplo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER kexplo
WORKDIR /home/kexplo

ENV USER kexplo

