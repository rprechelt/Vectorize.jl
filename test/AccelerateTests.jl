## Initialize testing globals
println("===== Testing Accelerate =====")
N = 1000
Random.seed!(13)



## LOGARITHM
for T in (Float32, Float64)
    @testset "Accelerate: Logarithmic::$T" begin
        X = exp.(10*randn(T, N))
        @testset "Testing $f::$T" for f in [:log,:log2,:log10, :log1p]
            @eval fb = $f
            @eval fa = Vectorize.Accelerate.$f
            @test fa(X) ≈ fb.(X)
        end
    end
end

## EXPONENIATION
for T in (Float32, Float64)
    @testset "Accelerate: Exponential::$T" begin
        @testset "Testing $f::$T" for f in [:exp,:exp2,:expm1]
            X = 10*randn(T, N)
            @eval fb = $f
            @eval fa = Vectorize.Accelerate.$f
            @test fa(X) ≈ fb.(X)
        end
    end
end

## TRIGONOMETRIC
for T in (Float32, Float64)
    X = 10*randn(T, N)
    @testset "Accelerate: Trigonometric::$T" begin
        @testset "Testing $f::$T" for f in [:sin,:sinpi,:cos,:cospi,:tan,:atan] # tanpi not defined in Base
            @eval fb = $f
            @eval fa = Vectorize.Accelerate.$f
            @test fa(X) ≈ fb.(X)
        end

        Y = 10*randn(T, N)
        @testset "Testing $f::$T" for f in [:atan]
            @eval fb = $f
            @eval fa = Vectorize.Accelerate.$f
            @test fa(X,Y) ≈ fb.(X,Y)
        end

        Z = 2*rand(T, N).-1
        @testset "Testing $f::$T" for f in [:asin,:acos]
            @eval fb = $f
            @eval fa = Vectorize.Accelerate.$f
            @test fa(Z) ≈ fb.(Z)
        end
    end
end

## HYPERBOLIC
for T in (Float32, Float64)
    @testset "Accelerate: Hyperbolic::$T" begin
        X = 10*randn(T, N)
        @testset "Testing $f::$T" for f in [:sinh,:cosh,:tanh,:asinh]
            @eval fb = $f
            @eval fa = Vectorize.Accelerate.$f
            @test fa(X) ≈ fb.(X)
        end

        Y = exp.(10*randn(T, N)).+1
        @testset "Testing $f::$T" for f in [:acosh]
            @eval fb = $f
            @eval fa = Vectorize.Accelerate.$f
            @test fa(Y) ≈ fb.(Y)
        end

        Z = 2*rand(T, N).-1
        @testset "Testing $f::$T" for f in [:atanh]
            @eval fb = $f
            @eval fa = Vectorize.Accelerate.$f
            @test fa(Z) ≈ fb.(Z)
        end
    end
end

## VECTOR OPERATIONS
for T in (Float32, Float64)
    @testset "Accelerate: Vector Operations::$T" begin
        X = 10*randn(T, N)
        Y = 10*randn(T, N)
        @testset "Testing $facc::$T" for (f, facc) in [(:+, :add), (:-, :sub), (:*, :mul), (:/, :div)]
            @eval fb = $f
            @eval facl = Vectorize.Accelerate.$facc
            @test fb.(X, Y) ≈ facl(X, Y)
        end
    end
end


println("===== Accelerate Tests Successful =====\n\n")
