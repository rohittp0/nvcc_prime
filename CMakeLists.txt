cmake_minimum_required(VERSION 3.20)
project (untitled CUDA)

set(CMAKE_CUDA_STANDARD 23)

add_compile_options(-G)

add_executable(untitled main.cu)

set_target_properties(untitled PROPERTIES
                      CUDA_SEPARABLE_COMPILATION ON)
