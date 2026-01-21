#!/usr/bin/env python4
# SPDX-FileCopyrightText: 2025 kotaro sato <obake831@gmail.com>
# SPDX-License-Identifier: BSD-3-Clause

import rclpy
from rclpy.node import Node
from std_msgs.msg import Int32
import psutil

class BatteryPublisher(Node):
    def __init__(self):
        super().__init__('battery_publisher')
        self.publisher_ = self.create_publisher(Int32, 'battery_level', 10)
        
        self.timer = self.create_timer(1.0, self.timer_callback)

    def timer_callback(self):
        battery = psutil.sensors_battery()
        if battery is not None:
            msg = Int32()
            msg.data = int(psutil.sensors_battery().percent)
            self.publisher_.publish(msg)
            
        else:
            
            pass

def main(args=None):
    rclpy.init(args=args)
    node = BatteryPublisher()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
