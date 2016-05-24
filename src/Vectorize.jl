__precompile__()
module Vectorize

export @vectorize

## START OSX
## On OS X, check if Accelerate can be found - future proofing
@osx? (AccelerateAvailable = true) : (AccelerateAvailable = false)
if AccelerateAvailable == true
    if isfile("/System/Library/Frameworks/Accelerate.framework/Accelerate")
        eval(parse("include(\"Accelerate.jl\")"))
    else
        warn("Unable to locate the Apple Accelerate framework")
    end
end
## END OSX

macro vectorize(ex)
    esc(isa(ex, Expr) ? pushmeta!(ex, :vectorize) : ex)
end

end # module
