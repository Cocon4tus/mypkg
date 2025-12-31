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
        self.get_logger().info('バッテリー監視（受信側）が起動しました')

    def listener_callback(self, msg):
        
        level = msg.data
        if level <= 20:
            
            self.get_logger().warn(f'warning{level}%')
        else:
            
            self.get_logger().info(f'{level}%')

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

