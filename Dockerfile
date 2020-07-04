FROM gcc:latest

WORKDIR /home

RUN git clone https://github.com/cpputest/cpputest.git && \
    cd cpputest && \
    autoreconf . -i && \
    ./configure && \
    make install 

ENV CPPUTEST_HOME="/home/cpputest"

WORKDIR /home/src