FROM  osrf/ros:humble-desktop
LABEL maintainer="asoragna at irobot dot com"

#######
# OS setup
#######

# working directory
ENV HOME /root
WORKDIR $HOME

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Make apt to always ignore recommended and suggested packages
# This is particularly important with rosdep which invoked apt without `--no-install-recommends`
RUN echo \
  'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > /etc/apt/apt.conf.d/01norecommend

RUN rosdep update

# Upgrade everything
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

#######
# Install Gazebo classic
#######

RUN curl -sSL http://get.gazebosim.org | sh

#######
# Install Gazebo ignition fortress
#######

RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y \
        ignition-fortress \
        ros-humble-ros-ign-bridge \
        ros-humble-ros-ign-gazebo \
        ros-humble-ros-ign-interfaces \
    && rm -rf /var/lib/apt/lists/*

#######
# Install ROS dev tools
#######

RUN apt-get update && apt-get install -y \
        git \
        python3-colcon-common-extensions \
        python3-rosdep \
        python3-vcstool \
    && rm -rf /var/lib/apt/lists/*

#######
# Create 3 packages
#######

RUN mkdir -p $HOME/create3_ws/src
WORKDIR $HOME/create3_ws/src
RUN git clone -b asoragna/humble https://github.com/iRobotEducation/create3_sim.git
WORKDIR $HOME/create3_ws
RUN apt-get update \
    && rosdep install --from-path src -yi --rosdistro humble \
    && rm -rf /var/lib/apt/lists/*
RUN /bin/bash -c '. /opt/ros/humble/setup.sh; IGNITION_VERSION=fortress colcon build'

#######
# Common utilities
#######

RUN apt-get update && apt-get install -y \
        iputils-ping \
        nano \
        vim \
    && rm -rf /var/lib/apt/lists/*

#######
# Env setup
#######

WORKDIR $HOME

RUN echo ' \n\
export IGNITION_VERSION=fortress \n\
source /opt/ros/humble/setup.bash \n\
source /root/create3_ws/install/local_setup.bash' >> $HOME/.bashrc
