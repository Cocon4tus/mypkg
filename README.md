# mypkg
このパッケージは、PCのバッテリー残量を随時提示し、確認するROS2のパッケージです。

## 機能
- battery.py : `psutil` を使用してバッテリー残量を取得し、パブリッシュします。
- reception.py : 受信した残量が20%以下のときに警告（WARN）を表示します。
- battery.launch.py : 送信・受信の両方のノードを一度に起動します。

## 実行環境
- ROS 2 Humble (Ubuntu 22.04)
- Python 3.10
- 依存ライブラリ: `psutil`

##　ダウンロード方法
---
cd ~/ros2_ws/src
git clone 
---
