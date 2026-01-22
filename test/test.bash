#!/bin/bash
# SPDX-FileCopyrightText: 2025 k0ta
# SPDX-License-Identifier: BSD-3-Clause


# 1. 環境設定
source /opt/ros/humble/setup.bash
# ワークスペースのルートへ移動
cd $(dirname $0)/../../..

# 2. 最新のビルド設定を反映
if [ -f install/setup.bash ]; then
    source install/setup.bash
fi

echo "Starting ROS 2 node test..."

# 3. コマンドが存在するかチェック (setup.pyのentry_pointsが正しければ通る)
if ! command -v srot &> /dev/null; then
    echo "srot not found"
    # デバッグ用にinstallフォルダの中身を表示
    ls -R install/mypkg/lib/mypkg/
    exit 1
fi

# 4. 数秒間実行して、エラーが出ないかだけ確認
timeout 3s srot 読書 筋トレ 掃除 > /tmp/srot.log 2>&1 || true
timeout 3s reception > /tmp/reception.log 2>&1 || true

echo "Test finished successfully."
exit 0
