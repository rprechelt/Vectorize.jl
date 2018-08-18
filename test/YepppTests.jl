println("===== Testing Yeppp!  =====")

## length of test array
N = 1000
Random.seed!(7)

## YepCore Signed Integer Tests
for T in (Int8, Int16, Int32, Int64)
    @testset "Yeppp: Integer Operations::$T" begin
        X = round.(T, randn(N))
        Y = round.(T, randn(N))
        @testset "Testing $fy::$T" for (f, fy) in [(+, :add), (-, :sub), (*, :mul)]
            @eval fb = $f
            @eval fyp = Vectorize.Yeppp.$fy
            @test fb.(X, Y) ≈ fyp(X, Y)
        end
    end
end

## YepCore Floating Point Tests
for T in (Float32, Float64)
    @testset "Yeppp: Floating Point Operations::$T" begin
        X = randn(T, N)
        Y = randn(T, N)
        @testset "Testing $fy::$T" for (f, fy) in [(+, :add), (-, :sub), (*, :mul)]
            @eval fb = $f
            @eval fyp = Vectorize.Yeppp.$fy
            @test fb.(X, Y) ≈ fyp(X, Y)
        end
    end
end

# YeppCore Max/Min Integer
for T in (Int8, Int16, Int32)
    @testset "Yeppp: Integer Max/Min::$T" begin
        X = round.(T, randn(N))
        Y = round.(T, randn(N))
        @testset "Testing $fy::$T" for (f, fy) in [(max, :max), (min, :min)]
            @eval fb = $f
            @eval fyp = Vectorize.Yeppp.$fy
            @test fb.(X, Y) ≈ fyp(X, Y)
        end
    end
end

# YeppCore Max/Min Floating Point
for T in (Float32, Float64)
    @testset "Yeppp: Floating Point Max/Min::$T" begin
        X = randn(T, N)
        Y = randn(T, N)
        @testset "Testing $fy::$T" for (f, fy) in [(max, :max), (min, :min)]
            @eval fb = $f
            @eval fyp = Vectorize.Yeppp.$fy
            @test fb.(X, Y) ≈ fyp(X, Y)
        end
    end
end

## YepCore Unsigned Integer Tests
# for (Tin, Tout) in ((UInt8, UInt16), (UInt16, UInt32), (UInt32, UInt64))
#     @testset "Yeppp: YepppCore::$Tin" begin
#         X = trunc(Tin, 10*abs(randn(N)) .+ 1)
#         Y = trunc(Tin, 10*abs(randn(N)) .+ 1)
#         @testset "Testing $fy::$Tin" for (f, fy) in [(.+, :add), (.-, :sub), (./, :div), (.*, :mul)]
#             @eval fb = $f
#             @eval fyp = Vectorize.Yeppp.$fy
#             println(trunc(Tout, abs(fb(X, Y))))
# #            println(trunc(T, fyp(X, Y)))
#             println("fyp: ",  trunc(Tout, fyp(X, Y)))
#             @test trunc(Tout, abs(fb(X, Y))) ≈ trunc(Tout, fyp(X, Y))
#         end
#     end
# end

# YepppMath Floating Point
for T in [Float64]
    @testset "Yeppp: Floating Point Math::$T" begin
        X = convert(Vector{T}, randn(N))
        @testset "Testing $f::$T" for f in [:sin, :cos, :tan]
            @eval fb = $f
            @eval fy = Vectorize.Yeppp.$f
            @test fb.(X) ≈ fy(X)
        end

        @testset "Testing $f::$T" for f in [:log, :exp]
            @eval fb = $f
            @eval fy = Vectorize.Yeppp.$f
            @test fb.(abs.(X)) ≈ fy(abs.(X))

        end
    end
end

# YepppMath Floating Point - return scalar
for T in (Float32, Float64)
    @testset "Yeppp: Floating Point Reductions::$T" begin
        X = convert(Vector{T}, randn(N))
        @testset "Testing $f::$T" for f in [:sum]
            @eval fb = $f
            @eval fy = Vectorize.Yeppp.$f
            @test fb(X) ≈ fy(X)
        end

        @testset "Testing $f::$T" for f in [:sumsqr]
            @eval fy = Vectorize.Yeppp.$f
            @test sum(X .* X) ≈ fy(X)
        end
    end
end


println("===== Yeppp! Tests Successful =====\n\n")
