module Vectorize

export @vectorize

macro vectorize(ex)
    esc(isa(ex, Expr) ? pushmeta!(ex, :vectorize) : ex)
end

end # module
