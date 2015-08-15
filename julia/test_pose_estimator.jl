include("pose_estimator.jl")

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

confidence = Array(Float32, length(candidates))
for i in 1:length(candidates)
    confidence[i] = abs(sum(candidates[i].confidence))
end

index = indmax(confidence)
#sort(candidates, by=x->sum(x.confidence)


image = PyPlot.imread(image_filename)
PyPlot.imshow(image)

for i in 1:length(candidates[1].parts)
    point = candidates[1].parts[i]
    PyPlot.scatter([point.x], [point.y])
    PyPlot.annotate(i, [point.x, point.y], color="white")
end

PyPlot.savefig("result.jpg")
#for candidate in candidates
#    println(candidate.parts)
#end

#println(candidates)
