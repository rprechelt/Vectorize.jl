## TODO

This file lists all the currently-known TODO's for Vectorize.jl that can be completed immediately; each section heading can be explained and developed below - this includes adding information about how the feature should be implemented. 

* Check for presence of Yeppp!, Accelerate, and VML. Pass this information on to `make` to allow compile time setup of function mapping
* Should we offer to download and install `CMake` in the `deps` directory if not available?
* Setup Travis testing for OS X (Not Linux/Windows ready)
* Test build process on Linux
* Build Accelerate functions manually to allow for specific function calls. (Helpful during benchmarking). This could be `@accelerate sum(X)` or `Vectorize.Accelerate.sum(X)`
