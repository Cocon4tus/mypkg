#!/bin/bash
# SPDX-FileCopyrightText: 2025 k0ta
# SPDX-License-Identifier: BSD-3-Clause


# ROS2環境の読み込み
source /opt/ros/humble/setup.bash

# ビルド（すでにyml側で行っている場合はスキップされますが、念のため）
colcon build --packages-select mypkg || exit 1
source install/setup.bash

# 【修正ポイント】実行ファイルが存在するかチェック
ros2 pkg executables mypkg | grep -q srot || exit 1
ros2 pkg executables mypkg | grep -q reception || exit 1

# 異常入力テスト（短時間で終わらせる）
timeout 3s ros2 run mypkg reception > /dev/null 2>&1
timeout 3s ros2 run mypkg reception " " "!!!" "漢字" > /dev/null 2>&1

# 通信テスト：1.0を注入してロジック検証
timeout 10s ros2 run mypkg srot > /dev/null 2>&1 &
# 境界値1.0をパブリッシュ
ros2 topic pub --once /roulette_value std_msgs/msg/Float32 "{data: 1.0}" > /dev/null 2>&1 &
timeout 10s ros2 run mypkg reception A B C > /tmp/mypkg_test.log 2>&1 &

# 通信を待つ
sleep 12

# 判定：Traceback（Pythonエラー）が出ていなければ合格
if grep -qiE "error|fault|traceback" /tmp/mypkg_test.log; then
    cat /tmp/mypkg_test.log
    exit 1
fi

exit 0

