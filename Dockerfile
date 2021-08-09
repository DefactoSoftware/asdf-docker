FROM heroku/heroku:20

ENV DOCKERIZE_VERSION v0.6.1

RUN apt-get update -q && apt-get install -y git curl build-essential libssl-dev automake autoconf libncurses-dev

RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

COPY asdf-install-plugins /bin/asdf-install-plugins
COPY asdf-install-versions /bin/asdf-install-versions

WORKDIR /root

RUN git clone --depth 1 https://github.com/asdf-vm/asdf.git $HOME/.asdf

RUN echo 'export LC_ALL="en_US.UTF-8"' >> $HOME/.profile
RUN echo 'export LC_CTYPE="en_US.UTF-8"' >> $HOME/.profile
RUN echo 'export MAKEFLAGS="-j2"' >> $HOME/.profile
RUN echo 'export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"' >> $HOME/.profile
RUN echo '. $HOME/.asdf/asdf.sh' >> $HOME/.profile

CMD ["bash"]
