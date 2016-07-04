using Vectorize
if VERSION >= v"0.5-"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

## Test Apple Accelerate
@osx? println("===== Testing Accelerate =====")
@osx? include("AccelerateTests.jl") : println("Accelerate not present on current system. Aborting Accelerate tests")
@osx? println("===== Accelerate Tests Successful =====\n\n")

## Check for presence of Yeppp!
println("===== Testing Yeppp!  =====")
include("YepppTests.jl")
println("===== Yeppp! Tests Successful =====\n\n")

## Check for presence of VML
if Libdl.find_library(["libmkl_vml_avx"], ["/opt/intel/mkl/lib"]) != ""
    println("===== Testing Intel's VML =====")
    include("VMLTests.jl")
    println("===== VML Tests Successful =====\n\n")
end

