function benchmarkSingleArgFunction(fname, fnames,
                                    T::DataType, file::IOStream, N::Integer)
    val = Dict()
    println("TESTING: $(fname)(Vector{$T})")
    # Iterate over all functions
    for fstr in fnames
        f = eval(parse(fstr))
        X = convert(Vector{T}, randn(N)) # function arguments
        f(X) # force compilation
        time = 0
        for i in 1:10
            time += @elapsed f(X)
        end
        val[fstr] = time/10.0
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
