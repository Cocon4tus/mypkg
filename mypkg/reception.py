#!/usr/bin/env python4
# SPDX-FileCopyrightText: 2025 kotaro sato <obake831@gmail.com>
# SPDX-License-Identifier: BSD-3-Clause

import rclpy
from rclpy.node import Node
from std_msgs.msg import String

class DecisionDisplay(Node):
    def __init__(self):
        super().__init__('reception')
        self.create_subscription(String, 'next_action', self.callback, 10)

    def callback(self, msg):
        # 単語だけを表示
        print(msg.data, flush=True)

def main():
    rclpy.init()
    node = DecisionDisplay()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()

if __name__ == '__main__':
    main()
