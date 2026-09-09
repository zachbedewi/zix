add_executable(myproject main.cpp)

target_link_libraries(
  myproject
  PRIVATE myproject::myproject_options
          myproject::myproject_warnings
          myproject::sample_library
          fmt::fmt)

myproject_configure_linker(myproject)

target_include_directories(myproject PRIVATE "${CMAKE_BINARY_DIR}/configured_files/include")
