add_executable(build_halide_h build_halide_h.cpp)
target_compile_options(build_halide_h PRIVATE $<$<CXX_COMPILER_ID:MSVC>:/wd4996>)

add_executable(binary2cpp binary2cpp.cpp)
target_compile_options(binary2cpp PRIVATE $<$<CXX_COMPILER_ID:MSVC>:/wd4996>)

# TODO: export this.
add_library(Halide_run_gen_main OBJECT RunGenMain.cpp)
add_library(Halide::RunGenMain ALIAS Halide_run_gen_main)
target_link_libraries(Halide_run_gen_main PUBLIC Halide::Halide Halide::ImageIO)

# TODO: export this.
add_library(Halide_generator INTERFACE)
add_library(Halide::Generator ALIAS Halide_generator)
target_sources(Halide_generator INTERFACE GenGen.cpp)
target_link_libraries(Halide_generator INTERFACE Halide::Halide Threads::Threads ${CMAKE_DL_LIBS})
