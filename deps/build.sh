#!/usr/bin/env bash

address="https://github.com/IshitaTakeshi/PartsBasedDetector.git"

project_root=$(julia -e 'print(Pkg.dir("PartsBasedDetector"))')
deps_dir="$project_root/deps"
prefix="$deps_dir/usr"
src_dir="$deps_dir/src"

opencv_dir="$src_dir/opencv-2.4.9"
opencv_build_dir="$opencv_dir/build"

pbd_dir="$src_dir/pbd"
pbd_build_dir="$pbd_dir/build"

# cvmatio will be located as a subdirectory of $pbd_dir
cvmatio_dir="$pbd_dir/cvmatio"
cvmatio_build_dir="$cvmatio_dir/build"

sudo apt-get install git cmake libboost-all-dev doxygen zlib1g-dev python3-matplotlib python-matplotlib
sudo pip3 install scipy matplotlib
git submodule update --init --recursive

mkdir -p $src_dir

if [ "$(pkg-config --modversion opencv)" != "2.4.9" ]; then
    sudo apt-get -qq install libopencv-dev build-essential checkinstall cmake pkg-config yasm libjpeg-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libxine-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev python-dev python-numpy libtbb-dev libqt4-dev libgtk2.0-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils cmake qt5-default checkinstall

    cd $src_dir
    if [ ! -f 2.4.9.tar.gz ]; then
        wget https://github.com/Itseez/opencv/archive/2.4.9.tar.gz
    fi
    tar xvf 2.4.9.tar.gz
    mkdir -p $opencv_build_dir
    cd $opencv_build_dir
    cmake -WITH_FFMPEG=OFF $opencv_dir
    make -j4
    sudo make install
    sudo checkinstall
    sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
    sudo ldconfig
fi

if [ ! -d "$pbd_dir" ]; then
    git clone $address --recursive $pbd_dir
fi

mkdir -p $cvmatio_build_dir
cd $cvmatio_build_dir
echo $cvmatio_dir
cmake -DCMAKE_INSTALL_PREFIX=$cvmatio_dir $cvmatio_dir
make -j4
make install

mkdir -p $pbd_build_dir
cd $pbd_build_dir
cmake $pbd_dir
make -j4
sudo make install

mkdir -p "$project_root/lib"
cp "$pbd_dir/lib/libPartsBasedDetector.so" "$project_root/lib"
