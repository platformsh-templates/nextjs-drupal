#!/usr/bin/env bash
########################################################################################################################
# Drupal backend installation:
#   This script installs Drupal, and preps the backend during its first deploy.
########################################################################################################################
# VARIABLES
HOME=$(pwd)
DRUPAL_DIR=$HOME/web
SETUP_DIR=$DRUPAL_DIR/platformsh-setup
NEXTJS_SETTINGS=$HOME/deploy/platformsh.installed
########################################################################################################################
track-installation() {
    cd $HOME
    UPDATE_ENVIRONMENT=$(jq --arg PLATFORM_BRANCH "$PLATFORM_BRANCH" '.environment = $PLATFORM_BRANCH' $SETUP_DIR/env_tracking.json)
    NEXTJS_USER_ID=$(drush user:information 'nextjs' --format=json | jq -r 'to_entries[] | .value.uid')
    UPDATE_USER=$(echo $UPDATE_ENVIRONMENT | jq --arg NEXTJS_USER_ID "$NEXTJS_USER_ID" '.user.uid = $NEXTJS_USER_ID')
    echo $UPDATE_USER > $NEXTJS_SETTINGS
}
########################################################################################################################
make-dotenv() {
    cd $HOME
    FILE='.env.local'

    BASE_URL_UNTRIMMED=$(echo $PLATFORM_ROUTES | base64 --decode | jq -r 'to_entries[] | select (.value.id == "drupal-upstream") | .key')
    DRUPAL_BASE_URL=$(echo "${BASE_URL_UNTRIMMED::-1}")
    NEXT_IMAGE_DOMAIN=$(echo "${BASE_URL_UNTRIMMED:8:-1}")

    DRUPAL_SITE_ID=blog
    DRUPAL_FRONT_PAGE='/node'
    DRUPAL_PREVIEW_SECRET=$PLATFORM_ENVIRONMENT

    DRUPAL_CLIENT_ID=$1
    DRUPAL_CLIENT_SECRET=$PLATFORM_PROJECT_ENTROPY

    printf "# This .env file is generated programmatically within the backend Drupal app for each Platform.sh environment
    # and stored within an network storage mount so it can be shared between apps.

    NEXT_PUBLIC_DRUPAL_BASE_URL=$DRUPAL_BASE_URL
    NEXT_IMAGE_DOMAIN=$NEXT_IMAGE_DOMAIN
    DRUPAL_SITE_ID=$DRUPAL_SITE_ID
    DRUPAL_FRONT_PAGE=$DRUPAL_FRONT_PAGE
    DRUPAL_PREVIEW_SECRET=$DRUPAL_PREVIEW_SECRET
    DRUPAL_CLIENT_ID=$DRUPAL_CLIENT_ID
    DRUPAL_CLIENT_SECRET=$DRUPAL_CLIENT_SECRET
    " > $FILE
}
########################################################################################################################
# Drupal first deploy backend setup.
first-deploy() {
    if [ -f "$NEXTJS_SETTINGS" ]; then
        printf "\n\033[1m* DRUPAL: Skipping installation.\033[0m\n"
    else
        printf "\n\033[1m* DRUPAL: First deploy installation and setup.\033[0m\n"

        # 1. Install Drupal with default profile + creds.
        # TODO: Use cat ../run/config.json | jq -r '.applications[0].slug'
        printf "\033[1m   > Installing Drupal.\033[0m\n"
        INIT_ADMIN_PASS=$PLATFORM_PROJECT_ENTROPY
        drush si --site-name="Drupal" --account-pass=$INIT_ADMIN_PASS -y
        printf "\033[1m   > Installation complete. Your Drupal site has been installed with the following credentials.\n     Please update them immediately, as they will only be available once.\033[0m\n"
        printf "\033[1m     * user:\033[0m admin\n"
        printf "\033[1m     * pass:\033[0m $INIT_ADMIN_PASS\n"

        # 2. Enable modules (https://next-drupal.org/learn/quick-start/enable-modules).
        printf "\033[1m   > Enabing modules.\033[0m\n"
        drush pm:enable next next_jsonapi -y

        # 3. Create role and user (https://next-drupal.org/learn/quick-start/create-role).
        # Create role
        printf "\033[1m   > Creating role.\033[0m\n"
        ROLE_ID=$(cat $SETUP_DIR/env_tracking.json | jq -r '.user.role.id')
        ROLE_LABEL=$(cat $SETUP_DIR/env_tracking.json | jq -r '.user.role.label')
        drush role:create $ROLE_ID $ROLE_LABEL
        # Assign permissions (Bypass content access control, Issue subrequests, View user information).
        printf "\033[1m   > Defining role permissions.\033[0m\n"
        ROLE_PERMISSIONS=$(cat $SETUP_DIR/env_tracking.json | jq -r '.user.role.permissions | join(", ")')
        drush role:perm:add $ROLE_ID $ROLE_PERMISSIONS
        # Create user.
        printf "\033[1m   > Creating user.\033[0m\n"
        USER_ID=$(cat $SETUP_DIR/env_tracking.json | jq -r '.user.id')
        drush user:create $USER_ID
        # Grant permissions to user.
        printf "\033[1m   > Granting permissions.\033[0m\n"
        drush user:role:add $ROLE_ID $USER_ID

        # 4. Configure path aliases (https://next-drupal.org/learn/quick-start/configure-content-types).
        printf "\033[1m   > Configure path aliases for pathauto.\033[0m\n"
        drush scr $SETUP_DIR/create_pathauto_pattern.php

        # 5. Create demo content (https://next-drupal.org/learn/quick-start/create-content).
        printf "\033[1m   > Generating demo nodes.\033[0m\n"
        drush scr $SETUP_DIR/create_dummy_nodes.php

        # 6. Track the installation for the project, and for the current environment.
        printf "\033[1m   > Tracking installation.\033[0m\n"
        track-installation

        # 7. Rebuild the cache post-installation.
        drush cr
    fi

}
########################################################################################################################
# Drupal per branch backend setup.
per-branch-deploy() {
    if [ -f "$NEXTJS_SETTINGS" ]; then
        printf "\n\033[1m* DRUPAL: Something went wrong with the installation.\033[0m\n"
        exit 1
    else
        TRACKING_FILE=platformsh.installed
        PREPPED_ENV=$(cat $TRACKING_FILE | jq -r '.environment')
        PRODUCTION_INITIALIZED=$(cat $TRACKING_FILE | jq -r '.production.initialized')
        if [ "$PREPPED_ENV" != "$PLATFORM_BRANCH" ] || [ "$PRODUCTION_INITIALIZED" = false ]; then

            if [ "$PRODUCTION_INITIALIZED" = false ]; then
                printf "\n\033[1m* DRUPAL: Preparing Drupal for NextJS consumer (first push).\033[0m\n"
            else
                printf "\n\033[1m* DRUPAL: Preparing Drupal for NextJS consumer (new environment).\033[0m\n"
                # Delete entities configured for the parent environment.
                drush entity:delete consumer
                drush entity:delete next_site
                drush entity:delete next_entity_type_config
            fi 

            # Generate keys.
            printf "\033[1m   > Generating keys.\033[0m\n"
            drush simple-oauth:generate-keys /app/private
            # Configure the NextJS consumer.
            printf "\033[1m   > Configuring the NextJS consumer.\033[0m\n"

        else 
            printf "\n\033[1m* DRUPAL: Environment already prepped for frontend. Skipping setup.\033[0m\n"
        fi 


            # # 1. Create consumer (https://next-drupal.org/learn/quick-start/create-consumer)
            # # Generate keys
            # printf "\033[1m   > Generating keys.\033[0m\n"
            # drush simple-oauth:generate-keys /app/private
            # # Create consumer (/admin/config/services/consumer/add)
            # printf "\033[1m   > Creating consumer.\033[0m\n"
            # NEXT_USER_ID=$(cat platformsh.installed | jq -r '.nextjs.id')
            # # TODO: pipe everything into the script (maybe one script), so its consistent.
            # CONSUMER_SECRET=$PLATFORM_PROJECT_ENTROPY
            # CONSUMER_UUID=$(drush scr newconsumer.php $NEXTJS_USER_ID)

            # # 5. Create Next.js site (https://next-drupal.org/learn/quick-start/create-nextjs-site)
            # printf "\033[1m   > Creating NextJS site.\033[0m\n"
            # # Create site (/admin/config/services/next)
            # #   - depends on: current environment url, PLATFORM_ENVIRONMENT as preview secret
            # drush scr newnextsite.php

            #     # Configure preview (/admin/config/services/next/entity-types)
            # # Configure a site-resolver for the Article content type.
            # #   - depends on: the created nextjs site for the current environment.
            # drush scr configsiteresolver.php
    fi
# Per branch (commit/first commit?):
#   - env url, preview secret --> create next.js site
#   - next.js site id --> configure site-resolver
#   - generate a new .env.local file in the network storage mount
}
########################################################################################################################
# Drupal maintenance deployment commands.
maintenance-deploy() {
    cd $DRUPAL_DIR
    drush -y cache-rebuild
    drush -y updatedb
    drush -y config-import
}
########################################################################################################################
# Main
#  1. consumer secret, consumer_uuid need to be available to frontend, and downloadable for local (network storage)
#  2. need to update/delete next.js side (expand newnextsite to check, update/delete)
#  3. need to update/delete site-resolver for that site (expand configsiteresolver to check, update/delete)
#  4. platformsh.installed is good for 'first_deploy' tracking, but something better is needed for tracking across environments. (platformsh.installed-like check in a regular mount?)
deploy() {
    cd $HOME
    php ./drush/platformsh_generate_drush_yml.php
    first-deploy
    # per-branch-deploy 
    maintenance-deploy
}

# deploy
maintenance-deploy

# 1. missing htaccess file in config/sync
# 2. 