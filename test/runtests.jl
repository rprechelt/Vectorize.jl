using Vectorize
if VERSION >= v"0.5-"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

## Test Apple Accelerate
if is_apple()
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

