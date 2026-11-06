#!/usr/bin/env bash
#
# get-dep-pkgs.sh
#

set -e
set -o pipefail
# set -u
# set -x

umask 0022

################################################################################

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# . "$SCRIPT_DIR/../../ros2_ws/ros2_setup.sh"
. /opt/ros/jazzy/local_setup.bash

################################################################################

# vcs import --force --shallow --recursive --input deps.repos src

rosdep update --rosdistro=jazzy
rosdep install \
    --rosdistro=jazzy \
    --from-paths src \
    --ignore-src \
    -s | awk '{print $5}' | sed -E -e '/^\s*$/d' -e "/'$/s/'//" | LC_ALL=C sort -n > /tmp/deps.txt
xargs -a /tmp/deps.txt sudo apt install --no-install-recommends
