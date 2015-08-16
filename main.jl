include("pose/estimator.jl")

using Images: imread, imwrite

using PoseEstimator: create_estimator, estimate


model_filename = "./pose/matlab/lsp.mat"
image_filename = "./pose/dataset/lsp_dataset/positive/im0033.jpg"

estimator = create_estimator(model_filename)
candidates = estimate(estimator, image_filename)

println(candidates[1].parts)

right = maximum(candidates[1].parts[:, 1])
left = minimum(candidates[1].parts[:, 1])
top = minimum(candidates[1].parts[:, 2])
bottom = maximum(candidates[1].parts[:, 2])

image = imread(image_filename)

margin = 10

image = image[left-margin:right+margin, top-margin:bottom+margin]

imwrite(image, "cropped.jpg")
