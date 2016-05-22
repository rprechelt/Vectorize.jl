cmake_minimum_required(VERSION 3.4)

## VECTORIZE ##
project(Vectorize)
add_subdirectory(Vectorize)
if (DEFINED ENV{VEC_JULIA_DIR})
   set(VEC_JULIA_DIR $ENV{VEC_JULIA_DIR})
else()
   set(VEC_JULIA_DIR ".julia")
endif()


## Since we are building against the Julia-installed LLVM, we must manually locate LLVM in
## case it isn't in the users PATH (likely). 
set(LLVM_DIR "$ENV{HOME}/${VEC_JULIA_DIR}/deps/build/llvm-3.7.1/build_Release")
set(CMAKE_MODULE_PATH "$ENV{HOME}/${VEC_JULIA_DIR}/deps/srccache/llvm-3.7.1/cmake/modules")

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

## Include Julia LLVM source directories
include_directories("$ENV{HOME}/${VEC_JULIA_DIR}/deps/build/llvm-3.7.1/build_Release/include")
include_directories("$ENV{HOME}/${VEC_JULIA_DIR}/deps/srccache/llvm-3.7.1/include")

## Print included directories to log for debug purposes
get_property(dirs DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES)
foreach(dir ${dirs})
  message(STATUS "Including ${dir}")
endforeach()

## A known issue in LLVM 3.7 requires the setting of the below variables - they
## don't affect compilation at all - they just prevent sytnax errors in building
## a pass out of source - see http://lists.llvm.org/pipermail/llvm-dev/2015-January/081019.html
set(LLVM_RUNTIME_OUTPUT_INTDIR ${CMAKE_BINARY_DIR}/${CMAKE_CFG_INTDIR}/bin)
set(LLVM_LIBRARY_OUTPUT_INTDIR ${CMAKE_BINARY_DIR}/${CMAKE_CFG_INTDIR}/lib)
set(LLVM_ENABLE_PLUGINS ON)
set(LLVM_PLUGIN_EXT “so”)

## Configure target as LLVM module and bring in AddLLVM.cmake
include(HandleLLVMOptions) 
include(AddLLVM)
add_llvm_loadable_module(Vectorize Vectorize/Vectorize.cpp)

