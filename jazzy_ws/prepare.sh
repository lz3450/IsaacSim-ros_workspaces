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

. "$SCRIPT_DIR/../../ros2_ws/ros2_setup.sh"
# . /opt/ros/jazzy/local_setup.bash

################################################################################

vcs import --force --shallow --recursive --input deps.repos src

rosdep install \
    --rosdistro=$ROS_DISTRO \
    --reinstall \
    --from-paths src \
    --ignore-src \
    -s | awk '{print $5}' | sed -E -e '/^\s*$/d' -e "/'$/s/'//" | LC_ALL=C sort -n | sed -E \
    -e '/^python3-pytest$/d' \
    -e "s/'$//g" > dep-pkgs.txt

xargs -a dep-pkgs.txt sudo apt install --no-install-recommends -s \
    | (grep "^Inst" || :) | awk '{print $2}' | LC_ALL=C sort -n \
    > dep-pkgs-to-install.txt

if [ -s dep-pkgs.txt ]; then
    xargs -a dep-pkgs.txt sudo apt install --no-install-recommends
fi
