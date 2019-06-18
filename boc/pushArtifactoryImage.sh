#!/bash/bin
version='latest'
echo 'begin push artifactory-oss'
echo 'docker pull artifactory-oss'
#docker pull docker.bintray.io/jfrog/artifactory-oss:latest

imageID=`docker images |grep jfrog/artifactory-oss |awk '{print $3}'`
echo "artifactory imageID is ${imageID}"

echo 'docker tag'
#docker tag ${imageID} registry.cn-hangzhou.aliyuncs.com/zhangchunlin/artifactory:${version}
docker tag ${imageID} 192.168.1.237:5000/paas/artifactory-oss:${version}

echo 'docker push'
#docker push registry.cn-hangzhou.aliyuncs.com/zhangchunlin/artifactory:${version}
docker push 192.168.1.237:5000/paas/artifactory-oss:${version}

echo 'successfully!'
