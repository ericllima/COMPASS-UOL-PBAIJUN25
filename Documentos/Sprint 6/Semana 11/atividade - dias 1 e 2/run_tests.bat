@echo off
echo Running Restful Booker API Tests...

REM Create results directory
if not exist "results" mkdir results

REM Run all tests
echo.
echo === Running All Tests ===
robot -d results tests

REM Run specific test suites
echo.
echo === Running Smoke Tests Only ===
robot -d results/smoke -i smoke tests

echo.
echo === Running CRUD Tests Only ===
robot -d results/crud -i crud tests

echo.
echo === Running Negative Tests Only ===
robot -d results/negative -i negative tests

echo.
echo === Running Search Tests Only ===
robot -d results/search -i search tests

echo.
echo Tests completed. Check results directory for reports.
pause