if (NOT TARGET Halide::Test)
    # Capture common halide test features in a single target.
    add_library(Halide_test INTERFACE)
    add_library(Halide::Test ALIAS Halide_test)

    # Obviously, link to the main library
    target_link_libraries(Halide_test INTERFACE Halide::Halide)

    # Everyone gets to see the common headers
    target_include_directories(Halide_test
                               INTERFACE
                               ${Halide_SOURCE_DIR}/test/common
                               ${Halide_SOURCE_DIR}/tools)

    # Tests are built with the equivalent of OPTIMIZE_FOR_BUILD_TIME (-O0 or /Od).
    # Also allow tests, via conditional compilation, to use the entire
    # capability of the CPU being compiled on via -march=native. This
    # presumes tests are run on the same machine they are compiled on.
    target_compile_options(Halide_test INTERFACE
                           $<$<CXX_COMPILER_ID:MSVC>:/Od>
                           $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-O0>
                           $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-march=native>)
endif ()

if (NOT TARGET Halide::ExpectAbort)
    # Add an OBJECT (not static) library to convert abort calls into exit(1).
    add_library(Halide_expect_abort OBJECT ${Halide_SOURCE_DIR}/test/common/expect_abort.cpp)
    add_library(Halide::ExpectAbort ALIAS Halide_expect_abort)
endif ()

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
    message(DEPRECATION "Link to Halide::Test and only enable exports if needed.")
    add_executable("${name}" ${ARGN})
    target_link_libraries("${name}" PRIVATE Halide::Halide ${CMAKE_DL_LIBS} Threads::Threads $<$<CXX_COMPILER_ID:MSVC>:Kernel32>)
    set_target_properties("${name}" PROPERTIES
                          FOLDER "${folder}"
                          ENABLE_EXPORTS True)
endfunction(halide_project)

function(tests)
    set(options EXPECT_FAILURE)
    set(oneValueArgs)
    set(multiValueArgs SOURCES GROUPS)
    cmake_parse_arguments(args "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    list(GET args_GROUPS 0 PRIMARY_GROUP)

    set(TEST_NAMES "")
    foreach (file ${args_SOURCES})
        get_filename_component(name "${file}" NAME_WE)
        set(TARGET "${PRIMARY_GROUP}_${name}")

        list(APPEND TEST_NAMES "${TARGET}")

        add_executable("${TARGET}" "${file}")
        target_link_libraries("${TARGET}" PRIVATE Halide::Test)
        if (COMMAND target_precompile_headers AND "${file}" MATCHES ".cpp$")
            target_precompile_headers("${TARGET}" REUSE_FROM _test_internal)
        endif ()

        if (args_EXPECT_FAILURE)
            add_halide_test("${TARGET}" GROUPS ${args_GROUPS} EXPECT_FAILURE)
            target_link_libraries("${TARGET}" PRIVATE Halide::ExpectAbort)
        else ()
            add_halide_test("${TARGET}" GROUPS ${args_GROUPS})
        endif ()
    endforeach ()

    set(TEST_NAMES "${TEST_NAMES}" PARENT_SCOPE)
endfunction(tests)