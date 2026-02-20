#!/usr/bin/env bash
#
# backup.sh
#

set -e
set -o pipefail
# set -u
# set -x

umask 0022

################################################################################

tar --zstd -vcf isaacsim_ros2_jazzy_backup.tar.zst build install src log
