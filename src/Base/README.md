The following Julia source files have been changed:

* codegen.cpp - add check for vectorize_sym [here](https://github.com/rprechelt/Vectorize.jl/blob/master/src/Base/codegen.cpp#L3421)
* alloc.c - added vectorize_sym definition [here](https://github.com/rprechelt/Vectorize.jl/blob/master/src/Base/alloc.c#L104) and [here](https://github.com/rprechelt/Vectorize.jl/blob/master/src/Base/alloc.c#L276)
* julia.h - added vectorize_sym definition [here](https://github.com/rprechelt/Vectorize.jl/blob/master/src/Base/julia.h#L573)
* interpreter.c - added check that :vectorize is not being interpreted [here](https://github.com/rprechelt/Vectorize.jl/blob/master/src/Base/interpreter.c#L429)
* julia-syntax.scm - added parses recognition of vectorize [here](https://github.com/rprechelt/Vectorize.jl/blob/master/src/Base/julia-syntax.scm#L2663) and [here](https://github.com/rprechelt/Vectorize.jl/blob/master/src/Base/julia-syntax.scm#L3205) 
* jltypes.c - added parsing of vectorize to vectorize_sym [here](https://github.com/rprechelt/Vectorize.jl/blob/master/src/Base/jltypes.c#L3778) 
