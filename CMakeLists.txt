cmake_minimum_required(VERSION 3.14)
project(Halide)

##
# Set up project-wide properties
##
get_property(USE_FOLDERS_WAS_SET GLOBAL PROPERTY USE_FOLDERS SET)
if (NOT USE_FOLDERS_WAS_SET)
    set_property(GLOBAL PROPERTY USE_FOLDERS ON)
endif ()

if (${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    set(CMAKE_OBJECT_PATH_MAX 260)
    message("Windows: setting CMAKE_OBJECT_PATH_MAX to ${CMAKE_OBJECT_PATH_MAX}")
endif ()

# Export all symbols
# TODO: reevaluate this. We should probably be selective about what we export.
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

# Require the given C++ standard
# TODO: evaluate if we actually need to match LLVM on this.
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

##
# Import dependencies
##
add_subdirectory(dependencies)

##
# Add source directories
##

add_subdirectory(src)
add_subdirectory(tools)

##
# Add tests, apps, tutorials, etc. if we're not being imported.
##

if (CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    option(WITH_TESTS "Build tests" OFF)
    if (WITH_TESTS)
        message(STATUS "Building tests enabled")
        enable_testing()
        add_subdirectory(test)
    else ()
        message(STATUS "Building tests disabled")
    endif ()

    option(WITH_APPS "Build apps" OFF)
    if (WITH_APPS)
        message(STATUS "Building apps enabled")
        add_subdirectory(apps)
    else ()
        message(STATUS "Building apps disabled")
    endif ()

    option(WITH_TUTORIALS "Build tutorials" OFF)
    if (WITH_TUTORIALS)
        message(STATUS "Building tutorials enabled")
        add_subdirectory(tutorial)
    else ()
        message(STATUS "Building tutorials disabled")
    endif ()

    option(WITH_DOCS "Build documentation" OFF)
    if (WITH_DOCS)
        message(STATUS "Building docs enabled")
        add_subdirectory(doc)
    else ()
        message(STATUS "Building docs disabled")
    endif ()

    option(WITH_UTILS "Build utils" OFF)
    if (WITH_UTILS)
        message(STATUS "Building utils enabled")
        add_subdirectory(util)
    else ()
        message(STATUS "Building utils disabled")
    endif ()

    add_subdirectory(packaging)

    add_custom_target(distrib
                      COMMAND ${CMAKE_COMMAND} -E echo "\\'distrib\\' is not available under CMake. Use \\'package\\' instead.")

    # TODO: use clang-format target.
    add_custom_target(format
                      COMMAND find "${Halide_SOURCE_DIR}/apps" "${Halide_SOURCE_DIR}/src" "${Halide_SOURCE_DIR}/tools" "${Halide_SOURCE_DIR}/test" "${Halide_SOURCE_DIR}/util" "${Halide_SOURCE_DIR}/python_bindings" -name *.cpp -o -name *.h -o -name *.c | xargs clang-format -i -style=file)
endif ()