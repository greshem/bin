
pip install 'buildbot[bundle]'
buildbot create-master master
mv master/master.cfg.sample master/master.cfg
echo vim master/master.cfg 
ls
buildbot start master 
lsof -i:8010

#==========================================================================
git clone --depth 1 https://github.com/buildbot/buildbot-docker-example-config 
cd buildbot-docker-example-config/
cd simple/
lsof -i:8080
ls
docker-compose  up 
