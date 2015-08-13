include("pose_estimator.jl")

#using Images
using PyCall
pyinitialize("python3")

using PyPlot
pygui(:tk)

using PoseEstimator


model_filename = "./pose/matlab/demo_model.mat"
image_filename = "./pose/dataset/images/2007_001423.jpg"


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

for candidate in candidates
    for point in points
        PyPlot.scatter([point.x], [point.y])
    end
end
#
PyPlot.savefig("./fig1.jpg")
#for candidate in candidates
#    println(candidate.parts)
#end

#println(candidates)
