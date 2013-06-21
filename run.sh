ruby -v
sudo gem install --no-rdoc --no-ri vmc
vmc target api.cloudfoundry.com
vmc login --username $WERCKER_CLOUDFOUNDRY_USERNAME --password $WERCKER_CLOUDFOUNDRY_PASSWORD
vmc app $WERCKER_CLOUDFOUNDRY_APPNAME
vmc push --name $WERCKER_CLOUDFOUNDRY_APPNAME --start -f