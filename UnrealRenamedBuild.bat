:: 언리얼 엔진과 프로젝트 주소를 입력합니다.
@echo off
set EngineDirectoryPath=C:\Program Files\Epic Games\UE_4.27\Engine
set ProjectDictionaryPath=D:\BuildTest
set ProjectName=BuildTest
@echo on

:: 인수로 사용할 변수를 작성합니다.
@echo off
set AutomationToolPath=%EngineDirectoryPath%\Binaries\DotNET\AutomationTool.exe
set UE4ExePath=%EngineDirectoryPath%\Binaries\Win64\UE4Editor-Cmd.exe
@echo on

:Main
call :RunUAT "BuildTest_en.uproject" "D:\BuildTest\EN"
pause
goto EOF

:: .uproject를 복사하고 해당 프로젝트를 이용하여 빌드합니다.
:: UAT를 이용하여 프로젝트를 빌드하고, 해당 위치에 저장합니다.
:: UAT가 종료되면 Intermediate폴더를 삭제합니다.
:RunUAT <SpecificName> <StagingDirectoryPath>
if not exist %~1 copy %ProjectName%.uproject %~1
"%AutomationToolPath%" BuildCookRun -project="%ProjectDictionaryPath%\%~1" -noP4 -clientconfig=Shipping -serverconfig=Shipping -nocompile -nocompileeditor -installed -ue4exe="%UE4ExePath%" -utf8output -platform=Win64 -targetplatform=Win64 -build -cook -map= -unversionedcookedcontent -compressed -prereqs -stage -package -stagingdirectory=%~2 -cmdline=" -Messaging"
if not "%ProjectName%.uproject" == "%~1" del %~1
if exist "Intermediate" rd /s /q "Intermediate"
