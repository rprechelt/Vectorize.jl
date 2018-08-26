##===----------------------------------------------------------------------===##
##                                      VML.JL                                ##
##                                                                            ##
##===----------------------------------------------------------------------===##
##                                                                            ##
##  This file provides access to VML and handles checking for the existence   ##
##  of the VML library during import and checks for the available             ##
##  vector instruction sets.                                                  ##
##                                                                            ##
##===----------------------------------------------------------------------===##
module VML
import Vectorize: functions, addfunction

using Libdl

OS = Sys.KERNEL

# Library dependency for VML
const global librt = Libdl.find_library(["libmkl_rt"], ["/opt/intel/mkl/lib"])

if librt == ""
    error("Unable to load librt")
end
Libdl.dlopen(librt)

# ======= VML FUNCTION ACCURACY CONTROL ======= #
const VML_LA               =  0x00000001     # Low Accuracy
const VML_HA               =  0x00000002     # High Accuracy
const VML_EP               =  0x00000003     # Enhanced Performance

# ======= VML ERROR HANDLING CONTROL ======= #
const VML_ERRMODE_IGNORE   =  0x00000100     # ignore errors
const VML_ERRMODE_ERRNO    =  0x00000200     # errno variable is set on error
const VML_ERRMODE_STDERR   =  0x00000400     # error description text is written to stderr
const VML_ERRMODE_EXCEPT   =  0x00000800     # exception is raised on error
const VML_ERRMODE_CALLBACK =  0x00001000     # user's error handler is called
# errno variable is set, exceptions are raised, and user's error handler is called on error
const VML_ERRMODE_DEFAULT  = VML_ERRMODE_ERRNO | VML_ERRMODE_CALLBACK | VML_ERRMODE_EXCEPT

# ======= FTZ & DAZ MODE CONTROL ======= #
const VML_FTZDAZ_ON        =  0x00280000     # faster denormal value processing
const VML_FTZDAZ_OFF       =  0x00140000     # accurate denormal value processing


"""
This function sets the default values for the VME library on import,
allowing for the precompilation of the rest of the package.
"""
function __init__()

    # Open librt
    Libdl.dlopen(librt)

    # Set default mode
    VML.setmode(VML.VML_HA | VML.VML_ERRMODE_DEFAULT | VML.VML_FTZDAZ_ON)
end


"""
Sets accuracy, error, and FTZDAZ modes for all VML functions. This is automatically
called in init() but can also be called to change the modes during runtime.
"""
function setmode(mode)
    oldmode = ccall(("vmlSetMode", librt),  Cuint,
                    (Cuint,),
                    mode)
    return oldmode
end

"""
Returns the accuracy, error, and FTZDAZ modes for all VML functions". This is automatically
called in init() but can also be called to change the modes during runtime".
"""
function getmode()
    status = ccall(("vmlGetMode", librt),  Cuint,
                   (), )
    return status
end


# Basic operations on two args
for (T, prefix) in [(Float32,  "s"), (Float64, "d"),  (Complex{Float32}, "c"),  (Complex{Float64}, "z")]
    for (f, fvml, name) in [(:add, :Add, "addition"), (:mul, :Mul, "multiplcation"),
                      (:sub, :Sub, "subtraction"), (:div, :Div, "division"), (:pow, :Pow, "power")]
        f! = Symbol("$(f)!")
        addfunction(functions, (f, (Array{T}, Array{T})), "Vectorize.VML.$f")
        addfunction(functions, (f!, (Array{T}, Array{T}, Array{T})), "Vectorize.VML.$(f!)")
        @eval begin
            @doc """
            `$($f)(X::Array{$($T)}, Y::Array{$($T)})`
            Implements element-wise **$($name)** over two **Array{$($T)}**. Allocates
            memory to store result. *Returns:* **Array{$($T)}**
            """
            function ($f)(X::Array{$T}, Y::Array{$T})
                out = similar(X)
                return $(f!)(out, X, Y)
            end
            @doc """
            `$($f!)(result::Array{$($T)}, X::Array{$($T)}, Y::Array{$($T)})`
            Implements element-wise **$($name)** over two **Array{$($T)}** and overwrites
            the result vector with computed value. *Returns:* **Array{$($T)}** `result`
            """
            function ($f!)(out::Array{$T}, X::Array{$T}, Y::Array{$T})
                ccall($(string("v", prefix, fvml), librt),  Cvoid,
                      (Cint, Ptr{$T}, Ptr{$T},  Ptr{$T}),
                      length(out), X, Y,  out)
                return out
            end
        end
    end
end

# Real only returning real - two args
for (T, prefix) in [(Float32, "s"),  (Float64, "d")]
    for (f, fvml, name) in [(:hypot, :Hypot, "hypotenuse"), (:atan, :Atan2, "atan2"),
                            (:max, :Fmax, "max"), (:min, :Fmin, "min")]
        f! = Symbol("$(f)!")
        addfunction(functions, (f, (Array{T}, Array{T})), "Vectorize.VML.$f")
        addfunction(functions, (f!, (Array{T}, Array{T}, Array{T})), "Vectorize.VML.$(f!)")
        @eval begin
            @doc """
            `$($f)(X::Array{$($T)}, Y::Array{$($T)})`
            Implements element-wise **$($name)** over two **Array{$($T)}**. Allocates
            memory to store result. *Returns:* **Array{$($T)}**
            """
            function ($f)(X::Array{$T}, Y::Array{$T})
                out = similar(X)
                return $(f!)(out, X, Y)
            end
            @doc """
            `$($f!)(result::Array{$($T)}, X::Array{$($T)}, Y::Array{$($T)})`
            Implements element-wise **$($name)** over two **Array{$($T)}** and overwrites
            the result vector with computed value. *Returns:* **Array{$($T)}** `result`
            """
            function ($f!)(out::Array{$T}, X::Array{$T}, Y::Array{$T})
                ccall($(string("v", prefix, fvml), librt),  Cvoid,
                      (Cint, Ptr{$T}, Ptr{$T},  Ptr{$T}),
                      length(out), X, Y,  out)
                return out
            end
        end
    end
end

# Complex only returning complex - two arg
# note order change in c-call, in VML library the second argument is conjugated
for (T, prefix) in [(Complex{Float32}, "c"),  (Complex{Float64}, "z")]
    for (f, fvml, name) in [(:dot, :MulByConj, "multiply-by-conjugate")]
        f! = Symbol("$(f)!")
        addfunction(functions, (f, (Array{T}, Array{T})), "Vectorize.VML.$f")
        addfunction(functions, (f!, (Array{T}, Array{T}, Array{T})), "Vectorize.VML.$(f!)")
        @eval begin
            @doc """
            `$($f)(X::Array{$($T)}, Y::Array{$($T)})`
            Implements element-wise **$($name)** over two **Array{$($T)}**. Allocates
            memory to store result. *Returns:* **Array{$($T)}**
            """
            function ($f)(X::Array{$T}, Y::Array{$T})
                out = similar(X)
                return $(f!)(out, X, Y)
            end
            @doc """
            `$($f!)(result::Array{$($T)}, X::Array{$($T)}, Y::Array{$($T)})`
            Implements element-wise **$($name)** over two **Array{$($T)}** and overwrites
            the result vector with computed value. *Returns:* **Array{$($T)}** `result`
            """
            function ($f!)(out::Array{$T}, X::Array{$T}, Y::Array{$T})
                ccall($(string("v", prefix, fvml), librt),  Cvoid,
                      (Cint, Ptr{$T}, Ptr{$T},  Ptr{$T}),
                      length(out), Y, X,  out)
                return out
            end
        end
    end
end

# Basic operations on one arg
for (T, prefix) in [(Float32,  "s"), (Float64, "d"),  (Complex{Float32}, "c"),  (Complex{Float64}, "z")]
    for (f, fvml) in [(:sqrt, :Sqrt), (:exp, :Exp),  (:acos, :Acos), (:asin, :Asin),
                      (:acosh, :Acosh), (:asinh, :Asinh), (:log,  :Ln),
                     (:atan, :Atan), (:atanh, :Atanh), (:cos, :Cos), (:sin, :Sin),
                      (:tan, :Tan), (:cosh, :Cosh), (:sinh, :Sinh), (:tanh, :Tanh),
                      (:log10, :Log10)]
        f! = Symbol("$(f)!")
        name = string(f)
        addfunction(functions, (f, (Array{T},)), "Vectorize.VML.$f")
        addfunction(functions, (f!, (Array{T}, Array{T})), "Vectorize.VML.$(f!)")
        @eval begin
            @doc """
            `$($f)(X::Array{$($T)})`
            Implements element-wise **$($name)** over a **Array{$($T)}**. Allocates
            memory to store result. *Returns:* **Array{$($T)}**
            """
            function ($f)(X::Array{$T})
                out = similar(X)
                return $(f!)(out, X)
            end
            @doc """
            `$($f!)(result::Array{$($T)}, X::Array{$($T)})`
            Implements element-wise **$($name)** over a **Array{$($T)}** and overwrites
            the result vector with computed value. *Returns:* **Array{$($T)}** `result`
            """
            function ($f!)(out::Array{$T}, X::Array{$T})
                ccall($(string("v", prefix, fvml), librt),  Cvoid,
                      (Cint, Ptr{$T}, Ptr{$T}),
                      length(out), X, out)
                return out
            end
        end
    end
end

# Real only basic operations on one arg:
for (T, prefix) in [(Float32,  "s"), (Float64, "d")]
    for (f, fvml) in [(:inv, :Inv), (:invsqrt, :InvSqrt),  (:cbrt,  :Cbrt),
                      (:invcbrt, :InvCbrt), (:pow2o3, :Pow2o3), (:pow3o2, :Pow3o2),
                      (:erf, :Erf),  (:ceil, :Ceil),
                      (:erfc, :Erfc), (:cdfnorm, :CdfNorm),  (:erfinv, :ErfInv),
                      (:erfcinv,  :ErfcInv),  (:cdfnorminv, :CdfNormInv), (:lgamma, :LGamma),
                      (:gamma, :TGamma), (:floor, :Floor), (:trunc, :Trunc),
                      (:round, :Round), (:frac,  :Frac), (:abs, :Abs), (:sqr, :Sqr),
                      (:cosd, :Cosd), (:sind, :Sind), (:tand, :Tand),
                      (:log2, :Log2), (:log1p, :Log1p),
                      (:expm1, :Expm1), (:exp2, :Exp2), (:exp10, :Exp10),
                      (:cospi, :Cospi), (:sinpi, :Sinpi)]
        f! = Symbol("$(f)!")
        name = string(f)
        addfunction(functions, (f, (Array{T},)), "Vectorize.VML.$f")
        addfunction(functions, (f!, (Array{T}, Array{T})), "Vectorize.VML.$(f!)")
        @eval begin
            @doc """
            `$($f)(X::Array{$($T)})`
            Implements element-wise **$($name)** over a **Array{$($T)}**. Allocates
            memory to store result. *Returns:* **Array{$($T)}**
            """
            function ($f)(X::Array{$T})
                out = similar(X)
                return $(f!)(out, X)
            end
            @doc """
            `$($f!)(result::Array{$($T)}, X::Array{$($T)})`
            Implements element-wise **$($name)** over a **Array{$($T)}** and overwrites
            the result vector with computed value. *Returns:* **Array{$($T)}** `result`
            """
            function ($f!)(out::Array{$T}, X::Array{$T})
                ccall($(string("v", prefix, fvml), librt),  Cvoid,
                      (Cint, Ptr{$T}, Ptr{$T}),
                      length(out), X, out)
                return out
            end
        end
    end
end

# Operations on complex returning complex - one arg
for (T, prefix) in [(Complex{Float32}, "c"),  (Complex{Float64}, "z")]
    for (f, fvml, name) in [(:conj,  :Conj, "conjugation")]
        f! = Symbol("$(f)!")
        addfunction(functions, (f, (Array{T},)), "Vectorize.VML.$f")
        addfunction(functions, (f!, (Array{T}, Array{T})), "Vectorize.VML.$(f!)")
        @eval begin
             @doc """
            `$($f)(X::Array{$($T)})`
            Implements element-wise **$($name)** over a **Array{$($T)}**. Allocates
            memory to store result. *Returns:* **Array{$($T)}**
            """
            function ($f)(X::Array{$T})
                out = similar(X)
                return $(f!)(out, X)
            end
            @doc """
            `$($f!)(result::Array{$($T)}, X::Array{$($T)})`
            Implements element-wise **$($name)** over a **Array{$($T)}** and overwrites
            the result vector with computed value. *Returns:* **Array{$($T)}** `result`
            """
            function ($f!)(out::Array{$T}, X::Array{$T})
                ccall($(string("v", prefix, fvml), librt),  Cvoid,
                      (Cint, Ptr{$T}, Ptr{$T}),
                      length(out), X, out)
                return out
            end
        end
    end
end


# Operations on complex returning real - one arg
for (T, prefix) in [(Complex{Float32}, "c"),  (Complex{Float64}, "z")]
    for (f, fvml, name) in [(:abs, :Abs, "absolute-value"),  (:angle,  :Arg, "complex-argument") ]
        f! = Symbol("$(f)!")
        addfunction(functions, (f, (Array{T},)), "Vectorize.VML.$f")
        addfunction(functions, (f!, (Array{real(T)},Array{T})), "Vectorize.VML.$(f!)")
        @eval begin
            @doc """
            `$($f)(X::Array{$($T)})`
            Calculates the **$($name)** element-wise over a **Array{$($T)}**. Allocates
            memory to store result. *Returns:* **Array{$($T)}**
            """
            function ($f)(X::Array{$T})
                out = Array{real($T)}(undef, length(X))
                return $(f!)(out, X)
            end
            @doc """
            `$($f!)(result::Array{$($T)}, X::Array{$($T)})`
            Calculates the **$($name)** element-wise over a **Array{$($T)}** and overwrites
            the result vector with computed value. *Returns:* **Array{$($T)}** `result`
            """
            function ($f!)(out::Array{real($T)}, X::Array{$T})
                ccall($(string("v", prefix, fvml), librt),  Cvoid,
                      (Cint, Ptr{$T}, Ptr{real($T)}),
                      length(out), X, out)
                return out
            end
        end
    end
end

# Operations on real returning complex - one arg
# note that input type is real, although prefix is "complex"
for (T, prefix) in [(Float32, "c"),  (Float64, "z")]
    for (f, fvml, name) in [(:cis, :CIS, "cosine-imaginary-sin"),]
        f! = Symbol("$(f)!")
        addfunction(functions, (f, (Array{T},)), "Vectorize.VML.$f")
        addfunction(functions, (f!, (Array{complex(T)},Array{T})), "Vectorize.VML.$(f!)")
        @eval begin
            @doc """
            `$($f)(X::Array{$($T)})`
            Calculates the **$($name)** element-wise over a **Array{$($T)}**. Allocates
            memory to store result. *Returns:* **Array{$($T)}**
            """
            function ($f)(X::Array{$T})
                out = Array{Complex{$T}}(undef, length(X))
                return $(f!)(out, X)
            end
            @doc """
            `$($f!)(result::Array{$($T)}, X::Array{$($T)})`
            Calculates the **$($name)** element-wise over a **Array{$($T)}** and overwrites
            the result vector with computed value. *Returns:* **Array{$($T)}** `result`
            """
            function ($f!)(out::Array{Complex{$T}}, X::Array{$T})
                ccall($(string("v", prefix, fvml), librt),  Cvoid,
                      (Cint, Ptr{$T}, Ptr{Complex{$T}}),
                      length(out), X, out)
                return out
            end
        end
    end
end

# Basic operations on two complex args, with one arg being scalar
for (T, prefix) in [(Complex{Float32}, "c"),  (Complex{Float64}, "z")]
    for (f, fvml, name) in ((:pow, :Powx, "scalar power"),)
        f! = Symbol("$(f)!")
        addfunction(functions, (f, (Array{T}, T)), "Vectorize.VML.$f")
        addfunction(functions, (f!, (Array{T}, Array{T}, T)), "Vectorize.VML.$(f!)")
        @eval begin
            @doc """
            `$($f)(X::Array{$($T)}, Y::$($T))`
            Implements element-wise **$($name)** over two **Array{$($T)}**. Allocates
            memory to store result. *Returns:* **Array{$($T)}**
            """
            function ($f)(X::Array{$T}, Y::$T)
                out = similar(X)
                return $(f!)(out, X, Y)
            end
            @doc """
            `$($f!)(result::Array{$($T)}, X::Array{$($T)}, Y::$($T))`
            Implements element-wise **$($name)** over two **Array{$($T)}** and overwrites
            the result vector with computed value. *Returns:* **Array{$($T)}** `result`
            """
            function ($f!)(out::Array{$T}, X::Array{$T}, Y::$T)
                ccall($(string("v", prefix, fvml), librt),  Cvoid,
                      (Cint, Ptr{$T}, $T, Ptr{$T}),
                      length(out), X, Y, out)
                return out
            end
        end
    end
end

# Optimized calls to ^(1/3), ^(2/3), ^(3/2), ^(-1/3), ^(-1/2) via pow
for (T, prefix) in [(Float32,  "s"), (Float64, "d")]
    for (f, fvml, name) in ((:pow, :Powx, "scalar power"),)
        f! = Symbol("$(f)!")
        addfunction(functions, (f, (Array{T}, T)), "Vectorize.VML.$f")
        addfunction(functions, (f!, (Array{T}, Array{T}, T)), "Vectorize.VML.$(f!)")
        @eval begin
            @doc """
            `$($f)(X::Array{$($T)}, Y::$($T))`
            Implements element-wise **$($name)** over two **Array{$($T)}**. Allocates
            memory to store result. *Returns:* **Array{$($T)}**
            """
            function ($f)(X::Array{$T}, Y::$T)
                out = similar(X)
                return $(f!)(out, X, Y)
            end
            @doc """
            `$($f!)(result::Array{$($T)}, X::Array{$($T)}, Y::$($T))`
            Implements element-wise **$($name)** over two **Array{$($T)}** and overwrites
            the result vector with computed value. *Returns:* **Array{$($T)}** `result`
            """
            function ($f!)(out::Array{$T}, X::Array{$T}, Y::$T)
                if Y == 1/2
                    VML.sqrt!(out, X)
                elseif Y == -1/2
                    VML.invsqrt!(out, X)
                elseif Y == 1/3
                    VML.cbrt!(out, X)
                elseif Y == -1/3
                    VML.invcbrt!(out, X)
                elseif Y == 2/3
                    VML.pow2o3!(out, X)
                elseif Y == 3/2
                    VML.pow3o2!(out, X)
                else
                    ccall($(string("v", prefix, fvml), librt),  Cvoid,
                        (Cint, Ptr{$T}, $T, Ptr{$T}),
                        length(out), X, Y, out)
                end
                return out
            end
        end
    end
end



end # End Module
