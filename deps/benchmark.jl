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
    write(file, "\n$(fname)(X::Vector{$T}) = $(fbest)(X)\n")
    println("BENCHMARK: $(fname)(Vector{$T}) mapped to $(fbest)()\n")
end


function benchmarkTwoArgFunction(fname, fnames,
                                 T::Tuple{DataType, DataType}, file::IOStream, N::Integer)
    println("TESTING: $(fname)(Vector{$(T[1])}, Vector{$(T[2])})")
    val = Dict()
    # Iterate over all functions
    for fstr in fnames
        f = eval(parse(fstr))
        X = convert(Vector{T[1]}, randn(N)) # function arguments
        Y = convert(Vector{T[2]}, randn(N)) # function arguments
        f(X, Y) # force compilation
        time = 0
        for i in 1:10
            time += @elapsed f(X, Y)
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
    write(file, "\n$(fname)(X::Vector{$(T[1])}, Y::Vector{$(T[2])}) = $(fbest)(X, Y)\n")
    println("BENCHMARK: $(fname)(Vector{$(T[1])}, Vector{$(T[2])}) mapped to $(fbest)()\n")
end

function benchmarkThreeArgFunction(fname, fnames,
                                   T::Tuple{DataType, DataType, DataType}, file::IOStream, N::Integer)
    println("TESTING: $(fname)(Vector{$(T[1])}, Vector{$(T[2])}, Vector{$(T[3])})")
    val = Dict()
    # Iterate over all functions
    for fstr in fnames
        f = eval(parse(fstr))
        X = convert(Vector{T[1]}, randn(N)) # function arguments
        Y = convert(Vector{T[2]}, randn(N)) # function arguments
        Z = convert(Vector{T[3]}, randn(N)) # function arguments
        f(X, Y, Z) # force compilation
        time = 0
        for i in 1:10
            time += @elapsed f(X, Y, Z)
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
    write(file, "\n$(fname)(X::Vector{$(T[1])}, Y::Vector{$(T[2])}, Z::Vector{$(T[3])}) = $(fbest)(X, Y, Z)\n")
    println("BENCHMARK: $(fname)(Vector{$(T[1])}, Vector{$(T[2])}, Vector{$(T[3])}) mapped to $(fbest)()\n")
end
