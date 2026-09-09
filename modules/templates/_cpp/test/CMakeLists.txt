cmake_minimum_required(VERSION 3.15...3.29)

project(CmakeConfigPackageTests
  VERSION ${PROJECT_VERSION}
  LANGUAGES CXX)

# ---- Dependencies ----

include(${Catch2_SOURCE_DIR}/extras/Catch.cmake)

add_executable(tests tests.cpp)
target_link_libraries(
  tests
  PRIVATE myproject::myproject_warnings
          myproject::myproject_options
          myproject::sample_library
          Catch2::Catch2WithMain)

myproject_configure_linker(tests)

# automatically discover tests that are defined in catch based test files you can modify the unittests. Set TEST_PREFIX
# to whatever you want, or use different for different binaries
catch_discover_tests(
  tests
  TEST_PREFIX
  "unittests."
  REPORTER
  XML
  OUTPUT_DIR
  .
  OUTPUT_PREFIX
  "unittests."
  OUTPUT_SUFFIX
  .xml)

# Add a file containing a set of constexpr tests
add_executable(constexpr_tests constexpr_tests.cpp)
target_link_libraries(
  constexpr_tests
  PRIVATE myproject::myproject_warnings
          myproject::myproject_options
          myproject::sample_library
          Catch2::Catch2WithMain)

myproject_configure_linker(constexpr_tests)

catch_discover_tests(
  constexpr_tests
  TEST_PREFIX
  "constexpr."
  REPORTER
  XML
  OUTPUT_DIR
  .
  OUTPUT_PREFIX
  "constexpr."
  OUTPUT_SUFFIX
  .xml)

# Disable the constexpr portion of the test, and build again this allows us to have an executable that we can debug when
# things go wrong with the constexpr testing
add_executable(relaxed_constexpr_tests constexpr_tests.cpp)
target_link_libraries(
  relaxed_constexpr_tests
  PRIVATE myproject::myproject_warnings
          myproject::myproject_options
          myproject::sample_library
          Catch2::Catch2WithMain)
target_compile_definitions(relaxed_constexpr_tests PRIVATE -DCATCH_CONFIG_RUNTIME_STATIC_REQUIRE)

myproject_configure_linker(relaxed_constexpr_tests)

catch_discover_tests(
  relaxed_constexpr_tests
  TEST_PREFIX
  "relaxed_constexpr."
  REPORTER
  XML
  OUTPUT_DIR
  .
  OUTPUT_PREFIX
  "relaxed_constexpr."
  OUTPUT_SUFFIX
  .xml)
