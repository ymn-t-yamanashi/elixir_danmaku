@echo off
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Command ^
  "$utf8 = [System.Text.UTF8Encoding]::new($false); [Console]::OutputEncoding = $utf8; $OutputEncoding = $utf8; [System.Console]::InputEncoding = $utf8; powershell -NoLogo -NoProfile"
