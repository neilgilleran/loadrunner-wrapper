::===============================================================
:: This is a batch file for running jmeter from the command line
:: It will set up the dashboard / log files and folders
:: Author: NEiL Gilleran McLoughlin
::===============================================================
@echo off

rem check a testfile was passed in from the command line (exit on error)
IF "%~1" == "" (
	echo Please specify a testfile
	echo e.g. "testrunner.bat testfile.jmx"
	exit /b 
)

rem check if the jmeter folder exists  (exit on error
:: this could potentially cause an issue on a non windows or with the wrong username
set apache_dir=C:\Users\neilmcloughlin\Documents\apache-jmeter-5.0\bin
if exist %apache_dir% (echo ) ELSE (echo Update the apache_dir with the correct JMeter path)
if exist %apache_dir% (echo ) ELSE (exit /b)

rem change directory to where JMeter is located
cd apache_dir

rem get the date time of the run for the log files
:: YYYY-MM-DD_24HHmm-s
:: an example is 2019-05-31_1012-08 
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j
set ldt=%ldt:~0,4%-%ldt:~4,2%-%ldt:~6,2%_%ldt:~8,2%%ldt:~10,2%-%ldt:~12,2%

set test_file=%1
set results=%test_file%_%ldt%

rem set up the switches for running JMeter
:: -n  [This specifies JMeter is to run in non-gui mode]
:: -t  [name of JMX file that contains the Test Plan]
:: -l  [name of JTL file to log sample results to]
:: -e  [execute the following actions once the test is complete]
:: -o  [name of test files output folder]
::call jmeter.bat -Jjmeter.save.saveservice.autoflush=true -n  -t %test_file% -l %results%.jtl -e -o %results%
call jmeter.bat -Jjmeter.save.saveservice.autoflush=true -n  -t %test_file% -l %results%.jtl
call jmeter.bat -g %results%.jtl -o %results%

rem open the test directory and test results
set test_results=%apache_dir%\%results%
explorer %test_results%\index.html
