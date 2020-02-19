##
# Test apps from the perspective of a consuming project. Each of these
##

set(HALIDE_DIR "${CMAKE_CURRENT_BINARY_DIR}/_Halide_install")

# TODO: if we can support CMake 3.15+, we can use ${CMAKE_COMMAND} --install ...
add_test(NAME create_halide_distrib
         COMMAND ${CMAKE_COMMAND} "-DCMAKE_INSTALL_PREFIX=${HALIDE_DIR}" -P cmake_install.cmake
         WORKING_DIRECTORY ${Halide_BINARY_DIR})

set_tests_properties(create_halide_distrib PROPERTIES FIXTURES_SETUP apps)

function(add_app_test NAME)
    add_test(NAME ${NAME}
             COMMAND ${CMAKE_CTEST_COMMAND}
             --build-and-test "${CMAKE_CURRENT_SOURCE_DIR}/${NAME}" "${CMAKE_CURRENT_BINARY_DIR}/${NAME}"
             --build-generator ${CMAKE_GENERATOR}
             --build-options "-DCMAKE_PREFIX_PATH=${HALIDE_DIR}"
             --test-command ${CMAKE_CTEST_COMMAND})
    set_tests_properties(${NAME} PROPERTIES FIXTURES_REQUIRED apps LABELS apps)
endfunction()

# TODO: deprecated as of CMake 3.17. Replace "remove_directory" with "rm -rf" instead (which was introduced in 3.17).
add_test(NAME delete_halide_distrib
         COMMAND ${CMAKE_COMMAND} -E remove_directory "${HALIDE_DIR}")

set_tests_properties(delete_halide_distrib PROPERTIES FIXTURES_CLEANUP apps)

#add_app_test(autoscheduler)
#add_app_test(bilateral_grid)
#add_app_test(blur)
#add_app_test(c_backend)
#add_app_test(camera_pipe)
#add_app_test(conv_layer)
#add_app_test(glsl)
#add_app_test(harris)
#add_app_test(iir_blur)
#add_app_test(interpolate)
#add_app_test(lens_blur)
#add_app_test(linear_algebra)
#add_app_test(linear_blur)
#add_app_test(local_laplacian)
#add_app_test(nl_means)
#add_app_test(resize)
#add_app_test(stencil_chain)
#add_app_test(unsharp)
add_app_test(wavelet)
