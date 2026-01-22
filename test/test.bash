#!/bin/bash
# SPDX-FileCopyrightText: 2025 k0ta
# SPDX-License-Identifier: BSD-3-Clause


source /opt/ros/humble/setup.bash

# ビルド
colcon build --packages-select mypkg > /dev/null 2>&1 || exit 1
source install/setup.bash

# ノード起動
ros2 run mypkg srot > /dev/null 2>&1 &
SROT_PID=$!
ros2 run mypkg reception A B C > /tmp/mypkg_test.log 2>&1 &
RECEPTION_PID=$!

# 注入待ち
sleep 10
ros2 topic pub --once /roulette_value std_msgs/msg/Float32 "{data: 1.0}" > /dev/null 2>&1
sleep 5

# 【ここが解決の核心】これがないと yml が終わりません
kill -9 $SROT_PID $RECEPTION_PID > /dev/null 2>&1 || true
ros2 daemon stop > /dev/null 2>&1 || true
pkill -9 -f "ros2" > /dev/null 2>&1 || true

# 判定：ログがあれば成功(0)
[ -s /tmp/mypkg_test.log ] && exit 0 || exit 1
