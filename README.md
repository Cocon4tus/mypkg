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
```
cd ~/ros2_ws/src
git clone https://github.com/Cocon4tus/mypkg
cd ~/ros2_ws
colcon build --packages-select mypkg
```

## 実行方法
このパッケージはlaunchファイルで実行できるようになっています。
```
source install/setup.bash
ros2 launch mypkg battery.launch.py
```
実行結果
```
[INFO] [launch]: Default logging verbosity is set to INFO
[INFO] [battery-1]: process started with pid [298722]
[INFO] [reception-2]: process started with pid [298724]
[reception-2] [INFO] [1767190637.537391095] [battery_subscriber]: Start
[reception-2] [INFO] [1767190638.529133075] [battery_subscriber]: 72
```
このプログラムはCtrl+Cを入力すると終了します。

## テスト環境
- ubuntu　22.04

## ライセンス
- 
-
