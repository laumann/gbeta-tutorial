@echo off
rem 
rem   This script runs gbeta on the Windows
rem   platforms, setting up some env.vars first
rem
rem For installation you should only need to look at the lines
rem between "INSTALL BEGIN" and "INSTALL END".

rem ----- INSTALL BEGIN -----

rem GBETA_ROOT must point to the root directory of the gbeta installation 
if not defined GBETA_ROOT set GBETA_ROOT=c:\gbeta
if not defined GBETA_BASEDIR set GBETA_BASEDIR=%GBETA_ROOT%\tools\trunk\gbeta

rem ----- INSTALL END -----

rem Setup paths to the interpreter and to its grammar tables
set GBETA_METAGRAMMAR_PATH=%GBETA_BASEDIR%\grammars\metagram\metagrammar
set GBETA_GRAMMAR_PATH=%GBETA_BASEDIR%\grammars\beta\beta
set GBETA_GGRAMMAR_PATH=%GBETA_BASEDIR%\grammars\gbeta\gbeta
set GBETA=%GBETA_BASEDIR%\bin\gbetabin.exe

"%GBETA%" %1 %2 %3 %4 %5 %6 %7 %8 %9

rem Local variables:
rem mode: shell-script
rem end:
