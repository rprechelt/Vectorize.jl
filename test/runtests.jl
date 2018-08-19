using Vectorize
using Test
using Random
using Libdl
using SpecialFunctions
using LinearAlgebra

## Test Apple Accelerate
@static if Sys.isapple()
    include("AccelerateTests.jl")
else
    println("Accelerate not present. Aborting Accelerate tests")
end

## Test Yeppp
include("YepppTests.jl")

## Check for presence of VML and test VML
if Libdl.find_library(["libmkl_vml_avx"], ["/opt/intel/mkl/lib"]) != ""
    include("VMLTests.jl")
end

## Running tests over benchmarked Vectorized functions
include("VectorizeTests.jl")
