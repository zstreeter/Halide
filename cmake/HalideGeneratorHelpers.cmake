define_property(TARGET PROPERTY HL_GEN_TARGET
                BRIEF_DOCS "On a Halide library target, names the generator target used to create it"
                FULL_DOCS "On a Halide library target, names the generator target used to create it")

define_property(TARGET PROPERTY HL_FILTER_NAME
                BRIEF_DOCS "On a Halide library target, names the filter this library corresponds to"
                FULL_DOCS "On a Halide library target, names the filter this library corresponds to")

define_property(TARGET PROPERTY HL_LIBNAME
                BRIEF_DOCS "On a Halide library target, names the function it provides"
                FULL_DOCS "On a Halide library target, names the function it provides")

define_property(TARGET PROPERTY HL_RUNTIME
                BRIEF_DOCS "On a Halide library target, names the runtime target it depends on"
                FULL_DOCS "On a Halide library target, names the runtime target it depends on")

define_property(TARGET PROPERTY HL_PARAMS
                BRIEF_DOCS "On a Halide library target, lists the parameters used to configure the filter"
                FULL_DOCS "On a Halide library target, lists the parameters used to configure the filter")

define_property(TARGET PROPERTY HL_TARGET
                BRIEF_DOCS "On a Halide library target, lists the runtime targets supported by the filter"
                FULL_DOCS "On a Halide library target, lists the runtime targets supported by the filter")

function(add_generator_stubs TARGET)
    set(options)
    set(oneValueArgs FOR GENERATOR FUNCTION_NAME)
    set(multiValueArgs PARAMS EXTRA_OUTPUTS TARGETS FEATURES)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if (NOT ARG_FOR)
        message(FATAL_ERROR "Missing FOR argument specifying a Halide generator target")
    endif ()

    if (NOT ARG_GENERATOR)
        get_target_property(ARG_GENERATOR ${ARG_FOR} NAME)
        string(REPLACE ".generator" "" ARG_GENERATOR "${ARG_GENERATOR}")
    endif ()

    set(TARGET_NAME "${TARGET}")

    add_custom_command(OUTPUT "${TARGET_NAME}.stub.h"
                       COMMAND "${ARG_FOR}" -g "${ARG_GENERATOR}" -o . -e cpp_stub -n "${ARG_GENERATOR}"
                       DEPENDS "${ARG_FOR}")

    add_custom_target("${TARGET_NAME}.stub.update"
                      DEPENDS
                      "${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}.stub.h"
                      )

    add_library("${TARGET}" INTERFACE)
    target_sources("${TARGET}" INTERFACE "${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}.stub.h")
    target_include_directories("${TARGET}" INTERFACE "${CMAKE_CURRENT_BINARY_DIR}")
    add_dependencies("${TARGET}" "${TARGET_NAME}.stub.update")
endfunction()

function(add_halide_library TARGET)
    set(options)
    set(oneValueArgs FROM GENERATOR FUNCTION_NAME USE_RUNTIME)
    set(multiValueArgs PARAMS EXTRA_OUTPUTS TARGETS FEATURES)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if (NOT ARG_FROM)
        message(FATAL_ERROR "Missing FROM argument specifying a Halide generator target")
    endif ()

    if (NOT ARG_GENERATOR)
        set(ARG_GENERATOR "${TARGET}")
    endif ()

    if (NOT ARG_FUNCTION_NAME)
        set(ARG_FUNCTION_NAME "${ARG_GENERATOR}")
    endif ()

    if (NOT ARG_TARGETS)
        set(ARG_TARGETS host)
    else ()
        string(REPLACE ";" "," ARG_TARGETS "${ARG_TARGETS}")
    endif ()

    if (NOT ARG_USE_RUNTIME)
        add_library("${TARGET}.runtime" STATIC IMPORTED)
        add_custom_command(OUTPUT "${TARGET}.runtime.a"
                           COMMAND "${ARG_FROM}" -r "${TARGET}.runtime" -o . target=${ARG_TARGETS})
        add_custom_target("${TARGET}.runtime.update"
                          DEPENDS "${TARGET}.runtime.a")
        set_target_properties("${TARGET}.runtime" PROPERTIES IMPORTED_LOCATION "${CMAKE_CURRENT_BINARY_DIR}/${TARGET}.runtime.a")
        set(ARG_USE_RUNTIME "${TARGET}.runtime")
        add_dependencies("${TARGET}.runtime" "${TARGET}.runtime.update")
    endif ()

    # TODO: handle extra outputs and features.

    ##
    # Main library target for filter.
    ##

    add_library("${TARGET}" STATIC IMPORTED)

    set_target_properties("${TARGET}" PROPERTIES
                          HL_GEN_TARGET "${ARG_FROM}"
                          HL_FILTER_NAME "${ARG_GENERATOR}"
                          HL_LIBNAME "${ARG_FUNCTION_NAME}"
                          HL_PARAMS "${ARG_PARAMS}"
                          HL_TARGET "${ARG_TARGET}")

    add_custom_command(OUTPUT
                       "${ARG_FUNCTION_NAME}.a"
                       "${ARG_FUNCTION_NAME}.h"
                       "${ARG_FUNCTION_NAME}.registration.cpp"
                       COMMAND "${ARG_FROM}" -g "${ARG_GENERATOR}" -f "${ARG_FUNCTION_NAME}" -o . target=${ARG_TARGETS} ${ARG_PARAMS}
                       DEPENDS "${ARG_FROM}")

    add_custom_target("${ARG_FUNCTION_NAME}.update"
                      DEPENDS
                      "${CMAKE_CURRENT_BINARY_DIR}/${ARG_FUNCTION_NAME}.a"
                      "${CMAKE_CURRENT_BINARY_DIR}/${ARG_FUNCTION_NAME}.h"
                      "${CMAKE_CURRENT_BINARY_DIR}/${ARG_FUNCTION_NAME}.registration.cpp")

    set_target_properties("${ARG_FUNCTION_NAME}" PROPERTIES IMPORTED_LOCATION "${CMAKE_CURRENT_BINARY_DIR}/${ARG_FUNCTION_NAME}.a")
    add_dependencies("${TARGET}" "${ARG_FUNCTION_NAME}.update")

    target_include_directories("${TARGET}" INTERFACE "${CMAKE_CURRENT_BINARY_DIR}")
    target_link_libraries("${TARGET}" INTERFACE "${ARG_USE_RUNTIME}")
endfunction()