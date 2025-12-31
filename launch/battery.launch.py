import launch
import launch.actions
import launch.substitutions
import launch_ros.actions

def generate_launch_description():
    return launch.LaunchDescription([
        # 1. 送信側（battery.py）の起動
        launch_ros.actions.Node(
            package='mypkg',
            executable='battery_publisher',
            name='pub_node'
        ),
        # 2. 受信側（battery_subscriber.py）の起動
        launch_ros.actions.Node(
            package='mypkg',
            executable='battery_subscriber',
            name='sub_node'
        ),
    ])

