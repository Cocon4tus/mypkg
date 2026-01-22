#!/usr/bin/env python4
# SPDX-FileCopyrightText: 2025 kotaro sato <obake831@gmail.com>
# SPDX-License-Identifier: BSD-3-Clause


import rclpy
from rclpy.node import Node
from std_msgs.msg import String
import sys
import random

class RouletteEngine(Node):
    def __init__(self):
        super().__init__('srot')
        # 引数があればそれをリストにし、なければデフォルトをセット
        self.actions = sys.argv[1:] if len(sys.argv) > 1 else ["A", "B", "C"]
        self.pub = self.create_publisher(String, 'next_action', 10)
        self.timer = self.create_timer(2.0, self.timer_callback)

    def timer_callback(self):
        msg = String()
        msg.data = random.choice(self.actions)
        self.pub.publish(msg)
        # 自分の画面にも何を送ったか表示
        self.get_logger().info(msg.data)

def main():
    rclpy.init()
    node = RouletteEngine()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()

if __name__ == '__main__':
    main()
