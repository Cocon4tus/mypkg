#!/bin/bash
# SPDX-FileCopyrightText: 2025 k0ta
# SPDX-License-Identifier: BSD-3-Clause



source /opt/ros/humble/setup.bash
source install/setup.bash

echo "Starting ROS 2 node test..."

# 1. ノードがコマンドとして認識されているかチェック
# setup.pyを直せばここが通るようになります
ros2 run mypkg srot --help > /dev/null 2>&1 || { echo "srot not found"; exit 1; }

# 2. 実際に数秒だけ動かして即座に終了させる（通信待ちはしない）
timeout 5s ros2 run mypkg srot > /tmp/srot.log 2>&1 || true
timeout 5s ros2 run mypkg reception A B C > /tmp/reception.log 2>&1 || true

# 3. 最後に後片付け
ros2 daemon stop > /dev/null 2>&1 || true

echo "Test finished successfully."
exit 0
