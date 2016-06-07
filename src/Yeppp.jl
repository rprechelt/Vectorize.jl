#__precompile__()
module Yeppp

## Find Yeppp library
currdir = @__FILE__
bindir = currdir[1:end-4]*"deps/src/yeppp/binaries/"
if OS_NAME == :Darwin
    @eval const libyeppp = bindir*"macosx/x86_64/libyeppp.dylib"
elseif OS_NAME == :Linux
    @eval const libyeppp = bindir*"linux/x86_64/libyeppp.so"
elseif OS_NAME == :Windows
    @eval const libyeppp = bindir*"windows/amd64/yeppp.dll"
end


end # End Module
