#__precompile__()
module Vectorize

# eval(x) = Core.eval(Vectorize, x)
# eval(m,x) = Core.eval(m, x)
# @osx? a : b = Core.@osx? a : b

export @vectorize

## START OSX
## On OS X, check if Accelerate can be found - future proofing
@osx? (ACCELERATE = true) : (ACCELERATE = false)
if ACCELERATE == true
    if isfile("/System/Library/Frameworks/Accelerate.framework/Accelerate")
        eval(:(include("Accelerate.jl")))
    else
        warn("Unable to locate the Apple Accelerate framework")
    end
end
## END OSX


## Find Yeppp library
libyeppp_ = Libdl.find_library(["libyeppp"])
if libyeppp_ != ""
    const global libyeppp = libyeppp_
else
    currdir = @__FILE__
    bindir = currdir[1:end-16]*"deps/src/yeppp/binaries/"
    if OS_NAME == :Darwin
        @eval const global libyeppp = bindir*"macosx/x86_64/libyeppp.dylib"
    elseif OS_NAME == :Linux
        @eval const global libyeppp = bindir*"linux/x86_64/libyeppp.so"
    elseif OS_NAME == :Windows
        @eval const global libyeppp = bindir*"windows/amd64/yeppp.dll"
    end
end

include("Yeppp.jl") # include Yeppp

## Find VML
const global libvml = Libdl.find_library(["libmkl_vml_avx"], ["/opt/intel/mkl/lib"])
if libvml != ""
    include("VML.jl")
end


macro vectorize(ex)
    esc(isa(ex, Expr) ? Base.pushmeta!(ex, :vectorize) : ex)
end

const yepppfunctions = Dict(:add => (Float32, Float64), :sub => (Float32, Float64),
                            :mul => (Float32, Float64), :max => (Float32, Float64),
                            :min => (Float32, Float64))


# Include benchmark-generated functions
include("Functions.jl")

end # module
