#!/bin/bash
# SPDX-FileCopyrightText: 2025 k0ta
# SPDX-License-Identifier: BSD-3-Clause


source /opt/ros/humble/setup.bash

colcon build --packages-select mypkg || 
exit 1
source install/setup.bash

ros2 pkg executables mypkg | grep -q srot || exit 1
ros2 pkg executables mypkg | 
grep -q reception || exit 1

timeout 3s ros2 run mypkg reception > /dev/null 2>&1
timeout 3s ros2 run mypkg reception " " "!!!" "漢字" > /dev/null 2>&1

timeout 10s ros2 run mypkg srot > /dev/null 2>&1 &
ros2 topic pub --once /roulette_value std_msgs/msg/Float32 "{data: 1.0}" > /dev/null 2>&1 &
timeout 10s ros2 run mypkg reception A B C > /tmp/mypkg_test.log 2>&1 &

sleep 12

grep -qiE "error|fault|traceback" /tmp/mypkg_test.log && 
exit 1
[ ! -s /tmp/mypkg_test.log ] && exit 1

exit 0

