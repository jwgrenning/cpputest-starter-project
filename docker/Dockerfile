FROM gcc:12.2.0

# Install cpputest
WORKDIR /opt/cpputest

RUN git clone --depth 1 --branch v4.0 https://github.com/cpputest/cpputest.git .
RUN autoreconf . -i && \
    ./configure && \
    make tdd && \
    make install 

ENV CPPUTEST_HOME=/opt/cpputest

# Install leagcy-build
WORKDIR /opt/legacy-build
RUN git clone --depth 1 https://github.com/jwgrenning/legacy-build.git .
RUN git config pull.ff only
RUN git pull
RUN git submodule update --init --recursive
ENV LEGACY_BUILD="/opt/legacy-build"
RUN echo '#!/bin/bash' >>/usr/bin/legacy-build && \
    echo '/opt/legacy-build/legacy-build.sh $1 $2 $3' >>/usr/bin/legacy-build && \
        chmod +x /usr/bin/legacy-build
RUN echo 'echo run "make -C <test-makefile-dir>/" or "legacy-build"' >> ~/.bashrc

WORKDIR /home/src
