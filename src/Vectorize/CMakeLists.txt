cmake_minimum_required(VERSION 3.4)

## VECTORIZE ##
project(Vectorize)
add_subdirectory(Vectorize)

## Since we are building against the Julia-installed LLVM, we must manually locate LLVM in
## case it isn't in the users PATH (likely). 
set(LLVM_DIR "/Users/rprechelt/julia5/deps/build/llvm-3.7.1/build_Release")
#set(LLVM_TOOLS_BINARY_DIR "/Users/rprechelt/julia5/deps/build/llvm-3.7.1/build_Release/Release/bin")
#set(LLVM_CMAKE_DIR "/Users/rprechelt/julia5/deps/build/llvm-3.7.1/build_Release/cmake")
set(CMAKE_PREFX_PATH "/Users/rprechelt/julia5/deps/srccache/llvm-3.7.1/cmake")
set(CMAKE_MODULE_PATH "/Users/rprechelt/julia5/deps/srccache/llvm-3.7.1/cmake/modules")
#set(CMAKE_BINARY_DIR "/Users/rprechelt/julia5/deps/build/llvm-3.7.1/build_Release")
#set(CMAKE_CFG_INTDIR "Release")
#list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

include_directories(${LLVM_INCLUDE_DIRS})
include_directories("/Users/rprechelt/julia5/deps/build/llvm-3.7.1/build_Release/include")
include_directories("/Users/rprechelt/julia5/deps/srccache/llvm-3.7.1/include")
link_directories("/Users/rprechelt/julia5/deps/build/llvm-3.7.1/build_Release/Release/lib")
link_directories("/Users/rprechelt/julia5/deps/build/llvm-3.7.1/build_Release/Release/bin")
link_directories("/Users/rprechelt/julia5/deps/build/llvm-3.7.1/build_Release/lib")
link_directories(${LLVM_LINK_DIRS})
add_definitions(${LLVM_DEFINITIONS})

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



get_property(dirs DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES)
foreach(dir ${dirs})
  message(STATUS "dir='${dir}'")
endforeach()
