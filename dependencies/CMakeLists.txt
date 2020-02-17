set(THREADS_PREFER_PTHREAD_FLAG YES)
find_package(Threads QUIET)
set_target_properties(Threads::Threads PROPERTIES IMPORTED_GLOBAL TRUE)

find_package(OpenGL)
set_target_properties(OpenGL::GL PROPERTIES IMPORTED_GLOBAL TRUE)

add_subdirectory(clang)
add_subdirectory(llvm)

add_subdirectory(jpeg)
add_subdirectory(png)