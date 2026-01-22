#!/bin/bash
# SPDX-FileCopyrightText: 2025 k0ta
# SPDX-License-Identifier: BSD-3-Clause


source /opt/ros/humble/setup.bash

# ビルド
colcon build --packages-select mypkg > /dev/null 2>&1 || exit 1
source install/setup.bash

# 15秒で確実に切れるように timeout をかける
timeout 15s ros2 run mypkg srot > /dev/null 2>&1 &
SROT_PID=$!
timeout 15s ros2 run mypkg reception A B C > /tmp/mypkg_test.log 2>&1 &
RECEPTION_PID=$!

sleep 10
# 注入
ros2 topic pub --once /roulette_value std_msgs/msg/Float32 "{data: 1.0}" > /dev/null 2>&1

sleep 5

# --- ここが重要：残っているプロセスを強制終了 ---
kill $SROT_PID $RECEPTION_PID > /dev/null 2>&1 || true

# 判定
grep -qiE "error|fault|traceback" /tmp/mypkg_test.log && exit 1
[ -s /tmp/mypkg_test.log ] && exit 0 || exit 1
