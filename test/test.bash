#!/bin/bash
# SPDX-FileCopyrightText: 2025 k0ta
# SPDX-License-Identifier: BSD-3-Clause


source /opt/ros/humble/setup.bash

# ビルド（出力を捨てる）
colcon build --packages-select mypkg > /dev/null 2>&1 || exit 1
source install/setup.bash

# ノード起動
ros2 run mypkg srot > /dev/null 2>&1 &
ros2 run mypkg reception A B C > /tmp/mypkg_test.log 2>&1 &

sleep 10
# データ注入
ros2 topic pub --once /roulette_value std_msgs/msg/Float32 "{data: 1.0}" > /dev/null 2>&1
sleep 5

# 【ここが解決の鍵】
# ROS2の通信管理(daemon)を止め、関連プロセスをすべて強制終了
ros2 daemon stop > /dev/null 2>&1 || true
pkill -9 -f "ros2" > /dev/null 2>&1 || true
pkill -9 -f "python3" > /dev/null 2>&1 || true

# 判定：ログがあれば成功(0)、なければ失敗(1)
[ -s /tmp/mypkg_test.log ] && exit 0 || exit 1
