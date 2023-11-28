@echo off

rem define registry url here:
set registryurl=""

rem make sure Docker Desktop is installed and running
echo ============= Checking docker Desktop.... 
docker version >NUL  2>NUL
rem Error message if this fails:
IF "%errorlevel%"=="0" goto :dockerIsAvailable
echo.
echo.
echo ============= Docker not available. ===============
echo   Please install Docker for Windows
echo   and run Docker Desktop.
echo.
echo   https://www.docker.com/products/docker-desktop/
echo ===================================================
echo.
goto EndOfBatch
:dockerIsAvailable
echo ============= OK
echo.

rem make sure the 'work' folder exists
echo ============= Preparing synchronized 'work' directory....
IF NOT EXIST work\ mkdir work
SET hostdir="%~dp0\work"
SET guestdir=/home/jovyan/work
echo ============= OK
echo.

rem if the container already exists (i.e. this is not the first time
rem running this script), skip the download part and start the 
rem container.
docker ps -a -q -f name=hydraulicstructures | findstr . && echo container exists || goto initialDownload
echo.
docker start hydraulicstructures
IF "%errorlevel%"=="0" goto :dockerRunSuccess
echo.
echo starting docker container failed
echo.
goto :EndOfBatch


:initialDownload
rem login not required, since repo is public and so is the registry
goto dockerPullImage

rem pull the docker image from the registry.
:dockerPullImage
echo ============= Pulling docker image from gitlab ....
echo.
echo.
echo Link to registry was removed. Please build docker image yourself. 
echo.
echo. 
goto :EndOfBatch
rem docker pull %registryurl%
rem IF "%errorlevel%"=="0" goto :dockerPullSuccess
rem echo.
rem echo docker pull failed
rem echo.
rem goto :EndOfBatch
rem :dockerPullSuccess
rem echo ============= OK
rem echo.


rem run the docker container
echo ============= Running docker container ....
docker run^
    -d ^
    --name hydraulicstructures ^
    -v %hostdir%:%guestdir%^
    -p 5901:5901^
    -p 6901:6901^
    -p 8888:8888^
    %registryurl%
IF "%errorlevel%"=="0" goto :dockerRunSuccess
echo.
echo running docker container failed
echo.
goto :EndOfBatch
:dockerRunSuccess
echo ============= OK
echo.

rem open two Webbrowser tabs to interact with Jupyter and GUI
echo ============= Opening Jupyter in Webbrowser ....
rem wait a few seconds to make sure everything is running
TIMEOUT /T 10
rem get login token from docker logs
docker logs hydraulicstructures 2>docker.log 1>nul
for /F "delims=" %%a in ('findstr "127.0.0.1:8888" docker.log ^| findstr /v "]"') do set "jupyterurl=%%a"
echo Jupyter login url: %jupyterurl%
start %jupyterurl%

goto :EndOfBatch


:EndOfBatch
pause
