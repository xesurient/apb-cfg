@ECHO OFF
Color 9F
TITLE [V10] Esurient's Installer
set version=[V10] Esurient's Installer
COLOR C
mode con: cols=145 lines=30

if exist "%cd%\Backup\" ( 
  for /f "skip=5 tokens=1,2,4 delims= " %%a in (
   'dir /ad /tc "%cd%\Backup\."') do IF "%%c"=="." (
    set "dt=%%a"
    set backup=Backup Created: %%a, %%b
  )
) else ( 
  set backup=Backup: Not Found
)

if exist "%cd%\Files\Z\gdir.txt" ( 
set /p apb=< Files\Z\gdir.txt
goto MENU
  )
) else ( 
goto start
)

:START
Echo Drives:
Echo -----------------------------
wmic logicaldisk get caption,volumename
Echo -----------------------------
set /p Input=Select APB Drive [Manual Path = Blank]: 

IF "%Input%"=="" (GOTO PATH) ELSE (GOTO FIND)

:FIND
cls
echo Looking For APB Folder
for /d /r "%Input%:\" %%i in ("APB Reloaded") do @if exist "%%i" set apb=%%i
set apb=%apb:"=%
cls
echo APB Folder Found, Direcotry: %apb%

SET /P AREYOUSURE=Correct Path To APB? (Y/N): 
IF /I "%AREYOUSURE%" NEQ "Y" GOTO PATH
@echo %APB%> Files\Z\gdir.txt
cls
GOTO CHANGE_LOG

:MENU
COLOR C
cls
SET M==""
ECHO ---------------------------Welcome %username%
ECHO ----Esurient's Installer---------------------
ECHO ----------------Select Option From Below-----
ECHO ---------------------------------------------
ECHO  1: Config	    			[%cfg%]
ECHO ---------------------------------------------
ECHO  2: HUD Editor    			[%HUDED%]
ECHO ---------------------------------------------
ECHO  3: Alternative Files			[%lqc%]
ECHO  4: Optional Changes
ECHO ---------------------------------------------
ECHO  U: Update
ECHO  B: Backup/Update Game  		[%backup%]
ECHO  P: Change Current APB Path 		[%apb%]
ECHO ---------------------------------------------
ECHO  C: Changelog
ECHO ---------------------------------------------
ECHO  Q: EXIT
ECHO ---------------------------------------------
SET /P M=ENTER OPTION: 

IF "%M%"=="" (GOTO MENU) ELSE (GOTO MENU_LIST)

:MENU_LIST
IF %M%==1 GOTO CFG_PROMPT
IF %M%==2 GOTO HUDED_WARN
IF %M%==3 GOTO LQC_PROMPT
IF %M%==4 GOTO OPT_PROMPT
IF %M%==u GOTO UPDATE_PROMPT
IF %M%==U GOTO UPDATE_PRMOPT
IF %M%==b GOTO BACKUP_PROMPT
IF %M%==B GOTO BACKUP_PROMPT
IF %M%==p GOTO MENU_CHECK
IF %M%==P GOTO MENU_CHECK
IF %M%==c GOTO CHANGE_LOG
IF %M%==C GOTO CHANGE_LOG
IF %M%==q GOTO EXIT
IF %M%==Q GOTO EXIT

:MENU_CHECK
IF /I "%M%" NEQ "p" or "P" GOTO MENU

:PATH
cls
echo Copy Paste APB Path [E.g. F:\Program Files (x86)\Steam\steamapps\common\APB Reloaded]
set /p apb=APB Folder Path: 
del /q "%cd%\Files\Z\gdir.txt"
@echo %APB%> Files\Z\gdir.txt
cls
GOTO MENU

:CFG_PROMPT
cls
SET M==""
ECHO ---------------------------------------------
ECHO  Select Option:
ECHO ---------------------------------------------
ECHO  1: Install
ECHO ---------------------------------------------
ECHO  M: Main Menu
ECHO ---------------------------------------------
ECHO  Q: EXIT
ECHO ---------------------------------------------
SET /P M=ENTER OPTION:

IF "%M%"=="" (GOTO CFG_PROMPT) ELSE (GOTO CFG_LIST)

:CFG_LIST
IF %M%==1 GOTO CFG
IF %M%==m GOTO MENU
IF %M%==M GOTO MENU
IF %M%==q GOTO EXIT
IF %M%==Q GOTO EXIT
GOTO CFG_PROMPT
cls

:CFG
COLOR 0B
[7m                   
xcopy /s /y "Files\Z\n.ico" "%apb%\Binaries\."
xcopy /s /y "Files\Z\nn.ico" "%apb%\Binaries\."
del /q "%apb%\APBGame\Movies\."
xcopy /s /y "Files/Config" "%apb%"
[0m
COLOR C
cls
set MYPATH=%apb%
set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = "%USERPROFILE%\Desktop\APB Config.lnk" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%mypath%/Binaries/APB.exe" >> %SCRIPT%
echo oLink.Arguments = "-language=1031 -NoMovies -NoVerifyGC" >> %SCRIPT%
echo oLink.IconLocation = "%mypath%\Binaries\n.ico" >> %SCRIPT%
echo olink.WorkingDirectory = "%mypath%/Binaries/" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%
cscript /nologo %SCRIPT%
del %SCRIPT%
cls
GOTO CFG2

:CFG2
@echo off
setlocal enabledelayedexpansion
ECHO ---------------------------------------------
ECHO  Config: Installed
ECHO ---------------------------------------------
ECHO  Creating: Design Installation...
ECHO.
for %%i in ("%apb%") do set "parentdir=%%~dpi"
set "designfolder=!parentdir!APB Reloaded - Design"
xcopy "%apb%" "%designfolder%\" /E /I /H /Y /Q
if !errorlevel! neq 0 (
    echo Error: Copy Failed
    pause
    goto :eof
)
copy "%cd%\Backup\Engine\Config\BaseEngine.ini" "%designfolder%\Engine\Config\BaseEngine.ini" /Y
if !errorlevel! neq 0 (
    echo Warning: Could not copy BaseEngine.ini
)
copy "%cd%\Backup\APBGame\Config\DefaultEngine.ini" "%designfolder%\APBGame\Config\BaseEngine.ini" /Y
if !errorlevel! neq 0 (
    echo Warning: Could not copy DefaultEngine.ini
)
set MYPATH=%designfolder%
set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = "%USERPROFILE%\Desktop\APB Config - Design.lnk" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%mypath%/Binaries/APB.exe" >> %SCRIPT%
echo oLink.Arguments = "-language=1031 -NoVerifyGC" >> %SCRIPT%
echo oLink.IconLocation = "%apb%\Binaries\nn.ico" >> %SCRIPT%
echo olink.WorkingDirectory = "%mypath%/Binaries/" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%
cscript /nologo %SCRIPT%
del %SCRIPT%
endlocal
ECHO ---------------------------------------------
Echo Desktop: Shortcuts Created
ECHO ---------------------------------------------
pause
set CFG=x
goto MENU

:CHANGE_LOG
color 0f
cls
ECHO ---------------------------------------------
ECHO  Version: [7m%version%[0m
ECHO ---------------------------------------------
ECHO.
ECHO ---------------------------------------------
ECHO  [32mADDED[0m:
ECHO ---------------------------------------------
ECHO  [32m+[0m Installer Overhaul
ECHO ---------------------------------------------
ECHO.
ECHO ---------------------------------------------
ECHO  [31mREMOVED[0m:
ECHO ---------------------------------------------
ECHO  [31m-[0m Obsolete Options
ECHO ---------------------------------------------
ECHO.
ECHO ---------------------------------------------
ECHO  Do Not Use Max Frame Rate Unless You Have To
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
color C
goto MENU

:LQC_PROMPT
cls
SET M==""
ECHO ---------------------------------------------
ECHO  Select Option:
ECHO ---------------------------------------------
ECHO  1: Max Framerate			[%Frames%]
ECHO  3: Splash Screens 			[%splsh%]
ECHO  4: Custom Variants  		  	[%CVCC%]
ECHO  6: Enable Street Names 		[%esn%]
ECHO  7: Custom Color Killfeed 		[%cckf%]
ECHO  8: Current/Next Stage Tasks Only 	[%cnst%]
ECHO ---------------------------------------------
ECHO  M: Main Menu
ECHO ---------------------------------------------
ECHO  Q: EXIT
ECHO ---------------------------------------------
SET /P M=ENTER OPTION: 

IF "%M%"=="" (GOTO LQC_PROMPT) ELSE (GOTO LQC_LIST)

:LQC_LIST
IF %M%==1 GOTO MaxFrames1
IF %M%==3 GOTO SPLSH_PROMPT
IF %M%==4 GOTO CFG_CC
IF %M%==6 GOTO LQC1
IF %M%==7 GOTO LQC2_CC
IF %M%==8 GOTO LQC3
IF %M%==m GOTO MENU
IF %M%==M GOTO MENU
IF %M%==q GOTO EXIT
IF %M%==Q GOTO EXIT
GOTO LQC_PROMPT
cls

:CFG_CC
COLOR C
cls
SET M==""
ECHO ---------------------------------------------
ECHO  Select Option:
ECHO ---------------------------------------------
ECHO  1: Custom Variant 1		[%cv1%]
ECHO ---------------------------------------------
ECHO  P: Preview
ECHO ---------------------------------------------
ECHO  B: Back
ECHO  M: Main Menu
ECHO ---------------------------------------------
ECHO  Q: EXIT
ECHO ---------------------------------------------
SET /P M=ENTER OPTION: 

IF "%M%"=="" (GOTO CFG_CC) ELSE (GOTO CFG_LIST)

:CFG_LIST
IF %M%==1 GOTO CV1CC
IF %M%==p GOTO CFGCC_Preview
IF %M%==P GOTO CFGCC_Preview
IF %M%==b GOTO LQC_PROMPT
IF %M%==B GOTO LQC_PROMPT
IF %M%==m GOTO MENU
IF %M%==M GOTO MENU
IF %M%==q GOTO EXIT
IF %M%==Q GOTO EXIT
GOTO CFG_CC
cls

:CV1CC
xcopy /s /y "Files/Alt/CustomVariant1" "%apb%"
cls
ECHO ---------------------------------------------
ECHO  Installed: Custom Variant
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
set cv1=x
set CVCC=x
set lqc=x
goto CFG_CC

:CFGCC_Preview
COLOR B
cls
SET M==""
ECHO ---------------------------------------------
ECHO  Select Preview:
ECHO ---------------------------------------------
ECHO  1: Custom Variant
ECHO ---------------------------------------------
ECHO  B: Back
ECHO  M: Main Menu
ECHO ---------------------------------------------
ECHO  Q: EXIT
ECHO ---------------------------------------------
SET /P M=ENTER OPTION: 

IF "%M%"=="" (GOTO CFGCC_Preview) ELSE (GOTO CFGCC_PreviewList)

:CFGCC_PreviewList
IF %M%==1 GOTO strmr_preview
IF %M%==b GOTO CFG_CC
IF %M%==B GOTO CFG_CC
IF %M%==m GOTO MENU
IF %M%==M GOTO MENU
IF %M%==q GOTO EXIT
IF %M%==Q GOTO EXIT
GOTO CFGCC_Preview
cls

:strmr_preview
cls
START "" "Files\Alt\Previews\CV1.png"
ECHO ---------------------------------------------
ECHO  Preview: Oppened
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
GOTO CFGCC_Preview

:SPLSH_PROMPT
cls
SET M==""
ECHO ---------------------------------------------
ECHO  Select Option:
ECHO ---------------------------------------------
ECHO  1: Home 				[%SPL1%]
ECHO  2: Pier 				[%SPL2%]
ECHO  3: Skies 				[%SPL3%]
ECHO  4: Neon Sign 				[%SPL4%]
ECHO  5: Asylum Death 			[%SPL5%]
ECHO  6: Bird Mountain 			[%SPL6%]
ECHO  7: Lightning Clouds			[%SPL7%]
ECHO  8: Top-Down Airplane			[%SPL8%]
ECHO  9: Bird Mountain Alt			[%SPL9%]
ECHO ---------------------------------------------
ECHO  P: Preview
ECHO ---------------------------------------------
ECHO  B: Back
ECHO  M: Main Menu
ECHO ---------------------------------------------
ECHO  Q: EXIT
ECHO ---------------------------------------------
SET /P M=ENTER OPTION: 

IF "%M%"=="" (GOTO SPLSH_PROMPT) ELSE (GOTO SPLSH_LIST)

:SPLSH_LIST
IF %M%==1 GOTO SPL1
IF %M%==2 GOTO SPL2
IF %M%==3 GOTO SPL3
IF %M%==4 GOTO SPL4
IF %M%==5 GOTO SPL5
IF %M%==6 GOTO SPL6
IF %M%==7 GOTO SPL7
IF %M%==8 GOTO SPL8
IF %M%==9 GOTO SPL9
IF %M%==p GOTO SPL_Preview
IF %M%==P GOTO SPL_Preview
IF %M%==b GOTO LQC_PROMPT
IF %M%==B GOTO LQC_PROMPT
IF %M%==m GOTO MENU
IF %M%==M GOTO MENU
IF %M%==q GOTO EXIT
IF %M%==Q GOTO EXIT
GOTO SPLSH_PROMPT
cls

:SPL1
xcopy /s /y "Files/Alt/SplashScreens/1" "%apb%"
cls
ECHO ---------------------------------------------
ECHO  Splash Screen Installed: Home
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
COLOR C
set SPL1=x
set splsh=x
set lqc=x
GOTO SPLSH_PROMPT

:SPL2
xcopy /s /y "Files/Alt/SplashScreens/2" "%apb%"
cls
ECHO ---------------------------------------------
ECHO  Splash Screen Installed: Pier
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
COLOR C
set SPL2=x
set splsh=x
set lqc=x
GOTO SPLSH_PROMPT

:SPL3
xcopy /s /y "Files/Alt/SplashScreens/3" "%apb%"
cls
ECHO ---------------------------------------------
ECHO  Splash Screen Installed: Skies
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
COLOR C
set SPL3=x
set splsh=x
set lqc=x
GOTO SPLSH_PROMPT

:SPL4
xcopy /s /y "Files/Alt/SplashScreens/4" "%apb%"
cls
ECHO ---------------------------------------------
ECHO  Splash Screen Installed: Neon Sign
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
COLOR C
set SPL4=x
set splsh=x
set lqc=x
GOTO SPLSH_PROMPT

:SPL5
xcopy /s /y "Files/Alt/SplashScreens/5" "%apb%"
cls
ECHO ---------------------------------------------
ECHO  Splash Screen Installed: Asylum Death
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
COLOR C
set SPL5=x
set splsh=x
set lqc=x
GOTO SPLSH_PROMPT

:SPL6
xcopy /s /y "Files/Alt/SplashScreens/6" "%apb%"
cls
ECHO ---------------------------------------------
ECHO  Splash Screen Installed: Bird Mountain
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
COLOR C
set SPL6=x
set splsh=x
set lqc=x
GOTO SPLSH_PROMPT

:SPL7
xcopy /s /y "Files/Alt/SplashScreens/7" "%apb%"
cls
ECHO ---------------------------------------------
ECHO  Splash Screen Installed: Lightning Clouds
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
COLOR C
set SPL7=x
set splsh=x
set lqc=x
GOTO SPLSH_PROMPT

:SPL8
xcopy /s /y "Files/Alt/SplashScreens/8" "%apb%"
cls
ECHO ---------------------------------------------
ECHO  Splash Screen Installed: Top-Down Airplane
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
COLOR C
set SPL8=x
set splsh=x
set lqc=x
GOTO SPLSH_PROMPT

:SPL9
xcopy /s /y "Files/Alt/SplashScreens/9" "%apb%"
cls
ECHO ---------------------------------------------
ECHO  Splash Screen Installed: Bird Mountain (Alt)
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
COLOR C
set SPL9=x
set splsh=x
set lqc=x
GOTO SPLSH_PROMPT

:SPL_Preview
cls
START "" "Files\Alt\SplashScreens\preview.gif"
ECHO ---------------------------------------------
ECHO  Preview: Oppened
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
GOTO SPLSH_PROMPT

:LQC1
xcopy /s /y "Files/Alt/StreetNames" "%apb%"
cls
ECHO ---------------------------------------------
ECHO  Enabled: Street Names
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
COLOR C
set esn=x
set lqc=x
goto LQC_PROMPT

:LQC3
xcopy /s /y "Files/Alt/NextStage" "%apb%"
cls
ECHO ---------------------------------------------
ECHO  Installed: Next Stage 
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
COLOR C
set cnst=x
set lqc=x
goto LQC_PROMPT

:END_CC
xcopy /s /y "Files/Alt/Custom/output" "%apb%"
cls
COLOR B
ECHO ---------------------------------------------
ECHO  Installed: Custom Killfeed
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
COLOR C
set cckf=x
set lqc=x
goto LQC_PROMPT

:OPT_PROMPT
cls
SET M==""
ECHO ---------------------------------------------
ECHO  Select Option:
ECHO ---------------------------------------------
ECHO  1: Launch Shortcuts			[%lscs%]
ECHO ---------------------------------------------
ECHO  M: Main Menu
ECHO ---------------------------------------------
ECHO  Q: EXIT
ECHO ---------------------------------------------
SET /P M=ENTER OPTION: 

IF "%M%"=="" (GOTO OPT_PROMPT) ELSE (GOTO OPT_LIST)

:OPT_LIST
IF %M%==1 GOTO LaunchShortcuts_Prompt
IF %M%==m GOTO MENU
IF %M%==M GOTO MENU
IF %M%==q GOTO EXIT
IF %M%==Q GOTO EXIT
GOTO OPT_PROMPT
cls

:LaunchShortcuts_Prompt
cls
SET M==""
ECHO ---------------------------------------------
ECHO  Select Option:
ECHO ---------------------------------------------
ECHO  1: Use All Cores  			[%ALLCORE%]
ECHO  2: Use All Cores / No Movies	 	[%uanm%]
ECHO ---------------------------------------------
ECHO  B: Back
ECHO  M: Main Menu
ECHO ---------------------------------------------
ECHO  Q: EXIT
ECHO ---------------------------------------------
SET /P M=ENTER OPTION: 

IF "%M%"=="" (GOTO LaunchShortcuts_Prompt) ELSE (GOTO LaunchShortcuts_LIST)

:LaunchShortcuts_LIST
IF %M%==1 GOTO ALL_CORE
IF %M%==2 GOTO ALL_CORE_NM
IF %M%==b GOTO OPT_PROMPT
IF %M%==B GOTO OPT_PROMPT
IF %M%==m GOTO MENU
IF %M%==M GOTO MENU
IF %M%==q GOTO EXIT
IF %M%==Q GOTO EXIT
GOTO LaunchShortcuts_PROMPT
cls

:ALL_CORE
xcopy /s /y "Files\Z\n.ico" "%apb%\Binaries\."
cls
set MYPATH=%apb%
set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = "%USERPROFILE%\Desktop\APB Config - All Cores.lnk" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%mypath%/Binaries/APB.exe" >> %SCRIPT%
echo oLink.Arguments = "-language=1031 -LanPlay -PrimaryNet -USEALLAVAILABLECORES" >> %SCRIPT%
echo oLink.IconLocation = "%mypath%\Binaries\n.ico" >> %SCRIPT%
echo olink.WorkingDirectory = "%mypath%/Binaries/" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%
cscript /nologo %SCRIPT%
del %SCRIPT%
COLOR E
ECHO ---------------------------------------------
ECHO  Warning: Experimental
ECHO  Shortcut Created: Use All Available Cores
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
COLOR C
set ALLCORE=x
set lscs=x
goto LaunchShortcuts

:ALL_CORE_NM
xcopy /s /y "Files\Z\n.ico" "%apb%\Binaries\."
cls

set MYPATH=%apb%
set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = "%USERPROFILE%\Desktop\APB Config - All Cores.lnk" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%mypath%/Binaries/APB.exe" >> %SCRIPT%
echo oLink.Arguments = "-language=1031 -LanPlay -PrimaryNet -nomoviesstartup -USEALLAVAILABLECORES" >> %SCRIPT%
echo oLink.IconLocation = "%mypath%\Binaries\n.ico" >> %SCRIPT%
echo olink.WorkingDirectory = "%mypath%/Binaries/" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%
cscript /nologo %SCRIPT%
del %SCRIPT%
COLOR E
ECHO ---------------------------------------------
ECHO  Warning: Experimental
ECHO  Shortcut Created: Use All Available Cores (NM)
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
COLOR C
set uanm=x
set lscs=x
goto LaunchShortcuts

:BACKUP_PROMPT
cls
tasklist /fi "imagename eq APB.exe" | find ":" > nul
if %errorlevel%==0 (
    COLOR ED
    ECHO ---------------------------------------------
    ECHO APB.EXE IS RUNNING!
    ECHO CLOSE THE PROCESS BEFORE CONTINUING!
    ECHO THIS COULD BREAK THE BACKUP/RESTORE PROCESS!
    ECHO ---------------------------------------------
    TaskMgr
    tasklist /fi "imagename eq APB.exe" | find ":" > nul
    if %errorlevel%==0 (
        GOTO MENU
    )
)
COLOR C
SET M==""
ECHO ---------------------------------------------
ECHO  Select Option:
ECHO ---------------------------------------------
ECHO  %backup%
ECHO ---------------------------------------------
ECHO  B: Backup
ECHO  R: Restore (Original Files)
ECHO ---------------------------------------------
ECHO  P: Open Backup Location
ECHO ---------------------------------------------
ECHO  M: Main Menu
ECHO ---------------------------------------------
ECHO  Q: EXIT
ECHO ---------------------------------------------
SET /P M=ENTER OPTION: 

IF "%M%"=="" (GOTO BACKUP_PROMPT) ELSE (GOTO BACKUP_LIST)

:BACKUP_LIST
IF %M%==B GOTO BACKUP
IF %M%==b GOTO BACKUP
IF %M%==R GOTO RESTORE
IF %M%==r GOTO RESTORE
IF %M%==P GOTO BACKUPLOC
IF %M%==p GOTO BACKUPLOC
IF %M%==m GOTO MENU
IF %M%==M GOTO MENU
IF %M%==q GOTO EXIT
IF %M%==Q GOTO EXIT
GOTO BACKUP_PROMPT
cls

:BACKUP
if exist "%cd%\Backup\" GOTO BACKUPWARN
if not exist "%cd%\Backup\" mkdir "Backup"
xcopy /s /y /i "%apb%\" "%cd%\Backup\"

if exist "%cd%\Backup\" ( 
  for /f "skip=5 tokens=1,2,4 delims= " %%a in (
   'dir /ad /tc "%cd%\Backup\."') do IF "%%c"=="." (
    set "dt=%%a"
    set backup=Backup Created: %%a, %%b
  )
) else ( 
  set backup=Backup: None Found
)
GOTO MENU

:BACKUPWARN
color 0f
cls
ECHO ---------------------------------------------
ECHO  NOTE! NOTE! NOTE!
ECHO ---------------------------------------------
ECHO  Backup already exists.
ECHO  Launcher will redirect to backup menu.
ECHO ---------------------------------------------
ECHO.
ECHO ---------------------------------------------
ECHO  Backup should contain only the clean game.
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
cls
color C
GOTO BACKUP_PROMPT

:RESTORE
if not exist "%cd%\Backup\" goto BACKUP_PROMPT
del /q "%apb%\*"
xcopy /s /y /i "%cd%\Backup\*" "%apb%"
GOTO MENU

:BACKUPLOC
cls
explorer "%cd%\Backup"
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Opening: Backup Location
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
COLOR C
GOTO BACKUP_PROMPT

:LQC2_CC
cls
del /q "%cd%\Files\Alt\Custom\output\APBGame\Localization\GER\HUDMessages.GER"
cls
GOTO CUSTOMFEED

:CUSTOMFEED
@echo off
cls
del /q "%cd%\Files\Alt\Custom\output\APBGame\Localization\GER\HUDMessages.GER"
cls
setLocal DisableDelayedExpansion

echo Select Color: Team
echo E.g. Red, Green, Blue. Purple, White
echo Supported Colors: https://pastebin.com/zKQUk4Cs
set /p friendly=Color: 
cls

echo Select Color: Enemy
echo E.g. Red, Green, Blue. Purple, White
echo Supported Colors: https://pastebin.com/zKQUk4Cs
set /p enemy=Color: 
cls
for /f "tokens=* delims= " %%G in (Files\Alt\Custom\base.txt) do (
    set str=%%G
    setLocal EnableDelayedExpansion
	
    set str=!str:xxxxx=%friendly%!
    set str=!str:zzzzz=%enemy%!
    >> Files\Alt\Custom\output\APBGame\Localization\GER\HUDMessages.GER echo(!str!
    endlocal
)
COLOR C
ECHO ---------------------------------------------
ECHO  Created: Custom Killfeed
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
COLOR C
GOTO END_CC

:MaxFrames1
cls
del /q "%cd%\Files\Misc\MaxFrames\output\Engine\Config\BaseEngine.ini"
cls
GOTO MaxFrames2

:MaxFrames2
@echo off
setlocal enabledelayedexpansion

ECHO ---------------------------------------------
ECHO  Max Game Framerate: Number
ECHO ---------------------------------------------
ECHO  Recommended: RefreshRate + 1
ECHO ---------------------------------------------
set /p maxframemax=MaxClientFrameRate: 
cls

set "inputfile=%apb%\Engine\Config\BaseEngine.ini"
set "tempfile=%inputfile%.tmp"

(for /f "usebackq tokens=* delims=" %%G in ("%inputfile%") do (
    set "line=%%G"
    if "!line:~0,19!"=="MaxClientFrameRate=" (
        echo MaxClientFrameRate=%maxframemax%
    ) else (
        echo !line!
    )
)) > "%tempfile%"

rem Overwrite original file with tempfile
move /y "%tempfile%" "%inputfile%"

endlocal

cls
GOTO EndFrames

:EndFrames
cls
COLOR B
ECHO ---------------------------------------------
ECHO  Installed: Custom Max Frame Cap
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
COLOR C
set frames=x
set lqc=x
goto LQC_PROMPT

:HUDED_WARN
cls
SET M==""
ECHO ---------------------------------------------
ECHO  Select Option:
ECHO ---------------------------------------------
ECHO  1:  Toggle: Cash				[%HCSH%]
ECHO  2:  Toggle: Radar				[%HRAD%]
ECHO  3:  Toggle: Clock				[%HDTC%]
ECHO  4:  Toggle: Usables				[%HUSE%]
ECHO  5:  Toggle: Killfeed				[%HACT%]
ECHO  6:  Toggle: Tutorial				[%HTUT%]
ECHO  7:  Toggle: Crosshair				[%HRET%]
ECHO  8:  Toggle: Player List			[%HGRP%]
ECHO  9:  Toggle: Dirty Money			[%HOPW%]
ECHO  10: Toggle: Bottom Pop-Ups			[%HCMB%]
ECHO  11: Toggle: Progress Circle			[%HCSA%]
ECHO  12: Toggle: Health Indicator			[%HHLT%]
ECHO  13: Toggle: Daily Activities			[%HDLY%]
ECHO  14: Toggle: Ceremony Pop-Ups			[%HCER%]
ECHO  15: Toggle: Minigame Overlay			[%HMIN%]
ECHO  16: Toggle: Radial Hit Marker			[%HHIT%]
ECHO  17: Toggle: Contact Progression		[%HCON%]
ECHO  18: Toggle: Fight Club Challenges		[%HCHL%]
ECHO  19: Toggle: Held Items/Grenades Icon		[%HCRG%]
ECHO  20: Toggle: Prestige/Notoriety Meter		[%HHET%]
ECHO  21: Toggle: Icons (Rank/Money/JT/Weapon)	[%HAPB%]
ECHO  22: Toggle: Weapon Ammo/Reload/Resupply Text 	[%HWPN%]
ECHO ---------------------------------------------
ECHO  O: Change: Opacity				[%HDOP%]
ECHO  R: Restore: Default				[%HDFLT%]
ECHO ---------------------------------------------
ECHO  P: Preview
ECHO ---------------------------------------------
ECHO  M: Main Menu
ECHO ---------------------------------------------
ECHO  Q: EXIT
ECHO ---------------------------------------------
SET /P M=ENTER OPTION: 

IF "%M%"=="" (GOTO HUDED_PROMPT) ELSE (GOTO HUDED_LIST)

:HUDED_LIST
IF %M%==1 GOTO RMCash
IF %M%==2 GOTO RMRadar
IF %M%==3 GOTO RMClck
IF %M%==4 GOTO RMUsables
IF %M%==5 GOTO RMAction
IF %M%==6 GOTO RMTutorial
IF %M%==7 GOTO RMReticule
IF %M%==8 GOTO RMGrpMet
IF %M%==9 GOTO RMOpenWorld
IF %M%==10 GOTO RMCombat
IF %M%==11 GOTO RMCSA
IF %M%==12 GOTO RMHealth
IF %M%==13 GOTO RMDaily
IF %M%==14 GOTO RMCeremony
IF %M%==15 GOTO RMMinigame
IF %M%==16 GOTO RMHitIndicators
IF %M%==17 GOTO RMContact
IF %M%==18 GOTO RMChallenges
IF %M%==19 GOTO RMCargo
IF %M%==20 GOTO RMHeat
IF %M%==21 GOTO RMAPBImages
IF %M%==22 GOTO RMWeapon
IF %M%==O GOTO RMMet
IF %M%==o GOTO RMMet
IF %M%==R GOTO RMStock
IF %M%==r GOTO RMStock
IF %M%==P GOTO HUD_PREVIEW
IF %M%==p GOTO HUD_PREVIEW
IF %M%==m GOTO MENU
IF %M%==M GOTO MENU
IF %M%==q GOTO EXIT
IF %M%==Q GOTO EXIT
GOTO HUDED_PROMPT
cls

:RMStock
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Reverting to Stock Configuration...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "changesCount=0"

ECHO  Modifying File...

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    
    echo !line! | findstr /i "GlobalDataStoreClasses.*APBUserInterface\.cUIDataStore" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            echo !line:~1!
            set /a changesCount+=1
        ) else (
            echo !line!
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

endlocal & set "HDTC=o" & set "HRET=o" & set "HWPN=o" & set "HGRP=o" & set "HACT=o" & set "HHIT=o" & set "HHLT=o" & set "HCSA=o" & set "HRAD=o" & set "HUSE=o" & set "HCSH=o" & set "HCMB=o" & set "HCRG=o" & set "HCON=o" & set "HHET=o" & set "HTUT=o" & set "HOPW=o" & set "HCHL=o" & set "HDLY=o" & set "HMIN=o" & set "HAPB=o" & set "HCER=o" & set "HDFLT=x" & set "HUDED=x"

cls
COLOR B
ECHO ---------------------------------------------
ECHO  Stock Configuration Restored
ECHO ---------------------------------------------
ECHO  All HUD Elements: ENABLED
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
COLOR C
goto HUDED_WARN

set HUDED=x
set HDFLT=x
goto HUDED_WARN

:RMWeapon
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Detecting Current State...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "currentState=unknown"

for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_WeaponInfo" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            set "currentState=disabled"
        ) else (
            set "currentState=enabled"
        )
    )
)

if "!currentState!"=="enabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Disabling Weapon Info...
    set "finalState=disabled"
) else if "!currentState!"=="disabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Enabling Weapon Info...
    set "finalState=enabled"
) else (
    ECHO  Current State: Line not found
    ECHO  Action: No changes made
    pause
    goto :eof
)

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_WeaponInfo" >nul
    if !errorlevel! equ 0 (
        if "!currentState!"=="enabled" (
            if "!line:~0,1!"==";" (
                echo !line!
            ) else (
                echo ;!line!
            )
        ) else (
            if "!line:~0,1!"==";" (
                echo !line:~1!
            ) else (
                echo !line!
            )
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

if "!finalState!"=="enabled" (
    endlocal & set "HWPN=o" & set "HUDED=x"
) else (
    endlocal & set "HWPN=x" & set "HUDED=x"
)

cls
COLOR C
goto HUDED_WARN

:RMHitIndicators
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Detecting Current State...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "currentState=unknown"

for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_HitIndicators" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            set "currentState=disabled"
        ) else (
            set "currentState=enabled"
        )
    )
)

if "!currentState!"=="enabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Disabling Hit Indicators...
    set "finalState=disabled"
) else if "!currentState!"=="disabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Enabling Hit Indicators...
    set "finalState=enabled"
) else (
    ECHO  Current State: Line not found
    ECHO  Action: No changes made
    pause
    goto :eof
)

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_HitIndicators" >nul
    if !errorlevel! equ 0 (
        if "!currentState!"=="enabled" (
            if "!line:~0,1!"==";" (
                echo !line!
            ) else (
                echo ;!line!
            )
        ) else (
            if "!line:~0,1!"==";" (
                echo !line:~1!
            ) else (
                echo !line!
            )
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

if "!finalState!"=="enabled" (
    endlocal & set "HHIT=o" & set "HUDED=x"
) else (
    endlocal & set "HHIT=x" & set "HUDED=x"
)

cls
COLOR C
goto HUDED_WARN

:RMReticule
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Detecting Current State...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "currentState=unknown"

for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Reticule" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            set "currentState=disabled"
        ) else (
            set "currentState=enabled"
        )
    )
)

if "!currentState!"=="enabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Disabling Crosshair...
    set "finalState=disabled"
) else if "!currentState!"=="disabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Enabling Crosshair...
    set "finalState=enabled"
) else (
    ECHO  Current State: Line not found
    ECHO  Action: No changes made
    pause
    goto :eof
)

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Reticule" >nul
    if !errorlevel! equ 0 (
        if "!currentState!"=="enabled" (
            if "!line:~0,1!"==";" (
                echo !line!
            ) else (
                echo ;!line!
            )
        ) else (
            if "!line:~0,1!"==";" (
                echo !line:~1!
            ) else (
                echo !line!
            )
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

if "!finalState!"=="enabled" (
    endlocal & set "HRET=o" & set "HUDED=x"
) else (
    endlocal & set "HRET=x" & set "HUDED=x"
)

cls
COLOR C
goto HUDED_WARN

:RMAction
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Detecting Current State...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "currentState=unknown"

for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_ActionMessage" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            set "currentState=disabled"
        ) else (
            set "currentState=enabled"
        )
    )
)

if "!currentState!"=="enabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Disabling Killfeed...
    set "finalState=disabled"
) else if "!currentState!"=="disabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Enabling Killfeed...
    set "finalState=enabled"
) else (
    ECHO  Current State: Line not found
    ECHO  Action: No changes made
    pause
    goto :eof
)

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_ActionMessage" >nul
    if !errorlevel! equ 0 (
        if "!currentState!"=="enabled" (
            if "!line:~0,1!"==";" (
                echo !line!
            ) else (
                echo ;!line!
            )
        ) else (
            if "!line:~0,1!"==";" (
                echo !line:~1!
            ) else (
                echo !line!
            )
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

if "!finalState!"=="enabled" (
    endlocal & set "HACT=o" & set "HUDED=x"
) else (
    endlocal & set "HACT=x" & set "HUDED=x"
)

cls
COLOR C
goto HUDED_WARN

:RMOpenWorld
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Detecting Current State...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "currentState=unknown"

for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_OpenWorld" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            set "currentState=disabled"
        ) else (
            set "currentState=enabled"
        )
    )
)

if "!currentState!"=="enabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Disabling Dirty Money...
    set "finalState=disabled"
) else if "!currentState!"=="disabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Enabling Dirty Money...
    set "finalState=enabled"
) else (
    ECHO  Current State: Line not found
    ECHO  Action: No changes made
    pause
    goto :eof
)

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_OpenWorld" >nul
    if !errorlevel! equ 0 (
        if "!currentState!"=="enabled" (
            if "!line:~0,1!"==";" (
                echo !line!
            ) else (
                echo ;!line!
            )
        ) else (
            if "!line:~0,1!"==";" (
                echo !line:~1!
            ) else (
                echo !line!
            )
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

if "!finalState!"=="enabled" (
    endlocal & set "HOPW=o" & set "HUDED=x"
) else (
    endlocal & set "HOPW=x" & set "HUDED=x"
)

cls
COLOR C
goto HUDED_WARN

:RMCeremony
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Detecting Current State...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "currentState=unknown"

for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Ceremony" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            set "currentState=disabled"
        ) else (
            set "currentState=enabled"
        )
    )
)

if "!currentState!"=="enabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Disabling Ceremony...
    set "finalState=disabled"
) else if "!currentState!"=="disabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Enabling Ceremony...
    set "finalState=enabled"
) else (
    ECHO  Current State: Line not found
    ECHO  Action: No changes made
    pause
    goto :eof
)

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Ceremony" >nul
    if !errorlevel! equ 0 (
        if "!currentState!"=="enabled" (
            if "!line:~0,1!"==";" (
                echo !line!
            ) else (
                echo ;!line!
            )
        ) else (
            if "!line:~0,1!"==";" (
                echo !line:~1!
            ) else (
                echo !line!
            )
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

if "!finalState!"=="enabled" (
    endlocal & set "HCER=o" & set "HUDED=x"
) else (
    endlocal & set "HCER=x" & set "HUDED=x"
)

cls
COLOR C
goto HUDED_WARN

:RMAPBImages
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Detecting Current State...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "currentState=unknown"

for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_APBImages" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            set "currentState=disabled"
        ) else (
            set "currentState=enabled"
        )
    )
)

if "!currentState!"=="enabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Disabling Icons...
    set "finalState=disabled"
) else if "!currentState!"=="disabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Enabling Icons...
    set "finalState=enabled"
) else (
    ECHO  Current State: Line not found
    ECHO  Action: No changes made
    pause
    goto :eof
)

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_APBImages" >nul
    if !errorlevel! equ 0 (
        if "!currentState!"=="enabled" (
            if "!line:~0,1!"==";" (
                echo !line!
            ) else (
                echo ;!line!
            )
        ) else (
            if "!line:~0,1!"==";" (
                echo !line:~1!
            ) else (
                echo !line!
            )
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

if "!finalState!"=="enabled" (
    endlocal & set "HAPB=o" & set "HUDED=x"
) else (
    endlocal & set "HAPB=x" & set "HUDED=x"
)

cls
COLOR C
goto HUDED_WARN

:RMMinigame
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Detecting Current State...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "currentState=unknown"

for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Minigame" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            set "currentState=disabled"
        ) else (
            set "currentState=enabled"
        )
    )
)

if "!currentState!"=="enabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Disabling Minigame...
    set "finalState=disabled"
) else if "!currentState!"=="disabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Enabling Minigame...
    set "finalState=enabled"
) else (
    ECHO  Current State: Line not found
    ECHO  Action: No changes made
    pause
    goto :eof
)

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Minigame" >nul
    if !errorlevel! equ 0 (
        if "!currentState!"=="enabled" (
            if "!line:~0,1!"==";" (
                echo !line!
            ) else (
                echo ;!line!
            )
        ) else (
            if "!line:~0,1!"==";" (
                echo !line:~1!
            ) else (
                echo !line!
            )
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

if "!finalState!"=="enabled" (
    endlocal & set "HMIN=o" & set "HUDED=x"
) else (
    endlocal & set "HMIN=x" & set "HUDED=x"
)

cls
COLOR C
goto HUDED_WARN

:RMDaily
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Detecting Current State...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "currentState=unknown"

for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_DailyActivities" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            set "currentState=disabled"
        ) else (
            set "currentState=enabled"
        )
    )
)

if "!currentState!"=="enabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Disabling Daily Activities...
    set "finalState=disabled"
) else if "!currentState!"=="disabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Enabling Daily Activities...
    set "finalState=enabled"
) else (
    ECHO  Current State: Line not found
    ECHO  Action: No changes made
    pause
    goto :eof
)

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_DailyActivities" >nul
    if !errorlevel! equ 0 (
        if "!currentState!"=="enabled" (
            if "!line:~0,1!"==";" (
                echo !line!
            ) else (
                echo ;!line!
            )
        ) else (
            if "!line:~0,1!"==";" (
                echo !line:~1!
            ) else (
                echo !line!
            )
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

if "!finalState!"=="enabled" (
    endlocal & set "HDLY=o" & set "HUDED=x"
) else (
    endlocal & set "HDLY=x" & set "HUDED=x"
)

cls
COLOR C
goto HUDED_WARN

:RMChallenges
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Detecting Current State...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "currentState=unknown"

for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Challenges" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            set "currentState=disabled"
        ) else (
            set "currentState=enabled"
        )
    )
)

if "!currentState!"=="enabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Disabling Fight Club Challenges...
    set "finalState=disabled"
) else if "!currentState!"=="disabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Enabling Fight Club Challenges...
    set "finalState=enabled"
) else (
    ECHO  Current State: Line not found
    ECHO  Action: No changes made
    pause
    goto :eof
)

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Challenges" >nul
    if !errorlevel! equ 0 (
        if "!currentState!"=="enabled" (
            if "!line:~0,1!"==";" (
                echo !line!
            ) else (
                echo ;!line!
            )
        ) else (
            if "!line:~0,1!"==";" (
                echo !line:~1!
            ) else (
                echo !line!
            )
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

if "!finalState!"=="enabled" (
    endlocal & set "HCHL=o" & set "HUDED=x"
) else (
    endlocal & set "HCHL=x" & set "HUDED=x"
)

cls
COLOR C
goto HUDED_WARN

:RMTutorial
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Detecting Current State...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "currentState=unknown"

for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Tutorial" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            set "currentState=disabled"
        ) else (
            set "currentState=enabled"
        )
    )
)

if "!currentState!"=="enabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Disabling Tutorial...
    set "finalState=disabled"
) else if "!currentState!"=="disabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Enabling Tutorial...
    set "finalState=enabled"
) else (
    ECHO  Current State: Line not found
    ECHO  Action: No changes made
    pause
    goto :eof
)

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Tutorial" >nul
    if !errorlevel! equ 0 (
        if "!currentState!"=="enabled" (
            if "!line:~0,1!"==";" (
                echo !line!
            ) else (
                echo ;!line!
            )
        ) else (
            if "!line:~0,1!"==";" (
                echo !line:~1!
            ) else (
                echo !line!
            )
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

if "!finalState!"=="enabled" (
    endlocal & set "HTUT=o" & set "HUDED=x"
) else (
    endlocal & set "HTUT=x" & set "HUDED=x"
)

cls
COLOR C
goto HUDED_WARN


:RMHeat
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Detecting Current State...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "currentState=unknown"

for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Heat" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            set "currentState=disabled"
        ) else (
            set "currentState=enabled"
        )
    )
)

if "!currentState!"=="enabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Disabling Heat Indicator...
    set "finalState=disabled"
) else if "!currentState!"=="disabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Enabling Heat Indicator...
    set "finalState=enabled"
) else (
    ECHO  Current State: Line not found
    ECHO  Action: No changes made
    pause
    goto :eof
)

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Heat" >nul
    if !errorlevel! equ 0 (
        if "!currentState!"=="enabled" (
            if "!line:~0,1!"==";" (
                echo !line!
            ) else (
                echo ;!line!
            )
        ) else (
            if "!line:~0,1!"==";" (
                echo !line:~1!
            ) else (
                echo !line!
            )
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

if "!finalState!"=="enabled" (
    endlocal & set "HHET=o" & set "HUDED=x"
) else (
    endlocal & set "HHET=x" & set "HUDED=x"
)

cls
COLOR C
goto HUDED_WARN

:RMContact
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Detecting Current State...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "currentState=unknown"

for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Contact" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            set "currentState=disabled"
        ) else (
            set "currentState=enabled"
        )
    )
)

if "!currentState!"=="enabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Disabling Contact Progression...
    set "finalState=disabled"
) else if "!currentState!"=="disabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Enabling Contact Progression...
    set "finalState=enabled"
) else (
    ECHO  Current State: Line not found
    ECHO  Action: No changes made
    pause
    goto :eof
)

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Contact" >nul
    if !errorlevel! equ 0 (
        if "!currentState!"=="enabled" (
            if "!line:~0,1!"==";" (
                echo !line!
            ) else (
                echo ;!line!
            )
        ) else (
            if "!line:~0,1!"==";" (
                echo !line:~1!
            ) else (
                echo !line!
            )
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

if "!finalState!"=="enabled" (
    endlocal & set "HCON=o" & set "HUDED=x"
) else (
    endlocal & set "HCON=x" & set "HUDED=x"
)

cls
COLOR C
goto HUDED_WARN

:RMCombat
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Detecting Current State...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "currentState=unknown"

for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_CombatMsgs" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            set "currentState=disabled"
        ) else (
            set "currentState=enabled"
        )
    )
)

if "!currentState!"=="enabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Disabling Combat Messages...
    set "finalState=disabled"
) else if "!currentState!"=="disabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Enabling Combat Messages...
    set "finalState=enabled"
) else (
    ECHO  Current State: Line not found
    ECHO  Action: No changes made
    pause
    goto :eof
)

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_CombatMsgs" >nul
    if !errorlevel! equ 0 (
        if "!currentState!"=="enabled" (
            if "!line:~0,1!"==";" (
                echo !line!
            ) else (
                echo ;!line!
            )
        ) else (
            if "!line:~0,1!"==";" (
                echo !line:~1!
            ) else (
                echo !line!
            )
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

if "!finalState!"=="enabled" (
    endlocal & set "HCMB=o" & set "HUDED=x"
) else (
    endlocal & set "HCMB=x" & set "HUDED=x"
)

cls
COLOR C
goto HUDED_WARN

:RMCargo
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Detecting Current State...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "currentState=unknown"

for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Cargo" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            set "currentState=disabled"
        ) else (
            set "currentState=enabled"
        )
    )
)

if "!currentState!"=="enabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Disabling Cargo/Grenades...
    set "finalState=disabled"
) else if "!currentState!"=="disabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Enabling Cargo/Grenades...
    set "finalState=enabled"
) else (
    ECHO  Current State: Line not found
    ECHO  Action: No changes made
    pause
    goto :eof
)

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Cargo" >nul
    if !errorlevel! equ 0 (
        if "!currentState!"=="enabled" (
            if "!line:~0,1!"==";" (
                echo !line!
            ) else (
                echo ;!line!
            )
        ) else (
            if "!line:~0,1!"==";" (
                echo !line:~1!
            ) else (
                echo !line!
            )
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

if "!finalState!"=="enabled" (
    endlocal & set "HCRG=o" & set "HUDED=x"
) else (
    endlocal & set "HCRG=x" & set "HUDED=x"
)

cls
COLOR C
goto HUDED_WARN

:RMCash
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Detecting Current State...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "currentState=unknown"

for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Cash" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            set "currentState=disabled"
        ) else (
            set "currentState=enabled"
        )
    )
)

if "!currentState!"=="enabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Disabling Cash...
    set "finalState=disabled"
) else if "!currentState!"=="disabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Enabling Cash...
    set "finalState=enabled"
) else (
    ECHO  Current State: Line not found
    ECHO  Action: No changes made
    pause
    goto :eof
)

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Cash" >nul
    if !errorlevel! equ 0 (
        if "!currentState!"=="enabled" (
            if "!line:~0,1!"==";" (
                echo !line!
            ) else (
                echo ;!line!
            )
        ) else (
            if "!line:~0,1!"==";" (
                echo !line:~1!
            ) else (
                echo !line!
            )
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

if "!finalState!"=="enabled" (
    endlocal & set "HCSH=o" & set "HUDED=x"
) else (
    endlocal & set "HCSH=x" & set "HUDED=x"
)

cls
COLOR C
goto HUDED_WARN


:RMUsables
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Detecting Current State...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "currentState=unknown"

for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Usables" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            set "currentState=disabled"
        ) else (
            set "currentState=enabled"
        )
    )
)

if "!currentState!"=="enabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Disabling Usables...
    set "finalState=disabled"
) else if "!currentState!"=="disabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Enabling Usables...
    set "finalState=enabled"
) else (
    ECHO  Current State: Line not found
    ECHO  Action: No changes made
    pause
    goto :eof
)

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Usables" >nul
    if !errorlevel! equ 0 (
        if "!currentState!"=="enabled" (
            if "!line:~0,1!"==";" (
                echo !line!
            ) else (
                echo ;!line!
            )
        ) else (
            if "!line:~0,1!"==";" (
                echo !line:~1!
            ) else (
                echo !line!
            )
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

if "!finalState!"=="enabled" (
    endlocal & set "HUSE=o" & set "HUDED=x"
) else (
    endlocal & set "HUSE=x" & set "HUDED=x"
)

cls
COLOR C
goto HUDED_WARN


:RMRadar
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Detecting Current State...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "currentState=unknown"

for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Radar" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            set "currentState=disabled"
        ) else (
            set "currentState=enabled"
        )
    )
)

if "!currentState!"=="enabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Disabling Radar...
    set "finalState=disabled"
) else if "!currentState!"=="disabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Enabling Radar...
    set "finalState=enabled"
) else (
    ECHO  Current State: Line not found
    ECHO  Action: No changes made
    pause
    goto :eof
)

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Radar" >nul
    if !errorlevel! equ 0 (
        if "!currentState!"=="enabled" (
            if "!line:~0,1!"==";" (
                echo !line!
            ) else (
                echo ;!line!
            )
        ) else (
            if "!line:~0,1!"==";" (
                echo !line:~1!
            ) else (
                echo !line!
            )
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

if "!finalState!"=="enabled" (
    endlocal & set "HRAD=o" & set "HUDED=x"
) else (
    endlocal & set "HRAD=x" & set "HUDED=x"
)

cls
COLOR C
goto HUDED_WARN

:RMCSA
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Detecting Current State...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "currentState=unknown"

for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_CSAProgressBars" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            set "currentState=disabled"
        ) else (
            set "currentState=enabled"
        )
    )
)

if "!currentState!"=="enabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Disabling Progress Bars...
    set "finalState=disabled"
) else if "!currentState!"=="disabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Enabling Progress Bars...
    set "finalState=enabled"
) else (
    ECHO  Current State: Line not found
    ECHO  Action: No changes made
    pause
    goto :eof
)

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_CSAProgressBars" >nul
    if !errorlevel! equ 0 (
        if "!currentState!"=="enabled" (
            if "!line:~0,1!"==";" (
                echo !line!
            ) else (
                echo ;!line!
            )
        ) else (
            if "!line:~0,1!"==";" (
                echo !line:~1!
            ) else (
                echo !line!
            )
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

if "!finalState!"=="enabled" (
    endlocal & set "HCSA=o" & set "HUDED=x"
) else (
    endlocal & set "HCSA=x" & set "HUDED=x"
)

cls
COLOR C
goto HUDED_WARN

:RMClck
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Detecting Current State...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "currentState=unknown"

for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Clock" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            set "currentState=disabled"
        ) else (
            set "currentState=enabled"
        )
    )
)

if "!currentState!"=="enabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Disabling Clock...
    set "finalState=disabled"
) else if "!currentState!"=="disabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Enabling Clock...
    set "finalState=enabled"
) else (
    ECHO  Current State: Line not found
    ECHO  Action: No changes made
    pause
    goto :eof
)

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Clock" >nul
    if !errorlevel! equ 0 (
        if "!currentState!"=="enabled" (
            if "!line:~0,1!"==";" (
                echo !line!
            ) else (
                echo ;!line!
            )
        ) else (
            if "!line:~0,1!"==";" (
                echo !line:~1!
            ) else (
                echo !line!
            )
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

if "!finalState!"=="enabled" (
    endlocal & set "HDTC=o" & set "HUDED=x"
) else (
    endlocal & set "HDTC=x" & set "HUDED=x"
)

cls
COLOR C
goto HUDED_WARN

:RMMet
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultUI.ini
ECHO ---------------------------------------------

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultUI.ini"
set "tempfile=%inputfile%.tmp"

rem Check if file exists
if not exist "%inputfile%" (
    cls
    COLOR 4
    ECHO ---------------------------------------------
    ECHO  Error: DefaultUI.ini not found!
    ECHO ---------------------------------------------
    pause
    endlocal
    goto :eof
)

rem Get current value
set "currentValue=Not found"
for /f "usebackq tokens=2 delims==" %%a in (`findstr /i "OverlaySceneAlphaModulation" "%inputfile%" 2^>nul`) do (
    set "currentValue=%%a"
)

cls
COLOR C
ECHO ---------------------------------------------
ECHO  Set UI Opacity Value
ECHO ---------------------------------------------
ECHO  Current Value: %currentValue%
ECHO ---------------------------------------------
ECHO  Enter new value (0 to 1):
ECHO  Examples: 0, 0.5, 0.75, 1
ECHO  Leave blank to cancel
ECHO ---------------------------------------------
set /p "newValue=New Value: "

rem Check if cancelled
if "%newValue%"=="" (
    endlocal
    goto :HUDED_WARN
)

cls
COLOR C
ECHO ---------------------------------------------
ECHO  Modifying DefaultUI.ini...
ECHO  Setting value: %newValue%
ECHO ---------------------------------------------

powershell -Command "(Get-Content '%inputfile%') -replace '^OverlaySceneAlphaModulation=.*', 'OverlaySceneAlphaModulation=%newValue%' | Set-Content '%tempfile%'"

move "%tempfile%" "%inputfile%" >nul 2>&1

endlocal & set "savedValue=%newValue%"

cls
COLOR B
ECHO ---------------------------------------------
ECHO  Success: UI Opacity Changed
ECHO ---------------------------------------------
ECHO  New Value: %savedValue%
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
COLOR C
set HUDED=x
set HDOP=x
goto HUDED_WARN

:RMGrpMet
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Detecting Current State...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "currentState=unknown"

for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Clock" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            set "currentState=disabled"
        ) else (
            set "currentState=enabled"
        )
    )
)

if "!currentState!"=="enabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Disabling Group List...
    set "finalState=disabled"
) else if "!currentState!"=="disabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Enabling Group List...
    set "finalState=enabled"
) else (
    ECHO  Current State: Line not found
    ECHO  Action: No changes made
    pause
    goto :eof
)

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Group" >nul
    if !errorlevel! equ 0 (
        if "!currentState!"=="enabled" (
            if "!line:~0,1!"==";" (
                echo !line!
            ) else (
                echo ;!line!
            )
        ) else (
            if "!line:~0,1!"==";" (
                echo !line:~1!
            ) else (
                echo !line!
            )
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

if "!finalState!"=="enabled" (
    endlocal & set "HGRP=o" & set "HUDED=x"
) else (
    endlocal & set "HGRP=x" & set "HUDED=x"
)

cls
COLOR C
goto HUDED_WARN

:RMHealth
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Parsing: DefaultEngine.ini
ECHO ---------------------------------------------
ECHO  Detecting Current State...

@echo off
setlocal enabledelayedexpansion

set "inputfile=%apb%\APBGame\Config\DefaultEngine.ini"
set "tempfile=%inputfile%.tmp"
set "currentState=unknown"

for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Health" >nul
    if !errorlevel! equ 0 (
        if "!line:~0,1!"==";" (
            set "currentState=disabled"
        ) else (
            set "currentState=enabled"
        )
    )
)

if "!currentState!"=="enabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Disabling Health Indicator...
    set "finalState=disabled"
) else if "!currentState!"=="disabled" (
    cls
    ECHO ---------------------------------------------
    ECHO  Parsing: DefaultEngine.ini
    ECHO ---------------------------------------------
    ECHO  Enabling Health Indicator...
    set "finalState=enabled"
) else (
    ECHO  Current State: Line not found
    ECHO  Action: No changes made
    pause
    goto :eof
)

> "%tempfile%" (
  for /f "usebackq eol= delims=" %%L in ("%inputfile%") do (
    set "line=%%L"
    echo !line! | findstr /i "GlobalDataStoreClasses.*cUIDataStore_HUD_Health" >nul
    if !errorlevel! equ 0 (
        if "!currentState!"=="enabled" (
            if "!line:~0,1!"==";" (
                echo !line!
            ) else (
                echo ;!line!
            )
        ) else (
            if "!line:~0,1!"==";" (
                echo !line:~1!
            ) else (
                echo !line!
            )
        )
    ) else (
        echo !line!
    )
  )
)

move /y "%tempfile%" "%inputfile%" >nul

if "!finalState!"=="enabled" (
    endlocal & set "HHLT=o" & set "HUDED=x"
) else (
    endlocal & set "HHLT=x" & set "HUDED=x"
)

cls
COLOR C
goto HUDED_WARN

:HUD_PREVIEW
cls
START "" "Files\Alt\Previews\HUD.png"
ECHO ---------------------------------------------
ECHO  Preview: Oppened
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
GOTO HUDED_WARN

:UPDATE_PROMPT
cls
SET M==""
ECHO ---------------------------------------------
ECHO  Select Option:
ECHO ---------------------------------------------
ECHO  1: Update Game
ECHO  2: Update Launcher
ECHO ---------------------------------------------
ECHO  M: Main Menu
ECHO ---------------------------------------------
ECHO  Q: EXIT
ECHO ---------------------------------------------
SET /P M=ENTER OPTION: 

IF "%M%"=="" (GOTO UPDATE_PROMPT) ELSE (GOTO UPDATE_LIST)

:UPDATE_LIST
IF %M%==1 GOTO UPDATEGAME
IF %M%==2 GOTO UPDATE
IF %M%==m GOTO MENU
IF %M%==M GOTO MENU
IF %M%==q GOTO EXIT
IF %M%==Q GOTO EXIT
GOTO UPDATE_PROMPT
cls

:UPDATEGAME
cls
echo ---------------------------------------------
echo  Launching APB Launcher
echo ---------------------------------------------
start "" "%cd%\Backup\Launcher\APBLauncher.exe"

cls
echo ---------------------------------------------
echo  Wait for Update...
echo ---------------------------------------------
echo:
echo Press Enter to Continue...
pause >nul

cls
rem Copying updated files...
COLOR 0B
xcopy "%cd%\Backup\APBGame\Localization\INT" "%apb%\APBGame\Localization\INT" /E /Y /I
xcopy "%cd%\Backup\APBGame\Content" "%apb%\APBGame\Content" /E /Y /I
xcopy "%cd%\Backup\APBGame\ScriptUserBuild" "%apb%\APBGame\ScriptUserBuild" /E /Y /I
xcopy "%cd%\Backup\APBGame\Content" "%apb%\APBGame\Content" /E /Y /I
xcopy "%cd%\Backup\Binaries\APB.exe" "%apb%\Binaries\" /I /Y
cls

COLOR C
echo ---------------------------------------------
echo  Update Complete
echo ---------------------------------------------
echo:
echo Press any key to Exit...
pause >nul
GOTO MENU


:UNUSEDTEXT_FUCKINGRETARD
COLOR B
ECHO ---------------------------------------------
ECHO  WARNING: THIS INSTALLER AND FILES INCLUDED ARE PROPERTY OF ESURIENT
ECHO  WARNING: IF YOU HAVE OBTAINED THESE FILES WITHOUT PERMISSION THEN FUCK YOU
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
cls
GOTO EXIT

:UPDATE
del /q "%cd%\Files\Z\version.txt"
cls
curl -L https://github.com/xesurient/apb-cfg/raw/main/version.txt -o "%cd%\Files\Z\version.txt" --ssl-no-revoke
setlocal enabledelayedexpansion
for /f "usebackq delims=" %%A in ("%cd%\Files\Z\version.txt") do (
    set "git_version=%%A"
)
endlocal & set "git_version=%git_version%"
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Update: Checking GitHub
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
cls
if "%git_version%"=="%version%" (
    GOTO UPDATE0
) else (
    GOTO UPDATE1
)

:UPDATE0
cls
COLOR C
ECHO ---------------------------------------------
ECHO  Update: [32mNo Update Available[0m
ECHO ---------------------------------------------
ECHO  Any Key: Continue
pause >nul
GOTO MENU

:Update1
cls
@echo off
setLocal DisableDelayedExpansion
set "URL=https://github.com/xesurient/apb-cfg/archive/refs/heads/main.zip"
cls
COLOR B
curl -L %URL% -o "%cd%\Files\Z\update.esurient" --ssl-no-revoke
cls
GOTO UPDATE2

:UPDATE2
cls
"Files\Z\7z\7za.exe" x "%cd%\Files\Z\update.esurient" -o"%cd%" -aoa 
cls
ECHO ---------------------------------------------
ECHO  Update: Complete
ECHO  Required: Installer Restart
ECHO ---------------------------------------------
ECHO  Any Key: Exit
pause >nul
del /q "%cd%\Files\Z\update.esurient"
GOTO EXIT

:EXIT
exit