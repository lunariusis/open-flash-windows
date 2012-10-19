@echo off
cls

python ..\..\python\psd_parser.py %1 toswc
..\..\python\include_in_swc.jsfl
pause