__precompile__()
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
currdir = @__FILE__
bindir = currdir[1:end-16]*"deps/src/yeppp/binaries/"
if OS_NAME == :Darwin
    @eval const libyeppp = bindir*"macosx/x86_64/libyeppp.dylib"
elseif OS_NAME == :Linux
    @eval const libyeppp = bindir*"linux/x86_64/libyeppp.so"
elseif OS_NAME == :Windows
    @eval const libyeppp = bindir*"windows/amd64/yeppp.dll"
end

include("Yeppp.jl") # include Yeppp

"""
`__init__()` -> Void

This function initializes the Yeppp library whenever the module is imported.
This allows us to precompile the rest of the module without asking the user
to explictly initialize Yeppp! on load.
"""
function __init__()
    const status = ccall(("yepLibrary_Init", libyeppp), Cint,
                         (), )
    status != 0 && error("Error initializing Yeppp library (error: ", status, ")")

    return true
end

macro vectorize(ex)
    esc(isa(ex, Expr) ? Base.pushmeta!(ex, :vectorize) : ex)
end

end # module
