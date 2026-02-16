@echo off
chcp 65001 >nul
title Установка Scanner 2 - NaitSide Custom Build

:: Проверка прав администратора
net session >nul 2>&1
if %errorlevel% neq 0 (
    cls
    echo.
    echo =========================================================
    echo    [ОШИБКА] Требуются права администратора!
    echo =========================================================
    echo.
    echo    Запустите скрипт правой кнопкой мыши
    echo    -^> "Запуск от имени администратора"
    echo.
    echo =========================================================
    echo.
    pause
    exit /b
)

cls
echo.
echo =========================================================
echo    Установка Scanner 2.13
echo    Disk Space Analyzer
echo    NaitSide Custom Build
echo =========================================================
echo.
echo    Этот скрипт установит Scanner в систему:
echo.
echo    • Копирование в Program Files
echo    • Ярлык в меню Пуск
echo    • Контекстное меню для папок и дисков
echo.
echo =========================================================
echo    Источник: http://steffengerlach.de/freeware/
echo    GitHub: github.com/NaitSide
echo =========================================================
echo.
pause

cls
echo.
echo =========================================================
echo    Выполнение...
echo =========================================================
echo.

REM Перейти в папку где лежит батник
cd /d "%~dp0"

REM Определение папки Program Files
set "INSTALL_DIR=%ProgramFiles%\Scanner"

REM Создание папки Scanner
if not exist "%INSTALL_DIR%" (
    echo    [1/4] Создание директории...
    mkdir "%INSTALL_DIR%"
) else (
    echo    [1/4] Директория существует...
)

REM Проверка наличия исходных файлов
if not exist "Scanner\Scanner.exe" (
    echo.
    echo    [ОШИБКА] Не найдена папка Scanner с файлами!
    echo.
    echo    Структура должна быть:
    echo    install_Scanner.bat
    echo    Scanner\
    echo        Scanner.exe
    echo        (остальные файлы)
    echo.
    pause
    exit /b 1
)

REM Копирование файлов
echo    [2/4] Копирование файлов...
xcopy /E /I /Y "Scanner" "%INSTALL_DIR%" >nul

if %errorlevel% neq 0 (
    echo.
    echo    [ОШИБКА] Не удалось скопировать файлы!
    echo.
    pause
    exit /b 1
)

REM Создание ярлыка в меню Пуск
echo    [3/4] Создание ярлыка в меню Пуск...
powershell -ExecutionPolicy Bypass -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%ProgramData%\Microsoft\Windows\Start Menu\Programs\Scanner.lnk'); $Shortcut.TargetPath = '%INSTALL_DIR%\Scanner.exe'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.Description = 'Disk Space Analyzer'; $Shortcut.Save()" 2>nul

REM Добавление в контекстное меню
echo    [4/4] Добавление в контекстное меню...

REM Контекстное меню для папок
reg add "HKCR\Directory\shell\Scan_Content" /ve /t REG_SZ /d "Show Usage with Scanner" /f >nul 2>&1
reg add "HKCR\Directory\shell\Scan_Content" /v "Icon" /t REG_SZ /d "%INSTALL_DIR%\Scanner.exe" /f >nul 2>&1
reg add "HKCR\Directory\shell\Scan_Content\command" /ve /t REG_SZ /d "\"%INSTALL_DIR%\Scanner.exe\" \"%%1\"" /f >nul 2>&1

REM Контекстное меню для дисков
reg add "HKCR\Drive\shell\Scan_Content" /ve /t REG_SZ /d "Show Usage with Scanner" /f >nul 2>&1
reg add "HKCR\Drive\shell\Scan_Content" /v "Icon" /t REG_SZ /d "%INSTALL_DIR%\Scanner.exe" /f >nul 2>&1
reg add "HKCR\Drive\shell\Scan_Content\command" /ve /t REG_SZ /d "\"%INSTALL_DIR%\Scanner.exe\" \"%%1\"" /f >nul 2>&1

cls
echo.
echo =========================================================
echo    ✓ Scanner 2.13 успешно установлен!
echo =========================================================
echo.
echo    Расположение:
echo    %INSTALL_DIR%
echo.
echo    Использование:
echo    • Меню Пуск: Scanner
echo    • ПКМ на папке: "Show Usage with Scanner"
echo    • ПКМ на диске: "Show Usage with Scanner"
echo.
echo =========================================================
echo    NaitSide Custom Build
echo    github.com/NaitSide
echo =========================================================
echo.
pause