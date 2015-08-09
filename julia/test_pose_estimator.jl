include("pose_estimator.jl")

using PoseEstimator

model_filename = "./pose/matlab/demo_model.mat"
estimator = create_estimator(model_filename)
candidates = estimate(estimator, "./pose/dataset/images/2007_000480.jpg")

#for candidate in candidates
#    println(candidate.confidence)
#end
#
#using Base.Sort
#
#sort(candidates, by=x->sum(x.confidence))
##println(candidates)
