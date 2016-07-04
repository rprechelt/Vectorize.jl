module Yeppp

## Find Yeppp library
libyeppp_ = Libdl.find_library(["libyeppp"])
if libyeppp_ != ""
    const global libyeppp = libyeppp_
else
    currdir = @__FILE__
    bindir = currdir[1:end-12]*"deps/src/yeppp/binaries/"
    if OS_NAME == :Darwin
        @eval const global libyeppp = bindir*"macosx/x86_64/libyeppp.dylib"
    elseif OS_NAME == :Linux
        @eval const global libyeppp = bindir*"linux/x86_64/libyeppp.so"
    elseif OS_NAME == :Windows
        @eval const global libyeppp = bindir*"windows/amd64/yeppp.dll"
    end
end

"""
`__init__()` -> Void

This function initializes the Yeppp library whenever the module is imported.
This allows us to precompile the rest of the module without asking the user
to explictly initialize Yeppp! on load. 
"""
function __init__()
    # Yeppp Initialization
    const status = ccall(("yepLibrary_Init", libyeppp), Cint,
                         (), )
    status != 0 && error("Error initializing Yeppp library (error: ", status, ")")
    
    return true
end


## This defines the argument and return types for every yepCore function; this are as follow:
##
## (First Argument Type, Second Argument Type, Return Type
##
const yepppcore = ((Int8, Int8, Int8), (UInt8, UInt8, UInt16),  (Int16, Int16, Int16),
                   (UInt16, UInt16, UInt32), (Int32, Int32, Int32),
                   (UInt32, UInt32, UInt64), (Int64, Int64, Int64),
                   (Float32, Float32, Float32), (Float64, Float64, Float64))

## This defines the mapping between argument types and Yeppp function name specifications
const identifier = Dict(Int8 => "V8s", Int16 => "V16s", Int32 => "V32s", Int64 => "V64s",
                        UInt8 => "V8u", UInt16 => "V16u", UInt32 => "V32u", UInt64 => "V64u",
                        Float32 => "V32f", Float64 => "V64f")

#### YepppCore ####
for (f, fname) in ((:add, "Add"),  (:sub, "Subtract"),  (:mul, "Multiply"), (:max, "Max"),
                   (:min, "Min"))
    for (argtype1, argtype2, returntype) in yepppcore
        yepppname = string("yepCore_$(fname)_", identifier[argtype1], identifier[argtype2],
                           "_", identifier[returntype])
        @eval begin
            function ($f)(X::Vector{$argtype1}, Y::Vector{$argtype2})
                len = length(X)
                out = Array($returntype, len)
                ccall(($(yepppname, libyeppp)), Cint,
                          (Ptr{$argtype1}, Ptr{$argtype2}, Ptr{$returntype},  Clonglong),
                          X, Y, out, len)
                return out
            end
        end
    end
end


#### YepppMath ####
for (f, fname) in [(:sin, "Sin"),  (:cos, "Cos"),  (:tan, "Tan"), (:log, "Log"), (:exp, "Exp")]
    yepppname = string("yepMath_$(fname)_V64f_V64f")
    @eval begin
        function ($f)(X::Vector{Float64})
            len = length(X)
            out = Array(Float64, len)
            ccall(($(yepppname, libyeppp)), Cint,
                  (Ptr{Float64}, Ptr{Float64},  Clonglong),
                  X, out, len)
            return out
        end
    end
end

## YepppCore - return scalar
for (T, Tscalar) in ((Float32, "S32f"), (Float64, "S64f"))
    for (f, fname) in [(:sum, "Sum"), (:sumabs, "SumAbs"), (:sumsqr, "SumSquares")]
        yepppname = string("yepCore_$(fname)_", identifier[T], "_", Tscalar)
        @eval begin
            function ($f)(X::Vector{$T})
                len = length(X)
                out = Array($T, 1)
                ccall(($(yepppname, libyeppp)), Cint,
                      (Ptr{$T}, Ptr{$T},  Clonglong),
                      X, out, len)
                return out[1]
            end
        end
    end
end





end # End Module
