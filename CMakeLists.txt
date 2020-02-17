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

# Export all symbols -- TODO: reevaluate this. We should probably be selective about what we export.
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

# Require the given C++ standard
# TODO: evaluate if we actually need to match LLVM on this.
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_subdirectory(dependencies)

option(LLVM_USE_SHARED_LLVM_LIBRARY "Use shared versions of LLVM libraries" OFF)
if (LLVM_USE_SHARED_LLVM_LIBRARY)
    # Since we will be linking to the shared LLVM library,
    # we will get all the transitive dependencies for free automagically.
    set(HALIDE_SYSTEM_LIBS)
else ()
    # LLVM doesn't appear to expose --system-libs via its CMake interface,
    # so we must shell out to llvm-config to find this info
    execute_process(COMMAND llvm-config --system-libs --link-static OUTPUT_VARIABLE HALIDE_SYSTEM_LIBS_RAW)
    string(STRIP "${HALIDE_SYSTEM_LIBS_RAW}" HALIDE_SYSTEM_LIBS_RAW)  # strip whitespace from start & end
    string(REPLACE " " ";" HALIDE_SYSTEM_LIBS "${HALIDE_SYSTEM_LIBS_RAW}")  # convert into a list
    if ("${HALIDE_SYSTEM_LIBS}" STREQUAL "")
        # It's theoretically possible that this could be legitimately empty,
        # but in practice that doesn't really happen, so we'll assume it means we
        # aren't configured correctly.
        message(WARNING "'llvm-config --system-libs --link-static' is empty; this is possibly wrong.")
    endif ()
endif ()

# TODO: this only works on Clang. What is this actually fixing?
# see: https://libcxx.llvm.org/docs/UsingLibcxx.html#id5
string(FIND "${LLVM_CONFIG_CXXFLAGS}" "-stdlib=libc++" LLVM_LIBCXX)
if (LLVM_LIBCXX GREATER -1)
    add_compile_options(-stdlib=libc++)
    add_link_options(-stdlib=libc++)
endif ()

# Needed for 'make distrib' to properly fill in the .tpl files
if (HALIDE_ENABLE_RTTI)
    set(HALIDE_RTTI_RAW 1)
else ()
    set(HALIDE_RTTI_RAW 0)
endif ()

function(halide_project name folder)
    add_executable("${name}" ${ARGN})
    target_link_libraries("${name}" PRIVATE Halide::Halide ${CMAKE_DL_LIBS} Threads::Threads $<$<CXX_COMPILER_ID:MSVC>:Kernel32>)
    set_target_properties("${name}" PROPERTIES
                          FOLDER "${folder}"
                          ENABLE_EXPORTS True)
endfunction(halide_project)

# Set warnings globally
option(WARNINGS_AS_ERRORS "Treat warnings as errors" ON)
if (WARNINGS_AS_ERRORS)
    message(STATUS "WARNINGS_AS_ERRORS enabled")
else ()
    message(STATUS "WARNINGS_AS_ERRORS disabled")
endif ()

if (NOT MSVC)
    add_compile_options(
            -Wall
            -Wno-unused-function
            -Wcast-qual
            -Wignored-qualifiers
            $<$<COMPILE_LANGUAGE:CXX>:-Woverloaded-virtual>
            $<$<AND:$<COMPILE_LANGUAGE:CXX>,$<CXX_COMPILER_ID:GNU>,$<VERSION_GREATER:$<CXX_COMPILER_VERSION>,5.1>>:-Wsuggest-override>
    )
    if (WARNINGS_AS_ERRORS)
        add_compile_options(-Werror)
    endif ()
    if (HALIDE_ENABLE_EXCEPTIONS)
        add_compile_options(-DWITH_EXCEPTIONS)
    endif ()
else ()
    add_compile_options(/W3)
    add_compile_options(/wd4018)  # disable "signed/unsigned mismatch"
    add_compile_options(/wd4503)  # disable "decorated name length exceeded, name was truncated"
    add_compile_options(/wd4267)  # disable "conversion from 'size_t' to 'int', possible loss of data"
    add_compile_options(/wd4800)  # forcing value to bool 'true' or 'false' (performance warning)
    if (WARNINGS_AS_ERRORS)
        add_compile_options(/WX)
    endif ()
    if (HALIDE_ENABLE_EXCEPTIONS)
        add_compile_options(/DWITH_EXCEPTIONS)
    endif ()
endif ()

# -----------------------------------------------------------------------------
# Option to enable/disable assertions
# -----------------------------------------------------------------------------
# Filter out definition of NDEBUG definition from the default build
# configuration flags.  # We will add this ourselves if we want to disable
# assertions.
# FIXME: Perhaps our own default ``cxx_flags_overrides.cmake`` file would be better?
foreach (build_config Debug Release RelWithDebInfo MinSizeRel)
    string(TOUPPER ${build_config} upper_case_build_config)
    foreach (language CXX C)
        set(VAR_TO_MODIFY "CMAKE_${language}_FLAGS_${upper_case_build_config}")
        string(REGEX REPLACE "(^| )[/-]D *NDEBUG($| )"
               " "
               replacement
               "${${VAR_TO_MODIFY}}"
               )
        #message("Original (${VAR_TO_MODIFY}) is ${${VAR_TO_MODIFY}} replacement is ${replacement}")
        set(${VAR_TO_MODIFY} "${replacement}" CACHE STRING "Default flags for ${build_config} configuration" FORCE)
    endforeach ()
endforeach ()

add_subdirectory(src)
add_subdirectory(tools)

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

add_custom_target(format
                  COMMAND find "${Halide_SOURCE_DIR}/apps" "${Halide_SOURCE_DIR}/src" "${Halide_SOURCE_DIR}/tools" "${Halide_SOURCE_DIR}/test" "${Halide_SOURCE_DIR}/util" "${Halide_SOURCE_DIR}/python_bindings" -name *.cpp -o -name *.h -o -name *.c | xargs ${CLANG}-format -i -style=file)
