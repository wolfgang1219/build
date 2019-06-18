#!/bin/bash

version='2.1'
path='boc2.1'
function  create_dev_env 
{
  if [ "x$(which pip)" = "x" ];then
      echo "pip installatin"
      python resource/get-pip.py
  fi
  echo "requests & docker python lib"
  pip install requests docker 
}
function clean_all_images
{
  for i in $(docker images | grep "192.168.1.237:5000/${path}" | awk '{if($2=="<none>"){print $3}else{ print $1":"$2}}');do docker rmi $i; done
  for i in $(docker images | grep "deploy.bocloud/${path}" | awk '{if($2=="<none>"){print $3}else{ print $1":"$2}}');do docker rmi $i; done
}
clean_all_images
create_dev_env
if [ $1 = "boc" ];then
    echo "clean"
    docker stop registryII
    container=$(docker ps --all -f name=registryboc -q)
    if [ "x$container" != "x" ];then
        docker stop registryboc && docker rm registryboc
        rm -rf /home/boc-images/docker
    fi
    rm -rf /home/boc-images/docker
    sleep 3
    docker run --name registryboc -it --net=host -v /home/boc-images:/var/lib/registry -d bocloud-deploy:v2.0
    python pullImage.py -r 'http://192.168.1.237:5000' -t v${version} -p ${path}

    cd boc-boms-image
    rm -rf containers/registry/docker/
    cp -r /home/boc-images/docker containers/registry/
    docker build -t uboc-deploy:v${version} -f Dockerfile .
    [ -f uboc-deploy.tar ] && rm -rf uboc-deploy.tar
    docker save uboc-deploy:v${version} > uboc-deploy.tar
fi
    
