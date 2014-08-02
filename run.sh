ruby -v
wget http://go-cli.s3-website-us-east-1.amazonaws.com/releases/v6.3.2/cf-linux-amd64.tgz
tar -zxvf cf-linux-amd64.tgz
./cf api https://api.run.pivotal.io
org=`get_option organization`
space=`get_option space`
./cf login -u $WERCKER_CLOUDFOUNDRY_USERNAME -p $WERCKER_CLOUDFOUNDRY_PASSWORD -o $org -s $space
appname=`get_option appname`
./cf push $appname
