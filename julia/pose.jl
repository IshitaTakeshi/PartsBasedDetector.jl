using Cxx
using Images

image = imread("./dataset/images/2007_000423.jpg")
println(typeof(data(image)))

const path_to_lib = pwd()

addHeaderDir(path_to_lib, kind=C_System)
Libdl.dlopen(path_to_lib * "/lib/libPartsBasedDetector.so",
             Libdl.RTLD_GLOBAL)
cxxinclude(path_to_lib * "/include/PartsBasedDetector.hpp")
cxxinclude(path_to_lib * "/include/Visualize.hpp")

visualizer = @cxxnew Visualize()
