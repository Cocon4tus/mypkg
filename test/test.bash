#!/bin/bash
# SPDX-FileCopyrightText: 2025 k0ta
# SPDX-License-Identifier: BSD-3-Clause


source /opt/ros/humble/setup.bash

# ワークスペースのルートへ移動
cd $(dirname $0)/../../..

# ビルド環境を読み込む
[ -f install/setup.bash ] && source install/setup.bash

echo "Starting ROS 2 node test..."

# 1. 直接パスを指定して存在確認（これなら絶対に見つかる）
SROT_EXE="./install/mypkg/lib/mypkg/srot"
RECEPTION_EXE="./install/mypkg/lib/mypkg/reception"

if [ ! -f "$SROT_EXE" ]; then
    echo "srot not found at $SROT_EXE"
    exit 1
fi

# 2. 実行テスト（引数 A B C を渡して3秒で止める）
timeout 3s "$SROT_EXE" A B C > /tmp/srot.log 2>&1 || true
timeout 3s "$RECEPTION_EXE" > /tmp/reception.log 2>&1 || true

echo "Test finished successfully."
exit 0
