#All needed to run the main part of chatterbot: its c++ binary that processes language via libzmq messages from nodejs server
FROM ubuntu:latest
 
WORKDIR /home
 
RUN apt-get update && apt-get install -y \
    wget \
    git \
    build-essential automake autoconf libtool pkg-config \
    libusb-1.0-0-dev \
    gcc-arm-linux-gnueabi \
    openocd
 
#CMAKE INSTALLATION
RUN git clone https://github.com/Kitware/CMake \
    && cd CMake && ./bootstrap && make && make install \
    && cd .. && rm -rf CMake

RUN git clone https://github.com/texane/stlink \
    && cd stlink \
    && make release && make debug \
    && cd build/Release; sudo make install
