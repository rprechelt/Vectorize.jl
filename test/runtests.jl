using Vectorize
if VERSION >= v"0.5-"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

## Test Apple Accelerate
@osx? include("AccelerateTests.jl") : println("Accelerate not present on current system. Aborting Accelerate tests")

## TODO: Check for presence of Yeppp!
include("YepppTests.jl")

## TODO: Check for presence of VML
include("VMLTests.jl")


#################### VECTORIZE TESTS ####################


