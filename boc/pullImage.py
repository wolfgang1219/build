#!/usr/bin/python
# -*- coding: UTF-8 -*-
import sys, getopt, os
import requests
import json
import docker
import time
#base_repo_url = '192.168.1.237:5000'
#repo_url = 'http://192.168.1.237:5000/v2/'
catalog_argument = '_catalog?n=10000'
version_argument = 'tags/list'

def updade_docker_setting():
    if os.path.exists('/etc/docker/daemon.json'):
       x = json.load(open('/etc/docker/daemon.json'))
       x['insecure-registries'].append("0.0.0.0/0")
       json.dump(x, open('/etc/docker/daemon.json', 'w'))
    else:
        f = open('/etc/docker/daemon.json', 'w')
        f.write('{"insecure-registries":["0.0.0.0/0"]}')
        f.close()
def get_repo_list(repo_catalog_url):
    repositories_l = requests.get(url=repo_catalog_url)
    return repositories_l.json()
    
def get_imager_version_list(tag_url):
    version_l = requests.get(url=tag_url)
    return version_l.json()

def get_latest_image_tuple(tag_dict):
    if 'errors' in tag_dict.keys():
        return None
    tag_dict['tags'].sort(reverse=True)
    name = tag_dict['name']
    if name == 'paas/mariadb':
        version = '10.1.31'
    else:
        version = tag_dict['tags'][0] 
    return (name, version)
    
def save_image(base_repo_url, cli, detail, sdir):
    name = '%s/%s:%s' %(base_repo_url, detail[0], detail[1])
    image = cli.images.pull(name)
    image = cli.api.get_image(name)
    f = open('%s/%s-%s.tar' %(sdir, detail[0].split('/')[-1], detail[1]), 'wb')
    for chunk in image:
        f.write(chunk)
    f.close()
def push_image(base_repo_url, cli, detail, xtag, sdir):
    homeurl="deploy.bocloud"
    image_name_last = detail[0].split('/')[1]
    if image_name_last not in ['mariadb', 'rabbitmq', 'redis', 'artifactory-oss']:
        name = '%s/%s:%s' %(base_repo_url, detail[0], detail[1])
        print "%s pulling" %(name)
        image = cli.images.pull(name)
        newtag='%s/paas/%s:%s'%(homeurl, detail[0].split('/')[1], xtag)
        isOK = image.tag(newtag)
        if isOK:
            print newtag
            #os.system("docker push %s" %newtag)
            for i in cli.images.push(newtag, stream=True, decode=True): print i
        else:
            print "%s:%s Push Failed" %(detail[0], detail[1])

def push_base_images(base_repo_url, cli):
    base_images = ['paas/mariadb:10.1.31', 'paas/rabbitmq:3.6.15-management', 'paas/redis:5.0.0', 'paas/artifactory-oss:latest']
    homeurl="deploy.bocloud"
    for i in base_images:
        print('%s/%s'%(base_repo_url,i))
        image = cli.images.pull('%s/%s'%(base_repo_url,i))
        print('===============')
        newtag = '%s/%s'%(homeurl,i)
        isOK = image.tag(newtag)
        if isOK:
            print newtag
        #    sys.exit(0)
            for i in cli.images.push(newtag, stream=True, decode=True): print i
        else:
            print "%s Push Failed" %(newtag)
    

def run(repo_url, xtag, saved_dir, repo_path, action):
    client = docker.from_env()
    repos = get_repo_list("%s/v2/%s"%(repo_url,catalog_argument))
    print (repos)
    print('================================')
    paas_images = [item for item in repos['repositories'] if item.startswith(repo_path+'/')]
    push_base_images(repo_url[repo_url.find('/')+2:], client)
    for i in paas_images:
        image_detail = get_latest_image_tuple(get_imager_version_list("%s/v2/%s/%s"%(repo_url,i,version_argument)))
        if image_detail: 
           if action == 'test':
               print image_detail
           elif action == 'push':
              # push_base_images(repo_url[repo_url.find('/')+2:], client)
               push_image(repo_url[repo_url.find('/')+2:], client, image_detail, xtag, saved_dir)
           elif action == 'save':
               save_image(repo_url[repo_url.find('/')+2:], client, image_detail, saved_dir)
           else:
               print("action must be test/push/save")
        else: print (i,'error')
        time.sleep(1)
def main(argv):
    base_repo_url = "http://192.168.1.237:5000"
    repo_path = "paas"
    sdir = "images"
    xtag = "v2.0"
    try: 
       opts, args = getopt.getopt(argv,"hr:o:t:p:",["base_repo_url=","sdir=", "xtag=", "repo_path="])
    except getopt.GetoptError:
       print './pullImage -r <repo-url> -t <tag> -o <saved-directory> ' 
       sys.exit(2) 
    for opt, arg in opts:
       if opt == '-h':
          print './pullImage -r <repo-url> -t <tag> -o <saved-directory>'
          sys.exit(0)
       elif opt in ("-i", "--ifile"):
          base_repo_url = arg
       elif opt in ("-o", "--ofile"):
          sdir = arg
       elif opt in ("-t", "--tag"):
          xtag = arg
       elif opt in ("-p", "--repopath"):
          repo_path = arg
    print "%s - %s - %s - %s" %(base_repo_url, sdir, repo_path, xtag) 
    run(base_repo_url, xtag, sdir, repo_path, 'push')    

if __name__ == '__main__':
    updade_docker_setting()
    os.system("systemctl reload docker") 
    main(sys.argv[1:])
