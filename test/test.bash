#!/bin/bash
# SPDX-FileCopyrightText: 2025 k0ta
# SPDX-License-Identifier: BSD-3-Clause


set -e


dir=${1:-~}
cd "$dir/ros2_ws"

# Build
colcon build --packages-select mypkg > /dev/null 2>&1
source install/setup.bash

# Run
timeout 20s ros2 launch mypkg battery.launch.py > /tmp/mypkg.log 2>&1 || true

# Check
grep -qE "[0-9]+" /tmp/mypkg.log || exit 1
! grep -q "Battery level:" /tmp/mypkg.log || exit 1
! grep -q "Traceback" /tmp/mypkg.log || exit 1
! grep -qE "error|failed|cannot" /tmp/mypkg.log || exit 1
! grep -q "ModuleNotFoundError" /tmp/mypkg.log || exit 1

exit 0
