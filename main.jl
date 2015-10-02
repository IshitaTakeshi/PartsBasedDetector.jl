include("pose/estimator.jl")
include("image.jl")

using Images: imread, imwrite, data, Image

using PoseEstimator: create_estimator, estimate


model_filename = "./pose/models/fashionista2.mat"
image_filename = "./pose/dataset/fashionista/image10.jpg"


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

estimator = create_estimator(model_filename)
candidates = estimate(estimator, image_filename)

parts = candidates[1].parts
writecsv(open("prediction.txt", "w"), parts')
annotation = readcsv(open("./pose/dataset/fashionista/annotation10.txt"))
annotation = transpose(annotation)
println(parts-annotation)
image = imread(image_filename)

box = get_bounding_box_of_person(candidates[1])
image = imcrop(image, box)
image = Images.imresize(image, default_size)
