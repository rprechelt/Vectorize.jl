include("helper.jl")

# Locate and/or download Yeppp!
if isfile("$(pkgdir)deps/downloads/yeppp-1.0.0.tar.bz2") || (Libdl.find_library(["libyeppp"]) != "")
else
    @info("====== Installing Yeppp! into local directory ======")
    trycmd(`mkdir $(pkgdir)deps/downloads`, err="Unable to create Vectorize/deps/downloads")
    trycmd(`mkdir $(pkgdir)deps/src`, err="Unable to create Vectorize/src/")
    trycmd(`mkdir $(pkgdir)deps/src/yeppp`, err="Unable to create Vectorize/src/yeppp")
    yeppploc = "http://bitbucket.org/MDukhan/yeppp/downloads/yeppp-1.0.0.tar.bz2"
    @static if Sys.isapple()
        run(pipeline(`curl -L $(yeppploc)`, stdout="$(pkgdir)deps/downloads/yeppp-1.0.0.tar.bz2"))
    else
        trycmd(`wget -P downloads $(yeppploc)`, err="Unable to download Yeppp!")
    end
    trycmd(`tar -xjvf $(pkgdir)deps/downloads/yeppp-1.0.0.tar.bz2 -C $(pkgdir)deps/src/yeppp --strip-components=1`)
    @info("====== Successfully installed Yeppp! ======")
end
