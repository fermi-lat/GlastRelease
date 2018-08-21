#!/bin/bash

if [ -z "$1" ]; then
    echo "No externals folder supplied"
    exit 1
fi

target_dir=$1
scons -C GlastRelease --site-dir=../SConsShared/site_scons \
    --with-GLAST-EXT='' --compile-opt --compile-debug --externalsList 2>&1 > /dev/null

externals=$(cat data/externals.extList \
    | sed 's/#.*//' \
    | grep "[A-Za-z]" \
    | grep -v "python-env27")

mkdir -p $target_dir
cd $target_dir
for external in $externals
do
    link="https://www.slac.stanford.edu/exp/glast/ground/software/nfsLinks/u52/externals/redhat6-x86_64-64bit-gcc44/${external}.tar.gz"
    printf "Downloading ${external}\n at $link\n"
    curl -f -s -O $link
    rc=$?
    if [[ $rc != 0 ]]; then
        printf "Link not downloaded: $link"
        exit 1
    fi
    printf "Extracting ${external}\n"
    tar xzf "${external}.tar.gz"
    rm "${external}.tar.gz"
done
