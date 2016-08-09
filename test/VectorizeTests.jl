using Vectorize

if VERSION >= v"0.5-"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

println("===== Testing Vectorize Benchmarked Functions =====")
# Length of test array
N = 1000
srand(13)


# Tests whether a function exists - 1 arg
function testexist(f, X)
    try
        f(X)
    catch err
        if !(isa(err, UndefVarError))
            error("Testing $(fvec) has failed")
        end
    end
end


# Tests whether a function exists - 2 arg
function testexist(f, X, Y)
    try
        f(X, Y)
    catch err
        if !(isa(err, UndefVarError))
            error("Testing $(fvec) has failed")
        end
    end
end

# Real Arithmetic
for T in [Float32, Float64]
    @testset "Vectorize: Basic Arithmetic::$T" begin
        X = convert(Vector{T}, abs(randn(N)))
        Y = convert(Vector{T}, abs(randn(N)))
        @testset "Testing $f::$T" for (f, fb) in [(:add, .+), (:sub, .-), (:mul, .*), (:div, ./),
                                                  (:hypot, :hypot), (:atan2, :atan2), (:pow, .^)]
            @eval fbase = $fb
            @eval fvec = Vectorize.$f
            # need to catch functions that aren't available from any framework
            testexist(fvec, X, Y)
            @test fbase(X, Y) ≈ fvec(X, Y)
        end
    end
end

# Complex Arithmetic
for T in [Complex{Float32}, Complex{Float64}]
    @testset "Vectorize: Complex Arithmetic::$T" begin
        X = convert(Vector{T}, randn(N)) + convert(Vector{T}, randn(N))*im
        Y = convert(Vector{T}, randn(N)) + convert(Vector{T}, randn(N))*im
        @testset "Testing $f::$T" for (f, fb) in [(:add, .+), (:sub, .-), (:div, ./), (:mul, .*),
                                                  (:pow, .^)]
            @eval fbase = $fb
            @eval fvec = Vectorize.$f
            # need to catch functions that aren't available from any framework
            testexist(fvec, X, Y)
            @test fbase(X, Y) ≈ fvec(X, Y)
        end

        @testset "Testing $f::$T" for f in [:mulbyconj]
            
            @eval fvec = Vectorize.$f
            # need to catch functions that aren't available from any framework
            testexist(fvec, X, Y)
            @test X .* conj(Y) ≈ fvec(X, Y)
        end
    end
end

# Real Vector Math
for T in [Float32, Float64]
    @testset "Vectorize: Real Vector Math::$T" begin
        X = convert(Vector{T}, randn(N)) # unrestricted
        Y = convert(Vector{T}, abs(randn(N))) .+ 1 # greater than 1
        Z = clamp(convert(Vector{T}, randn(N)), -1,  1) # [-1, 1]
        W = clamp(convert(Vector{T}, randn(N)), 0,  2) # [0, 2]
        @testset "Testing $f::$T" for f in [:exp, :abs, :ceil, :floor, :round,
                                            :trunc, :cos, :sin, :tan, :cosh, :sinh, :tanh,
                                            :cbrt, :erf, :erfc, :lgamma, :gamma]
            @eval fb = $f
            @eval fvec = Vectorize.$f
            # need to catch functions that aren't available from any framework
            testexist(fvec, X)
            @test fb(X) ≈ fvec(X)
        end

        @testset "Testing $f::$T" for f in [:sqrt, :log10, :acosh, :asinh, :log]
            @eval fb = $f
            @eval fvec = Vectorize.$f
            # need to catch functions that aren't available from any framework
            testexist(fvec, Y)
            @test fb(Y) ≈ fvec(Y)
        end

        # @testset "Testing $f::$T" for f in [:erfcinv]
        #     @eval fb = $f
        #     @eval fvec = Vectorize.$f
        #     @test fb(W) ≈ fvec(W)
        # end
        
        @testset "Testing $f::$T" for f in [:acos, :asin, :atan]#, :atanh] #, :erfinv]
            @eval fb = $f
            @eval fvec = Vectorize.$f
            # need to catch functions that aren't available from any framework
            testexist(fvec, Z)
            @test fb(Z) ≈ fvec(Z)
        end
    end
end


# Complex Vector Math
for T in [Complex{Float32}, Complex{Float64}]
    @testset "Vectorize: Complex Vector Functions::$T" begin
        X = convert(Vector{T}, complex(randn(N)))
        @testset "Testing $f::$T" for f in [:exp, :abs, :cos, :sin, :tan, :cosh, :sinh, :tanh,
                                            :sqrt, :log10, :acosh, :asinh, :log, :acos, :asin,
                                            :atan, :conj] #, :atanh]
            @eval fb = $f
            @eval fvec = Vectorize.$f
            @test fb(X) ≈ fvec(X)
        end
    end
end

println("===== Vectorize Tests Successful =====\n\n")
