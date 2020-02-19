# NOTE: Unlike all other CMakeLists.txt in the apps/ folder, this
# is deliberately intended to be standalone (not included from the toplevel)
# in order to show the minimum scaffolding necessary to use ahead-of-time
# Generators in a simple app.
#
# To use:
# $ mkdir build
# $ cd build
# $ cmake -DCMAKE_PREFIX_PATH=<path/to/Halide> ..
# $ cmake --build . -j 4
# $ ./bin/wavelet ../../images/gray.png .

project(wavelet)
cmake_minimum_required(VERSION 3.14)

enable_testing()

# Set up language settings
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS NO)

# Find Halide
find_package(Halide REQUIRED COMPONENTS PNG)

# Define the wavelet app
add_executable(wavelet wavelet.cpp)
target_link_libraries(wavelet PRIVATE Halide::Halide Halide::ImageIO)

# Define a generator executable containing each generator we have
add_executable(wavelet.generator
               daubechies_x_generator.cpp
               inverse_daubechies_x_generator.cpp
               haar_x_generator.cpp
               inverse_haar_x_generator.cpp)
target_link_libraries(wavelet.generator PRIVATE Halide::Generator)

# Define a halide library for each filter we have, and link each one into wavelet
add_halide_library(daubechies_x FROM wavelet.generator)
add_halide_library(inverse_daubechies_x FROM wavelet.generator)
add_halide_library(haar_x FROM wavelet.generator)
add_halide_library(inverse_haar_x FROM wavelet.generator)

target_link_libraries(wavelet PRIVATE daubechies_x inverse_daubechies_x haar_x inverse_haar_x)

# Test that the app actually works!
configure_file(gray.png gray.png COPYONLY)
add_test(NAME run_wavelet
         COMMAND wavelet gray.png .)