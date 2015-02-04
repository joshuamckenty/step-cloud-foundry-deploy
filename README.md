# cloud-foundry-deploy

Deploys the current path to a cloud foundry instance. You

# What's new

- Blue-Green Deploys.
- Support for hosted cloud foundry instances

# Options

* `appname` (required) The application name.
* `username` (required) Cloud Foundry Username.
* `password` (required) Cloud Foundry Password.
* `organization` (required) Cloud Foundry Organization.
* `space` (required) Cloud Foundry Space.
* `alt_appname` (optional) Alternative application name for blue-green deploys.
* `domain` (optional) App domain.
* `route` (optional, required for blue-green deploys) App route.
* `api` (optional, default: `https://api.run.pivotal.io`) Cloud Foundry API endpoint.
* `skip_ssl` (optional) Skip ssl validation on API login.

# Example

Deploy to cloud foundry:

```yaml
steps:
  - USERNAME/cloud-foundry-deploy
...
deploy:
  steps:
    - dlapiduz/cloud-foundry-deploy:
      api: $CF_API # Set as environment variables
      username: $CF_USER
      password: $CF_PASS
      organization: $CF_ORG
      space: $CF_SPACE
      appname: myapp-green
      alt_appname: myapp-blue
      route: default_app.cfapps.io

```

# License

The MIT License (MIT)
