module Vectorize

export @vectorize

# macro vectorize(ex)
#     esc(vectorize_(ex))
# end

macro vectorize(ex)
    dump(ex)
    isa(ex, Expr) || error("@vectorize expects an expression as its only argument")

    ## Currently only support function calls
    ex.head == :call || error("@vectorize currently only supports function calls")

    ex
end

function vrize()
	 :($(Expr(:vectorize)))
end	


end # module
