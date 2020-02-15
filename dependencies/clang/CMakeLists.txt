if ("${Clang_DIR}" STREQUAL "")
    set(Clang_DIR "${LLVM_DIR}/../clang")
endif ()

find_package(Clang CONFIG REQUIRED)

set_target_properties(clang PROPERTIES IMPORTED_GLOBAL TRUE)