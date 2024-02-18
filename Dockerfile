FROM ubuntu:18.04

RUN apt-get update -y && apt-get install -y build-essential nasm file  bsdmainutils less xxd


RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
