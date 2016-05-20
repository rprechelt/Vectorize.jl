cmake_minimum_required(VERSION 3.4)
project(VectorizePass)

set(LLVM_DIR "/Users/rprechelt/julia5/deps/build/llvm-3.7.1/build_Release")
set(LLVM_INCLUDE_DIRS "/Users/rprechelt/julia5/deps/srccache/llvm-3.7.1/include")

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

include_directories(${LLVM_INCLUDE_DIRS})
include_directories("/Users/rprechelt/julia5/deps/build/llvm-3.7.1/build_Release/include")
add_definitions(${LLVM_DEFINITIONS})

add_subdirectory(VectorizePass)

get_property(dirs DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES)
foreach(dir ${dirs})
  message(STATUS "dir='${dir}'")
endforeach()
