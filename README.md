# cloud-foundry-deploy step

Required parameters can be set as deploy environment variables, OR as options
under the step in the wercker.yml file.

 - WERCKER_CLOUD_FOUNDRY_DEPLOY_USERNAME (or option of username)
 - WERCKER_CLOUD_FOUNDRY_DEPLOY_PASSWORD (or option of password)
 - WERCKER_CLOUD_FOUNDRY_DEPLOY_ORGANIZATION (or option of organization)
 - WERCKER_CLOUD_FOUNDRY_DEPLOY_SPACE (or option of space, defaults to development)
 - WERCKER_CLOUD_FOUNDRY_DEPLOY_APPNAME (or option of appname, defaults to default_app)
 - WERCKER_CLOUD_FOUNDRY_DEPLOY_DOMAIN (or option of domain, defaults to cfapps.io)
