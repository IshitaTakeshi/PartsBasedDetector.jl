include("estimator.jl")
include("image.jl")

using Images: data, Image, load
using PyPlot

using PoseEstimator: create_estimator, estimate


model_path = "pose/models/lsp.mat"
image_path = "pose/dataset/dataset/INRIAPerson/Train/pos/crop001012.png"


function get_bounding_box_of_person(candidate)
    xlist = slice(candidate.parts, 1, :)
    ylist = slice(candidate.parts, 2, :)
    right = maximum(xlist)
    left = minimum(xlist)
    top = minimum(ylist)
    bottom = maximum(ylist)
    return (left, right, top, bottom)
end


default_size = (100, 180)

estimator = create_estimator(model_path)
candidates = estimate(estimator, image_path, 3)
for c in candidates
    println("size = $(c.size)")
    println("parts = $(c.parts)")
    println("confidence = $(c.confidence)")
end

parts = candidates[1].parts
writedlm("prediction.txt", parts)

#ground truth
#annotation = readcsv(open("pose/dataset/dataset/fashionista/annotation10.txt"))

#image = load(image_path)
#
#box = get_bounding_box_of_person(candidates[1])
#image = imcrop(image, box)
#image = Images.imresize(image, default_size)
