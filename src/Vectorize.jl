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

using Libdl
using SpecialFunctions
using Statistics
export @vectorize, @replacebase

OS = Sys.KERNEL

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
    @static if Sys.iswindows()
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
const global libvml = Libdl.find_library(["libmkl_rt"], ["/opt/intel/mkl/lib"])
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

# replacebase macro
"""
Replace all broadcasted base functions with benchmarked vectorized equivalents.
Alternatively, if the user may pass the functions to overload instead.
"""
macro replacebase(fs...)
    b = Expr(:block)
    for ((fvec, args), vectorized_f) in functions
        m, f = get_corresponding_f(fvec)
        if isempty(fs) || f in fs
            if m == :Base
                if ismutating(fvec)
                    Tdest = first(args)
                    Targs = makeargs(args[2:end])
                    e = quote
                        (Base.copyto!)(dest::$Tdest, bc::Base.Broadcast.Broadcasted{Style, Axes, typeof($m.$f), $Targs}) where {Style, Axes, N} = (Vectorize.$fvec)(dest, bc.args...)
                    end
                else
                    Targs = makeargs(args)
                    e = quote
                        (Base.copy)(bc::Base.Broadcast.Broadcasted{Style, Axes, typeof($m.$f), $Targs}) where {Style, Axes, N} = (Vectorize.$fvec)(bc.args...)
                    end
                end
                push!(b.args, e)
            end
        end
    end
    b
end

function get_corresponding_f(fvec)
    fstr = string(fvec)
    if ismutating(fvec)
        fstr = chop(fstr)
    end
    if fstr == "add"
        fstr = "+"
    elseif fstr == "sub"
        fstr = "-"
    elseif fstr == "mul"
        fstr = "*"
    elseif fstr == "div"
        fstr = "/"
    elseif fstr == "rec"
        fstr = "inv"
    elseif fstr == "pow"
        fstr = "^"
    end

    m = :Base
    if fstr in ("cdfnorminv", "erf", "erfc", "erfi", "erfinv", "erfcinv", "cdfnorm")
        m = :SpecialFunctions
    elseif fstr in ("mean", )
        m = :Statistics
    elseif fstr in ("dot", )
        m = :LinearAlgebra
    elseif fstr in ("pow3o2", "frac", "mulbyconj", "tanpi", "fdiv", "invsqrt",
                    "sqr", "pow2o3", "summag", "sumsqr", "invcbrt")
        m = :None
    end

    fsym = Meta.parse(fstr)
    return m, fsym
end
@inline ismutating(f) = last(string(f)) == '!'
function makeargs(Targs)
    arg_str = "Tuple{"
    for T in Targs
        arg_str *= "$T, "
    end
    arg_str = arg_str[1:end-2]
    arg_str *= "}"
    arg_str = replace(arg_str, " where N" => "")

    return Meta.parse(arg_str)
end

# Include optimized functions
include("Functions.jl")


end # module
