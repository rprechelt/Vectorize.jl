include("helper.jl")

# Locate and/or download Yeppp!
if isfile("$(pkgdir)deps\\downloads\\yeppp-1.0.0.tar.bz2") || (Libdl.find_library(["libyeppp"]) != "")
else
    @info("====== Installing Yeppp! into local directory ======")
    trycmd(`cmd /C mkdir $(pkgdir)deps\\downloads`, err="Unable to create Vectorize/deps/downloads")
    trycmd(`cmd /C mkdir $(pkgdir)deps\\src`, err="Unable to create Vectorize/src/")
    trycmd(`wget64 -P downloads http://bitbucket.org/MDukhan/yeppp/downloads/yeppp-1.0.0.tar.bz2`, err="Unable to download Yeppp!")
    trycmd(`7z x $(pkgdir)deps\\downloads\\yeppp-1.0.0.tar.bz2 -o$(pkgdir)deps\\downloads\\`, err="Unable to decompress tar archive")
    trycmd(`7z x $(pkgdir)deps\\downloads\\yeppp-1.0.0.tar -o$(pkgdir)deps\\src\\`, err="Unable to expand tar archive")
    trycmd(`cmd /C move $(pkgdir)deps\\src\\yeppp-1.0.0 $(pkgdir)deps\\src\\yeppp`, err="Unable to rename Yeppp folder")
    @info("====== Successfully installed Yeppp! ======")
end
