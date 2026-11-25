@echo off
rem 一键发布：把最新 index.html 推到 GitHub Pages
rem 用法：双击，或在命令行里 deploy.cmd "提交说明"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0deploy.ps1" %*
pause
