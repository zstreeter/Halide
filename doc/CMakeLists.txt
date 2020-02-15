find_package(Doxygen REQUIRED doxygen)
if (TARGET Doxygen::doxygen)
    set(DOXYGEN_ALPHABETICAL_INDEX NO)
    set(DOXYGEN_BUILTIN_STL_SUPPORT YES)
    doxygen_add_docs(doc
                     ${Halide_SOURCE_DIR}/src
                     ${Halide_SOURCE_DIR}/test
                     COMMENT "Generate HTML documentation")
else ()
    message(FATAL_ERROR "Could not find Doxygen. Either install it or set WITH_DOCS to OFF")
endif ()