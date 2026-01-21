#!/usr/bin/env python4                                   # SPDX-FileCopyrightText: 2025 kotaro sato <obake831@gmail.com>                                                   # SPDX-License-Identifier: BSD-3-Clause

import rclpy
from rclpy.node import Node
from std_msgs.msg import Float32

class DecisionDisplay(Node):
    def __init__(self):
        super().__init__('decision_display')
        self.subscription = self.create_subscription(Float32, 'roulette_value', self.listener_callback, 10)
        
        # 【ここをユーザーが書き換える！】
        self.choices = ["課題をやる", "お風呂に入る", "動画を見る", "寝る"]

    def listener_callback(self, msg):
        index = int(msg.data * len(self.choices))
        selected = self.choices[index]
        
        self.get_logger().info(f'--- 抽選結果 ---')
        self.get_logger().info(f'運命の選択: 【 {selected} 】')

def main(args=None):
    rclpy.init(args=args)
    rclpy.spin(DecisionDisplay())
    rclpy.shutdown()
