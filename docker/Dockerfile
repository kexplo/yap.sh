FROM ubuntu:16.04

LABEL maintainer "Chanwoong Kim <chanwoong@chanwoong.kim>"

RUN useradd -ms /bin/bash kexplo
#            │└─ Set user's login shell to '/bin/bash'
#            └─ Create home directory

# Make kexplo user as sudoer
RUN echo "kexplo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER kexplo
WORKDIR /home/kexplo
