@echo off

REM using English
chcp 437 > $null
%* && exit 0 || exit 1
