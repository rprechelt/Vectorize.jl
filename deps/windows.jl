include("helper.jl")

# Locate and/or download Yeppp! 
if isfile("$(pkgdir)deps\\downloads\\yeppp-1.0.0.tar.bz2") || (Libdl.find_library(["libyeppp"]) != "")
else
    info("====== Installing Yeppp! into local directory ======")
    trycmd(`cmd /C mkdir $(pkgdir)deps\\downloads`)
    trycmd(`cmd /C mkdir $(pkgdir)deps\\src`)
    trycmd(`cmd /C mkdir $(pkgdir)deps\\src\\yeppp`)
    trycmd(`wget64 -P downloads http://bitbucket.org/MDukhan/yeppp/downloads/yeppp-1.0.0.tar.bz2`, err="Unable to download Yeppp!")
    trycmd(`tar -xjvf $(pkgdir)deps\\downloads\\yeppp-1.0.0.tar.bz2 -C $(pkgdir)deps\\src\\yeppp --strip-components=1`)
    info("====== Successfully installed Yeppp! ======")
end
