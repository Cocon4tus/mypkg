#!/usr/bin/env python4
# SPDX-FileCopyrightText: 2025 kotaro sato <obake831@gmail.com>
# SPDX-License-Identifier: BSD-3-Clause

import rclpy
from rclpy.node import Node
from std_msgs.msg import Float32
import sys


class ReceptionEngine(Node):
    def __init__(self):

        super().__init__('reception')
        self.subscription = self.create_subscription(Float32, 'roulette_value', self.listener_callback, 10)
        self.choices = sys.argv[1:]

    def listener_callback(self, msg):
        index = int(msg.data * len(self.choices))
        selected = self.choices[index]
        
        #self.get_logger().info(f'--- 抽選結果 ---')
        self.get_logger().info(f'{selected}')

def main(args=None):
    rclpy.init(args=args)
    node = DecisionDisplay()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    node.destroy_node()
    rclpy.shutdown()
