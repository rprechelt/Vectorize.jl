.. Vectorize.jl documentation master file, created by
   sphinx-quickstart on Thu Mar 24 17:17:48 2016.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Vectorize.jl
========================================

Vectorize.jl provides a unified interface to the high-performance vectorized functions provided by `Apple's Accelerate <https://developer.apple.com/reference/accelerate>`_ framework (OS X only), `Intel's VML <https://software.intel.com/en-us/node/521751>`_ and `Yeppp! <http://www.yeppp.info/>`_ These can be accessed using the ``Vectorize.LibraryName.Function()`` syntax i.e.::

    Vectorize.Accelerate.exp(X)
    Vectorize.VML.erf(X)
    Vectorize.Yeppp.log(x)

Furthermore, a complete benchmarking suite is run during package installation that automatically selects the fastest implementation *for your architecture* on a function-by-function basis; this means that calls to::

    Vectorize.sin(X)

will be transparently mapped to the Accelerate, VML or Yeppp! implementation based upon the performance of these frameworks on *your particular machine* and the type of ``X``. This mapping happens during package installation and so occurs no runtime overhead (expect to wait a few extra seconds than normal to install this package as the benchmarking suite needs to be run).

Vectorize.jl provides a ``@vectorize`` macro that automatically converts a call to Julia's standard implementation into the fastest vectorized equivalent available on your machine, i.e.::

    cos(X)    # Standard Julia implementation
    @vectorize cos(X)    # Converted to Yeppp, VML, or Accelerate at compile time

This macro provides an easy method for code to be quickly converted to use Vectorize.jl with little additional effort.

Vectorize.jl also provides a ``@replacebase`` macro that automatically overloads base broadcasting calls into the fastest vectorized equivalent available.

   X.^(-1/3)  # Standard Julia broadcast implementation
   Z .= cis.(X)   # Standard Julia in-place broadcast implementation
   @replacebase cis # Overloads both in-place and out-of-place broadcast calls to cis, provided cis is not fused in the broadcast
   @replacebase ^
   X.^(-1/3)  # This call now uses Vectorize.pow(X, -1/3)
   Z .= cis.(X)   # This call now uses Vectorize.cis!

These functions can provide orders of magnitude higher-performance than the standard functions in Julia; over 10-fold improvements are common for functions throughout the three libraries. Since these functions are designed to operate on moderate-to-large sized arrays, they tend to be less performant that standard Julia functions for arrays of length less than 10 elements; in that case, it is best not to use Vectorize.jl.

Vectorize.jl will transparently select from the different frameworks that are available on your machine; you are not required to have any particular framework installed (although having all three tends to provide the best performance as different frameworks have different strengths). For users not running OS X, we strongly recommend installing Intel's VML (free for open-source projects under the community license - other licenses are available) as the only other library available for non-OSX systems is Yeppp, and Yeppp only provides a very small collection of functions.

This package currently supports over 40 functions over ``Float32``, ``Float64``, ``Complex{Float32}``, and ``Complex{Float64}``; ``Vectorize.Yeppp`` also provides access to various Yeppp functions over ``UInt8``, ``UInt16``, ``UInt32``, ``UInt64``, ``Int8``, ``Int16``, ``Int32``, and ``Int64`` (although these are not benchmarked as neither Accelerate or VML provide equivalent functions). Every function by VML is currently supported, alongside the vast majority of optimized Yeppp functions and an equivalent portion of Accelerate.

.. toctree::
   :maxdepth: 2
   :hidden:

   installation
   functions
   devdocs



..
   Indices and tables
   ==================

   * :ref:`genindex`
   * :ref:`modindex`
   * :ref:`search`
