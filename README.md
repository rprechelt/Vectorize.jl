# Vectorize

[![Documentation Status](https://readthedocs.org/projects/vectorizejl/badge/?version=latest)](http://vectorizejl.readthedocs.io/en/latest/?badge=latest)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)]()

This package is under **heavy** development but it is **not** currently operational; do **not** attempt to **install** this package. It will only give you *nightmares*... This notice **will** be removed as soon as Vectorize.jl can reliably be installed, and the code base has become somewhat stable.

## Features
Currently, Vectorize.jl only provides direct access to array-oriented functions in Apple's Accelerate, Intel's VML, and Yeppp! These can be accessed using `Vectorize.LibraryName.Function()` i.e. 

    Vectorize.Accelerate.log(X)
    Vectorize.VML.log(X)
    Vectorize.Yeppp!.log(x)

These functions can provide orders of magnitude higher-performance than the standard functions in Julia; over 100-fold improvements are common for functions throughout the three libraries. Any attempt to call a function that is not supported by that particular library will result in an error; this is to allow the programmer specific knowledge of which functions are being vectorized, and which are not. 

## Installation
#### Julia
Vectorize.jl can only be installed against versions of Julia that have been built from source (binary downloads will not work). This is because Vectorize.jl links and registers itself against the version of LLVM included in the Julia repository. By default, it expects the Julia repo to be in `~/.julia/`. If the source of your Julia install is in a different location, you can specify this using the `VEC_JULIA_DIR` environment variable (i.e. Vectorize will search for the Julia repo in `~/VEC_JULIA_DIR/`. 

If you are installing Julia from scratch, you can install it in the correct location by running:

    git clone https://github.com/JuliaLang/julia .julia
    

#### Dependencies
Vectorize.jl has the following dependencies:

    CMake (>= 3.4)

Please ensure that all the dependencies are installed and are in your  `PATH`.

#### Installation 
To install the latest version of Vectorize from `master`, run

    Pkg.clone("http://github.com/rprechelt/Vectorize.jl")

from a Julia REPL.

Once the package has finished cloning, run

    Pkg.build("Vectorize")

This will print the build status to the terminal; you will be notified if the build completes successfully. If the build fails, please create an issue on Github and copy the output of `Pkg.build()` into the issue. This will help in debugging the build failures. 
