
Installation
============

To install the latest version of Vectorize from ``master``, run::

    Pkg.clone("http://github.com/rprechelt/Vectorize.jl")

from a Julia REPL. 

Once the package has finished cloning, run::

    Pkg.build("Vectorize")

This will print the build status to the terminal; you will be notified if the build completes successfully. This will attempt to determine which frameworks are available on your machine and incorporate those frameworks into the benchmarking process; it will attempt to locate Yeppp and VML in your ``PATH`` using ``Libdl``. If it is unable to locate Yeppp!, it will download a local copy and store it in the Vectorize.jl package directory (no changes are made to your broader system by installing Vectorize.jl). The build process will report what frameworks it is able to find - if it unable to find your system-installed version of Yeppp! or MKL, please ensure that they are both in your system ``PATH``. 

If the build fails, or it is unable to find system-installed packages correctly, please create an issue on Github and copy the output of ``Pkg.build()`` into the issue. This will help in debugging the build failures. 
