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