ARG BASE_IMAGE_PREFIX

FROM multiarch/qemu-user-static as qemu

FROM ${BASE_IMAGE_PREFIX}ubuntu:16.04

COPY --from=qemu /usr/bin/qemu-*-static /usr/bin/

RUN apt-get update && apt-get clean && apt-get install -y \
    x11vnc \
    xvfb \
    fluxbox \
    wmctrl \
    wget \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update && apt-get -y install google-chrome-stable

RUN useradd apps \
    && mkdir -p /home/apps \
    && chown -v -R apps:apps /home/apps

COPY bootstrap.sh /

RUN rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /usr/bin/qemu-*-static

CMD '/bootstrap.sh'
