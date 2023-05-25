@echo off

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
echo   Either from 
echo   https://www.docker.com/products/docker-desktop/
echo   or via the KU Leuven SET-IT Software Center
echo ===================================================
echo.
goto EndOfBatch
:dockerIsAvailable
echo ============= OK
echo.

rem make sure the 'work' folder exists
echo ============= Preparing synchronized 'work' directory....
IF NOT EXIST work\ mkdir work
SET hostdir=%~dp0\work
SET guestdir=/home/jovyan/work
echo ============= OK
echo.

rem Login to the docker registry at gitlab.kuleuven.be 
echo ============= Logging in to registry.gitlab.kuleuven.be....
docker login registry.gitlab.kuleuven.be
IF "%errorlevel%"=="0" goto :dockerLoginSuccess
echo.
echo Docker Login failed
echo.
goto :EndOfBatch
:dockerLoginSuccess
echo ============= OK
echo.

rem pull the docker image from the gitlab.kuleuven.be registry.
echo ============= Pulling docker image from gitlab.kuleuven.be ....
docker pull registry.gitlab.kuleuven.be/hwest/teaching/hydraulic-structures-b-kul-h0n37a:latest
IF "%errorlevel%"=="0" goto :dockerPullSuccess
echo.
echo docker pull failed
echo.
goto :EndOfBatch
:dockerPullSuccess
echo ============= OK
echo.


rem run the docker container
echo ============= Starting docker image ....
docker run^
    -d ^
    --name hydraulicstructures ^
    -v %hostdir%:%guestdir%^
    -p 5901:5901^
    -p 6901:6901^
    -p 8888:8888^
    registry.gitlab.kuleuven.be/hwest/teaching/hydraulic-structures-b-kul-h0n37a:latest
IF "%errorlevel%"=="0" goto :dockerRunSuccess
echo.
echo running docker image failed
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