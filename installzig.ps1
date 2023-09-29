$version = "zig-windows-x86_64-0.12.0-dev.640+937138cb9"
$uri = "https://ziglang.org/builds/$version.zip"
Invoke-WebRequest -Uri "$uri" -OutFile ".\zig-windows.zip"
Expand-Archive -Path ".\zig-windows.zip" -DestinationPath ".\" -Force
Remove-Item -Path ".\zig-windows.zip"
Rename-Item -Path ".\$version" -NewName ".\zig"

Write-Host "Zig installed."
./zig/zig.exe version
