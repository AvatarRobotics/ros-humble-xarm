# USERPASS="your password" docker build --secret id=userpass,env=USERPASS -t avatarrobotics/ros-humble-xarm:$(date +%Y%m%d) .
FROM ros:humble-ros-base-jammy AS humble-simulation

# Install simulation packages
RUN apt-get update && apt-get install -y --no-install-recommends \
  ros-humble-simulation=0.10.0-1* \
  && rm -rf /var/lib/apt/lists/*

FROM humble-simulation AS xrdp

# Create dev user with sudo access
RUN --mount=type=secret,id=userpass,env=USERPASS \
  useradd -m -s /bin/bash dev && \
  echo "dev:${USERPASS}" | chpasswd && \
  echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install xrdp and xfce for remote desktop
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  xrdp \
  xorgxrdp \
  xorg \
  dbus-x11 \
  locales \
  xfce4 \
  xfce4-terminal \
  && rm -rf /var/lib/apt/lists/*

# Set up locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Configure xrdp
RUN echo "#!/bin/sh\n\
  exec startxfce4" > /etc/xrdp/startwm.sh && \
  chmod +x /etc/xrdp/startwm.sh

# Create .xsession for dev user
RUN echo "#!/bin/sh\n\
  exec startxfce4" > /home/dev/.xsession && \
  chmod +x /home/dev/.xsession && \
  chown dev:dev /home/dev/.xsession

COPY start.bash /home/dev/start.bash


FROM xrdp AS xarm
USER dev

# Get xArm ROS2 and dependencies
RUN mkdir -p /home/dev/xarm_ws/src
WORKDIR /home/dev/xarm_ws/src
RUN git clone https://github.com/xArm-Developer/xarm_ros2.git --recursive -b humble
RUN rosdep update
RUN sudo apt-get update && rosdep install --from-paths /home/dev/xarm_ws/src --ignore-src --rosdistro humble -y

# Build xArm ROS2
WORKDIR /home/dev/xarm_ws
RUN . /opt/ros/humble/setup.sh && colcon build

EXPOSE 3389

FROM xarm AS avatar_challenge

RUN mkdir -p /home/dev/dev_ws/src
COPY avatar_challenge /home/dev/dev_ws/src/avatar_challenge

WORKDIR /home/dev/dev_ws
RUN . /home/dev/xarm_ws/install/setup.sh && colcon build

RUN echo "source /home/dev/dev_ws/install/setup.bash" >> /home/dev/.bashrc

COPY avatar_entrypoint.bash /home/dev/avatar_entrypoint.bash
ENTRYPOINT ["/home/dev/avatar_entrypoint.bash"]
CMD ["/home/dev/start.bash"]
