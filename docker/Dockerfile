FROM ubuntu:yakkety
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q
RUN apt-get -q -y install --autoremove make texlive-latex-extra latexmk latex-beamer make

WORKDIR /data
VOLUME ["/data"]
