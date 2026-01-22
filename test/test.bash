#!/bin/bash
# SPDX-FileCopyrightText: 2025 k0ta
# SPDX-License-Identifier: BSD-3-Clause


source /opt/ros/humble/setup.bash

# ビルド（失敗したら即終了）
colcon build --packages-select mypkg > /dev/null 2>&1 || exit 1
source install/setup.bash

# ノードをバックグラウンドで起動
ros2 run mypkg srot > /dev/null 2>&1 &
SROT_PID=$!
ros2 run mypkg reception A B C > /tmp/mypkg_test.log 2>&1 &
RECEPTION_PID=$!

# 通信が安定するまで待機
sleep 10

# テストデータを注入
ros2 topic pub --once /roulette_value std_msgs/msg/Float32 "{data: 1.0}" > /dev/null 2>&1

# ログが書き込まれるのを待つ
sleep 5

# 【最重要】kill でプロセスを確実に抹殺して GitHub Actions を終わらせる
kill -9 $SROT_PID $RECEPTION_PID > /dev/null 2>&1 || true
pkill -9 -f "ros2 run mypkg" > /dev/null 2>&1 || true

# 判定：ログにエラーがなく、かつ中身があること
if grep -qiE "error|fault|traceback" /tmp/mypkg_test.log; then
    exit 1
fi

[ -s /tmp/mypkg_test.log ] && exit 0 || exit 1
