                Binary installers for CUnit static libraries
                     for Microsoft Visual Studio 2015
                      and Microsoft Visual C/C++ 14


Each installer has the same version number as the corresponding CUnit framework.
Thus, CUnit-msvc-2.1-3.exe installs the binary static libraries for CUnit 2.1-3.

The static libraries are provided for "Release" and "Debug" configurations on
platforms "Win32", "x86" and "x64" ("Win32" and "x86" are identical). The
installers can be used on 32-bit or 64-bit Windows. The libraries are installed
for both architectures.

After installation, the environment variable CUnitRoot points to the CUnit root,
typically C:\Program Files (x86)\CUnit or C:\Program Files\CUnit.

From Visual Studio, you can reference CUnit libraries using the CUnit property
sheet %CUnitRoot%\CUnit.props. In your Visual Studio project file, an XML file
ending in .vcxproj, add the following section.

  <ImportGroup Label="PropertySheets">
    <Import Project="$(CUnitRoot)\CUnit.props" />
  </ImportGroup>

From C source files of your application's unitary tests, use CUnit the same way
as on any platform. Namely, from any source file:

  #include <CUnit/CUnit.h>

Compiling and linking from Visual Studio is done transparently.
