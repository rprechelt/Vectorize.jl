function benchmarkSingleArgFunction(fname::Symbol, fnames::Vector{Function},
                                    types::Vector{DataType}, filename, N::Integer)

    # open file for appending
    file = open(filename, "a")
    
    # For every argument type
    for T in types
        val = Dict()

        # Iterate over all functions
        for f in fnames
            X = convert(Vector{T}, randn(N)) # function arguments
            f(X) # force compilation
            time = @elapsed f(X)
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

        write(file, "\n$(fname)(X::Vector{$T}) = $(fbest)(X)\n")
    end

    close(file)
    
end


function benchmarkTwoArgFunction(fname::Symbol, fnames::Vector{Function},
                                 types::Vector{DataType}, filename, N::Integer)

    # open file for appending
    file = open(filename, "a")
    
    # For every argument type
    for T in types
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

        write(file, "\n$(fname)(X::Vector{$T}, Y::Vector{$T}) = $(fbest)(X, Y)\n")
    end

    close(file)
    
end

benchmarkSingleArgFunction(:cos,  [cos, sin], [Float32, Float64], "test", 1000)
benchmarkTwoArgFunction(:max,  [min, max], [Float32, Float64], "test", 1000)
