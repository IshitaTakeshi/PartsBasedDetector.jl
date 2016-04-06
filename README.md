VirtualFitting
==============


#Setting the environment

Read pose/README.md for setting.


#How to Run

Make sure that `<PROJECT ROOT>/pose/lib/libPartsBasedDetector.so` exists, and downloading dataset has finished.

Then run

```
$julia julia/test_pose_estimator.jl
```

The estimation result will be saved as result.jpg.


# Dependencies

Doxygen
OpenCV 2.4.9
Boost (apt-get install libboost-all-dev)
