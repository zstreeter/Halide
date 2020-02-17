# TODO: this is intended to eventually replicate all of the interesting test targets from our Make build, but not all are implemented yet:
# TODO(srj): add test_aotcpp_generators support
# TODO(srj): add test_valgrind variant
# TODO(srj): add test_avx512 variant
# TODO(srj): add test_python variant
# TODO(srj): add test_apps variant
function(add_halide_test TARGET)
    set(options EXPECT_FAILURE)
    set(oneValueArgs WORKING_DIRECTORY)
    set(multiValueArgs GROUPS)
    cmake_parse_arguments(args "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    add_test(NAME ${TARGET}
             COMMAND ${TARGET}
             WORKING_DIRECTORY "${args_WORKING_DIRECTORY}")

    set_tests_properties(${TARGET} PROPERTIES LABELS "${args_GROUPS}")
    if (${args_EXPECT_FAILURE})
        set_tests_properties(${TARGET} PROPERTIES WILL_FAIL true)
    endif ()
endfunction()

function(halide_project name folder)
    add_executable("${name}" ${ARGN})
    target_link_libraries("${name}" PRIVATE Halide::Halide ${CMAKE_DL_LIBS} Threads::Threads $<$<CXX_COMPILER_ID:MSVC>:Kernel32>)
    set_target_properties("${name}" PROPERTIES
                          FOLDER "${folder}"
                          ENABLE_EXPORTS True)
endfunction(halide_project)