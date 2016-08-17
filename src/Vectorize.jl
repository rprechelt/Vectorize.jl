__precompile__()
##===----------------------------------------------------------------------===##
##                                   ACCELERATE.JL                            ##
##                                                                            ##
##===----------------------------------------------------------------------===##
##                                                                            ##
##  This file checks for the available frameworks and imports only the        ##
##  frameworks available; it also coordinates access to three frameworks      ##
##  through the unified Vectorize.f() syntax                                  ##
##                                                                            ##
##===----------------------------------------------------------------------===##
module Vectorize

export @vectorize

# Cross-version compatibility
if VERSION < v"0.5.0-dev" # Julia v0.4
    OS = OS_NAME
else
    OS = Sys.KERNEL
end

## FUNCTION DICTIONARY
functions = Dict()

## Function for adding to function dictionary
function addfunction(d::Dict, k, v)
    if k in keys(d)
        append!(d[k], [v])
    else
        d[k] = []
        append!(d[k], [v])
    end
end

## START OSX
## On OS X, check if Accelerate can be found - future proofing
OS == :Darwin ? (ACCELERATE = true) : (ACCELERATE = false)
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
    @eval const global libyeppp = libyeppp_
else
    currdir = @__FILE__
    @static if is_windows()
        bindir = currdir[1:end-16]*"deps\\src\\yeppp\\binaries\\"
    else
        bindir = currdir[1:end-16]*"deps/src/yeppp/binaries/"
    end
    
    if OS == :Darwin
        @eval const global libyeppp = bindir*"macosx/x86_64/libyeppp.dylib"
    elseif OS == :Linux
        @eval const global libyeppp = bindir*"linux/x86_64/libyeppp.so"
    elseif OS == :NT
        @eval const global libyeppp = bindir*"windows\\amd64\\yeppp.dll"
    end
end

if isfile(libyeppp)
    include("Yeppp.jl") # include Yeppp if present
end

## Find VML
const global libvml = Libdl.find_library(["libmkl_vml_avx"], ["/opt/intel/mkl/lib"])
if libvml != ""
    include("VML.jl")
end

# vectorize macro
macro vectorize(ex)
    len = length(ex.args)
    if len == 2
        f = :(Vectorize.$(ex.args[1]))
        arg = ex.args[2]
        return esc(:($f($arg)))
    elseif len == 3
        f = :(Vectorize.$(ex.args[1]))
        arg1 = ex.args[2]
        arg2 = ex.args[3]
        return esc(:($f($arg1, $arg2)))
    else
        f = :(Vectorize.$(ex.args[1]))
        arg1 = ex.args[2]
        arg2 = ex.args[3]
        arg3 = ex.args[4]
        return esc(:($f($arg1, $arg2, $arg3)))
    end
end

# Include optimized functions
include("Functions.jl")


end # module
