# NOTE: Unlike all other CMakeLists.txt in the apps/ folder, this
# is deliberately intended to be standalone (not included from the toplevel)
# in order to show the minimum scaffolding necessary to use ahead-of-time
# Generators in a simple app.
#
# To use:
# $ mkdir build
# $ cd build
# $ cmake -DHalide_DIR=<path/to/HalideConfig.cmake> -DCMAKE_BUILD_TYPE=Release ..
# $ cmake --build . -j 4
# $ ./bin/wavelet ../../images/gray.png .

project(wavelet)
cmake_minimum_required(VERSION 3.14)

# Set up language settings
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS NO)

# Find Halide
find_package(Halide CONFIG REQUIRED)

# Define the wavelet app
add_executable(wavelet wavelet.cpp)
target_link_libraries(wavelet PRIVATE Halide::Halide Halide::ImageIO)

# Define a halide library for each generator we have, and link each one into wavelet
set(GEN_SOURCES
    daubechies_x_generator.cpp
    inverse_daubechies_x_generator.cpp
    haar_x_generator.cpp
    inverse_haar_x_generator.cpp
    )

foreach (GEN IN LISTS GEN_SOURCES)
    string(REPLACE "_generator.cpp" "" BASE_NAME "${GEN}")
    add_executable("${BASE_NAME}.generator" "${GEN}" daubechies_constants.h)
    target_link_libraries("${BASE_NAME}.generator" PRIVATE Halide::Generator)

    add_halide_library("${BASE_NAME}" FROM "${BASE_NAME}.generator")
    target_link_libraries(wavelet PRIVATE "${BASE_NAME}")
endforeach ()