#!/usr/bin/env python4                                   # SPDX-FileCopyrightText: 2025 kotaro sato <obake831@gmail.com>                                                   # SPDX-License-Identifier: BSD-3-Clause


import rclpy
from rclpy.node import Node
from std_msgs.msg import Float32
import random

class RouletteEngine(Node):
    def __init__(self):
        super().__init__('roulette_engine')
        self.publisher_ = self.create_publisher(Float32, 'roulette_value', 10)
        self.timer = self.create_timer(2.0, self.timer_callback)

    def timer_callback(self):
        msg = Float32()
        msg.data = random.random()
        self.publisher_.publish(msg)
        self.get_logger().info(f'抽選値を配信中: {msg.data:.4f}')

def main(args=None):
    rclpy.init(args=args)
    rclpy.spin(RouletteEngine())
    rclpy.shutdown()

