#!/usr/bin/env bash
########################################################################################################################
# A. VARIABLES AND HELPERS
HOME=$(pwd)
DRUPAL_WEB=$HOME/web
DRUPAL_SETUP=$HOME/platformsh-scripts
ENV_SETTINGS=$HOME/deploy/platformsh.installed
ENV_SOURCED=$HOME/deploy/platformsh.env
ENV_EXPORT_SOURCED=$HOME/deploy/platformsh.environment
separator() {
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}
########################################################################################################################
# B. DRUSH
php ./drush/platformsh_generate_drush_yml.php
########################################################################################################################
# C. FIRST INSTALLATION
install_drupal() {
    # 1. Install the site.
    printf "    ✔ Installing Drupal with a Standard profile.\n"
    INIT_ADMIN_PASS=$(cat ../run/config.json | jq -r '.applications[0].slug')
    drush si -q --site-name="Drupal" --account-pass=$INIT_ADMIN_PASS -y
    # 2. Warn the user.
    printf "    ✔ Installation complete.\n"
    printf "    ✔ Your Drupal site has been installed with the following credentials:\n"
    printf "        * \033[1muser:\033[0m admin\n"
    printf "        * \033[1mpass:\033[0m $INIT_ADMIN_PASS\n"
    printf "    ✗ \033[1mWARNING: Update your password and email immediately. They will only be available once.\033[0m\n"
    # 3. Track the installation in a writable file.
    cp $DRUPAL_SETUP/settings.json $ENV_SETTINGS
}
enable_modules() {
    MODULES=$(cat $ENV_SETTINGS | jq -r '.modules | join(" ")')
    printf "    ✔ Enabing modules.\n"
    for row in $(cat $ENV_SETTINGS | jq -r '.modules [] | @base64'); do
        _jq() {
            echo ${row} | base64 --decode
        }
    printf "        * $(_jq '.')\n"
    done 
    drush -q pm:enable $MODULES -y
}
config_role_user_perms(){
    # 1. Create role.
    ROLE_ID=$(cat $ENV_SETTINGS | jq -r '.user.role.id')
    ROLE_LABEL=$(cat $ENV_SETTINGS | jq -r '.user.role.label')
    printf "    ✔ Creating role.\n"
    drush -q role:create "$ROLE_ID" "$ROLE_LABEL"
    printf "        * id: $ROLE_ID\n"
    printf "        * label: $ROLE_LABEL\n"
    # 2. Assign permissions (Bypass content access control, Issue subrequests, View user information).
    ROLE_PERMISSIONS=$(cat $ENV_SETTINGS | jq -r '.user.role.permissions | join(", ")')
    printf "    ✔ Defining role permissions.\n"
    for row in $(cat $ENV_SETTINGS | jq -r '.user.role.permissions [] | @base64'); do
        _jq() {
            echo ${row} | base64 --decode
        }
    printf "        * $(_jq '.')\n"
    done 
    drush -q role:perm:add "$ROLE_ID" "$ROLE_PERMISSIONS"
    # 3. Create user.
    USER_ID=$(cat $ENV_SETTINGS | jq -r '.user.id')
    printf "    ✔ Creating user: $USER_ID\n"
    printf "        * id: $USER_ID\n"
    drush -q user:create "$USER_ID"
    # 4. Grant permissions to user.
    printf "    ✔ Granting role permissions to user: $USER_ID\n"
    drush -q user:role:add "$ROLE_ID" "$USER_ID"
    printf "        * user_id: $USER_ID\n"
    printf "        * role_id: $USER_ID\n"
}
configure_pathauto(){
    # Configure path aliases (https://next-drupal.org/learn/quick-start/configure-content-types).
    printf "    ✔ Defining node aliases via pathauto.\n"
    drush scr $DRUPAL_SETUP/drupal_config_pathauto.php
    printf "        * type: $(cat $ENV_SETTINGS | jq -r '.nodes.pathauto.type')\n"
    printf "        * bundle: $(cat $ENV_SETTINGS | jq -r '.nodes.pathauto.bundle')\n"
    printf "        * label: $(cat $ENV_SETTINGS | jq -r '.nodes.pathauto.label')\n"
    printf "        * pattern: $(cat $ENV_SETTINGS | jq -r '.nodes.pathauto.pattern')\n"
}
create_demo_content(){
    # Create demo content (https://next-drupal.org/learn/quick-start/create-content).
    NUM_NODES=$(cat $ENV_SETTINGS | jq -r '.nodes.dummy.num_nodes')
    printf "    ✔ Generating $NUM_NODES demo article nodes.\n"
    printf "        * data: $(cat $ENV_SETTINGS | jq -r '.nodes.dummy.data')\n"
    printf "        * num_nodes: $(cat $ENV_SETTINGS | jq -r '.nodes.dummy.num_nodes')\n"
    printf "        ! Get some coffee, this will take a moment...\n"
    drush scr $DRUPAL_SETUP/demo_create_nodes.php '/app/platformsh-scripts/demo_nasa_images.json'
}
track_installation() {
    printf "    ✔ Tracking project installation.\n"
    # Track environment name.
    UPDATE_ENVIRONMENT=$(jq --arg PLATFORM_BRANCH "$PLATFORM_BRANCH" '.environment = $PLATFORM_BRANCH' $ENV_SETTINGS)
    # Track created user.
    USER_ID=$(cat $ENV_SETTINGS | jq -r '.user.id')
    NEXTJS_USER_ID=$(drush user:information "$USER_ID" --format=json | jq -r 'to_entries[] | .value.uid')
    # Save the data.
    UPDATE_USER=$(echo $UPDATE_ENVIRONMENT | jq --arg NEXTJS_USER_ID "$NEXTJS_USER_ID" '.user.uid = $NEXTJS_USER_ID')
    echo $UPDATE_USER > $ENV_SETTINGS
    # Rebuild the cache.
    printf "    ✔ Rebuilding the cache.\n"
    drush -q -y cr
}
# separator
if [ -f "$ENV_SETTINGS" ]; then
    printf "\n* Project already installed.\n"
else
    printf "\n* Fresh project detected.\n"    
    # 1. Install Drupal with default profile + creds.
    install_drupal
    # 2. Enable modules (https://next-drupal.org/learn/quick-start/enable-modules).
    enable_modules
    # 3. Create role and user (https://next-drupal.org/learn/quick-start/create-role).
    config_role_user_perms
    # 4. Configure pathauto.
    configure_pathauto
    # 5. Create demo content.
    create_demo_content
    # 6. Track the installation for the project, and for the current environment.
    track_installation
fi
########################################################################################################################
# D. ENVIRONMENT FIRST PUSH
clear_consumer_config(){
        printf "* Preparing Drupal for NextJS consumer.\n"
        printf "    ✔ Current settings    : $PLATFORM_BRANCH\n"
        printf "    ✔ Current environment : $2\n"
        printf "    ✔ Production installed: $1\n"
        
    if [ "$1" = false ]; then
        printf "* Fresh project detected.\n"
    else
        printf "* New environment detected.\n"
        printf "    ✔ Deleting parent environment configuration\n"
        # Delete entities configured for the parent environment.
        drush -q entity:delete consumer
        drush -q entity:delete next_site
        drush -q entity:delete next_entity_type_config
        printf "* Configuring the current environment.\n"
    fi 
}
generate_keys() {
    KEY_LOCATION=$(cat $ENV_SETTINGS | jq -r '.keys.path')
    printf "    ✔ Generating keys: $KEY_LOCATION\n"
    drush -q simple-oauth:generate-keys $KEY_LOCATION
}
create_consumer() {
    printf "    ✔ Configuring the NextJS consumer: \n"
    # Create the consumer.
    NEXT_USER_ID=$(cat $ENV_SETTINGS | jq -r '.user.role.id')
    CONSUMER_SECRET=$PLATFORM_PROJECT_ENTROPY
    CONSUMER_UUID=$(drush scr $DRUPAL_SETUP/drupal_create_consumer.php "$NEXTJS_USER_ID" "$CONSUMER_SECRET")
    # Track the changes.
    SETTINGS_UPDATES=$(jq --arg CONSUMER_SECRET "$CONSUMER_SECRET" '.consumer.secret = $CONSUMER_SECRET' $ENV_SETTINGS)
    SETTINGS_UPDATES=$(echo $SETTINGS_UPDATES | jq --arg CONSUMER_UUID "$CONSUMER_UUID" '.consumer.uid = $CONSUMER_UUID')
    echo $SETTINGS_UPDATES > $ENV_SETTINGS
    printf "        * user: $(cat $ENV_SETTINGS | jq -r '.user.role.id')\n"
    printf "        * site: TODO-FIX-THIS IS WHERE IT BREAKS I BET.\n"
    printf "        * id: $(cat $ENV_SETTINGS | jq -r '.consumer.id')\n"
    printf "        * label: $(cat $ENV_SETTINGS | jq -r '.consumer.label')\n"
    printf "        * consumer_uid: $(cat $ENV_SETTINGS | jq -r '.consumer.uid')\n"
    printf "        * consumer_secret: $(cat $ENV_SETTINGS | jq -r '.consumer.secret')\n"
}
create_nextjs_site() {
    printf "    ✔ Creating the NextJS site entity. \n"
    # Create the site.
    PREVIEW_SECRET=$PLATFORM_ENVIRONMENT
    drush scr $DRUPAL_SETUP/drupal_create_nextjs.php $PREVIEW_SECRET
    # Track the changes.
    SETTINGS_UPDATES=$(jq --arg PREVIEW_SECRET "$PREVIEW_SECRET" '.nextjssite.preview.secret = $PREVIEW_SECRET' $ENV_SETTINGS)
    echo $SETTINGS_UPDATES > $ENV_SETTINGS
    printf "        * id: $(cat $ENV_SETTINGS | jq -r '.nextjssite.id') \n"
    printf "        * label: $(cat $ENV_SETTINGS | jq -r '.nextjssite.label')  \n"
    printf "        * base_url: $(cat $ENV_SETTINGS | jq -r '.nextjssite.url.base') \n"
    printf "        * preview_url: $(cat $ENV_SETTINGS | jq -r '.nextjssite.url.preview') \n"
    printf "        * preview_secret: $(cat $ENV_SETTINGS | jq -r '.nextjssite.preview.secret') \n"
}
configure_previews() {
    printf "    ✔ Configuring previews. \n"
    drush scr $DRUPAL_SETUP/drupal_config_previews.php
    printf "        * id: $(cat $ENV_SETTINGS | jq -r '.resolver.id') \n"
    printf "        * site: $(cat $ENV_SETTINGS | jq -r '.nextjssite.id')  \n"
    printf "        * site_resolver: $(cat $ENV_SETTINGS | jq -r '.resolver.resolver') \n"
}
make-dotenvs() {

    printf "* Preparing credentials for frontend.\n"
    NEXT_PUBLIC_DRUPAL_BASE_URL=$(cat $ENV_SETTINGS | jq -r '.url.base')
    NEXT_IMAGE_DOMAIN=$(cat $ENV_SETTINGS | jq -r '.url.image_domain')
    DRUPAL_SITE_ID=$(cat $ENV_SETTINGS | jq -r '.nextjssite.id')
    DRUPAL_FRONT_PAGE=$(cat $ENV_SETTINGS | jq -r '.front_page')
    DRUPAL_PREVIEW_SECRET=$(cat $ENV_SETTINGS | jq -r '.nextjssite.preview.secret')
    DRUPAL_CLIENT_ID=$(cat $ENV_SETTINGS | jq -r '.consumer.uid')
    DRUPAL_CLIENT_SECRET=$(cat $ENV_SETTINGS | jq -r '.consumer.secret')

    # Create the .env file that can be used for local development.
    # separator
    printf "* Writing local configuration.\n"
    printf "# This .env file is generated programmatically within the backend Drupal app for each Platform.sh environment
# and stored within an network storage mount so it can be used locally.

NEXT_PUBLIC_DRUPAL_BASE_URL=$NEXT_PUBLIC_DRUPAL_BASE_URL
NEXT_IMAGE_DOMAIN=$NEXT_IMAGE_DOMAIN
DRUPAL_SITE_ID=$DRUPAL_SITE_ID
DRUPAL_FRONT_PAGE=$DRUPAL_FRONT_PAGE
DRUPAL_PREVIEW_SECRET=$DRUPAL_PREVIEW_SECRET
DRUPAL_CLIENT_ID=$DRUPAL_CLIENT_ID
DRUPAL_CLIENT_SECRET=$DRUPAL_CLIENT_SECRET
    " > $ENV_SOURCED
    printf "\n$(cat $ENV_SOURCED)\n"

    # Create the exporting .environment file.
    # separator
    printf "* Writing remote configuration.\n"
    printf "# This .env file is generated programmatically within the backend Drupal app for each Platform.sh environment
# and stored within an network storage mount so it can be shared between apps.

export NEXT_PUBLIC_DRUPAL_BASE_URL=$NEXT_PUBLIC_DRUPAL_BASE_URL
export NEXT_IMAGE_DOMAIN=$NEXT_IMAGE_DOMAIN
export DRUPAL_SITE_ID=$DRUPAL_SITE_ID
export DRUPAL_FRONT_PAGE=$DRUPAL_FRONT_PAGE
export DRUPAL_PREVIEW_SECRET=$DRUPAL_PREVIEW_SECRET
export DRUPAL_CLIENT_ID=$DRUPAL_CLIENT_ID
export DRUPAL_CLIENT_SECRET=$DRUPAL_CLIENT_SECRET
    " > $ENV_EXPORT_SOURCED
    printf "\n$(cat $ENV_EXPORT_SOURCED)\n"
}
track_environment() {
    printf "    ✔ Logging environment updates. \n"
    # Track the backend URLs.
    printf "    ✔ Logging backend configuration.\n"
    ENVIRONMENT=$(echo $PLATFORM_ROUTES | base64 --decode | jq -r 'to_entries[] | select(.value.id == "api") | .key')
    DRUPAL_URL=${ENVIRONMENT%/}
    IMAGE_DOMAIN="${DRUPAL_URL:8}"
    SETTINGS_UPDATES=$(jq --arg DRUPAL_URL "$DRUPAL_URL" '.url.base = $DRUPAL_URL' $ENV_SETTINGS)
    SETTINGS_UPDATES=$(echo $SETTINGS_UPDATES | jq --arg IMAGE_DOMAIN "$IMAGE_DOMAIN" '.url.image_domain = $IMAGE_DOMAIN')
    echo $SETTINGS_UPDATES > $ENV_SETTINGS

    # Track the frontend URLs.
    printf "    ✔ Logging frontend configuration.\n"
    FRONTEND=$(echo $PLATFORM_ROUTES | base64 --decode | jq -r 'to_entries[] | select(.value.id == "client") | .key')
    FRONTEND_URL=${FRONTEND%/}
    PREVIEW_URL=$FRONTEND_URL/api/preview
    SETTINGS_UPDATES=$(jq --arg FRONTEND_URL "$FRONTEND_URL" '.nextjssite.url.base = $FRONTEND_URL' $ENV_SETTINGS)
    SETTINGS_UPDATES=$(echo $SETTINGS_UPDATES | jq --arg PREVIEW_URL "$PREVIEW_URL" '.nextjssite.url.preview = $PREVIEW_URL')
    echo $SETTINGS_UPDATES > $ENV_SETTINGS

    # Track the production install.
    if [[ "$PLATFORM_ENVIRONMENT_TYPE" == "production" ]] || [[ "$PLATFORM_BRANCH" == "installer" ]] ; then
        echo "    ✔ Logging production installation"
        SETTINGS_UPDATES=$(jq '.production.initialized = true' $ENV_SETTINGS)
        echo $SETTINGS_UPDATES > $ENV_SETTINGS
    fi

    # Share everything we've been tracking with the frontend.
    make-dotenvs

}
# separator
if [ -f "$ENV_SETTINGS" ]; then
    printf "* Configuring the environment.\n"
    # 1. Check the current environment and project status.
    PREPPED_ENV=$(cat $ENV_SETTINGS | jq -r '.environment')
    PROD_INSTALL=$(cat $ENV_SETTINGS | jq -r '.production.initialized')
    # 2. Run setup if a) very first project deploy on production environment, or b) first deploy on a new environment.
    if [ "$PROD_INSTALL" = false ]  || [ "$PREPPED_ENV" != "$PLATFORM_BRANCH" ]; then
        # a. Clear the previous environment's configuration.
        clear_consumer_config $PROD_INSTALL $PREPPED_ENV
        # b. Generate keys.
        generate_keys
        # c. Create consumer (https://next-drupal.org/learn/quick-start/create-consumer).
        create_consumer
        # d. Create Next.js site (https://next-drupal.org/learn/quick-start/create-nextjs-site).
        create_nextjs_site
        # e. Configure previews.
        configure_previews
        # f. Track environment setup.
        track_environment
    else
        printf "\n\033[1m* Environment already prepped for frontend. Skipping setup.\033[0m\n"
    fi
else
    printf "\n\033[1m! Something went wrong with the installation.\033[0m\n"
    exit 1
fi
########################################################################################################################
# E. EVERY DEPLOYMENT
# separator
drush -q -y cache-rebuild
drush -q -y updatedb
drush -q -y config-import
