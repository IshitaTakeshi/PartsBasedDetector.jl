using Cxx
using Images

#image = imread("./dataset/images/2007_000423.jpg")

ccall((:test_calling, "./build/src/libPartsBasedDetector.so"), Void, ())
