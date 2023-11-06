# docker image is based on a minimal Jupyter docker image
## JupyterLab v3.6.1
# FROM jupyter/minimal-notebook:2023-02-27
## JupyterLab v4.0.6
FROM jupyter/minimal-notebook:2023-10-02

###### STEPS to make gui programs in a VNC session available ##########

ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901

EXPOSE $NO_VNC_PORT

USER root

# tools.sh
RUN apt-get update && \ 
    apt-get install -y vim wget net-tools locales bzip2 procps && \ 
    apt-get clean -y

### Install xvnc-server & noVNC - HTML5 based VNC viewer
# config can be put into ~/.vnc/config maybe?
RUN apt-get install -y tigervnc-standalone-server && \ 
    apt-get clean -y && \ 
    printf '\n# docker-headless-vnc-container:\n$localhost = "no";\n1;\n' >>/etc/tigervnc/vncserver-config-defaults

# iceWM
RUN apt-get update && \ 
    apt-get install -y supervisor icewm xterm xfonts-base xauth xinit dbus-x11 libdbus-glib-1-2 && \ 
    apt-get purge -y pm-utils *screensaver* && \ 
    apt-get clean -y

#nss-wrapper
RUN apt-get update && \ 
    apt-get install -y libnss-wrapper gettext && \ 
    apt-get clean -y

USER ${NB_UID}

# noVNC
RUN git clone https://github.com/novnc/noVNC.git && \ 
    cp noVNC/vnc_lite.html noVNC/index.html && \ 
    mv noVNC/ .noVNC/

RUN git clone https://github.com/novnc/websockify .noVNC/utils/websockify

RUN mkdir ~/.vnc && \ 
    echo "hydrodynamics" | vncpasswd -f >> ~/.vnc/passwd && \ 
    chmod 600 ~/.vnc/passwd 

EXPOSE $VNC_PORT 

USER root
RUN apt-get install -y libglu1-mesa
USER ${NB_UID}

# move some required files into the container
ADD ./installscripts/icewm/ .
ADD ./installscripts/.generate_container_user .
RUN echo 'source .generate_container_user' >> ./.bashrc
ADD ./installscripts/vnc_startup.sh .

###### End of STEPS to make gui programs in a VNC session available ##########


###### Add basic gui programs
USER root
RUN apt-get update && \
    apt-get install -y rox-filer notepadqq
RUN echo prog Files rox-filer rox-filer >> .icewm/menu && \
    echo prog Notepad notepadqq notepadqq >> .icewm/menu && \
    echo separator>> .icewm/menu
USER ${NB_UID}





##### Install software for the hydrodynamics course  ##############################

RUN pip install numpy

# Add RISE for JupyterLab so users can show live slideshows from their notebooks
# More info at https://github.com/jupyterlab-contrib/rise
# For JupyterLab 3.x, install version prior to 0.40.0
# RUN pip install "jupyterlab_rise<0.40.0"
# For JupyterLab >= 4.0.0, install latest version
RUN pip install jupyterlab_rise

# GMSH
RUN wget http://gmsh.info/bin/Linux/gmsh-4.11.1-Linux64.tgz
RUN tar -xzvf gmsh-4.11.1-Linux64.tgz && \ 
    rm gmsh-4.11.1-Linux64.tgz && \ 
    mv ./gmsh-4.11.1-Linux64/ ./gmsh/
RUN wget https://gitlab.onelab.info/gmsh/gmsh/-/raw/1a02bc7b8bf547512c65a6e68635f9c813b6f966/utils/icons/gmsh-no-text.png && \ 
    mv gmsh-no-text.png ./gmsh/
USER root
RUN echo prog gmsh /home/jovyan/gmsh/gmsh-no-text.png /home/jovyan/gmsh/bin/gmsh >> .icewm/menu
USER ${NB_UID}


# meshmagick
# "There is one and only one supported installation procedure that is currently and it relies on pip package installer."
# see https://lheea.github.io/meshmagick/install/install.html
RUN git clone https://github.com/LHEEA/meshmagick.git && \ 
    cd meshmagick && \ 
    git checkout 3.4 && \ 
    pip install -e . && \ 


# capytaine
RUN conda install -c conda-forge capytaine --yes
# enable saving capytaine results to netCDF files with h5netcdf
RUN pip install h5netcdf

# openfast
RUN conda install -c conda-forge openfast --yes
# with python toolbox
RUN git clone http://github.com/OpenFAST/python-toolbox openfast-python-toolbox && \
    cd openfast-python-toolbox && \
    python -m pip install -e .

# Nemoh v3 from https://gitlab.com/lheea/Nemoh
RUN wget https://gitlab.com/api/v4/projects/41313230/releases -O releases.json && \
    cat releases.json | grep -oE https://gitlab.com[^,]*nemoh-linux-x64[^,]*.tar.gz | head -1 | xargs wget && \
    rm releases.json
RUN tar -xf nemoh-linux* --one-top-level && \
    rm nemoh-linux*.tar.gz

# Nemoh v2 from https://github.com/LHEEA/Nemoh
# This needs to be compiled with gfortran. No binaries available.
# Since Nemoh v2 is deprecated, it is not included in this Docker Image 






# BEMRosetta from https://github.com/BEMRosetta/BEMRosetta

# Option a) use the precompiled binaries uploaded to the 'hydraulic structures' git repo
RUN mkdir BEMRosetta
ADD ./BEMRosetta/BEMRosetta ./BEMRosetta/BEMRosetta
ADD ./BEMRosetta/BEMRosetta_cl ./BEMRosetta/BEMRosetta_cl
ADD ./BEMRosetta/icon256x256.png ./BEMRosetta/icon256x256.png
# add GUI launcher to icewm start menu
USER root
RUN echo prog BEMRosetta /home/jovyan/BEMRosetta/icon256x256.png /home/jovyan/BEMRosetta/BEMRosetta >> .icewm/menu
USER ${NB_UID}


# Option b) new compilation. At time of this writing, the MatIO package had some issues
# which needed to be resolved to fix the compilation. The whole compilation setup is 
# rather inconvenient. See https://github.com/BEMRosetta/BEMRosetta/tree/master/install

## The depth option will make sure to copy the least bit of history possible to get that repo.
## Somewhere in the history the .git folder has a weird 1.6G file in it. 
## Delete it anyway to save ~100MB.
#RUN git clone --depth=1 https://github.com/BEMRosetta/BEMRosetta.git && \
#    rm -rf BEMRosetta/.git/
## install required packages for compilation
#USER root
#RUN apt-get update && \
#    apt-get install -y g++  make  libgtk-3-dev  libnotify-dev  libbz2-dev  sox libgtkglext1-dev clang clang-format libssl-dev xdotool
#USER ${NB_UID}
## download and install U++ development framework
#RUN wget -k https://www.ultimatepp.org/www%24uppweb%24download%24en-us.html -O releases.html && \
#    cat releases.html | grep -oE https://www.ultimatepp.org/downloads/upp-posix-[0-9]+.tar.xz | head -1 | xargs wget && \
#    rm releases.html
#RUN tar -xf upp-posix* && \
#    rm upp-posix*.tar.xz
#RUN cd upp && \
#    make && \
#    make -f umkMakefile.in && \
#    ./install
#    cd ..
#
## now start the docker container and run the U++ gui IDE (theide), 
## install missing Packages with the UppHub
## and possibly fix the MatIO package. 




# Add example and tutorial files for the software packages in one common folder 'examples'
RUN mkdir examples

## capytaine
RUN cd examples && \
    git clone -n --depth 1 https://github.com/capytaine/capytaine.git && \
    cd capytaine && \
    git checkout HEAD docs/user_manual/examples/* && \
    mv docs/user_manual/examples/ .. && \
    cd .. && \
    rm -rf capytaine && \
    mv examples capytaine && \
    echo "* [Capytaine User Manual](https://ancell.in/capytaine/latest/user_manual/index.html)" >> references.md

## BemRosetta
RUN cd examples && \
    git clone -n https://github.com/BEMRosetta/BEMRosetta.git --depth 1 && \
    cd BEMRosetta && \
    git checkout HEAD examples/* && \
    mv examples .. && \
    cd .. && \
    rm -rf BEMRosetta && \
    mv examples BEMRosetta && \
    echo "* [BEMRosetta github page](https://bemrosetta.github.io/)" >> references.md

## Nemoh
RUN cd examples && \
    git clone -n https://gitlab.com/lheea/Nemoh.git --depth 1 && \
    cd Nemoh && \
    git checkout HEAD TestCases/* && \
    mv TestCases .. && \
    cd .. && \
    rm -rf Nemoh && \
    mv TestCases Nemoh && \
    echo "* [Nemoh release page with documentation](https://gitlab.com/lheea/Nemoh/-/releases)" >> references.md

## gmsh
RUN cd examples && \
    git clone -n https://gitlab.onelab.info/gmsh/gmsh.git --depth 1 && \
    cd gmsh && \
    git checkout HEAD tutorials/* && \
    mv tutorials .. && \
    cd .. && \
    rm -rf gmsh && \
    mv tutorials gmsh && \
    echo "* [gmsh documentation](http://gmsh.info/#Documentation)" >> references.md

## openFAST
RUN cd examples && \
    mkdir openfast && \
    cd openfast && \
    git clone https://github.com/OpenFAST/r-test.git --depth 1 && \
    cd .. && \
    echo "* [openfast documentation](https://openfast.readthedocs.io/en/main/)" >> references.md && \
    echo "* [openfast Python toolbox](https://github.com/OpenFAST/python-toolbox)" >> references.md



