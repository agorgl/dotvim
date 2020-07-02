@echo off
setlocal EnableDelayedExpansion

:: Eclipse jdt.ls location
set srv_loc=%USERPROFILE%\.local\opt\jdtls

:: Project location from arguments
set prj_loc=%1

:: Project unique identifier from location
for /f "tokens=* usebackq" %%f in (`echo %prj_loc% ^| sha256sum`) do (set prj_uid=%%f)

:: Temporary project directory
set tmp_dir=%TEMP%\jdtls.%prj_uid:~0,6%
rmdir /s /q %tmp_dir% >nul

:: Copy the configuration folder to tmp to be writable
robocopy /E "%srv_loc%\config_win" "%tmp_dir%" >nul

:: Launcher jar
for /f "tokens=* usebackq" %%f in (`dir /s /b %srv_loc%\plugins\org.eclipse.equinox.launcher_*.jar`) do (set launcher_jar=%%f)

:: Launch jdtls
java ^
	-Declipse.application=org.eclipse.jdt.ls.core.id1 ^
	-Dosgi.bundles.defaultStartLevel=4 ^
	-Declipse.product=org.eclipse.jdt.ls.core.product ^
	-Dlog.level=ALL -noverify -Xmx1G -jar %launcher_jar% ^
	-configuration %tmp_dir%\config_win -data %tmp_dir%\workspace ^
	%*
