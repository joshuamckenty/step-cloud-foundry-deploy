ruby -v
wget http://go-cli.s3-website-us-east-1.amazonaws.com/releases/v6.3.2/cf-linux-amd64.tgz
tar -zxvf cf-linux-amd64.tgz
./cf api https://api.run.pivotal.io

appname=${WERCKER_CLOUD_FOUNDRY_DEPLOY_APPNAME-default_app}
username=$WERCKER_CLOUD_FOUNDRY_DEPLOY_USERNAME
password=$WERCKER_CLOUD_FOUNDRY_DEPLOY_PASSWORD
organization=$WERCKER_CLOUD_FOUNDRY_DEPLOY_ORGANIZATION
space=${WERCKER_CLOUD_FOUNDRY_DEPLOY_SPACE-development}
domain=${WERCKER_CLOUD_FOUNDRY_DEPLOY_DOMAIN-cfapps.io}
./cf login -u $username -p $password -o $organization -s $space

# Basic blue-green here
if $(./cf app $appname-a | grep -q started)
then
  OLD="$appname-a"
  NEW="$appname-b"
else
  OLD="$appname-b"
  NEW="$appname-a"
fi

echo "Pushing new app to $NEW and disabling $OLD"
./cf push $NEW  -d $domain
if [[ $? -ne 0 ]]; then
  echo "Error pushing"
  ./cf stop $NEW
  exit 1
fi

echo "Re-routing"
./cf map-route $NEW $domain -n $appname
./cf unmap-route $OLD domain -n $appname
./cf stop $OLD

echo "Done"

