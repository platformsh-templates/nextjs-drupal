# nextjs-drupal


## Post-installation

When the project is initialized, a set of initial administrator credentials were used to install Drupal. In this case, the slug of the first commit event was used as the password. This is important because this information is only available during this first commit. After you've deployed the demo, view the first activity for the production environment, and find this block of text when Drupal's deploy hook runs:

```bash
Creating environment pr-1
  Starting environment
  Opening applications nextjs, drupal, and their relationships
  Executing deploy hook for application drupal
    Created Drush configuration file: /app/.drush/drush.yml
    
    * Fresh project detected.
        ✔ Installing Drupal with a Standard profile (see https://next-drupal.org/learn/quick-start/install-drupal).
        ✔ Installation complete.
        ✔ Your Drupal site has been installed with the following credentials:
            * user: admin
            * pass: PASSWORD-GENERATED-HERE-ON-FIRST-PUSH
        ✗ WARNING: Update your password and email immediately. They will only be available once.
```

From this, you can log into Drupal using the credentials listed (`admin`/`PASSWORD-GENERATED-HERE-ON-FIRST-PUSH`) and then update them to something more memorable.

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

One of two things are happening

- generate keys: configuration actually needs to be saved when keys are generated
- nextjs site: uses localhost in docs, not identical to local app

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
