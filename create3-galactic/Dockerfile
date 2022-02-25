FROM  osrf/ros:galactic-desktop
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

# Upgrade everything: this is needed to fix some errors in Fast-DDS
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

#######
# Install Gazebo classic
#######

RUN curl -sSL http://get.gazebosim.org | sh

#######
# Install Gazebo ignition edifice
#######

RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -
RUN apt-get update && apt-get install -y \
        ignition-edifice \
        ros-galactic-ros-ign-bridge \
        ros-galactic-ros-ign-gazebo \
        ros-galactic-ros-ign-interfaces \
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
# Create3 workspace
#######

RUN mkdir -p $HOME/create3_ws/src
WORKDIR $HOME/create3_ws/src
RUN git clone -b main https://github.com/iRobotEducation/create3_sim.git
RUN git clone https://github.com/iRobotEducation/create3_examples.git
WORKDIR $HOME/create3_ws
RUN vcs import $HOME/create3_ws/src/ < $HOME/create3_ws/src/create3_sim/dependencies.repos
RUN rosdep update \
    && apt-get update \
    && rosdep install --from-path src -yi --rosdistro galactic \
    && rm -rf /var/lib/apt/lists/*
RUN /bin/bash -c '. /opt/ros/galactic/setup.sh; IGNITION_VERSION=edifice colcon build'

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
export IGNITION_VERSION=edifice \n\
source /opt/ros/galactic/setup.bash \n\
source /root/create3_ws/install/local_setup.bash' >> $HOME/.bashrc
