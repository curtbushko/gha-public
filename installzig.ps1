https://ziglang.org/builds/zig-windows-x86_64-0.12.0-dev.640+937138cb9.zip
Invoke-WebRequest -Uri "https://ziglang.org/builds/zig-windows-x86_64-0.12.0-dev.640+937138cb9.zip" -OutFile ".\zig-windows.zip"
Expand-Archive -Path ".\zig-windows.zip" -DestinationPath ".\" -Force
Remove-Item -Path " .\zig-windows1.zip"
Rename-Item -Path ".\zig-windows-x86_64-0.12.0-dev.640+937138cb9" -NewName ".\zig"

Write-Host "Zig installed."
./zig/zig.exe version
