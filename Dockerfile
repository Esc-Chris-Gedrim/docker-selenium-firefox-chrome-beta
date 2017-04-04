FROM ubuntu:latest
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

MAINTAINER Vincent Voyer <vincent@zeroload.net>
MAINTAINER Chris Gedrim <chris.gedrim@es.catapult.org.uk>
RUN apt-get -y update
RUN apt-get install -y -q software-properties-common wget

RUN wget -qO- https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs bzip2
RUN wget -qO- https://ftp.mozilla.org/pub/firefox/releases/52.0.2esr/linux-x86_64/en-GB/firefox-52.0.2esr.tar.bz2 | tar xvj -C /opt
RUN ln -s /opt/firefox/firefox /usr/bin/firefox
RUN add-apt-repository ppa:openjdk-r/ppa
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list
RUN apt-get update -y
RUN apt-get install -y -q \
  google-chrome-stable \
  openjdk-8-jre-headless \
  nodejs \
  x11vnc \
  xvfb \
  xfonts-100dpi \
  xfonts-75dpi \
  xfonts-scalable \
  xfonts-cyrillic
RUN useradd -d /home/seleuser -m seleuser
RUN mkdir -p /home/seleuser/chrome
RUN chown -R seleuser /home/seleuser
RUN chgrp -R seleuser /home/seleuser

ADD ./scripts/ /home/root/scripts
RUN npm install -g \
  selenium-standalone@6.1.0 \
  phantomjs-prebuilt@2.1.14 && \
  selenium-standalone install
EXPOSE 4444 5999
ENTRYPOINT ["sh", "/home/root/scripts/start.sh"]
