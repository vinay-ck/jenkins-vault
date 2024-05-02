FROM ubuntu 
MAINTAINER vinay.naidu@cloud-kinetics.com 

RUN apt-get update 
RUN apt-get install telnet -y 
CMD [“echo”,”Image created”] 
