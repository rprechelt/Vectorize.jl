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
@static if is_windows()
    run(`del $(pkgdir)src\\Functions.jl`)
    run(`copy NUL Functions.jl`)
    run(`move Functions.jl $(pkdir)src`)
else
    run(`rm -rf $(pkgdir)src/Functions.jl`)
    run(`touch $(pkgdir)src/Functions.jl`)
end
