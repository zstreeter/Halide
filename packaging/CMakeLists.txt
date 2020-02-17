# Needed for 'make distrib' to properly fill in the .tpl files
if (HALIDE_ENABLE_RTTI)
    set(HALIDE_RTTI_RAW 1)
else ()
    set(HALIDE_RTTI_RAW 0)
endif ()


# TODO: the use of glob here is almost certainly brittle if not outright wrong.
file(GLOB FILES "${Halide_BINARY_DIR}/include/HalideRuntime*.h")
install(FILES
        "${Halide_BINARY_DIR}/include/Halide.h"
        "${Halide_BINARY_DIR}/include/HalideBuffer.h"
        "${Halide_BINARY_DIR}/include/HalidePyTorchHelpers.h"
        "${Halide_BINARY_DIR}/include/HalidePyTorchCudaHelpers.h"
        ${FILES}
        DESTINATION include)

install(DIRECTORY tutorial
        DESTINATION .
        FILES_MATCHING
        PATTERN "*.cpp"
        PATTERN "*.h"
        PATTERN "lesson_*.sh"
        PATTERN "*.gif"
        PATTERN "*.jpg"
        PATTERN "*.mp4"
        PATTERN "*.png")

# ---- Tools
install(FILES
        tools/mex_halide.m
        tools/GenGen.cpp
        tools/RunGen.h
        tools/RunGenMain.cpp
        tools/halide_benchmark.h
        tools/halide_image.h
        tools/halide_image_io.h
        tools/halide_image_info.h
        tools/halide_malloc_trace.h
        tools/halide_trace_config.h
        DESTINATION tools)

# ---- README
install(FILES
        CODE_OF_CONDUCT.md
        README_cmake.md
        README.md
        README_rungen.md
        README_webassembly.md
        DESTINATION .)

# ---- halide.cmake
install(FILES halide.cmake DESTINATION .)

# ---- halide_config
file(GLOB FILES "${Halide_SOURCE_DIR}/tools/halide_config.*.tpl")
foreach (F ${FILES})
    get_filename_component(FNAME "${F}" NAME)  # Extract filename
    string(REGEX REPLACE "\\.tpl$" "" FNAME "${FNAME}")  # Strip .tpl extension
    configure_file("${F}" "${Halide_BINARY_DIR}/${FNAME}" @ONLY)
    install(FILES "${Halide_BINARY_DIR}/${FNAME}"
            DESTINATION .)
endforeach ()

set(CPACK_PACKAGE_VENDOR "Halide")
set(CPACK_RESOURCE_FILE_LICENSE "${Halide_SOURCE_DIR}/LICENSE.txt")
set(CPACK_MONOLITHIC_INSTALL OFF)
if (WIN32)
    set(CPACK_GENERATOR "ZIP")
else ()
    set(CPACK_GENERATOR "TGZ")
endif ()
# Remove this to get package names that are formatted as
# ${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-${CPACK_SYSTEM_NAME}.
set(CPACK_PACKAGE_FILE_NAME "Halide" CACHE STRING "Name of package created by distrib target")
include(CPack)
