# Use Ubuntu as base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install necessary dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    wget \
    curl \
    git \
    pkg-config \
    ca-certificates \
    locales \
    libopencv-dev \
    libeigen3-dev \
    libvisp-dev \
    nlohmann-json3-dev \
    doxygen \
    libgtk2.0-dev \
    libhiredis-dev \
    libspdlog-dev \
    libmodbus-dev \
    ffmpeg \
    libusb-1.0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install ROS 2
RUN locale-gen en_US en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
    export LANG=en_US.UTF-8
RUN apt update && apt upgrade -y
RUN apt install software-properties-common -y && \
    add-apt-repository universe
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null
RUN apt update && apt upgrade -y
RUN apt install -y ros-humble-desktop

# Install Kinect packages (Optional)
RUN mkdir -p /home/Packages/k4a && cd /home/Packages/k4a
RUN curl -O https://packages.microsoft.com/ubuntu/18.04/prod/pool/main/libk/libk4a1.4/libk4a1.4_1.4.0_amd64.deb
RUN curl -O https://packages.microsoft.com/ubuntu/18.04/prod/pool/main/libk/libk4a1.4-dev/libk4a1.4-dev_1.4.0_amd64.deb
RUN apt-get install -y libsoundio-dev
RUN echo 'libk4a1.4 libk4a1.4/accepted-eula-hash string 0f5d5c5de396e4fee4c0753a21fee0c1ed726cf0316204edda484f08cb266d76' | debconf-set-selections &&	\
echo 'libk4a1.4 libk4a1.4/accept-eula boolean true' | debconf-set-selections
RUN cd /home/Packages/k4a
RUN dpkg -i libk4a1.4_1.4.0_amd64.deb && \
    dpkg -i libk4a1.4-dev_1.4.0_amd64.deb 
RUN rm -f libk4a1.4_1.4.0_amd64.deb && \ 
    rm -f libk4a1.4-dev_1.4.0_amd64.deb && \
    rm -rf /home/*

# Set entrypoint
CMD ["/bin/bash"]
