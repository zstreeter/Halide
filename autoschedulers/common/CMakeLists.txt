add_library(autoschedulers_common STATIC ASLog.cpp)

if (NOT HALIDE_ENABLE_RTTI)
    if (NOT MSVC)
        target_compile_options(autoschedulers_common PUBLIC "-fno-rtti")
    else ()
        target_compile_options(autoschedulers_common PUBLIC "/GR-")
    endif ()
endif ()
