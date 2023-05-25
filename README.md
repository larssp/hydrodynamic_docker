# Hydraulic Structures B-KUL-H0N37A

This repository aims to make software packages for hydrodynamic calculations easily accessible for the examples presented in the exercises of the aforementioned course. 

## Getting started for students

### Installation

- Install [Docker Desktop](https://www.docker.com/products/docker-desktop/) on your computer
- Create an access token for your gitlab.kuleuven.be account
    1. Go to [your profile's token page](https://gitlab.kuleuven.be/-/profile/personal_access_tokens)
    2. Give the token a name, e.g. 'docker container access'
    3. Choose or delete the expiration date
    4. Make a tick ✔️ at 'read_registry' (mandatory) and 'read_repository' (optional)
    5. Click on 'Create access token'. ❗❗ The token (password) will only be shown __once__ . Make sure to save it somewhere. 
- Download the [startup.bat](https://gitlab.kuleuven.be/hwest/teaching/hydraulic-structures-b-kul-h0n37a/-/blob/main/startup.bat) file to a directory of your choice on your computer. 
    - alternatively 'git clone' this repository if you're familiar with git

### Using the software

- Start Docker Desktop
- Double-click the startup.bat
    - On the first run Docker will ask for a username and password
        - username is your r-number, e.g. 'r012345', or u-number 'u0987654', respectively
        - password is the access token from above
- The docker container will be downloaded and started afterwards. Wait until a web browser is opened showing the JupyterLab environment. 

### Starting a VNC session to run gui programs

In order to use gui programms, e.g. 'gmsh', 'BEMRosetta' or 'meshmagick --show', a VNC session needs to be started. To do so, 
- open a Terminal inside Jupyterlab and run './vnc_startup.sh'
- wait until this message appears:
```bash
noVNC HTML client started:
        => connect via http://localhost:6901
Password is *************
```
- click on the link to [http://localhost:6901](http://localhost:6901) and enter the password. 
- A Linux desktop environment is shown with the available programs in the start menu (bottom left)

### Saving your data/work

There is a directory called 'work' on your Windows file system next to the 'startup.bat'. This folder will be created the first time you run the 'startup.bat'. 

There is also a 'work' folder in the JupyterLab environment and the Linux desktop environment. These folders are synchronized and files in this directory will be persistent, i.e. will remain on your Windows file system after you shut down Docker. 


## Development

To add additional teaching material or tutorials (Jupyter Notebooks, Python scripts, etc...), add these in the 'work' folder in an appropriate subdirectory.

When changing the Dockerfile, build the new image and push it to the [Container registry](https://gitlab.kuleuven.be/hwest/teaching/hydraulic-structures-b-kul-h0n37a/container_registry) like so:
```bash
cd docker
docker build -t registry.gitlab.kuleuven.be/hwest/teaching/hydraulic-structures-b-kul-h0n37a .
docker push registry.gitlab.kuleuven.be/hwest/teaching/hydraulic-structures-b-kul-h0n37a
```

### Roadmap

More software may be added at a later point. See [MRE CodeHub](https://mrecodehub.org/) for a nice overview of related software projects.

### Contributing

To report an issue or ask for additional features or material to be included in the Docker image, feel free to [create an issue here](https://gitlab.kuleuven.be/hwest/teaching/hydraulic-structures-b-kul-h0n37a/-/issues).
