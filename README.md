VirtualFitting
==============


#Setting the environment

Read pose/README.md for setting.


#How to Run

Make sure that `<PROJECT ROOT>/pose/lib/libPartsBasedDetector.so` is existing, and downloading dataset has finished.

Then run

```
$julia julia/test_pose_estimator.jl
```

The estimation result will be saved as result.jpg.
