FROM osrf/ros:noetic-desktop-full

# Install Python and other dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# Install Eigen 3.4.0 from source
RUN mkdir -p /eigen && cd /eigen && \
    git clone https://gitlab.com/libeigen/eigen.git -b 3.4.0 && \
    cd eigen && mkdir build && cd build && \
    cmake .. && make -j4 && make install

# Create a catkin workspace
RUN mkdir -p /catkin_ws/src
WORKDIR /catkin_ws/src

# Clone the required repositories
RUN git clone https://github.com/ICRA-2024/davidskdds_DMSA_LiDAR_SLAM.git

WORKDIR /catkin_ws

# Build the workspace
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && catkin_make"

# Set up the entrypoint
ENTRYPOINT ["/bin/bash", "-c", "source devel/setup.bash && exec \"$@\"", "--"]
CMD ["bash"]
