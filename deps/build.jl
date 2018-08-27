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
function_location = joinpath(pkgdir*"src", "Functions.jl")

# detect architecture
if Sys.ARCH != :x86_64
    error("Vectorize.jl currently only supports x86_64; your detected architecture is $(Sys.ARCH)")
    exit(1)
end

@static Sys.iswindows() ? include("windows.jl") : include("unix.jl")

# Have to import vectorize after Yeppp is downloaded
push!(LOAD_PATH, "$(pkgdir)src")

# import vectorize in order to benchmark
using Vectorize

# available functions - Yeppp, VML, Accelerate register against this dictionary
functions = Vectorize.functions

# Run the benchmarking process
N = 1_000 # length of each vector
file = open(joinpath("$(pkgdir)src", "Functions.jl"), "a")

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

Base.compilecache(Base.PkgId(Base.UUID("922354f6-6876-5285-8954-7bb8005415d2"), "Vectorize"))
