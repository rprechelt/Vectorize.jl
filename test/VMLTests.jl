using Vectorize
VML = Vectorize.VML

if VERSION >= v"0.5-"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

# Length of test array
N = 1000
srand(13)

# Test basic utility functionality
@testset "VML: Basic Functionality" begin
    mode = VML.getmode()
    @test mode == VML.setmode(VML.VML_HA)
    @test typeof(VML.setmode(VML.VML_HA)) <: Integer
end


# Real Arithmetic
for T in [Float32, Float64]
    @testset "VML: Basic Arithmetic::$T" begin
        X = convert(Vector{T}, randn(N))
        Y = convert(Vector{T}, randn(N))
        @testset "Testing $f::$T" for (f, fb) in [(:add, .+), (:sub, .-), (:div, ./), (:mul, .*)]
            @eval fb = $fb
            @eval fvml = Vectorize.VML.$f
            @test fb(X, Y) ≈ fvml(X, Y)
        end
    end
end

# Complex Arithmetic
for T in [Complex{Float32}, Complex{Float64}]
    @testset "VML: Complex Arithmetic::$T" begin
        X = convert(Vector{T}, randn(N)) + convert(Vector{T}, randn(N))*im
        Y = convert(Vector{T}, randn(N)) + convert(Vector{T}, randn(N))*im
        @testset "Testing $f::$T" for (f, fb) in [(:add, .+), (:sub, .-), (:div, ./), (:mul, .*)]
            @eval fb = $fb
            @eval fvml = Vectorize.VML.$f
            @test fb(X, Y) ≈ fvml(X, Y)
        end
    end
end

# Real Vector Math
for T in [Float32, Float64]
    @testset "VML: Real Vector Math::$T" begin
        X = convert(Vector{T}, randn(N))
        Y = convert(Vector{T}, abs(randn(N))) .+ 1
        Z = clamp(convert(Vector{T}, randn(N)), -1,  1)
        @testset "Testing $f::$T" for f in [:exp, :abs, :ceil, :floor, :round,
                                            :trunc, :cos, :sin, :tan, :cosh, :sinh, :tanh]
            @eval fb = $f
            @eval fvml = Vectorize.VML.$f
            @test fb(X) ≈ fvml(X)
        end

        @testset "Testing $f::$T" for f in [:sqrt, :log10, :acosh, :asinh, :log]
            @eval fb = $f
            @eval fvml = Vectorize.VML.$f
            @test fb(Y) ≈ fvml(Y)
        end
        
        @testset "Testing $f::$T" for f in [:acos, :asin, :atan, :atanh]
            @eval fb = $f
            @eval fvml = Vectorize.VML.$f
            @test fb(Z) ≈ fvml(Z)
        end
    end
end


# Complex Vector Math
for T in [Complex{Float32}, Complex{Float64}]
    @testset "VML: Complex Vector Functions::$T" begin
        X = convert(Vector{T}, complex(randn(N)))
        # Y = convert(Vector{T}, abs(randn(N))) .+ 1
        # Z = clamp(convert(Vector{T}, randn(N)), -1,  1)
        @testset "Testing $f::$T" for f in [:exp, :abs, :cos, :sin, :tan, :cosh, :sinh, :tanh,
                                            :sqrt, :log10, :acosh, :asinh, :log, :acos, :asin,
                                            :atan, :atanh]
            @eval fb = $f
            @eval fvml = Vectorize.VML.$f
            @test fb(X) ≈ fvml(X)
        end

        @testset "Testing $f::$T" for f in []
            @eval fb = $f
            @eval fvml = Vectorize.VML.$f
            @test fb(Y) ≈ fvml(Y)
        end
        
        @testset "Testing $f::$T" for f in []
            @eval fb = $f
            @eval fvml = Vectorize.VML.$f
            @test fb(Z) ≈ fvml(Z)
        end
    end
end
