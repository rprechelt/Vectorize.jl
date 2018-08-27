println("===== Testing Vectorize Benchmarked Functions =====")
# Length of test array
N = 1000
Random.seed!(13)

for T in (Float32, Float64)
    @testset "@replacebase macro::$T" begin

        @replacebase cis
        @replacebase atan
        @replacebase ^

        X = rand(T, N)
        Y = rand(T, N)
        invcbrt = convert(T, -1/3)

        @test Vectorize.cis(X) == cis.(X)
        @test Vectorize.atan(X) == atan.(X)
        @test Vectorize.atan(X, Y) == atan.(X, Y)
        @test Vectorize.pow(X, Y) == X.^Y
        @test Vectorize.pow(X, invcbrt) == X.^(invcbrt)

        #test in-place
        Zvec = similar(complex(X))
        Zbc = similar(Zvec)
        Vectorize.cis!(Zvec, X)
        Zbc .= cis.(X)
        @test Zbc == Zvec
        Yvec = similar(X)
        Ybc = similar(Yvec)
        Vectorize.atan!(Yvec, X)
        Ybc .= atan.(X)
        @test Yvec == Ybc
        Vectorize.pow!(Yvec, X, invcbrt)
        Ybc .= X.^(invcbrt)
        @test Yvec == Ybc
    end
end
# Real Arithmetic
# for T in [Float32, Float64]
#     @testset "Vectorize: Basic Arithmetic::$T" begin
#         X = convert(Vector{T}, abs(randn(N)))
#         Y = convert(Vector{T}, abs(randn(N)))
#         @testset "Testing $f::$T" for (f, fb) in [(:add, .+), (:sub, .-), (:mul, .*), (:div, ./),
#                                                   (:hypot, :hypot), (:atan2, :atan2), (:pow, .^)]
#             @eval fbase = $fb
#             try  # need to catch functions that aren't available from any framework
#                 @eval fvec = Vectorize.$f
#             catch err
#                 println("UndefVar on $f")
#                 if !(isa(err, UndefVarError))
#                     error("Testing $(fvec) has failed")
#                 end

#             end

#             @test fbase(X, Y) ≈ fvec(X, Y)
#             println("Testing $f")
#         end
#     end
# end

# # Complex Arithmetic
# for T in [Complex{Float32}, Complex{Float64}]
#     @testset "Vectorize: Complex Arithmetic::$T" begin
#         X = convert(Vector{T}, randn(N)) + convert(Vector{T}, randn(N))*im
#         Y = convert(Vector{T}, randn(N)) + convert(Vector{T}, randn(N))*im
#         @testset "Testing $f::$T" for (f, fb) in [(:add, .+), (:sub, .-), (:div, ./), (:mul, .*),
#                                                   (:pow, .^)]
#             @eval fbase = $fb

#             try # need to catch functions that aren't available from any framework
#                 @eval fvec = Vectorize.$f
#             catch err
#                 if !(isa(err, UndefVarError))
#                     error("Testing $(fvec) has failed")
#                 end
#                 continue
#             end
#             @test fbase(X, Y) ≈ fvec(X, Y)
#         end

#         @testset "Testing $f::$T" for f in [:mulbyconj]

#             try # need to catch functions that aren't available from any framework
#                 @eval fvec = Vectorize.$f
#             catch err
#                 if !(isa(err, UndefVarError))
#                     error("Testing $(fvec) has failed")
#                 end
#                 continue
#             end
#             @test X .* conj(Y) ≈ fvec(X, Y)
#         end
#     end
# end

# # Real Vector Math
# for T in [Float32, Float64]
#     @testset "Vectorize: Real Vector Math::$T" begin
#         X = convert(Vector{T}, randn(N)) # unrestricted
#         Y = convert(Vector{T}, abs(randn(N))) .+ 1 # greater than 1
#         Z = clamp(convert(Vector{T}, randn(N)), -1,  1) # [-1, 1]
#         W = clamp(convert(Vector{T}, randn(N)), 0,  2) # [0, 2]
#         @testset "Testing $f::$T" for f in [:exp, :abs, :ceil, :floor, :round,
#                                             :trunc, :cos, :sin, :tan, :cosh, :sinh, :tanh,
#                                             :cbrt, :erf, :erfc, :lgamma, :gamma]
#             @eval fb = $f
#             @eval fvec = Vectorize.$f
#             # need to catch functions that aren't available from any framework
#             if testexist(fvec, X) == true
#                 @test fb(X) ≈ fvec(X)
#             end
#         end

#         @testset "Testing $f::$T" for f in [:sqrt, :log10, :acosh, :asinh, :log]
#             @eval fb = $f
#             @eval fvec = Vectorize.$f
#             # need to catch functions that aren't available from any framework
#             if testexist(fvec, Y) == true
#                 @test fb(Y) ≈ fvec(Y)
#             end
#         end

#         # @testset "Testing $f::$T" for f in [:erfcinv]
#         #     @eval fb = $f
#         #     @eval fvec = Vectorize.$f
#         #     @test fb(W) ≈ fvec(W)
#         # end

#         @testset "Testing $f::$T" for f in [:acos, :asin, :atan]#, :atanh] #, :erfinv]
#             @eval fb = $f
#             @eval fvec = Vectorize.$f
#             # need to catch functions that aren't available from any framework
#             if testexist(fvec, Z) == true
#                 @test fb(Z) ≈ fvec(Z)
#             end
#         end
#     end
# end


# # Complex Vector Math
# for T in [Complex{Float32}, Complex{Float64}]
#     @testset "Vectorize: Complex Vector Functions::$T" begin
#         X = convert(Vector{T}, complex(randn(N)))
#         @testset "Testing $f::$T" for f in [:exp, :abs, :cos, :sin, :tan, :cosh, :sinh, :tanh,
#                                             :sqrt, :log10, :acosh, :asinh, :log, :acos, :asin,
#                                             :atan, :conj] #, :atanh]
#             @eval fb = $f
#             @eval fvec = Vectorize.$f
#             if testexist(fvec, X) == true
#                 @test fb(X) ≈ fvec(X)
#             end
#         end
#     end
# end

println("===== Vectorize Tests Successful =====\n\n")
