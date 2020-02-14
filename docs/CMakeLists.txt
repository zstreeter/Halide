find_package(Doxygen)
if (NOT DOXYGEN_FOUND)
    message(FATAL_ERROR "Could not find Doxygen. Either install it or set WITH_DOCS to OFF")
endif ()

configure_file(${Halide_SOURCE_DIR}/Doxyfile.in ${CMAKE_BINARY_DIR}/Doxyfile @ONLY)
# Note documentation is not built by default, the user needs to build the "doc" target
add_custom_target(doc
                  COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_BINARY_DIR}/Doxyfile
                  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                  COMMENT "Building Doxygen documentation"
                  )