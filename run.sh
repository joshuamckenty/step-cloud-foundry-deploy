ruby -v
wget https://cli.run.pivotal.io/stable?release=linux64-binary&version=6.3.2&source=github-rel
tar -zxvf cf-linux-amd64.tgz
cf api https://api.run.pivotal.io
org=`get_option organization`
space=`get_option space`
cf login -u $WERCKER_CLOUDFOUNDRY_USERNAME -p $WERCKER_CLOUDFOUNDRY_PASSWORD -o $org -s $space
appname=`get_option appname`
cf push $appname
