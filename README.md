PartsBasedDetector.jl
=====================

This is a Julia interface for [PartsBasedDetector](https://github.com/wg-perception/PartsBasedDetector) which is a C++ implementation of "Articulated Pose Estimation with Flexible Mixtures of Parts".

# Installation

```julia
$julia
> Pkg.clone("https://github.com/IshitaTakeshi/PartsBasedDetector.jl.git")
> Pkg.build("PartsBasedDetector")
```

If build fails, run the build script manually.
OpenCV and other dependent packages will be installed.

```sh
$<package_root>/deps/build.sh
```

# Usage

```julia
using PyCall
using PartsBasedDetector: make_estimator, estimate

estimator = make_estimator()
candidates = estimate(estimator, filename, n_candidates = 3)

parts = candidates[1].parts
x, y = parts[:, 1], parts[:, 2]

@pyimport matplotlib.pyplot as plt
image = plt.imread(filename)
plt.imshow(image)
plt.plot(x, y, color="r", marker="o", ls="")
plt.show()
```

Run `example/example.jl` for the demo.
