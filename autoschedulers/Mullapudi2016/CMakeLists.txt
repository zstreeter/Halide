# libhalide_scheduler_Mullapudi2016
add_library(halide_scheduler_Mullapudi2016 SHARED AutoSchedule.cpp)
target_link_libraries(halide_scheduler_Mullapudi2016 PRIVATE autoschedulers_common)

if (APPLE)
    set_target_properties(halide_scheduler_Mullapudi2016 PROPERTIES LINK_FLAGS "-undefined dynamic_lookup")
elseif (NOT MSVC)
    set_target_properties(halide_scheduler_Mullapudi2016 PROPERTIES LINK_FLAGS "-rdynamic")
endif ()

if (NOT HALIDE_ENABLE_RTTI)
    if (NOT MSVC)
        target_compile_options(halide_scheduler_Mullapudi2016 PUBLIC "-fno-rtti")
    else ()
        target_compile_options(halide_scheduler_Mullapudi2016 PUBLIC "/GR-")
    endif ()
endif ()

install(TARGETS halide_scheduler_Mullapudi2016 LIBRARY DESTINATION bin)
