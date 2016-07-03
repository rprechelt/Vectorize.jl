using Vectorize
if VERSION >= v"0.5-"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

## Test Apple Accelerate
println("===== Testing Accelerate =====")
@osx? include("AccelerateTests.jl") : println("Accelerate not present on current system. Aborting Accelerate tests")
println("===== Accelerate Tests Successful =====\n\n")

## TODO: Check for presence of Yeppp!
println("===== Testing Yeppp!  =====")
include("YepppTests.jl")
println("===== Yeppp! Tests Successful =====\n\n")

## TODO: Check for presence of VML
println("===== Testing Intel's VML =====")
include("VMLTests.jl")
println("===== VML Tests Successful =====\n\n")


#################### VECTORIZE TESTS ####################


