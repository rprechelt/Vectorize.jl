using Vectorize
if VERSION >= v"0.5-"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

N = 1000
srand(7)

## YepCore Signed Integer Tests
for T in (Int8, Int16, Int32, Int64)
    @testset "Yeppp: YepppCore::$T" begin
        X = round(T, randn(N))
        Y = round(T, randn(N))
        @testset "Testing $fy::$T" for (f, fy) in [(.+, :add), (.-, :sub), (.*, :mul)]
            @eval fb = $f
            @eval fyp = Vectorize.Yeppp.$fy
            @test fb(X, Y) ≈ fyp(X, Y)
        end
    end
end

## YepCore Floating Point Tests
for T in (Float32, Float64)
    @testset "Yeppp: YepppCore::$T" begin
        X = randn(N)
        Y = randn(N)
        @testset "Testing $fy::$T" for (f, fy) in [(.+, :add), (.-, :sub), (.*, :mul)]
            @eval fb = $f
            @eval fyp = Vectorize.Yeppp.$fy
            @test fb(X, Y) ≈ fyp(X, Y)
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
