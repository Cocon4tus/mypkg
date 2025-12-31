#!/bin/bash
# SPDX-FileCopyrightText: 2025 k0ta
# SPDX-License-Identifier: BSD-3-Clause

set -e
dir=${1:-~}
cd "$dir/ros2_ws"

# Build
colcon build --packages-select mypkg > /dev/null 2>&1
source install/setup.bash

# Run
timeout 20s ros2 launch mypkg battery.launch.py > /tmp/mypkg.log 2>&1 || true

# Check
# 1. 数字が出力されているか（receptionの動作確認）
grep -qE "[0-9]+" /tmp/mypkg.log || exit 1

# 2. Pythonの致命的なエラーが出ていないか
! grep -q "Traceback" /tmp/mypkg.log || exit 1

# 3. 依存ライブラリ不足がないか
! grep -q "ModuleNotFoundError" /tmp/mypkg.log || exit 1

exit 0
