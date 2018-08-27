##===----------------------------------------------------------------------===##
##                                     CLEAN.JL                               ##
##                                                                            ##
##===----------------------------------------------------------------------===##
##                                                                            ##
##   This file cleans the Vectorize directory to provide a fresh slate        ##
##   before building or as a debugging step.                                  ##
##                                                                            ##
##===----------------------------------------------------------------------===##

# erase old function definitions to prevent issues
currdir = @__FILE__
pkgdir = currdir[1:end-13]

# Clean up directory status
@static if Sys.iswindows()
    run(`cmd /C del $(pkgdir)src\\Functions.jl`)
    run(`cmd /C copy NUL Functions.jl`)
    run(`cmd /C move Functions.jl $(pkgdir)src`)
else
    run(`rm -rf $(pkgdir)src/Functions.jl`)
    run(`touch $(pkgdir)src/Functions.jl`)
end
