#!/bin/bash
# SPDX-FileCopyrightText: 2025 k0ta
# SPDX-License-Identifier: BSD-3-Clause


source /opt/ros/humble/setup.bash

# ビルドと環境反映
colcon build --packages-select mypkg || exit 1
source install/setup.bash

# 1. 実行ファイルが存在するか（ビルドが正しく通ったか）
ros2 pkg executables mypkg | grep -q srot || exit 1
ros2 pkg executables mypkg | grep -q reception || exit 1

# 2. 通信・ロジックテスト
# srot.py をバックグラウンドで起動
timeout 15s ros2 run mypkg srot > /dev/null 2>&1 &
# reception.py をログを取りながら起動
timeout 15s ros2 run mypkg reception A B C > /tmp/mypkg_test.log 2>&1 &

# ノードが立ち上がり、通信が1回発生するまで待つ
sleep 10

# 3. 【重要】境界値 1.0 を注入してロジックをテスト
ros2 topic pub --once /roulette_value std_msgs/msg/Float32 "{data: 1.0}" > /dev/null 2>&1

# 少し待ってから結果を確認
sleep 5

# エラーログの判定
if grep -qiE "error|fault|traceback" /tmp/mypkg_test.log; then
    echo "--- TEST FAILED: Error found in logs ---"
    cat /tmp/mypkg_test.log
    exit 1
fi

# ログが空でなければ合格（何かしら受信した証拠）
if [ ! -s /tmp/mypkg_test.log ]; then
    echo "--- TEST FAILED: No output from reception node ---"
    exit 1
fi

echo "--- TEST PASSED ---"
exit 0

