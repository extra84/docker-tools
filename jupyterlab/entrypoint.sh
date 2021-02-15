#!/bin/bash
for folder in {archives,envs,kernels,notebooks}; do
	if [ ! -d /workspace/$folder ]; then
		echo Creating folder $folder
        	mkdir /workspace/$folder
	fi
done

OLDPATH=$PATH
requested=$(ls /workspace/envs/ )
CURDIR=$(pwd)
GID=$(stat --format=%g /workspace)


install.sh
for e in $requested; do
        exist=$(ls -F  /workspace/kernels/ | grep  ^$e/ )
        if [[ "$exist" != "$e/" ]] ; then
                #create env
                echo creating $e
                cd /workspace/kernels
                python3 -m venv $e
                #pip requirements
                source /workspace/kernels/${e}/bin/activate
		set -x
		echo $(pwd)
		for filename in $(ls /workspace/envs/${e}/requirements*.txt ); do 
        	        /workspace/kernels/${e}/bin/pip3 install --no-cache-dir -r ${filename}
		done
                #install kernel
                /workspace/kernels/${e}/bin/pip3 install --no-cache-dir ipykernel
        else
                source /workspace/kernels/${e}/bin/activate
        fi
        ipython kernel install --name=$e
        export PATH=$OLDPATH
done;
if [[ -d "/workspace/init" ]]; then
	echo "Init folder found. Running available scripts"
	echo $(ls /workspace/init)
	run-parts /workspace/init
else
	echo "No Init folder found. Skipping"
fi
cd $CURDIR
echo "Current gid is $GID"
echo "Setting mask"
umask 002
echo "Initialisation complete. Now Ladies & Gentlemen Please welcome jupyter"
exec gosu jupyter:$GID jupyter lab --ip=0.0.0.0 --port=9980 --notebook-dir=/workspace

