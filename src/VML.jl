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

# Cross-version compatibility
if VERSION < v"0.5.0-dev" # Julia v0.4
    readstring(cmd) = readall(cmd)
    OS = OS_NAME
else
    OS = Sys.KERNEL
end

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
        addfunction(functions, (f, (T,T)), "Vectorize.VML.$f")
        addfunction(functions, (f!, (T,T,T)), "Vectorize.VML.$(f!)")
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
    for (f, fvml, name) in [(:hypot, :Hypot, "hypotenuse"), (:atan2, :Atan2, "atan2")]
        f! = Symbol("$(f)!")
        addfunction(functions, (f, (T,T)), "Vectorize.VML.$f")
        addfunction(functions, (f!, (T,T,T)), "Vectorize.VML.$(f!)")
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
for (T, prefix) in [(Complex{Float32}, "c"),  (Complex{Float64}, "z")]
    for (f, fvml, name) in [(:mulbyconj, :MulByConj, "multiply-by-conjugate")]
        f! = Symbol("$(f)!")
        addfunction(functions, (f, (T,T)), "Vectorize.VML.$f")
        addfunction(functions, (f!, (T,T,T)), "Vectorize.VML.$(f!)")
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

# Basic operations on one arg
for (T, prefix) in [(Float32,  "s"), (Float64, "d"),  (Complex{Float32}, "c"),  (Complex{Float64}, "z")]
    for (f, fvml) in [(:sqrt, :Sqrt), (:exp, :Exp),  (:acos, :Acos), (:asin, :Asin),
                      (:acosh, :Acosh), (:asinh, :Asinh), (:log,  :Ln),
                     (:atan, :Atan), (:cos, :Cos), (:sin, :Sin),
                      (:tan, :Tan), (:cosh, :Cosh), (:sinh, :Sinh), (:tanh, :Tanh), (:log10, :Log10)]
        f! = Symbol("$(f)!")
        name = string(f)
        addfunction(functions, (f, (T,)), "Vectorize.VML.$f")
        addfunction(functions, (f!, (T,T)), "Vectorize.VML.$(f!)")
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
                      (:round, :Round), (:frac,  :Frac), (:abs, :Abs), (:sqr, :Sqr)]
        f! = Symbol("$(f)!")
        name = string(f)
        addfunction(functions, (f, (T,)), "Vectorize.VML.$f")
        addfunction(functions, (f!, (T,T)), "Vectorize.VML.$(f!)")
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
        addfunction(functions, (f, (T,)), "Vectorize.VML.$f")
        addfunction(functions, (f!, (T,T)), "Vectorize.VML.$(f!)")
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
        addfunction(functions, (f, (T,)), "Vectorize.VML.$f")
        addfunction(functions, (f!, (real(T),T)), "Vectorize.VML.$(f!)")
        @eval begin
            @doc """
            `$($f)(X::Array{$($T)})`
            Calculates the **$($name)** element-wise over a **Array{$($T)}**. Allocates
            memory to store result. *Returns:* **Array{$($T)}**
            """
            function ($f)(X::Array{$T})
                out = Array(real($T), length(X))
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

end # End Module
