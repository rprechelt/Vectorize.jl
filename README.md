# Vectorize

[![Documentation Status](https://readthedocs.org/projects/vectorizejl/badge/?version=latest)](http://vectorizejl.readthedocs.io/en/latest/?badge=latest)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)]()
[![Build Status](https://travis-ci.org/rprechelt/Vectorize.jl.svg?branch=master)](https://travis-ci.org/rprechelt/Vectorize.jl)

## Features
Vectorize.jl provides a unified interface to the high-performance vectorized functions provided by Apple's [Accelerate](https://developer.apple.com/reference/accelerate) framework (OS X only), Intel's [VML](https://software.intel.com/en-us/node/521751) (part of MKL) and [Yeppp!](http://www.yeppp.info/) These can be accessed using the `Vectorize.LibraryName.Function()` syntax i.e. 

    Vectorize.Accelerate.exp(X)
    Vectorize.VML.erf(X)
    Vectorize.Yeppp.log(x)

These functions can provide orders of magnitude higher-performance than the standard functions in Julia; nearly 50-fold improvements are common for functions throughout the three libraries.

Furthermore, a complete benchmarking suite is run during package installation that automatically selects the fastest implementation *for your architecture* on a function-by-function basis; this means that calls to

    Vectorize.sin(X)

will be transparently mapped to the Accelerate, VML or Yeppp! implementation based upon the performance of these frameworks on *your particular machine* and the type of `X`. This mapping happens during package installation and precompilation and so occurs no runtime overhead (expect to wait a few extra seconds than normal to install this package as the benchmarking suite needs to be run).

Vectorize.jl will transparently select from the different frameworks that are available on your machine; you are not required to have any particular framework installed (although having all three tends to provide the best performance as different frameworks have different strengths).

This package currently supports over 40 functions over `Float32`, `Float64`, `Complex{Float32}`, and `Complex{Float64}`; Vectorize.Yeppp also provides access to various Yeppp functions over `UInt8`, `UInt16`, `UInt32`, `UInt64`, `Int8`, `Int16`, `Int32`, and `Int64` (although these are not benchmarked as neither Accelerate or VML provide equivalent functions). Every function by VML is currently supported, alongside the vast majority of optimized Yeppp functions and an equivalent portion of Accelerate. Please see the documentation for a complete list of provided functions and implementations. 

*Please note, this package is still in* **beta** *and has not been tested on all architectures and operating systems. Currently OS X and Linux on `x86_64` are the only officially supported operating systems and architecture, but full Windows support will be added in the next week or two, and other architectures may very well work as is (but they have not been tested). 

## Installation 
To install the latest version of Vectorize from `master`, run

    Pkg.clone("http://github.com/rprechelt/Vectorize.jl")

from a Julia REPL. 

Once the package has finished cloning, run

    Pkg.build("Vectorize")

This will print the build status to the terminal; you will be notified if the build completes successfully. This will attempt to determine which frameworks are available on your machine and incorporate those frameworks into the benchmarking process; if it is unable to locate Yeppp!, it will download a local copy and store it in the Vectorize.jl package directory (no changes are made to your system by installing Vectorize.jl). The build process will report what frameworks it is able to find - if it unable to find your system-installed version of Yeppp! or MKL, please ensure that they are both in your system PATH. 

If the build fails, or it is unable to find system-installed packages correctly, please create an issue on Github and copy the output of `Pkg.build()` into the issue. This will help in debugging the build failures. 