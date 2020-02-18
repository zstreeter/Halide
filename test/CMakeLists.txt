# Add an OBJECT (not static) library to convert abort calls into exit(1).
add_library(Halide_expect_abort OBJECT common/expect_abort.cpp)

# Capture common halide test features in a single target.
add_library(Halide_test INTERFACE)
target_include_directories(Halide_test INTERFACE
                           "${HALIDE_INCLUDE_DIR}"
                           "${Halide_SOURCE_DIR}" # TODO: break this dependency.
                           common)

# Tests are built with the equivalent of OPTIMIZE_FOR_BUILD_TIME (-O0 or /Od).
# Also allow tests, via conditional compilation, to use the entire
# capability of the CPU being compiled on via -march=native. This
# presumes tests are run on the same machine they are compiled on.
target_compile_options(Halide_test INTERFACE
                       $<$<CXX_COMPILER_ID:MSVC>:/Od>
                       $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-O0>
                       $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-march=native>)

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

        halide_project("${TARGET}" "${CMAKE_CURRENT_SOURCE_DIR}" "${file}")
        target_link_libraries("${TARGET}" PRIVATE Halide_test)

        if (args_EXPECT_FAILURE)
            add_halide_test("${TARGET}" GROUPS ${args_GROUPS} EXPECT_FAILURE)
            target_link_libraries("${TARGET}" PRIVATE Halide_expect_abort)
        else ()
            add_halide_test("${TARGET}" GROUPS ${args_GROUPS})
        endif ()
    endforeach ()

    set(TEST_NAMES "${TEST_NAMES}" PARENT_SCOPE)
endfunction(tests)

halide_project(_test_internal internal internal.cpp)
target_include_directories(_test_internal PRIVATE "${Halide_SOURCE_DIR}/src")
add_halide_test(_test_internal GROUPS internal)

option(WITH_TEST_AUTO_SCHEDULE "Build auto_schedule tests" OFF)
if (WITH_TEST_AUTO_SCHEDULE)
    add_subdirectory(auto_schedule)
endif ()

option(WITH_TEST_CORRECTNESS "Build correctness tests" OFF)
if (WITH_TEST_CORRECTNESS)
    add_subdirectory(correctness)
endif ()

option(WITH_TEST_ERROR "Build error tests" OFF)
if (WITH_TEST_ERROR)
    add_subdirectory(error)
endif ()

option(WITH_TEST_WARNING "Build warning tests" OFF)
if (WITH_TEST_WARNING)
    add_subdirectory(warning)
endif ()

option(WITH_TEST_PERFORMANCE "Build performance tests" OFF)
if (WITH_TEST_PERFORMANCE)
    add_subdirectory(performance)
endif ()

option(WITH_TEST_OPENGL "Build OpenGL tests" OFF)
if (WITH_TEST_OPENGL)
    add_subdirectory(opengl)
endif ()

option(WITH_TEST_GENERATOR "Build Generator tests" OFF)
if (WITH_TEST_GENERATOR)
    add_subdirectory(generator)
endif ()
