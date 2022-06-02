#!/bin/bash
#set -x
set -euo pipefail

# <rant>
# Shame on Docker: https://github.com/moby/moby/issues/7198
# This is ridiculous. It's been 7+ years and we still have no convenient way of
# mapping users between the containers and the host.
# This is not convenient: https://docs.docker.com/engine/security/userns-remap/
# And having to deal with filesystem permissions on a development machine is
# beyond annoying and breaks exactly the kind of isolation one tries to achieve
# I wrote a hack like this in 2014. I shouldn't have to be writing the same
# hack in 2021.
# </rant>

if [ $UID -eq 0 ] && [ -d /app/.git ]; then
    TARGET_UID=$(stat -c "%u" /app/.git)
    TARGET_GID=$(stat -c "%g" /app/.git)

    if ! getent group "$TARGET_GID" &>/dev/null; then
        groupadd --gid "$TARGET_GID" app
    fi

    if ! getent passwd "$TARGET_UID" &>/dev/null; then
        useradd --create-home --uid "$TARGET_UID" --gid "$TARGET_GID" --shell /bin/bash app
        echo 'source /usr/local/nvm/nvm.sh' >> /home/app/.bashrc
        echo 'source /usr/local/rvm/scripts/rvm' >> /home/app/.bashrc
    fi

    if [ "$TARGET_UID" != "$UID" ] || [ "$TARGET_GID" != "$(id -g)" ]; then
        exec /bin/gosu "$TARGET_UID:$TARGET_GID" "${BASH_SOURCE[0]}" "$@"
    fi

fi

set +ux
# Ensure we have rvm/nvm loaded even if not executing into a shell
# shellcheck disable=SC1091
source /usr/local/nvm/nvm.sh
# shellcheck disable=SC1091
source /usr/local/rvm/scripts/rvm

exec "$@"
