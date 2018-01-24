#All needed to run the main part of chatterbot: its c++ binary that processes language via libzmq messages from nodejs server
FROM ubuntu:latest
 
WORKDIR /home
 
RUN apt-get update && apt-get install -y \
    wget \
    git \
    build-essential automake autoconf libtool pkg-config \
    libusb-1.0-0-dev \
    gcc-arm-linux-gnueabi
    #openocd #You can install openocd here but I prefer to compile the most recent as below
 
#CMAKE INSTALLATION
RUN git clone https://github.com/Kitware/CMake \
    && cd CMake && ./bootstrap && make && make install \
    && cd .. && rm -rf CMake

RUN git clone https://github.com/texane/stlink \
    && cd stlink \
    && make release && make debug \
    && cd build/Release; make install \
    && rm -rf /home/texane

RUN git clone git://git.code.sf.net/p/openocd/code openocd-code \
    && cd openocd-code \
    && ./bootstrap \
    && ./configure --prefix=/usr --enable-maintainer-mode --enable-stlink \
    && make && make install \
    && rm -rf /home/openocd-code

WORKDIR /home/gcc-toolchain

RUN wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz \
    && tar -jxvf gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz

ENV PATH="/home/gcc-toolchain/gcc-arm-none-eabi-7-2017-q4-major/:${PATH}"

RUN mv gcc-arm-none-eabi-7-2017-q4-major/bin/* /usr/bin \
 && mv gcc-arm-none-eabi-7-2017-q4-major/lib/* /usr/lib \
 && mv gcc-arm-none-eabi-7-2017-q4-major/share/* /usr/share

WORKDIR /home/project

ENTRYPOINT "/bin/bash"
