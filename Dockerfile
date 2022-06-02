FROM --platform=linux/amd64 ubuntu:focal

SHELL ["/bin/bash", "-l", "-c"]

# so tzdata doesn't ask us what timezone we're in
ENV TZ=Etc/UTC

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    gnupg2 \
    libpq-dev \
    curl \
    sudo \
    patch \
    gawk \
    g++ \
    gcc \
    autoconf \
    automake \
    bison \
    libc6-dev \
    libffi-dev \
    libgdbm-dev \
    libncurses5-dev \
    libsqlite3-dev \
    libtool \
    libyaml-dev \
    make \
    patch \
    pkg-config \
    sqlite3 \
    zlib1g-dev \
    libgmp-dev \
    libreadline-dev \
    libssl-dev \
    nano \
    tmux \
&& apt clean

RUN mkdir -p /usr/local/nvm \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | env NVM_DIR=/usr/local/nvm bash \
    && source /usr/local/nvm/nvm.sh \
    && nvm install 16 \
    && npm install -g yarn

RUN gpg --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

RUN groupadd -g 65000 rvm \
    && curl -sSL https://get.rvm.io | bash -s stable

RUN rvm install 3.0

RUN gem install bundler:2.2.17

ADD https://github.com/tianon/gosu/releases/download/1.12/gosu-amd64 /bin/gosu
RUN chmod +x /bin/gosu
ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash", "-l"]
