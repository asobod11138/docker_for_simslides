FROM nvidia/cudagl:10.0-runtime-ubuntu18.04

# meta data
LABEL Maintainer="asobo11138 <asobod11138@gmail.com>"
LABEL Base = "nvidia/cudagl:10.0-runtime-ubuntu16.04 \
              6buntu18.04, CUDA10.0, OpenGL(glvnd1.0) "
LABEL Description="Customized ROS melodic on Ubuntu 18.04"
LABEL Version="0.1"
################# set Japanese environment #############
RUN apt update \
    && apt install -y locales \
    && locale-gen ja_JP.UTF-8 \
    && echo "export LANG=ja_JP.UTF-8" >> ~/.bashrc

# setup timezone
RUN echo 'Asia/Tokyo' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apt-get update && apt-get install -q -y tzdata && rm -rf /var/lib/apt/lists/* 

################# install ros melodic refered on RosWiki #########################

# install packages
RUN apt update && apt install -q -y \
    dirmngr \
    gnupg2 \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# install ros packages
ENV ROS_DISTRO melodic
RUN apt update && apt install -y \
    ros-melodic-desktop-full \
    && rm -rf /var/lib/apt/lists/*

# Initialize rosdep
RUN rosdep init \
&& rosdep update

# Environment Setup for ROS 
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc \
RUN source ~/.bahsrc

# Dependencies for building packages 何故か↑でsource ~/.bashrcをしないとそんなリポジトリ無いって怒られる
RUN apt update && apt  install -y python-rosinstall python-rosinstall-generator python-wstool build-essential  python-catkin-tools

############# GAZEBO9 ############################
# compile and install gazebo                                                                                 
RUN hg clone https://bitbucket.org/osrf/gazebo /tmp/gazebo && \
    cd /tmp/gazebo/ && \
    hg checkout gazebo9 && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr . && \
    make -j$(nproc) install && \
    ldconfig && \
    cd && rm -r /tmp/gazebo

# compile and install gazebo_ros_plugin
RUN mkdir -p /tmp/catkin_ws/src && \
    cd /tmp/catkin_ws/src && \
    git clone https://github.com/ros-simulation/gazebo_ros_pkgs.git -b melodic-devel && \
    cd /tmp/catkin_ws && \
    sed -i 's|<build_export_depend>libgazebo7-dev</build_export_depend>||g' src/gazebo_ros_pkgs/gazebo_dev/package.xml && \
    sed -i 's|<exec_depend>gazebo</exec_depend>||g' src/gazebo_ros_pkgs/gazebo_dev/package.xml && \
    /bin/bash -c '. /opt/ros/melodic/setup.bash; rosdep update' && \
    /bin/bash -c '. /opt/ros/melodic/setup.bash; rosdep install --from-paths src --ignore-src --rosdistro melodic -y' && \
    /bin/bash -c '. /opt/ros/melodic/setup.bash; catkin_make install -DCMAKE_INSTALL_PREFIX=/opt/ros/melodic' && \
    cd && rm -r /tmp/catkin_ws


############### install some tools ###################
RUN apt update\
    && apt install -y \
    vim \
    curl \
    python-pip \
    && rm -rf /var/lib/apt/lists/*


############## install simslides ##################
WORKDIR /root
RUN git clone https://github.com/chapulina/simslides.git
RUN apt update && apt install -y imagemagick

# biuld
WORKDIR /root/simslides
RUN mkdir build
WORKDIR build
RUN cmake ..
RUN make -j8
RUN make install

COPY policy.xml /etc/ImageMagick-6/policy.xml 
RUN echo "source /usr/share/gazebo/setup.sh" >> ~/.bashrc
