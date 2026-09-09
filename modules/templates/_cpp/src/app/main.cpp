#include <fmt/format.h>

#include <internal_use_only/config.hpp>
#include <myproject/sample_library.hpp>

int main()
{
  constexpr int demo_input = 5;

  fmt::print("{} v{}\n", myproject::cmake::project_name, myproject::cmake::project_version);
  fmt::print("factorial({}) = {}\n", demo_input, factorial(demo_input));

  return 0;
}
