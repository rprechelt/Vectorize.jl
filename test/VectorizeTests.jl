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

# Real Arithmetic
for T in [Float32, Float64]
    @testset "Vectorize: Basic Arithmetic::$T" begin
        X = convert(Vector{T}, abs(randn(N)))
        Y = convert(Vector{T}, abs(randn(N)))
        @testset "Testing $f::$T" for (f, fb) in [(:add, .+), (:sub, .-), (:mul, .*), (:div, ./),
                                                  (:hypot, :hypot), (:atan2, :atan2), (:pow, .^)]
            @eval fbase = $fb
            @eval fvml = Vectorize.$f
            @test fbase(X, Y) ≈ fvml(X, Y)
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
            @eval fvml = Vectorize.$f
            @test fbase(X, Y) ≈ fvml(X, Y)
        end

        @testset "Testing $f::$T" for f in [:mulbyconj]
            @eval fvml = Vectorize.$f
            @test X .* conj(Y) ≈ fvml(X, Y)
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
            @eval fvml = Vectorize.$f
            @test fb(X) ≈ fvml(X)
        end

        @testset "Testing $f::$T" for f in [:sqrt, :log10, :acosh, :asinh, :log]
            @eval fb = $f
            @eval fvml = Vectorize.$f
            @test fb(Y) ≈ fvml(Y)
        end

        # @testset "Testing $f::$T" for f in [:erfcinv]
        #     @eval fb = $f
        #     @eval fvml = Vectorize.$f
        #     @test fb(W) ≈ fvml(W)
        # end
        
        @testset "Testing $f::$T" for f in [:acos, :asin, :atan]#, :atanh] #, :erfinv]
            @eval fb = $f
            @eval fvml = Vectorize.$f
            @test fb(Z) ≈ fvml(Z)
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
            @eval fvml = Vectorize.$f
            @test fb(X) ≈ fvml(X)
        end
    end
end

# println("===== Vectorize Tests Successful =====\n\n")
