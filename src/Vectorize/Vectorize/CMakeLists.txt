#add_library(VectorizePass MODULE VectorizePass.cpp)
#add_llvm_loadable_module(VectorizePass VectorizePass.cpp )
SET(CMAKE_CXX_FLAGS "-std=c++11 -Wall -fno-rtti -D__STDC_CONSTANT_MACROS -D__STDC_LIMIT_MACROS -fPIC")
