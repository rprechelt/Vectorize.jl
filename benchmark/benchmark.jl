"""
`timefn_1arg(fn::Function, vtype::DataType, len::Int, repeats::Int = 3)`

Measures elapsed time for running function `fn` on a random `Vector{vtype}`
with length `len`; measures `repeats` calls and computes result over all
`repeats` iterations.

*Returns:* **Float64** mean
"""
function timefn_1arg(fn::Function, vtype::DataType, len::Int = 1000, repeats::Int = 3)

    times::Vector{Float64} = Array(Float64, repeats)
    X::Vector{vtype} = convert(Vector{vtype}, randn(len))
    fn(X)

    for i in 1:repeats
        times[i] = @elapsed fn(X)
    end

    return mean(times)
end

"""
`benchmark_fn1arg(fn::Function, vtype::DataType, n::Int,
                      min::Int = 10, max::Int = 10000, repeats::Int = 3)`

Measures average time for running function `fn` on random `Vector{vtype}`
with `n` lengths from `min` to `max`; each length is run `repeats` times
and then averaged.

*Returns:* **Vector{Float64}** `means`.
"""
function benchmark_fn1arg(fn::Function, vtype::DataType, n::Int,
                      min::Int = 10, max::Int = 10000, repeats::Int = 3)

    measurements::Vector{Float64} = Array(Float64, n)
    lens = linspace(min, max, n)

    for i in 1:n
        measurements[i] = timefn_1arg(fn, vtype, Int(lens[i]), 3)
    end

    return measurements
end


"""
`timefn_2arg(fn::Function, vtype::DataType, len::Int, repeats::Int = 3)`

Measures elapsed time for running function `fn` on two random `Vector{vtype}`
with length `len`; measures `repeats` calls and computes result over all
`repeats` iterations.

*Returns:* **Float64** `mean`
"""
function timefn_2arg(fn::Function, vtype::DataType, len::Int = 1000, repeats::Int = 3)

    times::Vector{Float64} = Array(Float64, repeats)
    X::Vector{vtype} = convert(Vector{vtype}, randn(len))
    Y::Vector{vtype} = convert(Vector{vtype}, randn(len))
    fn(X, Y)

    for i in 1:repeats
        times[i] = @elapsed fn(X, Y)
    end

    return mean(times)
end


"""
`benchmark_fn2arg(fn::Function, vtype::DataType, n::Int,
                      min::Int = 10, max::Int = 10000, repeats::Int = 3)`

Measures average time for running function `fn` on random `Vector{vtype}`
with `n` lengths from `min` to `max`; each length is run `repeats` times
and then averaged.

*Returns:* **Vector{Float64}** `means`.
"""
function benchmark_fn2arg(fn::Function, vtype::DataType, n::Int,
                      min::Int = 10, max::Int = 10000, repeats::Int = 3)

    measurements::Vector{Float64} = Array(Float64, n)
    lens = linspace(min, max, n)

    for i in 1:n
        measurements[i] = timefn_2arg(fn, vtype, Int(lens[i]), 3)
    end

    return measurements
end
