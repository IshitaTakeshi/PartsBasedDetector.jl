# This is a modified version of the matlab implementation of MR8.
# http://www.robots.ox.ac.uk/~vgg/research/texclass/code/MR8fast.m

include("anigauss.jl")


function normalize(matrix)
    matrix = map(x->convert(Float64, x), matrix)
    matrix = matrix - mean(matrix)
    matrix = matrix ./ sqrt(mean(matrix .^ 2))
end


function store_max_rotation(matrix, sigma, order, angles)
    maxout = anigauss(matrix, sigma, angles[1], order)
    max_brightness = sum(abs(maxout))
    angle_argmax = angles[1]

    for angle in angles[2:end]
        out = anigauss(matrix, sigma, angle, order)
        b = sum(abs(out))

        if b > max_brightness
            max_brightness = b
            maxout = out
            angle_argmax = angle
        end
    end
    return maxout, angle_argmax
end


function argmax_angles(matrix)
    matrix = normalize(matrix)

    angles = []
    mulfac = 2.0
    sigma = [3, 1]

    angles_ = [(k/6.0)*180.0 for k in 0:5]
    for j = 1:3

        _, angle1 = store_max_rotation(matrix, sigma, [0, 1], angles_)
        _, angle2 = store_max_rotation(matrix, sigma, [0, 2], angles_)

        push!(angles, angle1)
        push!(angles, angle2)

        sigma *= mulfac
    end
    return angles
end


function mr8(matrix)
    matrix = normalize(matrix)
    matrices = []

    mulfac = 2.0

    sigma = [3, 1]

    angles = [(k/6.0)*180.0 for k in 0:5]

    for j = 1:3
        maxout1, angle1 = store_max_rotation(matrix, sigma, [0, 1], angles)
        maxout2, angle2 = store_max_rotation(matrix, sigma, [0, 2], angles)

        push!(matrices, maxout1)
        push!(matrices, maxout2)

        sigma *= mulfac
    end

    sigma = [10.0, 10.0]

    out1 = anigauss(matrix, sigma, 0.0, [2, 0])
    out2 = anigauss(matrix, sigma, 0.0, [0, 2])
    push!(matrices, out1+out2)

    out = anigauss(matrix, sigma, 0.0, [0, 0])
    push!(matrices, out)

    # just throw away 25 pixel border...(half support of sigma=10 filter)
    R, C = size(matrices[1])
    for j = 1:length(matrices)
        matrices[j] = matrices[j][26:R-25, 26:C-25]
    end

    return (matrices[8], matrices[7], matrices[1], matrices[3],
            matrices[5], matrices[2], matrices[4], matrices[6])
end
