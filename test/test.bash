#!/bin/bash
# SPDX-FileCopyrightText: 2025 k0ta
# SPDX-License-Identifier: BSD-3-Clause

# 1. 環境準備（出力はすべて捨てる）
set -e
dir=~
[ "$1" != "" ] && dir="$1"
cd $dir/ros2_ws

# ビルドが失敗した場合は、この時点で set -e により即終了(exit 1)する
colcon build --packages-select mypkg > /dev/null 2>&1
source install/setup.bash

# 2. 実行（20秒間稼働させ、ログを保存）
# ここでプログラムが起動しない場合も stderr に何か出る可能性があるため保存
timeout 20s ros2 launch mypkg battery.launch.py > /tmp/mypkg.log 2>&1 || true


# A. パブリッシャーがトピックへ送出しているか（ログの有無）
grep -q "Battery level:" /tmp/mypkg.log || exit 1

# B. サブスクライバーが判定ロジックを通っているか
grep -qE "残量は正常|警告" /tmp/mypkg.log || exit 1

# C. Pythonの致命的なエラー（構文・インポート・属性エラー）の完全排除
! grep -q "Traceback" /tmp/mypkg.log || exit 1

# D. ROS 2の通信基盤（RMW）やノード起動に関するエラーの排除
! grep -qE "error|failed|cannot" /tmp/mypkg.log || exit 1

# E. 依存ライブラリ (psutil) が見つからないエラーの排除
! grep -q "ModuleNotFoundError" /tmp/mypkg.log || exit 1

# F. ロジックチェック：数値（%）が含まれているか
grep -q "[0-9]%" /tmp/mypkg.log || exit 1

# 4. 判定完了
exit 0
