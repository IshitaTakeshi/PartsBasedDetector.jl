include("pose/estimator.jl")

#using Images
using PyCall
pyinitialize("python3")

using PyPlot
pygui(:tk)

PyPlot.clf() #clear previously created figure in REPL

using PoseEstimator


model_filename = "./pose/matlab/lsp.mat"
image_filename = "./pose/dataset/lsp_dataset/positive/im0033.jpg"


estimator = create_estimator(model_filename)
candidates = estimate(estimator, image_filename)

image = PyPlot.imread(image_filename)
PyPlot.imshow(image)

for (i, point) in enumerate(candidates[1].parts)
    PyPlot.scatter(point[1], point[2])
    PyPlot.annotate(i, point, color="white")
end

PyPlot.savefig("result.jpg")
#for candidate in candidates
#    println(candidate.parts)
#end

#println(candidates)
