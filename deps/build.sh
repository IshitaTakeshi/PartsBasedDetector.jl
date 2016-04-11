#!/usr/bin/env sh

project_root=$(julia -e 'print(Pkg.dir("PartsBasedDetector"))')

address="https://github.com/IshitaTakeshi/PartsBasedDetector.git"
deps_dir="$project_root/deps"
prefix="$deps_dir/usr"
src_dir="$deps_dir/src"

pbd_dir="$src_dir/pbd"
pbd_build_dir="$pbd_dir/build"

# cvmatio will be located as a subdirectory of $pbd_dir
cvmatio_dir="$pbd_dir/cvmatio"
cvmatio_build_dir="$cvmatio_dir/build"

if [ ! -d "$pbd_dir" ]; then
    mkdir -p $src_dir
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
