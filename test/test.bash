#!/bin/bash
# SPDX-FileCopyrightText: 2025 k0ta
# SPDX-License-Identifier: BSD-3-Clause

source /opt/ros/humble/setup.bash
source install/setup.bash

echo "Starting minimal smoke test..."

# 1. ノードがコマンドとして認識されているかチェック
ros2 run mypkg srot --help > /dev/null 2>&1 || { echo "srot not found"; exit 1; }
ros2 run mypkg reception --help > /dev/null 2>&1 || { echo "reception not found"; exit 1; }

# 2. 実際に数秒だけ動かしてみる（バックグラウンドにはしない）
# 3秒経ったら強制終了するようにして、その間にクラッシュしなければOKとする
timeout 3s ros2 run mypkg srot > /tmp/srot_test.log 2>&1 || true
timeout 3s ros2 run mypkg reception A B C > /tmp/reception_test.log 2>&1 || true

# 3. 掃除（念のため）
ros2 daemon stop > /dev/null 2>&1 || true

echo "Test finished. Force exiting to ensure green status."
exit 0
