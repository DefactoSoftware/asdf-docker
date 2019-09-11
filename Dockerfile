FROM alpine:3.9

ENV ALPINE_VERSION=3.9 \
    GLIBC_VERSION=2.30-r0 \
    DOCKERIZE_VERSION=0.6.1

RUN echo "@main http://dl-cdn.alpinelinux.org/alpine/v$ALPINE_VERSION/main" >> /etc/apk/repositories
RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/v$ALPINE_VERSION/community" >> /etc/apk/repositories

RUN apk --no-cache add bash git build-base automake autoconf readline-dev \
    ncurses-dev openssl-dev yaml-dev libxslt-dev libffi-dev libtool \
    unixodbc-dev openssh-client curl gnupg coreutils libstdc++6 imagemagick

# Glibc for compatibility with asdf-nodejs
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    &&  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-$GLIBC_VERSION.apk" \
    &&  apk --no-cache add "glibc-$GLIBC_VERSION.apk" \
    &&  rm "glibc-$GLIBC_VERSION.apk" \
    &&  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-bin-$GLIBC_VERSION.apk" \
    &&  apk --no-cache add "glibc-bin-$GLIBC_VERSION.apk" \
    &&  rm "glibc-bin-$GLIBC_VERSION.apk" \
    &&  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-i18n-$GLIBC_VERSION.apk" \
    &&  apk --no-cache add "glibc-i18n-$GLIBC_VERSION.apk" \
    &&  rm "glibc-i18n-$GLIBC_VERSION.apk"

RUN wget https://github.com/jwilder/dockerize/releases/download/v$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-v$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-v$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-v$DOCKERIZE_VERSION.tar.gz

COPY shasum /bin/shasum
COPY asdf-install-plugins /bin/asdf-install-plugins
COPY asdf-install-versions /bin/asdf-install-versions

WORKDIR ~/

RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf
RUN echo -e '\nsource $HOME/.asdf/asdf.sh' >> ~/.bashrc

CMD ["bash"]
