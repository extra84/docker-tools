#!/bin/bash
OLDPATH=$PATH
requested=$(ls /workspace/envs/ )
CURDIR=$(pwd)
GID=$(stat --format=%g /workspace)
install.sh
for e in $requested; do
        #filename=$(basename $e .txt)
        #exist=$(ls -F  /workspace/kernels/ | grep  ^$filename/ )
        filename=$e/requirements.txt
        exist=$(ls -F  /workspace/kernels/ | grep  ^$e/ )
        if [[ "$exist" != "$e/" ]] ; then
                #create env
                echo creating $e
                cd /workspace/kernels
                python3 -m venv $e
                #pip requirements
                source /workspace/kernels/$e/bin/activate
                /workspace/kernels/$e/bin/pip3 install --no-cache-dir -r /workspace/envs/$filename
                #install kernel
                /workspace/kernels/$e/bin/pip3 install --no-cache-dir ipykernel
        else
                source /workspace/kernels/$e/bin/activate
        fi
        ipython kernel install --name=$e
        export PATH=$OLDPATH
done;
cd $CURDIR
echo "gid : $GID"
umask 002
exec gosu jupyter:$GID jupyter lab --ip=0.0.0.0 --port=9980 --notebook-dir=/workspace

