##===----------------------------------------------------------------------===##
##                                   ACCELERATE.JL                            ##
##                                                                            ##
##===----------------------------------------------------------------------===##
##                                                                            ##
##  This file provides access to Apple's Accelerate on OS X systems           ##
##                                                                            ##
##===----------------------------------------------------------------------===##
module Accelerate
import Vectorize: functions, addfunction

const libacc = "/System/Library/Frameworks/Accelerate.framework/Accelerate"

## This defines the mapping between Julia function names and Accelerate vecLib names.
## Each tuple is of the form (:julia_name, :accelerate_name).accelerate names should
## be stored without the "vv" prefix. The accelerate names are stored without type
## suffix; it is assumed that there is no suffix for Float64, and "f" suffix for Float32.
##
## This assumes arguments of the form (output_vector, input_vector, length)
##
const veclibfunctions =
    ((:ceil, :ceil), (:floor, :floor), (:sqrt, :sqrt), (:invsqrt, :rsqrt), (:inv, :rec),
     (:exp, :exp), (:exp2, :exp2), (:expm1, :expm1), (:log, :log), (:log1p, :log1p),
     (:log2, :log2), (:log10, :log10), (:sin, :sin), (:sinpi, :sinpi), (:cos, :cos),
     (:cospi, :cospi), (:tan, :tan), (:tanpi, :tanpi), (:asin, :asin), (:acos, :acos),
     (:atan, :atan), (:sinh, :sinh), (:cosh, :cosh), (:tanh, :tanh), (:asinh, :asinh),
     (:acosh, :acosh), (:atanh, :atanh), (:trunc,:int), (:round,:nint), (:exponent,:logb),
     (:abs,:fabs))

## For vecLibFunctions
for (T, suff) in ((Float64, ""), (Float32, "f"))

    for (f, fa) in veclibfunctions
        name = string(f)
        f! = Symbol("$(f)!")
        addfunction(functions, (f, (Array{T},)), "Vectorize.Accelerate.$f")
        addfunction(functions, (f!, (Array{T}, Array{T})), "Vectorize.Accelerate.$(f!)")
        @eval begin
            @doc """
            `$($f)(X::Vector{$($T)})`
            Implements element-wise **$($name)** over a **Vector{$($T)}**. Allocates
            memory to store result. *Returns:* **Vector{$($T)}**
            """
            function ($f)(X::Array{$T})
                out = similar(X)
                return ($f!)(out, X)
            end
            @doc """
            `$($f!)(result::Vector{$($T)}, X::Vector{$($T)})`
            Implements element-wise **$($name)** over a **Vector{$($T)}** and overwrites
            the result vector with computed value. *Returns:* **Vector{$($T)}** `result`
            """
            function ($f!)(out::Array{$T}, X::Array{$T})
                ccall(($(string("vv", fa,suff)),libacc),Cvoid,
                      (Ptr{$T},Ptr{$T},Ptr{Cint}),
                      out,X,Ref{Cint}(length(X)))
                return out
            end
        end
    end
    # 2 arg functions
    for f in (:copysign,)
        f! = Symbol("$(f)!")
        addfunction(functions, (f, (Array{T}, Array{T})), "Vectorize.Accelerate.$f")
        addfunction(functions, (f!, (Array{T}, Array{T}, Array{T})), "Vectorize.Accelerate.$(f!)")
        @eval begin
            function ($f)(X::Array{$T}, Y::Array{$T})
                size(X) == size(Y) || throw(DimensionMismatch("Arguments must have same shape"))
                out = similar(X)
                ($f!)(out, X, Y)
            end
            function ($f!)(out::Array{$T}, X::Array{$T}, Y::Array{$T})
                ccall(($(string("vv",f,suff)),libacc),Cvoid,
                      (Ptr{$T},Ptr{$T},Ptr{$T},Ptr{Cint}),out,X,Y,Ref{Cint}(length(X)))
                out
            end
        end
    end

    # for some bizarre reason, vvpow/vvpowf reverse the order of arguments.
    for f in (:pow,)
        f! = Symbol("$(f)!")
        addfunction(functions, (f, (Array{T}, Array{T})), "Vectorize.Accelerate.$f")
        addfunction(functions, (f!, (Array{T}, Array{T}, Array{T})), "Vectorize.Accelerate.$(f!)")
        @eval begin
            function ($f)(X::Array{$T}, Y::Array{$T})
                size(X) == size(Y) || throw(DimensionMismatch("Arguments must have same shape"))
                out = similar(X)
                ($f!)(out, X, Y)
            end
            function ($f!)(out::Array{$T}, X::Array{$T}, Y::Array{$T})
                ccall(($(string("vv",f,suff)),libacc),Cvoid,
                      (Ptr{$T},Ptr{$T},Ptr{$T},Ptr{Cint}),out,Y,X,Ref{Cint}(length(X)))
                out
            end
        end
    end


    # renamed 2 arg functions
    for (f,fa) in ((:rem,:fmod),(:fdiv,:div),(:atan,:atan2))
        f! = Symbol("$(f)!")
        addfunction(functions, (f, (Array{T}, Array{T})), "Vectorize.Accelerate.$f")
        addfunction(functions, (f!, (Array{T}, Array{T}, Array{T})), "Vectorize.Accelerate.$(f!)")
        @eval begin
            function ($f)(X::Array{$T}, Y::Array{$T})
                size(X) == size(Y) || throw(DimensionMismatch("Arguments must have same shape"))
                out = similar(X)
                ($f!)(out, X, Y)
            end
            function ($f!)(out::Array{$T}, X::Array{$T}, Y::Array{$T})
                ccall(($(string("vv",fa,suff)),libacc),Cvoid,
                      (Ptr{$T},Ptr{$T},Ptr{$T},Ptr{Cint}),out,X,Y,Ref{Cint}(length(X)))
                out
            end
        end
    end

    # two-arg return
    for f in (:sincos,)
        f! = Symbol("$(f)!")
        addfunction(functions, (f, (Array{T},)), "Vectorize.Accelerate.$f")
        addfunction(functions, (f!, (Array{T}, Array{T}, Array{T})), "Vectorize.Accelerate.$(f!)")
        @eval begin
            function ($f)(X::Array{$T})
                out1 = similar(X)
                out2 = similar(X)
                ($f!)(out1, out2, X)
            end
            function ($f!)(out1::Array{$T}, out2::Array{$T}, X::Array{$T})
                ccall(($(string("vv",f,suff)),libacc),Cvoid,
                      (Ptr{$T},Ptr{$T},Ptr{$T},Ptr{Cint}),out1,out2,X,Ref{Cint}(length(X)))
                out1, out2
            end
        end
    end

    # complex return
    for (f,fa) in ((:cis,:cosisin),)
        f! = Symbol("$(f)!")
        addfunction(functions, (f, (Array{T},)), "Vectorize.Accelerate.$f")
        addfunction(functions, (f!, (Array{Complex{T}},Array{T})), "Vectorize.Accelerate.$(f!)")
        @eval begin
            function ($f)(X::Array{$T})
                out = Array{Complex{$T}}(undef, size(X))
                ($f!)(out, X)
            end
            function ($f!)(out::Array{Complex{$T}}, X::Array{$T})
                ccall(($(string("vv",fa,suff)),libacc),Cvoid,
                      (Ptr{Complex{$T}},Ptr{$T},Ptr{Cint}),out,X,Ref{Cint}(length(X)))
                out
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
const vDSPfunctions = ((:add, :vadd, "addition"), (:sub, :vsub, "subtraction"),
                       (:div, :vdiv, "division"), (:mul, :vmul, "multiplication"),
                       (:max, :vmax, "maximum"), (:min, :vmin, "minimum"))

for (T, suff) in ((Float64, "D"), (Float32, ""))

    for (f, fa, name) in vDSPfunctions
        f! = Symbol("$(f)!")
        addfunction(functions, (f, (Array{T}, Array{T})), "Vectorize.Accelerate.$f")
        addfunction(functions, (f!, (Array{T}, Array{T}, Array{T})), "Vectorize.Accelerate.$f!")
        @eval begin
            @doc """
            `$($f)(X::Vector{$($T)}, Y::Vector{$($T)})`
            Implements element-wise **$($name)** over two **Vector{$($T)}**. Allocates
            memory to store result. *Returns:* **Vector{$($T)}**
            """
            function ($f)(X::Array{$T}, Y::Array{$T})
                out = Array{$T}(undef, length(X))
                return ($f!)(out, Y, X)
            end
        end
        @eval begin
            @doc """
            `$($f!)(result::Vector{$($T)}, X::Vector{$($T)}, Y::Vector{$($T)})`
            Implements element-wise **$($name)** over two **Vector{$($T)}** and overwrites
            the result vector with computed value. *Returns:* **Vector{$($T)}** `result`
            """
            function ($f!)(out::Array{$T}, X::Array{$T}, Y::Array{$T})
                ccall(($(string("vDSP_", fa,suff)),libacc), Cvoid,
                      (Ptr{$T},Int64, Ptr{$T}, Int64, Ptr{$T}, Int64, Int64),
                      X, 1, Y, 1, out, 1, length(out))
                return out
            end
        end
    end
end


## This defines the mapping between Julia function names and Accelerate vDSP names that
## return a scalar value.
## Each tuple is of the form (:julia_name, :accelerate_name); accelerate names should
## be stored without the "vDSP" prefix. The accelerate names are stored without type
## suffix; it is assumed that there is no suffix for Float32, and "D" suffix for Float64.
##
## This assumes arguments of the form (input_vec_a, stride_a,  output_scalar, length)
const vDSPscalar = ((:sum,  :sve, "sum"), (:summag, :svemg, "sum-of-magnitudes"),
                    (:sumsqr, :svesq, "sum-of-squares"), (:maximum, :maxv, "maximum value"),
                    (:minimum, :minv, "minimum value"),  (:mean, :meanv, "mean value"))

for (T, suff) in ((Float64, "D"), (Float32, ""))

    for (f, fa, name) in vDSPscalar
        addfunction(functions, (f, (Array{T},)), "Vectorize.Accelerate.$f")
        @eval begin
            @doc """
            `$($f)(X::Vector{$($T)}, Y::Vector{$($T)})`
            Computes the **$($name)** of a **Vector{$($T)}**.
            *Returns:* **$($T)**
            """
            function ($f)(X::Array{$T})
                out = Ref{$T}(0.0)
                ccall(($(string("vDSP_", fa,suff)),libacc),Cvoid,
                      (Ptr{$T},Cint, Ref{$T}, Cint),
                      X, 1, out, length(X))
                return out[]
            end
        end
    end

    for (f, fa, name) in ((:findmax, :maxvi, "maximum-value with index"),
                          (:findmin, :minvi, "minimum-value with index"))
        @eval begin
            @doc """
            `$($f)(X::Vector{$($T)})`
            Computes the **$($name)** element-wise over a **Vector{$($T)}**.
            *Returns:* **$(($T, UInt64))**
            """
            function ($f)(X::Array{$T})
                index = Ref{Int}(0)
                val = Ref{$T}(0.0)
                ccall(($(string("vDSP_", fa, suff), libacc)),  Cvoid,
                      (Ptr{$T}, Int64,  Ref{$T}, Ref{Int}, UInt64),
                      X, 1, val, index, length(X))
                return (val[], index[]+1)
            end
        end
    end
end


end # module
