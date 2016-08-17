##===----------------------------------------------------------------------===##
##                                     BUILD.JL                               ##
##                                                                            ##
##===----------------------------------------------------------------------===##
##                                                                            ##
##   This file builds Vectorize.jl during package installation and runs the   ##
##           benchmarking suite to determine the best implementations         ##
##                                                                            ##
##===----------------------------------------------------------------------===##

# Clean up directory and build status
include("clean.jl")

# compute package directory location
currdir = @__FILE__
pkgdir = currdir[1:end-13]
@static if is_windows()
    function_location = pkgdir*"src\Functions.jl"
else
    function_location = pkgdir*"src/Functions.jl"
end

# detect architecture
if Sys.ARCH != :x86_64
    error("Vectorize.jl currently only supports x86_64; your detected architecture is $(Sys.ARCH)")
    exit(1)
end

@static if is_windows()
    include("windows.jl")
else
    include("unix.jl")
end

# Have to import vectorize after Yeppp is downloaded
@static if is_windows()
    push!(LOAD_PATH, parsedir("$(pkgdir)src\\"))
else
    push!(LOAD_PATH, parsedir("$(pkgdir)src/"))
end

# import vectorize in order to benchmark
using Vectorize

# available functions - Yeppp, VML, Accelerate register against this dictionary
functions = Vectorize.functions 

# Run the benchmarking process
N = 1_000 # length of each vector
@static if is_windows()
    file = open("$(pkgdir)src\Functions.jl", "a")
else
    file = open("$(pkgdir)src/Functions.jl", "a")
end

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

Base.compilecache("Vectorize")
