#!/bin/bash
#
#
# Determine what platform we are running on
#
case $(uname) in
    "Linux")
        kernelSpecsDir="${HOME}/.local/share/jupyter/kernels";;
        distribDir='/cvmfs/sw.lsst.eu/linux-x86_64/lsst_distrib';;
    "Darwin")
        kernelSpecsDir="${HOME}/Library/Jupyter/kernels";;
        distribDir='/cvmfs/sw.lsst.eu/darwin-x86_64/lsst_distrib';;  
    *)
        echo "unsupported platform"
        exit 1
        ;;
esac
#
# get the last installed distrib
#
release=$(ls -d ${distribDir}/v*[0-9] ${distribDir}/w_*[0-9] | tail -1)
release=$(basename ${release})
source  /cvmfs/sw.lsst.eu/linux-x86_64/lsst_distrib/${release}/loadLSST.sh
echo "To also have the same LSST release in your deflaut linux session than in jupyter add in your .bashrc"
echo  "source  /cvmfs/sw.lsst.eu/linux-x86_64/lsst_distrib/"${release}"/loadLSST.sh"

#
# Create the destination directory for the kernel
#
kernelName='lsst_distrib_dask'
srcDir=./${kernelName}
dstDir=${kernelSpecsDir}/${kernelName}
mkdir -p ${dstDir}
rm -f ${dstDir}/*

#
# Copy the relevant files to the kernel directory
#
sed "s|{TODAY_DISTRIB}|${release}|g ; s|{KERNEL_DIR}|${dstDir}|g  " ${srcDir}/kernel.json > ${dstDir}/kernel.json
cp ${srcDir}/logo-64x64.png ${srcDir}/kernel_launcher.py ${srcDir}/lsst-jupyter-kernel-launcher.sh ${dstDir}
chmod u+x ${dstDir}/lsst-jupyter-kernel-launcher.sh

#
# install (1.1.1) of dask4in2p3 
#
conda env list
export dask4in2p3_pkg="git+https://git:oGLyx9HvwybDRxczniFd@gitlab.in2p3.fr/dask_for_jnp/dask4in2p3.git@v1.1.1" 
python -m pip install "${dask4in2p3_pkg}"

# install the other needed package
pip install ipykernel==‘6.9.1’
pip install jupyter-server-proxy

# fake to access python10
my_python=`which python`
cd ~/.local/bin
ln -s ${my_python} .
