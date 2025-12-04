import rclpy
from rclpy.node import Node
from person_msgs.srv import Query

rclpy.init()
node = Node("talker")


def cb(request,response):
    if request.name == "佐藤虎太朗":
        response.age = 19
    else:
        response.age = 255

    return response


def main():
    srv = node.create_service(Query, "query", cb)
    rclpy.spin(node)



