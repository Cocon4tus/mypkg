#!/bin/bash
# SPDX-FileCopyrightText: 2025 k0ta
# SPDX-License-Identifier: BSD-3-Clause


source /opt/ros/humble/setup.bash

# セットアップとビルド
colcon build --packages-select mypkg > /dev/null 2>&1 || exit 1
source install/setup.bash

# ノード起動と1.0注入テスト
timeout 15s ros2 run mypkg srot > /dev/null 2>&1 &
timeout 15s ros2 run mypkg reception A B C > /tmp/mypkg_test.log 2>&1 &

sleep 10
ros2 topic pub --once /roulette_value std_msgs/msg/Float32 "{data: 1.0}" > /dev/null 2>&1
sleep 5

# 判定ロジック：エラーがあれば1、成功（ログが空でない）なら0
grep -qiE "error|fault|traceback" /tmp/mypkg_test.log && exit 1
[ -s /tmp/mypkg_test.log ] && exit 0 || exit 1
