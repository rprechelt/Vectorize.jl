module Accelerate

const libacc = "/System/Library/Frameworks/Accelerate.framework/Accelerate"

## This defines the mapping between Julia function names and Accelerate names. Each tuple is of the form
## (:julia_name, :accelerate_name). The accelerate names are stored without type suffix; it is assumed that
## there is no suffix for Float32, and "D" suffix for Float64. 
const AccelerateFunctions =
    ((:ceil, :vvceil),
     (:floor, :vvfloor),
     (:sqrt, :vvsqrt),
     (:rsqrt, :vvrsqrt),
     (:rec, :vvrec),
     (:exp, :vvexp),
     (:exp2, :vvexp2),
     (:expm1, :vvexm1),
     (:log, :vvlog),
     (:log1p, :vvlog1p),
     (:log2, :vvlog2),
     (:log10, :vvlog10),
     (:sin, :vvsin),
     (:sinpi, :vvsinpi),
     (:cos, :vvcos),
     (:cospi, :vvcospi),
     (:tan, :vvtan),
     (:tanpi, :vvtanpi),
     (:asin, :vvasin),
     (:acos, :vvacos),
     (:atan, :vvatan), 
     (:sinh, :vvsinh),
     (:cosh, :vvcosh),
     (:tanh, :vvtanh),
     (:asinh, :vvasinh),
     (:acosh, :vvacosh),
     (:atanh, :vvatanh))

for (T, suff) in ((Float64, ""), (Float32, "f"))

    for (f, fa) in AccelerateFunctions
        f! = symbol("$(f)!")
        @eval begin
            function ($f)(X::Vector{$T})
                out = similar(X)
                ($f!)(out, X)
            end
            function ($f!)(out::Vector{$T}, X::Vector{$T})
                ccall(($(string(f,suff)),libacc),Void,
                      (Ptr{$T},Ptr{$T},Ptr{Cint}),out,X,&length(X))
                out
            end
        end
    end

end

end # module
