# docker build -t avatarrobotics/ros-humble-xarm .
FROM osrf/ros:humble-simulation

# Get xArm ROS2 and dependencies
RUN mkdir -p dev_ws/src
WORKDIR /dev_ws/src
RUN git clone https://github.com/xArm-Developer/xarm_ros2.git --recursive -b $ROS_DISTRO
RUN rosdep update
RUN apt-get update &&rosdep install --from-paths /dev_ws/src --ignore-src --rosdistro $ROS_DISTRO -y

# Build xArm ROS2
WORKDIR /dev_ws
RUN . /opt/ros/humble/setup.sh && colcon build

COPY avatar_entrypoint.sh /avatar_entrypoint.sh
ENTRYPOINT ["/avatar_entrypoint.sh"]
CMD ["/bin/bash"]
