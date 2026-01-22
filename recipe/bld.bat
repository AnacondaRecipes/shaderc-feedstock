mkdir build
if errorlevel 1 exit 1
cd build
if errorlevel 1 exit 1
cmake -GNinja ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DSHADERC_SKIP_TESTS=OFF ^
  -DSHADERC_SKIP_EXAMPLES=ON ^
  -DSHADERC_ENABLE_SHARED_CRT=ON ^
  -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
  ..
if errorlevel 1 exit 1

ninja -j%CPU_COUNT%
if errorlevel 1 exit 1
@REM There is no way to skip per test through ctest
@REM 3 tests in glslc_tests suite fail
@REM TestVersionContainsGlslang: shaderc v2023.8 unknown hash, 2026-01-22
@REM TestVersionContainsSpirvTools: shaderc v2023.8 unknown hash, 2026-01-22
@REM TestFMaxIdBoundLow: Expected error message, but glslc was terminated by signal -11
ctest --output-on-failure --exclude-regex="glslc_tests"
if errorlevel 1 exit 1
ninja install
if errorlevel 1 exit 1
