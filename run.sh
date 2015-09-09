simple_deploy() {
  set -e;
  local appname="$1";
  local domain="$2";

  local push_cmd="./cf push $appname";

  if [ -n "$domain" ]; then
    push_cmd="$push_cmd -d $domain";
  fi;

  eval $push_cmd;
}

blue_green_deploy() {
  local appname="$1";
  local alt_appname="$2";
  local domain="$3";
  local hostname="$4"

  if $(./cf app $appname | grep -q started); then
    OLD="$appname";
    NEW="$alt_appname";
  else
    OLD="$alt_appname";
    NEW="$appname";
  fi

  info "Pushing new app to $NEW and disabling $OLD"
  ./cf push $NEW --no-route
  if [[ $? -ne 0 ]]; then
    ./cf stop $NEW;
    fail "Error pushing app";
  fi

  info "Re-routing"
  local map_opts="$domain"
  if [ -n "$hostname" ]; then
    map_opts="$map_opts -n $hostname";
  fi;
  ./cf map-route $NEW $map_opts
  ./cf unmap-route $OLD $map_opts
  ./cf stop $OLD
}

main() {
  set -e;

  # Assign global variables to local

  local appname="$WERCKER_CLOUD_FOUNDRY_DEPLOY_APPNAME"
  local alt_appname="$WERCKER_CLOUD_FOUNDRY_DEPLOY_ALT_APPNAME"
  local username="$WERCKER_CLOUD_FOUNDRY_DEPLOY_USERNAME"
  local password="$WERCKER_CLOUD_FOUNDRY_DEPLOY_PASSWORD"
  local organization="$WERCKER_CLOUD_FOUNDRY_DEPLOY_ORGANIZATION"
  local space="$WERCKER_CLOUD_FOUNDRY_DEPLOY_SPACE"
  local domain="$WERCKER_CLOUD_FOUNDRY_DEPLOY_DOMAIN"
  local hostname="$WERCKER_CLOUD_FOUNDRY_DEPLOY_HOSTNAME"
  local api="$WERCKER_CLOUD_FOUNDRY_DEPLOY_API"
  local skip_ssl="$WERCKER_CLOUD_FOUNDRY_DEPLOY_SKIP_SSL"

  # Validate variables
  if [ -z "$appname" ] || [ -z "$username" ] || [ -z "$password" ] || [ -z "$organization" ] || [ -z "$space" ] ; then
    fail "appname, username, password, organization and space are required; please add them to the step";
  fi

  if [ -z "$api" ]; then
    api="https://api.run.pivotal.io";
    info "api not specified; using https://api.run.pivotal.io";
  fi

  info "Downloading CF CLI";
  wget -O cf.tgz "https://cli.run.pivotal.io/stable?release=linux64-binary";
  tar -zxf cf.tgz;

  info "Logging in to CF API";
  local login_cmd="./cf login \
      -u \"$username\" \
      -p \"$password\" \
      -o \"$organization\" \
      -s \"$space\" \
      -a \"$api\"";

  if [ -n "$skip_ssl" ]; then
    login_cmd="$login_cmd --skip-ssl-validation";
  fi
  eval $login_cmd;

  if [ -n "$alt_appname" ]; then
    info "Doing Blue-green deploy with $appname and $alt_appname";
    if [ -z "$domain" ]; then
      fail "domain not specified; it is required for blue-green deploys; please add the domain parameter to the step";
    fi
    blue_green_deploy "$appname" "$alt_appname" "$domain" "$hostname";
  else
    info "Pushing app";
    simple_deploy "$appname" "$domain";
  fi
}

# Run the main function
main;
