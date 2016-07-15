##===----------------------------------------------------------------------===##
##                                     BUILD.JL                               ##
##                                                                            ##
##===----------------------------------------------------------------------===##
##                                                                            ##
##   This file builds Vectorize.jl during package installation and runs the   ##
##           benchmarking suite to determine the best implementations         ##
##                                                                            ##
##===----------------------------------------------------------------------===##

# Cross-version compatibility
if VERSION < v"0.5.0-dev" # Julia v0.4
    readstring(cmd) = readall(cmd)
end


"""
This function selects a single implementation from `fnames` and associates it
with `fname`. It benchmarks every function in `fnames` against the single
type `Vector{T}` of length `N` and writes the resulting association into the 
IOstream `file`.  

    fname: name to be associated with Vectorize.(fname)
    fnames: a list of strings "Vectorize.VML.sin" to be benchmarked
    T: the type of the Vector{T} to pass to the function
    file: the IOStream to write the final string onto
    N: the length of the vector to benchmark over.
"""
function benchmarkSingleArgFunction(fname, fnames,
                                    T::DataType, file::IOStream, N::Integer)
    
    # dictionary to store elpased values
    val = Dict()
    println("TESTING: $(fname)(Vector{$T})")
    
    # Iterate over all functions
    for fstr in fnames
        f = eval(parse(fstr)) # convert string to function
        X = convert(Vector{T}, randn(N)) # function arguments
        f(X) # force compilation
        time = 0
        for i in 1:10 # benchmark ten times
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

    # write chosen file into IOStream
    write(file, "\n$(fname)(X::Vector{$T}) = $(fbest)(X)\n")
    println("BENCHMARK: $(fname)(Vector{$T}) mapped to $(fbest)()\n")
end


"""
This function selects a single implementation from `fnames` and associates it
with `fname`. It benchmarks every function in `fnames` against two `Vector{T}`'s
of length `N` and writes the resulting association into the 
IOstream `file`. 

    fname: name to be associated with Vectorize.(fname)
    fnames: a list of strings "Vectorize.VML.sin" to be benchmarked
    T: tuple of types of Vector{T} to pass to the function
    file: the IOStream to write the final string onto
    N: the length of the vector to benchmark over.
"""
function benchmarkTwoArgFunction(fname, fnames,
                                 T::Tuple{DataType, DataType}, file::IOStream, N::Integer)
    
    # dictionary of elapsed times for each implementation
    val = Dict()
    println("TESTING: $(fname)(Vector{$(T[1])}, Vector{$(T[2])})")
    
    # Iterate over all functions
    for fstr in fnames
        f = eval(parse(fstr)) # convert string to function
        X = convert(Vector{T[1]}, randn(N)) # function arguments
        Y = convert(Vector{T[2]}, randn(N)) # function arguments
        f(X, Y) # force compilation
        time = 0
        for i in 1:10 # benchmark ten times
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

    # write result into IOStream
    write(file, "\n$(fname)(X::Vector{$(T[1])}, Y::Vector{$(T[2])}) = $(fbest)(X, Y)\n")
    println("BENCHMARK: $(fname)(Vector{$(T[1])}, Vector{$(T[2])}) mapped to $(fbest)()\n")
end


"""
This function selects a single implementation from `fnames` and associates it
with `fname`. It benchmarks every function in `fnames` against three `Vector{T}`'s
of length `N` and writes the resulting association into the 
IOstream `file`. 

    fname: name to be associated with Vectorize.(fname)
    fnames: a list of strings "Vectorize.VML.sin" to be benchmarked
    T: tuple of types of Vector{T} to pass to the function
    file: the IOStream to write the final string onto
    N: the length of the vector to benchmark over.
"""
function benchmarkThreeArgFunction(fname, fnames,
                                   T::Tuple{DataType, DataType, DataType}, file::IOStream, N::Integer)
    
    # dictionary to store elapsed values
    val = Dict()
    println("TESTING: $(fname)(Vector{$(T[1])}, Vector{$(T[2])}, Vector{$(T[3])})")
    
    # Iterate over all functions
    for fstr in fnames
        f = eval(parse(fstr)) # convert string to function
        X = convert(Vector{T[1]}, randn(N)) # function arguments
        Y = convert(Vector{T[2]}, randn(N)) # function arguments
        Z = convert(Vector{T[3]}, randn(N)) # function arguments
        f(X, Y, Z) # force compilation
        time = 0
        for i in 1:10 # benchmark 10 times
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

        # write result into IOStream
    write(file, "\n$(fname)(X::Vector{$(T[1])}, Y::Vector{$(T[2])}, Z::Vector{$(T[3])}) = $(fbest)(X, Y, Z)\n")
    println("BENCHMARK: $(fname)(Vector{$(T[1])}, Vector{$(T[2])}, Vector{$(T[3])}) mapped to $(fbest)()\n")
end

"""
`trycmd(cmd::Cmd, msg::ASCIIString="", err::ASCIIString="")::ASCIIString`
This function attemps to run the shell command specified by `cmd` using `run`.
If `cmd` returns successfully, it will print `msg` using info().
If `run(cmd)` throws an exception (the shell command returns non-zero),
then the function throws an error and prints the `err` argument.

Note: This function does not return the value of the command to the caller. However,
prints to STD_OUT by the `run` command will print automatically from the shell process.
"""
function trycmd(cmd::Cmd; msg::ASCIIString="", err::ASCIIString="")
    try
        run(cmd)
        if msg == "" return else info(msg) end
    catch
        if err != ""
            error(err)
        end
    end
end

"""
`trycmd_read(cmd::Cmd, msg::ASCIIString="", err::ASCIIString="")::ASCIIString`
This function attemps to run the shell command specified by `cmd` using `readall`.
If `cmd` returns successfully, it will return its result to the caller and print `msg`.
If `readall(cmd)`/`readstring(cmd)` throws an exception (the shell command returns non-zero),
then the function throws an error and prints the `err` argument.
"""
function trycmd_read(cmd::Cmd; msg::ASCIIString="", err::ASCIIString="")
    try
        result = readstring(cmd) # Julia v0.5 and above
        if msg == "" return result else info(msg) end
        return result
    catch
        if err != ""
            error(err)
        end
    end
end

"""
`prompt_yn(prompt::ASCIIString)::Bool`

Prompts the user for a y or n response (y/n). Continually prompts
until user enters a valid response. Prompt string should be provided without
colon and whitespace.
"""
function prompt_yn(prompt::ASCIIString)
    print(prompt, " [y/n]:  ")
    input = chomp(readline())
    while input != "y" && input != "n"
        print("You did not enter y or n. Please enter a valid response: [y/n]  ")
        input = chomp(readline())
    end

    return (input == "y") ? true : false
end


##===----------------------------------------------------------------------===##
##                                     RUN-TIME                               ##
##===----------------------------------------------------------------------===##

# Clean up directory and build status
include("clean.jl")

# compute package directory location
currdir = @__FILE__
pkgdir = currdir[1:end-13]
function_location = pkgdir*"src/Functions.jl"

# detect architecture
if Sys.ARCH != :x86_64
    error("Vectorize.jl currently only supports x86_64; your detected architecture is $(Sys.ARCH)")
end

# Locate or download Yeppp! 
if isfile("$(pkgdir)deps/downloads/yeppp-1.0.0.tar.bz2") || (Libdl.find_library(["libyeppp"]) != "")
else
    info("====== Installing Yeppp! into local directory ======")
    trycmd(`mkdir $(pkgdir)deps/downloads`)
    trycmd(`mkdir $(pkgdir)deps/src`)
    trycmd(`mkdir $(pkgdir)deps/src/yeppp`)
    yeppploc = "http://bitbucket.org/MDukhan/yeppp/downloads/yeppp-1.0.0.tar.bz2"
    @osx? run(pipeline(`curl -L $(yeppploc)`, stdout="$(pkgdir)deps/downloads/yeppp-1.0.0.tar.bz2")) : trycmd(`wget -P downloads $(yeppploc)`, err="Unable to download Yeppp!")
    trycmd(`tar -xjvf $(pkgdir)deps/downloads/yeppp-1.0.0.tar.bz2 -C $(pkgdir)deps/src/yeppp --strip-components=1`)
    info("====== Successfully installed Yeppp! ======")
end

# Have to import vectorize after Yeppp is downloaded
push!(LOAD_PATH, "$(pkgdir)src/")
using Vectorize

# available functions - Yeppp, VML, Accelerate register against this dictionary
functions = Vectorize.functions 

# Run the benchmarking process
N = 1_000 # length of each vector
file = open("$(pkgdir)src/Functions.jl", "a")
for ((f, T), options) in functions
    if length(T) == 1
        benchmarkSingleArgFunction(f, options, T[1], file, 1_000)
    elseif length(T) == 2
        benchmarkTwoArgFunction(f, options, T, file, 1_000)
    elseif length(T) == 3
        benchmarkThreeArgFunction(f, options, T, file, 1_000)
    end
end
close(file)
