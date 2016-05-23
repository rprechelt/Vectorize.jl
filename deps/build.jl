############################## VECTORIZE.jl #############################
##                                                                     ##
## This script performs the build and install process for Vectorize.jl ##
##                                                                     ##
############################### #########################################

"""
`trycmd(cmd::Cmd, msg::ASCIIString="", err::ASCIIString="")` :: ASCIIString
This function attemps to run the shell command specified by `cmd` using `run`.
If `cmd` returns successfully, it will print `msg` using info().
If `readall(cmd)` throws an exception (the shell command returns non-zero),
then the function throws an error and prints the `err` argument.

Note: This function does not return the value of the command to the caller. However,
prints to STD_OUT by the `run` command will print automatically from the shell process.
"""
function trycmd(cmd::Cmd; msg::ASCIIString="", err::ASCIIString="")
    try
        run(cmd)
        info(msg)
    catch
        error(err)
    end
end

"""
`trycmd_read(cmd::Cmd, msg::ASCIIString="", err::ASCIIString="")` :: ASCIIString
This function attemps to run the shell command specified by `cmd` using `readall`.
If `cmd` returns successfully, it will return its result to the caller and print `msg`.
If `readall(cmd)` throws an exception (the shell command returns non-zero),
then the function throws an error and prints the `err` argument.
"""
function trycmd_read(cmd::Cmd; msg::ASCIIString="", err::ASCIIString="")
    try
        result = readall(cmd)
        if msg == "" return result else info(msg) end
        return result
    catch
        error(err)
    end
end


#### DEPENDENCIES ####
## We first check whether all dependencies are available on the system
deps = ["cmake", "julia"]
for dep in deps
    err = ("$dep is not installed. Please install $dep, ensure that it is in your"*
           "PATH,  and run Pkg.build(\"Vectorize\") again.")
    location = trycmd_read(`command -v $dep`, err=err)[1:end-1]
    info("Using $dep found at $location.")
end

#### MAKE ####
## We then run `make clean` before starting a fresh build of Vectorize.jl
currdir = @__FILE__
makedir = currdir[1:end-13]*"src/Vectorize/"
msg = "Vectorize.jl was built successfully!"
err = "Vectorize.jl failed to build correctly; please create an issue on"*
"GitHub and copy the output of the build process above; we will endeavour"*
"to fix your issue as soon as possible"
info("====== Attempting to build Vectorize.jl ======")
trycmd(`make -C $makedir clean`)
trycmd(`make -C $makedir`, msg=msg, err=msg) ## BUILD COMMAND
