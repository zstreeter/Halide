add_executable(build_halide_h build_halide_h.cpp)
add_executable(binary2cpp binary2cpp.cpp)

target_compile_options(build_halide_h PRIVATE $<$<CXX_COMPILER_ID:MSVC>:/wd4996>)
target_compile_options(binary2cpp PRIVATE $<$<CXX_COMPILER_ID:MSVC>:/wd4996>)