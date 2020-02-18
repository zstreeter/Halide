#install(DIRECTORY tutorial
#        DESTINATION .
#        FILES_MATCHING
#        PATTERN "*.cpp"
#        PATTERN "*.h"
#        PATTERN "lesson_*.sh"
#        PATTERN "*.gif"
#        PATTERN "*.jpg"
#        PATTERN "*.mp4"
#        PATTERN "*.png")
#
## ---- Tools
#install(FILES
#        tools/mex_halide.m
#        tools/GenGen.cpp
#        tools/RunGen.h
#        tools/RunGenMain.cpp
#        tools/halide_benchmark.h
#        tools/halide_image.h
#        tools/halide_image_io.h
#        tools/halide_image_info.h
#        tools/halide_malloc_trace.h
#        tools/halide_trace_config.h
#        DESTINATION tools)
#
## ---- README
#install(FILES
#        CODE_OF_CONDUCT.md
#        README_cmake.md
#        README.md
#        README_rungen.md
#        README_webassembly.md
#        DESTINATION .)
#
## ---- halide.cmake
#install(FILES halide.cmake DESTINATION .)
#
## ---- halide_config
#file(GLOB FILES "${Halide_SOURCE_DIR}/tools/halide_config.*.tpl")
#foreach (F ${FILES})
#    get_filename_component(FNAME "${F}" NAME)  # Extract filename
#    string(REGEX REPLACE "\\.tpl$" "" FNAME "${FNAME}")  # Strip .tpl extension
#    configure_file("${F}" "${Halide_BINARY_DIR}/${FNAME}" @ONLY)
#    install(FILES "${Halide_BINARY_DIR}/${FNAME}"
#            DESTINATION .)
#endforeach ()

##
# Main library exports
##

include(GNUInstallDirs)

install(TARGETS Halide
        EXPORT Halide
        RUNTIME
        DESTINATION ${CMAKE_INSTALL_BINDIR}
        COMPONENT Halide_Runtime

        LIBRARY
        DESTINATION ${CMAKE_INSTALL_LIBDIR}
        COMPONENT Halide_Runtime
        NAMELINK_COMPONENT Halide_Development

        ARCHIVE
        DESTINATION ${CMAKE_INSTALL_LIBDIR}
        COMPONENT Halide_Development

        INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

install(TARGETS Halide_ImageIO
        EXPORT Halide)

install(EXPORT Halide
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Halide
        NAMESPACE Halide::)

install(DIRECTORY ${Halide_BINARY_DIR}/include/ TYPE INCLUDE FILES_MATCHING PATTERN "include/*.h")

##
# Documentation
##

# TODO: install docs.
#include(GNUInstallDirs)
#set(CMAKE_INSTALL_DOCDIR ${CMAKE_INSTALL_DATAROOTDIR}/doc/${PROJECT_NAME})

##
# Actual packaging
##

set(CPACK_PACKAGE_VENDOR "Halide")
set(CPACK_RESOURCE_FILE_LICENSE "${Halide_SOURCE_DIR}/LICENSE.txt")
if (WIN32)
    set(CPACK_GENERATOR "ZIP")
else ()
    set(CPACK_GENERATOR "TGZ")
endif ()
# Remove this to get package names that are formatted as
# ${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-${CPACK_SYSTEM_NAME}.
set(CPACK_PACKAGE_FILE_NAME "Halide" CACHE STRING "Name of package created by distrib target")
include(CPack)
