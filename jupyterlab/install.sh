#!/bin/bash
if [ -e /workspace/packages.txt ]
then
        if [ ! -e /workspace/archives ]
        then
                mkdir -p /workspace/archives
        fi
        echo Checking required packages
        while IFS='' read -r line || [[ -n "$line" ]]; do
                PACKAGES=("${PACKAGES[@]} $line")
        done < packages.txt
else 
	echo "No packages.txt found. Skipping"
	exit 0
fi
for package in $PACKAGES; do
        output=$(dpkg -s $package 2> /dev/null | grep Status)
        if [ "$output" = "Status: install ok installed" ]
        then
                echo $package installed
        else
                echo $package not installed
                need_install=("${need_install[@]} $package")
        fi
done
if [ ${#need_install[@]} -gt 0 ]
then
        echo Installing new packages : $need_install
        apt-get update \
                && DEBIAN_FRONTEND=noninteractive apt-get -o dir::cache::archives="/workspace/archives" install -y ${need_install[@]}
fi

