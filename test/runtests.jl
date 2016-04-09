using Images: data, Image, load
using PyCall

using PartsBasedDetector: make_estimator, estimate


estimator = make_estimator()
candidates = estimate(estimator, image_path, n_candidates = 3)

@pyimport matplotlib.pyplot as plt
image = plt.imread(image_path)
plt.imshow(image)

parts = candidates[1].parts
x, y = parts[:, 1], parts[:, 2]
plt.plot(x, y, color="r", marker="o", ls="")
plt.show()
