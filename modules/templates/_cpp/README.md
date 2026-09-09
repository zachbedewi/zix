# myproject

A C++ project scaffolded from
[cpp-best-practices/cmake_template](https://github.com/cpp-best-practices/cmake_template),
trimmed to just the CMake project skeleton (compiler warnings, sanitizers,
hardening, `clang-tidy`/`cppcheck` wiring, [CPM.cmake](https://github.com/cpm-cmake/CPM.cmake)
for dependencies) with CI, Docker, devcontainers and the Conan/vcpkg options
removed. Those extras are handled by the accompanying Nix flake instead:
`treefmt` for formatting, `git-hooks.nix` for pre-commit checks, and a
`devShell` with the compiler toolchain, `cmake`, `ninja`, `ccache`,
`cppcheck` and `clang-tools`.

The project itself has **no dependency on Nix or this flake** — everything
under `cmake/`, `src/`, `test/` and the top-level `CMakeLists.txt` builds with
a plain CMake + Ninja/Make + compiler + git toolchain, since [CPM.cmake](https://github.com/cpm-cmake/CPM.cmake)
fetches dependencies (`fmt`, `Catch2`) itself at configure time via `git`. The
flake is purely a convenience layer for working on it.

## First step: rename

`myproject` is a placeholder used throughout `CMakeLists.txt`, the `cmake/*.cmake`
macros, `include/myproject/`, and the sources. Rename it once, right after
`nix flake init -t <zix>#cpp`:

```
just rename my_actual_project_name
```

(or do the equivalent `sed`/`mv` by hand if you don't have `just` yet).

## Working on it

With Nix + direnv (`direnv allow`, or `nix develop`):

```
just build   # configure + build (PRESET=dev by default, or PRESET=release)
just test    # build + run the test suite
just run     # build + run the app binary
just fmt     # format the whole tree
just check   # nix flake check (formatting + pre-commit + eval)
```

Without Nix, the same steps are just plain CMake:

```
cmake --preset dev
cmake --build --preset dev
ctest --preset dev
```

## Build options

Set via `-D<option>=ON|OFF` at configure time (see `ProjectOptions.cmake` for
the full list): `myproject_ENABLE_SANITIZER_ADDRESS`,
`myproject_ENABLE_SANITIZER_UNDEFINED`, `myproject_ENABLE_CLANG_TIDY`,
`myproject_ENABLE_CPPCHECK`, `myproject_ENABLE_IPO`, `myproject_ENABLE_HARDENING`,
`myproject_ENABLE_CACHE` (ccache/sccache). The `dev` preset turns sanitizers
and static analysis on; `release` turns them off and enables IPO/LTO and
hardening.

## Adding a dependency

Add a `cpmaddpackage(...)` call to `myproject_setup_dependencies()` in
`Dependencies.cmake`, then link the resulting target from the relevant
`CMakeLists.txt` — see the existing `fmt` and `Catch2` entries.

## Not included

Packaging/install (`CPack`), CI workflows, Docker/devcontainers, WASM
(Emscripten) and fuzz testing were part of the upstream template and were
deliberately dropped to keep this lean. Pull the relevant files back in from
[cpp-best-practices/cmake_template](https://github.com/cpp-best-practices/cmake_template)
if you need them.
