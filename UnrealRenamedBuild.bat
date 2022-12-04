@echo off
set AutomationToolPath="C:\Program Files\Epic Games\UE_4.27\Engine\Binaries\DotNET\AutomationTool.exe"
set UE4ExePath="C:\Program Files\Epic Games\UE_4.27\Engine\Binaries\Win64\UE4Editor-Cmd.exe"
::set ProjectPath="D:/BuildTest/BuildTest.uproject"
set ProjectDictionaryPath=D:/BuildTest/
set Project=BuildTest.uproject
set AddCMDLine="-SessionId=34475EA34CEE89957D9E5BBB9D27DEED -SessionOwner='kj' -SessionName='New Profile 3' "
@echo on

:Main
::call :RunUAT "D:/BuildTest/BuildTest.uproject" "D:/BuildTest/First"
call :RunUAT "BuildTest_en.uproject" "D:/BuildTest/EN"
pause
goto EOF

:: .uproject를 복사하고 해당 프로젝트를 이용하여 빌드합니다.
:: UAT를 이용하여 프로젝트를 빌드하고, 해당 위치에 저장합니다.
:: UAT가 종료되면 Intermediate폴더를 삭제합니다.
:RunUAT <SpecificName> <StagingDirectoryPath>
if not exist %~1 copy %Project% %~1
set TempProjectPath = %ProjectDictionaryPath%
%AutomationToolPath% BuildCookRun -project="%ProjectDictionaryPath%%~1" -noP4 -clientconfig=Shipping -serverconfig=Shipping -nocompile -nocompileeditor -installed -ue4exe=%UE4ExePath% -utf8output -platform=Win64 -targetplatform=Win64 -build -cook -map= -unversionedcookedcontent -compressed -prereqs -stage -package -stagingdirectory=%~2 -cmdline=" -Messaging" -addcmdline=%AddCMDLine%
if not %Project% == "%~1" del %~1
if exist "Intermediate" rd /s /q "Intermediate"