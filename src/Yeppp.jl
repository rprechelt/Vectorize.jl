#__precompile__()
module Yeppp

## Find Yeppp library
currdir = @__FILE__
bindir = currdir[1:end-4]*"deps/src/yeppp/binaries/"
if OS_NAME == :Darwin
    @eval const libyeppp = bindir*"macosx/x86_64/libyeppp.dylib"
elseif OS_NAME == :Linux
    @eval const libyeppp = bindir*"linux/x86_64/libyeppp.so"
elseif OS_NAME == :Windows
    @eval const libyeppp = bindir*"windows/amd64/yeppp.dll"
end


const yepppcore =
    ((Int8, Int8, Int8), (Int8, Int8, Int16), (UInt8, UInt8, UInt16),  (Int16, Int16, Int16),
     (Int16, Int16, Int32), (UInt16, UInt16, UInt32), (Int32, Int32, Int32),
     (Int32, Int32, Int64), (UInt32, UInt32, UInt64), (Int64, Int64, Int64),
     (Float32, Float32, Float32), (Float64, Float64, Float64))

const identifier = Dict(Int8 => "V8s", Int16 => "V16s", Int32 => "V32s", Int64 => "V64s",
                               UInt8 => "V8u", UInt16 => "V16u", UInt32 => "V32u", UInt64 => "V64u",
                               Float32 => "V32f", Float64 => "V64f")

for (f, fname) in ((:add, "Add"),  (:sub, "Subtract"),  (:mul, "Multiply"))
    for (argtype1, argtype2, returntype) in yepppcore
        @eval begin
            function ($f)(X::Vector{$argtype1}, Y::Vector{$argtype2})
                len = length(X)
                out = Array($returntype, len)
                yepppname = string("yepCore_$($(fname))_", identifier[$argtype1], identifier[$argtype2]
                                   ,  "_", identifier[$returntype])
                ccall((yepppname, libyeppp), Ptr{$returntype},
                          (Ptr{$argtype1}, Ptr{$argtype2}, Ptr{$returntype},  Cint),
                          X, Y, out, len)
                return out
            end
        end
    end
end


end # End Module
