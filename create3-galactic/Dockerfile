
FROM  osrf/ros:galactic-desktop
LABEL maintainer="asoragna at irobot dot com"

# working directory
ENV HOME /root
WORKDIR $HOME

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#######
# Install Gazebo
#######

RUN curl -sSL http://get.gazebosim.org | sh

#######
# Install ROS dev tools
#######

RUN apt-get update && apt-get install -y \
    git \
    iputils-ping \ 
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-vcstool

RUN rosdep update

#######
# Create3 workspace
#######

RUN mkdir -p $HOME/create3_ws/src
WORKDIR $HOME/create3_ws/src
RUN git clone https://github.com/iRobotEducation/create3_sim.git
RUN git clone https://github.com/iRobotEducation/create3_examples.git
WORKDIR $HOME/create3_ws
RUN vcs import $HOME/create3_ws/src/ < $HOME/create3_ws/src/create3_sim/dependencies.repos
RUN apt-get update && rosdep install --from-path src -yi --rosdistro galactic
RUN /bin/bash -c '. /opt/ros/galactic/setup.sh; colcon build'

#######
# Env setup
#######

WORKDIR $HOME

RUN echo ' \n\
source /opt/ros/galactic/setup.bash \n\
source /root/create3_ws/install/local_setup.bash ' >> $HOME/.bashrc
