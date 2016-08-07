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
run(`rm -rf $(pkgdir)src/Functions.jl`)
run(`touch $(pkgdir)src/Functions.jl`)
