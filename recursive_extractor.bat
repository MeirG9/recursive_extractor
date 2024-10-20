@echo off
setlocal EnableDelayedExpansion

:: Check if a target folder is provided
set "target_folder=%~1"
if "%target_folder%"=="" (
    echo Please provide a folder path.
    pause
    exit /b 1
)

:: Validate the existence of the target folder
if not exist "%target_folder%" (
    echo The folder "%target_folder%" does not exist.
    pause
    exit /b 1
)

:: Check for 7-Zip in default install location or PATH
where /q 7z.exe
if errorlevel 1 (
    if not exist "C:\Program Files\7-Zip\7z.exe" (
        echo 7-Zip is not installed or not in PATH.
        pause
        exit /b 1
    ) else (
        set "seven_zip=C:\Program Files\7-Zip\7z.exe"
    )
) else (
    set "seven_zip=7z.exe"
)

:: Initialize overwrite flags
set "overwrite_all="
set "skip_all="

echo Target folder: %target_folder%
pushd "%target_folder%"

FOR /D /r %%F in (".") DO (
    echo Processing folder: %%F
    pushd %%F

    FOR %%X in (*.rar *.zip *.7z) DO (
        set "archive_name=%%~nX"
        echo Extracting file: %%X

        :: Create a new folder if in a subfolder, to avoid overwriting
        if "%%~dpF" NEQ "%target_folder%\" (
            mkdir "!archive_name!" 2>nul
            FOR %%I IN ("!archive_name!\*") DO (
                if exist "%%~I" (
                    if defined skip_all (
                        echo Skipping extraction of %%~nxI
                        goto skip_file
                    )
                    if not defined overwrite_all (
                        echo File "%%~nxI" already exists in !archive_name!
                        set /p choice="Do you want to overwrite it? (Y/N/A for All): "
                        if /i "!choice!"=="A" (set "overwrite_all=1")
                        if /i "!choice!"=="N" (set "skip_all=1")
                        if /i "!choice!" NEQ "Y" if /i "!choice!" NEQ "A" (
                            echo Skipping extraction of %%~nxI
                            goto skip_file
                        )
                    )
                )
            )
            "%seven_zip%" x "%%X" -o"!archive_name!" >nul
        ) else (
            FOR %%I IN (*.*) DO (
                if exist "%%~I" (
                    if defined skip_all (
                        echo Skipping extraction of %%~nxI
                        goto skip_file
                    )
                    if not defined overwrite_all (
                        echo File "%%~nxI" already exists in the current folder.
                        set /p choice="Do you want to overwrite it? (Y/N/A for All): "
                        if /i "!choice!"=="A" (set "overwrite_all=1")
                        if /i "!choice!"=="N" (set "skip_all=1")
                        if /i "!choice!" NEQ "Y" if /i "!choice!" NEQ "A" (
                            echo Skipping extraction of %%~nxI
                            goto skip_file
                        )
                    )
                )
            )
            "%seven_zip%" x "%%X" >nul
        )
        :skip_file
        if errorlevel 1 (
            echo Error extracting %%X
        ) else (
            echo Extraction successful for %%X
        )
    )
    popd
)

popd
echo Extraction process completed.
endlocal
pause
