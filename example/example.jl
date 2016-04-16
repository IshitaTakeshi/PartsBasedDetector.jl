ENV["PYTHON"] = "/usr/bin/python3"
using PyCall
using PartsBasedDetector: make_estimator, estimate


filename = "dress.jpg"
url = "http://images0.chictopia.com/photos/districtofchic/9466442894/" *
      "black-skinny-jeans-dl1961-jeans-sky-blue-pixie-market-shirt_400.jpg"

filename_png = replace(filename, ".jpg", ".png")
run(`wget --continue $url -O $filename`)
run(`convert $filename $filename_png`)

estimator = make_estimator()
candidates = estimate(estimator, filename, n_candidates = 3)
parts = candidates[1].parts
x, y = parts[:, 1], parts[:, 2]

@pyimport matplotlib.pyplot as plt
image = plt.imread(filename_png)
plt.imshow(image)
plt.plot(x, y, color="r", marker="o", ls="")

for i in 1:size(parts, 1)
    plt.annotate(i, (x[i], y[i]), color="w")
end

plt.show()
