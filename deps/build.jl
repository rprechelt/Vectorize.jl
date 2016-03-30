if Sys.ARCH != :x86_64
    error("Package is not supported on $(Sys.ARCH). Vectorize.jl currently only supports x86_64.")
end

@osx_only begin
    if Pkg.installed("AppleAccelerate") != ""
        info("AppleAccelerate installation found.")
    else
        info("Installing AppleAccelerate.jl")
        Pkg.add("AppleAccelerate")
        info("AppleAccelerate.jl installed")
    end
end

"""
Prompts the user for a y or n response (y/n). Continually prompts
until user enters a valid response. Prompt string should be provided without
colon and whitespace.

Returns: Bool ('y' -> true, 'n' -> false)
"""
function prompt_yn(prompt::ASCIIString)
    print(prompt, " [y/n]:  ")
    input = chomp(readline())
    while input != "y" && input != "n"
        print("You did not enter y or n. Please enter a valid response: [y/n]  ")
        input = chomp(readline())
    end

    return (input == "y") ? true : false
end


"""
`addrequirement(requirement::ASCIIString)`

Appends a string and timestamp to Vectorize.jl/REQUIRE.

*Returns:* **Bool** success
"""
function addrequirement(requirement::ASCIIString)

    rfile = open("../REQUIRE",  "a");
    write(rfile, "\n## Added by build.jl on $(Libc.strftime(time())) ##\n");
    nbytes = write(rfile, "$(requirement)\n");
    close(rfile);

    return (nbytes == (length(requirement)+1)) ? true : false
end

"""
`addpackage(name::ASCIIString)`

Prompts user to install a package `name` and append it to the REQUIRE file. Also imports \
module into current scope.

*Returns:* **Bool** success (true/false)
"""
function addpackage(name::ASCIIString)

    if prompt_yn("Would you like to install $(name).jl?")
        if Pkg.installed(name) != ""
            info("Installing $(name).jl...")
            @eval Pkg.add($(name))
            if !addrequirement(name)
                warn("$(name).jl may not have successfully been added to REQUIRE")
            end
            info("$(name).jl installed.")

        else
            info("$(name).jl already installed.")
        end
    else
        info("$(name) will not be installed.")
    end

    return symbol(name)
end


### RUN ###
addpackage("Yeppp")
addpackage("VML")
