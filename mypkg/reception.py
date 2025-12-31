#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2025 kotaro sato <obake831@gmail.com>
# SPDX-License-Identifier: BSD-3-Clause


import rclpy
from rclpy.node import Node
from std_msgs.msg import Int32

class BatterySubscriber(Node):
    def __init__(self):
        super().__init__('battery_subscriber')
        self.subscription = self.create_subscription(
            Int32,
            'battery_level',
            self.listener_callback,
            10)
        # 起動メッセージも最小限、または消してもOK
        self.get_logger().info('Start')

    def listener_callback(self, msg):
        level = msg.data
        if level <= 20:
            # 20%以下は warning と数字
            self.get_logger().warn(f'warning {level}')
        else:
            # 通常時は数字のみ（%を消すとよりシンプル）
            self.get_logger().info(f'{level}')

def main(args=None):
    rclpy.init(args=args)
    node = BatterySubscriber()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
