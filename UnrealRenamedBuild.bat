:: 언리얼 엔진과 프로젝트 주소, 저장할 주소를 입력합니다.
@echo off
set EngineDirectoryPath=C:\Program Files\Epic Games\UE_4.27\Engine
set ProjectDictionaryPath=D:\BuildTest
set ProjectName=BuildTest
set DefaultStagingDirectoryPath=D:
@echo on

:: 인수로 사용할 변수를 작성합니다.
@echo off
set AutomationToolPath=%EngineDirectoryPath%\Binaries\DotNET\AutomationTool.exe
set UE4ExePath=%EngineDirectoryPath%\Binaries\Win64\UE4Editor-Cmd.exe
set UProject=%ProjectName%.uproject
set ConfigPathInBuild=WindowsNoEditor\Engine\Config
set BaseGameUserSettinginBuild=%ConfigPathInBuild%\BaseGameUserSettings.ini
@echo on

:Main
call :RunUAT BuildTest_en
	@echo off
	set BaseGameUserSettingPath=%StagingDirectoryPath%\%BaseGameUserSettinginBuild%
	@echo on
	:: 마지막 스테이징의 BaseGameuserSetting에 culture를 추가합니다.
	echo. >> "%BaseGameUserSettingPath%"
	echo culture=en >> "%BaseGameUserSettingPath%"
call :RunUAT BuildTest_ko
goto EOF

:: .uproject를 복사하고 해당 프로젝트를 이용하여 빌드합니다.
:: UAT를 이용하여 프로젝트를 빌드하고, 해당 위치에 저장합니다.
:: UAT가 종료되면 Intermediate폴더를 삭제합니다.
:RunUAT <NewProjectName>
@echo off
set NewProjectName=%~1
set NewUProject=%~1.uproject
set NewUProjectpath=%ProjectDictionaryPath%\%NewUProject%
set StagingDirectoryPath=%DefaultStagingDirectoryPath%\%NewProjectName%
@echo on
@echo off
set RunCommand="%AutomationToolPath%" BuildCookRun -project="%NewUProjectpath%"
@echo on
if not exist %NewUProject% copy %UProject% %NewUProject%
%RunCommand% -noP4 -clientconfig=Shipping -serverconfig=Shipping -nocompile -nocompileeditor -installed -ue4exe="%UE4ExePath%" -utf8output -platform=Win64 -targetplatform=Win64 -build -cook -map= -unversionedcookedcontent -compressed -prereqs -stage -package -stagingdirectory=%StagingDirectoryPath% -cmdline=" -Messaging"
if not "%ProjectName%.uproject" == "%NewUProject%" del %NewUProject%
if exist "Intermediate" rd /s /q "Intermediate"
