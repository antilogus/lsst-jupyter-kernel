# JupyterLab kernel configuration for the LSST science pipelines

## Introduction
This repository contains a [kernel specification](https://jupyter-client.readthedocs.io/en/stable/kernels.html) for executing [JupyterLab](https://jupyterlab.readthedocs.io/en/stable/) notebooks which use the the *Rubin Observatory* **Legacy Survey of Space and Time** ([LSST](https://lsst.org)) [science pipelines](https://pipelines.lsst.io).

Once deployed in the host where your *JupyterLab notebook server
executes* (e.g. in parctice today  at
[CC-IN2P3](https://doc.lsst.eu  only )  , you will be able to launch notebooks
which use a Python interpreter configured with all the packages
specific to the LSST software distribution and able to run under DASK 

When you launch JupyterLab, you will see a screen similar to the one below:

![Jupyter Launcher](./launcher.png)

Push the `lsst_distrib_dask` button to launch a server already configured to use the LSST science pipelines.

## Dependencies
This kernel specification requires that the LSST science pipelines are
installed on the host where JupyterLab executes, under
`/cvmfs/sw.lsst.eu` (see [https://sw.lsst.eu](https://sw.lsst.eu) for
more information). The hosts at the [CC-IN2P3 login
farm](https://doc.lsst.eu/ccin2p3/ccin2p3.html#login-farm) are
configured this way.

Remark that the package dask4in2p3 developed by Bernard Chambon from
CC-IN2P3    and other needed software to run DASK under jupyter
within LSST environement , will be installed under the ${HOME}/.local
directory ...if you are using this area for other anaconda
installation you may have a conflic poping up. 

## Installation

Execute the instructions below in the computer where you run JupyterLab (e.g. your laptop or a server in CC-IN2P3 login farm).

```
cd $HOME
git clone https://github.com/antilogus/lsst-jupyter-kernel.git
cd lsst-jupyter-kernel
bash ./install.sh
rm -r $HOME/lsst-jupyter-kernel
```

After a successful installation, you will find a directory located according to the operating system you deploy on, as follows:

| Operating system   | Installation directory                            |
| ------------------ |:--------------------------------------------------|
| Linux              | `$HOME/.local/share/jupyter/kernels/lsst_distrib_dask` |


This directory is populated with files needed by JupyterLab to launch
your notebook.

When running the code , it will recommand you to source in your bashrc
the same version of the LSST code that you will be using in jupyter
. This is recommended to avoid conflict with the content of your
./local directory ( see bellow ) .

## Customization

At this stage there is no customization possible .
In practice the LSST distribution used will be frozen to the latest
one available at the moment of the installation of this package . 
To move to a new version of the LSST distribution you will have to
re-install the full package.

## dask activation in your notebook 

Becarefull that to access your customized  installation of the lsst
distrib you should point to it in the call to Dask4in2p3 ( see below ,
and repalce a/antilog by what corresponds to your home at cc ) 

```
#  check the dask version 
from dask4in2p3 import dask4in2p3
import dask
print(dask4in2p3.version)
# Importing the class from the module (package.module)
from dask4in2p3.dask4in2p3 import Dask4in2p3
# Creating a Dask4in2p3 object  (with a default Python virtual environment)
# THE FOLLOWING LINE SHOULD BE UPDATED WITH YOUR HOME DIRECTORY 
#   a/antilog ==> x/xxxxx  
my_dask4in2p3 = Dask4in2p3('/pbs/home/a/antilog/.local',dask_scheduler_memory=2)

# Launching a dask-scheduler and a dask-worker. 
# Connecting a client from this notebook to the dask-scheduler 
client = my_dask4in2p3.new_client(dask_worker_jobs=nb_worker, 
                                  dask_worker_memory=3,
                                  dask_worker_time='01:00:00',
                                 )
# Using the existing logger provided from the module dask4in2p3 
logger = my_dask4in2p3.get_logger()
logger.info(f"Ready to prepare/launch the dask tasks")
# A pretty display !
client
```

## Credits

### Author
This tool was developed and are maintained by Pierre Antilogus  at [IN2P3 / CNRS LPNHE](http://lpnhe.in2p3.fr) (Paris, France).
It is mainly an extention of a package  developed and  maintained by
Fabio Hernandez at [IN2P3 / CNRS computing center](http://cc.in2p3.fr)
(Lyon, France) , adding the DASK fucntionalities  to the LSST
environement. 


