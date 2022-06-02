#!/bin/bash
IFS=$'\t\n'
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

{
    # https://github.com/nodesource/distributions/blob/master/README.md#manual-installation

    KEYRING=/usr/share/keyrings/nodesource.gpg
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | tee "$KEYRING" >/dev/null
    gpg --no-default-keyring --keyring "$KEYRING" --list-keys | grep 9FD3B784BC1C6FC31A8A0A1C1655A0AB68576280
    echo "deb [signed-by=$KEYRING] https://deb.nodesource.com/node_16.x $(lsb_release -s -c) main" | tee /etc/apt/sources.list.d/nodesource.list
}

library_deps=(
    autoconf \
    automake \
    bison \
    curl \
    g++ \
    gawk \
    gcc \
    gnupg2 \
    libc6-dev \
    libffi-dev \
    libgdbm-dev \
    libgmp-dev \
    libncurses5-dev \
    libpq-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libtool \
    libyaml-dev \
    make \
    nodejs \
    patch \
    patch \
    pkg-config \
    sqlite3 \
    sudo \
    zlib1g-dev \
)

service_deps=(
    nano \
    postgresql \
    postgresql-contrib \
    redis-server \
    siege \
    tmux \
)

apt-get update
apt-get upgrade -y
apt-get install --no-install-recommends -y \
    "${library_deps[@]}" "${service_deps[@]}"
apt clean

npm install -g yarn

echo "127.0.0.1 db" >> /etc/hosts
echo "127.0.0.1 redis" >> /etc/hosts

sudo -i -u postgres psql << EOF
CREATE DATABASE talent_test_dev_development;
CREATE DATABASE talent_test_dev_test;
CREATE ROLE dev LOGIN SUPERUSER PASSWORD 'example';
GRANT ALL PRIVILEGES ON DATABASE talent_test_dev_development TO dev;
GRANT ALL PRIVILEGES ON DATABASE talent_test_dev_test TO dev;
EOF

sudo -i -u vagrant bash << EOF
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
curl -sSL https://get.rvm.io | bash -s stable
source /home/vagrant/.rvm/scripts/rvm
rvm install 3.0
rvm use 3.0 --default
gem install bundler:2.2.17 foreman

cd app

if ! ln -s Dockerfile symlink_test ; then
    bundle config unset --local path
    yarn config set modules-folder ../node_modules
fi
rm -f symlink_test

yarn
bundle

bundle exec rails db:setup
EOF

cat << EOF >> /etc/environment
RAILS_MASTER_KEY=fa250faaa50267df2d7f08bdc0169adb
EOF
