# Robotics Software Engineer Code Challenge

We have created a Docker container with a basic ROS2 package for you to develop your code in. These are instructions on how to install and run it on Ubuntu or MacOS. Windows hosts are not supported, although these instructions may work (another option to run on Windows is to install Ubuntu in a VM).

## Setup

### Ubuntu

1. Install Docker: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
1. The following instructions assume you can run Docker as non-root user: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
1. Check that Docker works: `docker run hello-world`
1. Install the Remmina Remote Desktop Protocol (RDP) client: `sudo apt-get install remmina` or `sudo snap install remmina`
1. Pull Avatar docker image: `docker pull avatarrobotics/ros-humble-xarm:20250602`

### MacOS

1. Install Docker: https://docs.docker.com/desktop/setup/install/mac-install/
1. Check that Docker works: `docker run hello-world`
1. Install the Windows App (used as the Remote Desktop Protocol (RDP) client): https://apps.apple.com/us/app/windows-app/id1295203466
1. Pull Avatar docker image: `docker pull avatarrobotics/ros-humble-xarm:20250602`

## Starting the Container (both Ubuntu and MacOS)

1. In a terminal, start the docker container: `docker run --name xarm-container --platform linux/amd64 -p 5566:3389 avatarrobotics/ros-humble-xarm:20250602`. You should see a message that the container is running.
1. Open the RDP client (either Remmina or Windows App) and connect to `localhost:5566`
1. Log in with username `dev` and the password that was provided to you.
1. You should see a full desktop.

If you stop the container and need to restart it, you can run `docker start xarm-container && docker attach xarm-container`. Alternately, if you stop the container and want to start fresh (**THIS WILL REMOVE ALL FILES YOU CREATED INSIDE THE CONTAINER**), run `docker container prune`.

## Developing

The Docker container has ROS2 Humble installed, along with the XArm code (https://github.com/xArm-Developer/xarm_ros2/tree/humble). We will be using the XArm7.

The ROS package you will be developing in is in `/home/dev/dev_ws/src/avatar_challenge`. The `/home/dev/.bashrc` already sources `/home/dev/install/setup.bash`, so you can run `ros2` commands right away when you open a terminal. Test the setup by running `ros2 launch avatar_challenge start.launch.py` from a terminal inside the container. You should see RViz start with the MoveIt interface and be able to command the arm.

Add your code to the `avatar_challenge` package, and add any launch configurations into `avatar_challenge/launch/start.launch.py`, which is the launchfile we'll use to test the code. Feel free to change or replace `xarm_moveit_launch` if your code requires it. You may want to develop your code outside of the Docker container to prevent accidentally losing it if the container is cleaned up.

## Submitting

Create a public GitHub (or similar) git repository with your modified `avatar_challenge` code and a `README.md` describing how to build and run the code, as well as any additional information specified in the challenge. Optionally include a Dockerfile to build an updated image, otherwise we will run the code from the `avatarrobotics/ros-humble-xarm:20250602` container. You do not need to include automated tests.
