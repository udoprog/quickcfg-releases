rem Read build_version and build the ref that it points to for windows

set /p version=<build_version

set exe=quickcfg.exe
set "target=%cd%\target"
set "bin=%target%\bin\%exe%"
set "upload=%target%\upload"

set "platform=windows"
set "arch=x86_64"
set "tuple=%version%-%platform%-%arch%"
set "archive=quickcfg-%tuple%.tar.gz"
set "git=https://github.com/udoprog/quickcfg"

echo Building: %tuple%

If NOT exist %bin% (
    cargo install --root %target% --git %git% --tag %version% quickcfg
)

If NOT exist %bin% (
    echo "Binary not found: %bin%"
    Exit 1
)

mkdir %upload%
pushd %target%\bin
7z a -ttar -so archive.tar %exe% | 7z a -si %upload%\%archive%
Exit 0
