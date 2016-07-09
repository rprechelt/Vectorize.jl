module Benchmark

# erase old function definitions to prevent issues
run(`rm ../src/Functions.jl`)
run(`touch ../src/Functions.jl`)

#import Vectorize: functions
using Vectorize

function benchmarkSingleArgFunction(fname, fnames,
                                    T::DataType, file::IOStream, N::Integer)
    val = Dict()
    println("TESTING: $(fname)(Vector{$T})")
    # Iterate over all functions
    for fstr in fnames
        f = eval(parse(fstr))
        X = convert(Vector{T}, randn(N)) # function arguments
        f(X) # force compilation
        time = @elapsed f(X)
        val[fstr] = time
    end

    # default to first function
    t = val[fnames[1]]
    fbest = fnames[1]

    # find fastest function
    for f in fnames
        if val[f] < t
            t = val[f]
            fbest = f
        end
    end
    write(file, "$(fname)(X::Vector{$T}) = $(fbest)(X::Vector{$T})\n")
    println("BENCHMARK: $(fname)(Vector{$T}) mapped to $(fbest)()\n")
end


function benchmarkTwoArgFunction(fname::Symbol, fnames::Vector{Function},
                                 T::DataType, file::IOStream, N::Integer)
    val = Dict()
    # Iterate over all functions
    for f in fnames
        X = convert(Vector{T}, randn(N)) # function arguments
        Y = convert(Vector{T}, randn(N)) # function arguments
        f(X, Y) # force compilation
        time = @elapsed f(X, Y)
        val[f] = time
    end

    # default to first function
    t = val[fnames[1]]
    fbest = fnames[1]

    # find fastest function
    for f in fnames
        if val[f] < t
            t = val[f]
            fbest = f
        end
    end
    write(file, "\nVectorize.$(fname)(X::Vector{$T}, Y::Vector{$T}) = $(fbest)(X, Y)\n")
end

## RUN TIME
N = 100
file = open("../src/Functions.jl", "a")
for ((f, T), options) in functions
    if length(T) == 1
        benchmarkSingleArgFunction(f, options, T[1], file, 1_000)
#        println("f: $f, options: $(options), t: $(T[1])")
#        break
    end
end
close(file)

end
