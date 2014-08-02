ruby -v
wget http://go-cli.s3-website-us-east-1.amazonaws.com/releases/v6.3.2/cf-linux-amd64.tgz
tar -zxvf cf-linux-amd64.tgz
./cf api https://api.run.pivotal.io
./cf login -u $WERCKER_CLOUDFOUNDRY_USERNAME -p $WERCKER_CLOUDFOUNDRY_PASSWORD -o $WERCKER_CLOUD_FOUNDRY_DEPLOY_ORGANIZATION -s $WERCKER_CLOUD_FOUNDRY_DEPLOY_SPACE
./cf push $WERCKER_CLOUD_FOUNDRY_DEPLOY_APPNAME
