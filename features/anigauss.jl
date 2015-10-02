function anigauss(input, sigma, phi, order)
    sigmav, sigmau = sigma
    orderv, orderu = order
    assert(ndims(input) == 2)
    nrows, ncols = size(input)
    output = ones(Cdouble, nrows, ncols)

    ccall((:anigauss, "./libanigauss.so"), Void,
          (Ptr{Cdouble}, Ptr{Cdouble}, Cint, Cint,
           Cdouble, Cdouble, Cdouble, Cint, Cint),
          pointer(input), pointer(output), nrows, ncols,
          sigmav, sigmau, phi-90.0, orderv, orderu)
    return output
end
