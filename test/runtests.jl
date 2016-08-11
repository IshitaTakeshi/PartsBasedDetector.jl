ENV["PYTHON"] = "/usr/bin/python3"
using PyCall
using PartsBasedDetector: make_estimator, estimate

url = "http://images0.chictopia.com/photos/districtofchic/9466442894/" *
      "black-skinny-jeans-dl1961-jeans-sky-blue-pixie-market-shirt_400.jpg"

filename = basename(url)
run(`wget --continue $url -O $filename`)

root = Pkg.dir("PartsBasedDetector")
model_path = joinpath(root, "deps", "src", "pbd", "models", "mat", "lsp.mat")

estimator = make_estimator(model_path)
candidates = estimate(estimator, filename, n_candidates = 3)

@pyimport matplotlib.pyplot as plt
@pyimport scipy.misc as misc

parts = candidates[1].parts
image = misc.imread(filename)
plt.imshow(image)
height, width = size(image)
plt.xlim([width, 0])
plt.ylim([height, 0])
plt.plot(parts[:, 1], parts[:, 2], "ko")
plt.show()
