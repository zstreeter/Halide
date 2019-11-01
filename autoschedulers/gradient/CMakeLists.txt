# libgradient_autoscheduler
add_library(gradient_autoscheduler SHARED GradientAutoscheduler.cpp ASLog.cpp)

if (HALIDE_LIBRARY_TYPE STREQUAL STATIC)
else ()
    target_link_libraries(gradient_autoscheduler PRIVATE Halide)
endif ()

if (NOT MSVC)
    set_target_properties(gradient_autoscheduler PROPERTIES LINK_FLAGS "-rdynamic")
elseif (APPLE)
    set_target_properties(gradient_autoscheduler PROPERTIES LINK_FLAGS "-undefined dynamic_lookup")
endif ()

if (NOT HALIDE_ENABLE_RTTI)
    if (NOT MSVC)
        target_compile_options(gradient_autoscheduler PUBLIC "-fno-rtti")
    else ()
        target_compile_options(gradient_autoscheduler PUBLIC "/GR-")
    endif ()
endif ()

install(TARGETS gradient_autoscheduler LIBRARY DESTINATION bin)
