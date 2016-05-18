The following Julia source files have been changed:

* codegen.cpp - add check for vectorize_sym
* alloc.c - added vectorize_sym definition
* julia.h - added vectorize_sym definition
* interpreter.c - added check that :vectorize is not being interpreted
* julia-syntax.scm - added parses recognition of vectorize
* jltypes.c - added parsing of vectorize to vectorize_sym