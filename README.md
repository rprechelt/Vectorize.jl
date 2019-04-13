# Vectorize

[![Documentation Status](https://readthedocs.org/projects/vectorizejl/badge/?version=latest)](http://vectorizejl.readthedocs.io/en/latest/?badge=latest)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)]()
[![Build Status](https://travis-ci.org/rprechelt/Vectorize.jl.svg?branch=master)](https://travis-ci.org/rprechelt/Vectorize.jl)

## Features
Vectorize.jl provides a unified interface to the high-performance vectorized functions provided by Apple's [Accelerate](https://developer.apple.com/reference/accelerate) framework (OS X only), Intel's [VML](https://software.intel.com/en-us/node/521751) (part of MKL) and [Yeppp!](http://www.yeppp.info/); currently, over 160 functions are supported. These can be accessed using the `Vectorize.LibraryName.Function()` syntax i.e.

    Vectorize.Accelerate.exp(X)
    Vectorize.VML.erf(X)
    Vectorize.Yeppp.log(x)

Furthermore, a complete benchmarking suite is run during package installation that automatically selects the fastest implementation *for your architecture* on a function-by-function basis; this means that calls to

    Vectorize.sin(X)

will be transparently mapped to the Accelerate, VML or Yeppp! implementation based upon the performance of these frameworks on *your particular machine* and the type of `X`. This mapping happens during package installation and so occurs no runtime overhead (expect to wait a few extra seconds than normal to install this package as the benchmarking suite needs to be run).

Vectorize.jl provides a `@vectorize` macro that automatically converts a call to Julia's standard implementation into the fastest vectorized equivalent available on your machine, i.e.

    cos(X)    # Standard Julia implementation
    @vectorize cos(X)    # Converted to Yeppp, VML, or Accelerate at compile time

This macro provides an easy method for code to be quickly converted to use Vectorize.jl with little additional effort.

Vectorize.jl also provides a `@replacebase` macro that automatically overloads base broadcasting calls into the fastest vectorized equivalent available.

    X.^(-1/3)  # Standard Julia broadcast implementation
    Z .= cis.(X)   # Standard Julia in-place broadcast implementation
    
    @replacebase cis # Overloads both in-place and out-of-place broadcast calls to cis, provided cis is not fused in the broadcast
    @replacebase ^ # Note: ^ (pow) is currently only available for VML
    
    X.^(-1/3)  # This call now uses Vectorize.pow(X, -1/3)
    Z .= cis.(X)   # This call now uses Vectorize.cis!
    
    @replacebase # This will overload all functions that were benchmarked by Vectorize.jl

This macro allows pre-existing code to take advantage of optimized vectorized implementations with only a line of code. Note that if the broadcast call is multiple function calls fused together, the Vectorize.jl version will not be used, so some care must be taken to write simple broadcasts.

The performance benefits are significant; the two plots below the runtime reduction for a small selection of operators available in Vectorize.jl. This data was collected on a 2.5GHz Intel i7 running on OS X; each function was called immediately prior to benchmarking to ensure precompilation, before calculating the average over ten executions using `Vector{Float64}` of length 100.

![Accelerate Benchmark](https://raw.githubusercontent.com/rprechelt/Vectorize.jl/master/doc/images/accelerate.png)

![Vectorize Benchmark](https://raw.githubusercontent.com/rprechelt/Vectorize.jl/master/doc/images/vectorize.png)

These functions can provide orders of magnitude higher-performance than the standard functions in Julia; over 10-fold improvements are common for functions throughout the three libraries. Since these functions are designed to operate on moderate-to-large sized arrays, they tend to be less performant that standard Julia functions for arrays of length less than 10 elements; in that case, it is best not to use Vectorize.jl.

Vectorize.jl will transparently select from the different frameworks that are available on your machine; you are not required to have any particular framework installed (although having all three tends to provide the best performance as different frameworks have different strengths). For users not running OS X, we strongly recommend installing Intel's VML (free for open-source projects under the community license - other licenses are available) as the only other library available for non-OSX systems is Yeppp, and Yeppp only provides a very small collection of functions.

This package currently supports over 40 functions over `Float32`, `Float64`, `Complex{Float32}`, and `Complex{Float64}`; `Vectorize.Yeppp` also provides access to various Yeppp functions over `UInt8`, `UInt16`, `UInt32`, `UInt64`, `Int8`, `Int16`, `Int32`, and `Int64` (although these are not benchmarked as neither Accelerate or VML provide equivalent functions). Every function provided by VML is currently supported, alongside the vast majority of optimized Yeppp functions and an equivalent portion of Accelerate. Please see the documentation for a complete list of provided functions and implementations.

## Installation
To install the latest version of Vectorize from `master`, run

    Pkg.clone("http://github.com/rprechelt/Vectorize.jl")

from a Julia REPL on OS X, Linux, or Windows.

On Windows, you will need `wget64` and `7-Zip` installed and available in your `PATH` (in order to download and decompress Yeppp)

Once the package has finished cloning, run

    Pkg.build("Vectorize")

This will print the build status to the terminal; you will be notified if the build completes successfully. This will attempt to determine which frameworks are available on your machine and incorporate those frameworks into the benchmarking process; if it is unable to locate Yeppp!, it will download a local copy and store it in the Vectorize.jl package directory (no changes are made to your system by installing Vectorize.jl). The build process will report what frameworks it is able to find - if it unable to find your system-installed version of Yeppp! or MKL, please ensure that they are both in your system PATH.

If the build fails, or it is unable to find system-installed packages correctly, please create an issue on Github and copy the output of `Pkg.build()` into the issue. This will help in debugging the build failures.
