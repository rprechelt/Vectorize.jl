__precompile__()
module Accelerate

const libacc = "/System/Library/Frameworks/Accelerate.framework/Accelerate"

## This defines the mapping between Julia function names and Accelerate vecLib names.
## Each tuple is of the form (:julia_name, :accelerate_name).accelerate names should
## be stored without the "vv" prefix. The accelerate names are stored without type
## suffix; it is assumed that there is no suffix for Float64, and "f" suffix for Float32.
##
## This assumes arguments of the form (output_vector, input_vector, length)
##
const vecLibFunctions =
    ((:ceil, :ceil),
     (:floor, :floor),
     (:sqrt, :sqrt),
     (:rsqrt, :rsqrt),
     (:rec, :rec),
     (:exp, :exp),
     (:exp2, :exp2),
     (:expm1, :exm1),
     (:log, :log),
     (:log1p, :log1p),
     (:log2, :log2),
     (:log10, :log10),
     (:sin, :sin),
     (:sinpi, :sinpi),
     (:cos, :cos),
     (:cospi, :cospi),
     (:tan, :tan),
     (:tanpi, :tanpi),
     (:asin, :asin),
     (:acos, :acos),
     (:atan, :atan),
     (:sinh, :sinh),
     (:cosh, :cosh),
     (:tanh, :tanh),
     (:asinh, :asinh),
     (:acosh, :acosh),
     (:atanh, :atanh),
     (:trunc,:int),
     (:round,:nint),
     (:exponent,:logb),
     (:abs,:fabs))

## For vecLibFunctions
for (T, suff) in ((Float64, ""), (Float32, "f"))

    for (f, fa) in vecLibFunctions
        f! = symbol("$(f)!")
        @eval begin
            function ($f)(X::Vector{$T})
                out = similar(X)
                return ($f!)(out, X)
            end
            function ($f!)(out::Vector{$T}, X::Vector{$T})
                ccall(($(string("vv", f,suff)),libacc),Void,
                      (Ptr{$T},Ptr{$T},Ptr{Cint}),
                      out,X,&length(X))
                return out
            end
        end
    end
end


## This defines the mapping between Julia function names and Accelerate vDSP names.
## Each tuple is of the form (:julia_name, :accelerate_name); accelerate names should
## be stored without the "vDSP" prefix. The accelerate names are stored without type
## suffix; it is assumed that there is no suffix for Float32, and "D" suffix for Float64.
##
## This assumes arguments of the form (input_vec_a, stride_a, input_vec_b, stride_b,
##                                                   output_vec, stride_out, length)
##
const vDSPFunctions = ((:add, :vadd), (:sub, :vsub),  (:div, :vdiv), (:mul, :vmul))

for (T, suff) in ((Float64, "D"), (Float32, ""))

    for (f, fa) in vDSPFunctions
        f! = symbol("$(f)!")
        @eval begin
            function ($f)(X::Vector{$T}, Y::Vector{$T})
                out = similar(X)
                return ($f!)(out, X, Y)
            end
            function ($f!)(out::Vector{$T}, X::Vector{$T}, Y::Vector{$T})
                ccall(($(string("vDSP", f,suff)),libacc),Void,
                      (Ptr{$T},Cint, Ptr{$T}, Cint, Ptr{$T}, Cint, Cint),
                      X, 1, Y, 1, out, 1, length(X))
                return out 
            end
        end
    end
end

end # module
