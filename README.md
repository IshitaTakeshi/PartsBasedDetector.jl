PartsBasedDetector
==================

#Setting environment

```sh
julia -e 'Pkg.clone("https://github.com/IshitaTakeshi/PartsBasedDetector.jl.git")'
cd deps
./build.sh
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
