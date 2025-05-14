# Robotics Software Engineer Code Challenge

These instructions work with Docker on an Ubuntu host. You may be able to get them to work on MacOS, but it's a little tricky getting X11 forwarding to work.

## Setup

1. Install Docker: https://docs.docker.com/engine/install/
1. Pull Avatar docker image: `docker pull avatarrobotics/ros-humble-xarm`

## Running

```bash
xhost + && docker run -it -v /tmp/.X11-unix:/tmp/.X11-unix:ro -e DISPLAY=$DISPLAY avatarrobotics/ros-humble-xarm || xhost -
```
