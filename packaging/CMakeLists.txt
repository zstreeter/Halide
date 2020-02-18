include(GNUInstallDirs)

##
# Main library exports
##

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
# READMEs and other top-level documentation
##

install(FILES
        ${Halide_SOURCE_DIR}/CODE_OF_CONDUCT.md
        ${Halide_SOURCE_DIR}/README_cmake.md
        ${Halide_SOURCE_DIR}/README.md
        ${Halide_SOURCE_DIR}/README_rungen.md
        ${Halide_SOURCE_DIR}/README_webassembly.md
        TYPE DATA)

##
# Tools
##

install(DIRECTORY ${Halide_SOURCE_DIR}/tools
        TYPE DATA
        FILES_MATCHING
        PATTERN "*.h"
        PATTERN "*.cpp"
        PATTERN "*.m")

##
# Tutorial
##

install(DIRECTORY ${Halide_SOURCE_DIR}/tutorial
        TYPE DATA
        FILES_MATCHING
        PATTERN "*.cpp"
        PATTERN "*.h"
        PATTERN "lesson_*.sh"
        PATTERN "*.gif"
        PATTERN "*.jpg"
        PATTERN "*.mp4"
        PATTERN "*.png")

##
# Documentation
##

# See /doc/CMakeLists.txt. This way, special install logic isn't needed.

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
