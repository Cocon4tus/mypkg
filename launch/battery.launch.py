import launch
import launch.actions
import launch.substitutions
import launch_ros.actions

def generate_launch_description():
    # バッテリー残量を送るノード
    battery_node = launch_ros.actions.Node(
        package='mypkg',
        executable='battery',
    )
    # バッテリー残量を受信して表示するノード
    reception_node = launch_ros.actions.Node(
        package='mypkg',
        executable='reception',
    )

    return launch.LaunchDescription([
        battery_node,
        reception_node
    ])
