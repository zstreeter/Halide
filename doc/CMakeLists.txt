find_package(Doxygen REQUIRED doxygen)

# Halide-specific Doxygen options
set(DOXYGEN_ALPHABETICAL_INDEX NO)
set(DOXYGEN_BUILTIN_STL_SUPPORT YES)

doxygen_add_docs(doc
                 ${Halide_SOURCE_DIR}/src
                 ${Halide_SOURCE_DIR}/test
                 COMMENT "Generate HTML documentation")
