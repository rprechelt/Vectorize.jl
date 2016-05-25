__precompile__()
module Vectorize

export @vectorize

## START OSX
## On OS X, check if Accelerate can be found - future proofing
@osx? (ACCELERATE = true) : (ACCELERATE = false)
if ACCELERATE == true
    if isfile("/System/Library/Frameworks/Accelerate.framework/Accelerate")
        @eval parse("include(\"Accelerate.jl\")")
    else
        warn("Unable to locate the Apple Accelerate framework")
    end
end
## END OSX


"""
`__init__()` -> Void

This function initializes the Yeppp library whenever the module is imported.
This allows us to precompile the rest of the module without asking the user
to explictly initialize Yeppp! on load.
"""
function __init__()
    ## TODO: Init Yeppp
end

macro vectorize(ex)
    esc(isa(ex, Expr) ? pushmeta!(ex, :vectorize) : ex)
end

end # module
