
<p align="right">
    <a href="https://platform.sh">
        <img src="https://platform.sh/logos/redesign/Platformsh_logo_black.svg" width="150px">
    </a>
</p>

<p align="center">
    <a href="https://github.com/strapi/foodadvisor">
        <img src="header.svg">
    </a>
</p>

<h1 align="center">Deploy Next.js and Drupal on Platform.sh</h1>

<p align="center">
    <strong>Contribute to the Platform.sh knowledge base, or check out our resources</strong>
    <br />
    <br />
    <a href="https://community.platform.sh"><strong>Join our community</strong></a>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
    <a href="https://docs.platform.sh"><strong>Documentation</strong></a>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
    <a href="https://platform.sh/blog"><strong>Blog</strong></a>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
    <a href="https://github.com/platformsh-templates/nextjs-drupal/issues"><strong>Report a bug</strong></a>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
    <a href="https://github.com/platformsh-templates/nextjs-drupal/issues"><strong>Request a feature</strong></a>
    <br /><br />
</p>

<p align="center">
    <a href="https://github.com/platformsh-templates/nextjs-drupal/issues">
        <img src="https://img.shields.io/github/issues/platformsh-templates/nextjs-drupal.svg?style=flat-square&labelColor=f4f2f3&color=ffd9d9&label=Issues" alt="Open issues" />
    </a>&nbsp&nbsp
    <a href="https://github.com/platformsh-templates/pulls">
        <img src="https://img.shields.io/github/issues-pr/platformsh-templates/nextjs-drupal.svg?style=flat-square&labelColor=f4f2f3&color=ffd9d9&label=Pull%20requests" alt="Open PRs" />
    </a>&nbsp&nbsp
    <a href="https://github.com/platformsh-templates/nextjs-drupal/blob/master/LICENSE">
        <img src="https://img.shields.io/static/v1?label=License&message=MIT&style=flat-square&labelColor=f4f2f3&color=ffd9d9" alt="License" />
    </a>&nbsp&nbsp
    <br /><br /><br />
    <a href="https://console.platform.sh/projects/create-project?template=https://raw.githubusercontent.com/platformsh/template-builder/nextjs-drupal/templates/nextjs-drupal/.platform.template.yaml&utm_content=nextjs-drupal&utm_source=github&utm_medium=button&utm_campaign=deploy_on_platform">
        <img src="https://platform.sh/images/deploy/lg-blue.svg" alt="Deploy on Platform.sh" width="175px" />
    </a>
</p>
</p>

<hr>
<br />

## Contents

- [About this project](#about-this-project)
- [Getting started](#getting-started)
- [Customizations](#customizations)
- [License](#license)
- [Contact](#contact)
- [Resources](#resources)
- [Contributing](#contributing)

## About this project

This template demonstrates a multi-app deployment on Platform.sh, in this case, a Next.js frontend consuming data from a Drupal 9 backend running on the same environment. It is based largely on the configuration instructions provided by the [Next-Drupal project by Chapter Three](https://next-drupal.org/).

Next.js is an open-source web framework written for Javascript, and Drupal is a flexible and extensible PHP-based CMS framework..

### Features

- PHP 8.1
- Node.js 16
- MariaDB 10.4
- Redis 6.0
- Network Storage
- Automatic TLS certificates
- Multi-app configuration
- yarn-based builds
- Delayed SSG build (post deploy hook)

## Getting started

### Deploy

#### Quickstart

The quickest way to deploy this template on Platform.sh is by clicking the button below. This will automatically create a new project and initialize the repository for you.

<p align="center">
    <a href="https://console.platform.sh/projects/create-project?template=https://raw.githubusercontent.com/platformsh/template-builder/master/templates/nextjs-drupal/.platform.template.yaml&utm_content=nextjs-drupal&utm_source=github&utm_medium=button&utm_campaign=deploy_on_platform">
        <img src="https://platform.sh/images/deploy/lg-blue.svg" alt="Deploy on Platform.sh" width="170px" />
    </a>
</p>

> **Note:**
>
> If you do not already have a Platform.sh account, you will be asked to fill out some basic information, after which you will be given a 30-day free trial to experiment with our platform.

#### Other deployment options

<details>
<summary>Deploy directly to Platform.sh from the command line</summary><br />

1. Clone this repository:

   ```bash
   git clone https://github.com/platformsh-templates/nextjs-drupal
   ```

1. Create a free trial:

   [Register for a 30 day free trial with Platform.sh](https://auth.api.platform.sh/register). When you have completed signup, select the **Create from scratch** project option. Give you project a name, and select a region where you would like it to be deployed. As for the *Production environment* option, make sure to match it to this repository's settings, or to what you have updated the default branch to locally.

1. Install the Platform.sh CLI

   #### Linux/OSX

   ```bash
   curl -sS https://platform.sh/cli/installer | php
   ```

   #### Windows

   ```bash
   curl -f https://platform.sh/cli/installer -o cli-installer.php
   php cli-installer.php
   ```

   You can verify the installation by logging in (`platformsh login`) and listing your projects (`platform project:list`).

1. Set the project remote

   Find your `PROJECT_ID` by running the command `platform project:list` 

   ```bash
   +---------------+------------------------------------+------------------+---------------------------------+
   | ID            | Title                              | Region           | Organization                    |
   +---------------+------------------------------------+------------------+---------------------------------+
   | PROJECT_ID    | Your Project Name                  | xx-5.platform.sh | your-username                   |
   +---------------+------------------------------------+------------------+---------------------------------+
   ```

   Then from within your local copy, run the command `platform project:set-remote PROJECT_ID`.

1. Push

   ```bash
   git push platform DEFAULT_BRANCH
   ```

</details>

<details>
<summary>Deploy from GitHub</summary><br />

If you would instead to deploy this template from your own repository on GitHub, you can do so through the following steps.

> **Note:**
>
> You can find the full [GitHub integration documentation here](https://docs.platform.sh/integrations/source/github.html).

1. Clone this repository:

   Click the [Use this template](https://github.com/platformsh-templates/nextjs-drupal/generate) button at the top of this page to create a new repository in your namespace containing this demo. Then you can clone a copy of it locally with `git clone git@github.com:YOUR_NAMESPACE/nextjs-drupal.git`.

1. Create a free trial:

   [Register for a 30 day free trial with Platform.sh](https://auth.api.platform.sh/register). When you have completed signup, select the **Create from scratch** project option. Give you project a name, and select a region where you would like it to be deployed. As for the *Production environment* option, make sure to match it to whatever you have set at `https://YOUR_NAMESPACE/nextjs-drupal`.

1. Install the Platform.sh CLI

   #### Linux/OSX

   ```bash
   curl -sS https://platform.sh/cli/installer | php
   ```

   #### Windows

   ```bash
   curl -f https://platform.sh/cli/installer -o cli-installer.php
   php cli-installer.php
   ```

   You can verify the installation by logging in (`platformsh login`) and listing your projects (`platform project:list`).

1. Setup the integration:

   Consult the [GitHub integration documentation](https://docs.platform.sh/integrations/source/github.html#setup) to finish connecting your repository to a project on Platform.sh. You will need to create an Access token on GitHub to do so.

</details>

<details>
<summary>Deploy from GitLab</summary><br />

If you would instead to deploy this template from your own repository on GitLab, you can do so through the following steps.

> **Note:**
>
> You can find the full [GitLab integration documentation here](https://docs.platform.sh/integrations/source/gitlab.html).

1. Clone this repository:

   ```bash
   git clone https://github.com/platformsh-templates/nextjs-drupal
   ```

1. Create a free trial:

   [Register for a 30 day free trial with Platform.sh](https://auth.api.platform.sh/register). When you have completed signup, select the **Create from scratch** project option. Give you project a name, and select a region where you would like it to be deployed. As for the *Production environment* option, make sure to match it to this repository's settings, or to what you have updated the default branch to locally.

1. Install the Platform.sh CLI

   #### Linux/OSX

   ```bash
   curl -sS https://platform.sh/cli/installer | php
   ```

   #### Windows

   ```bash
   curl -f https://platform.sh/cli/installer -o cli-installer.php
   php cli-installer.php
   ```

   You can verify the installation by logging in (`platformsh login`) and listing your projects (`platform project:list`).

1. Create the repository

   Create a new repository on GitLab, set it as a new remote for your local copy, and push to the default branch. 

1. Setup the integration:

   Consult the [GitLab integration documentation](https://docs.platform.sh/integrations/source/gitlab.html#setup) to finish connecting a repository to a project on Platform.sh. You will need to create an Access token on GitLab to do so.

</details>

<details>
<summary>Deploy from Bitbucket</summary><br />

If you would instead to deploy this template from your own repository on Bitbucket, you can do so through the following steps.

> **Note:**
>
> You can find the full [Bitbucket integration documentation here](https://docs.platform.sh/integrations/source/bitbuckethtml).

1. Clone this repository:

   ```bash
   git clone https://github.com/platformsh-templates/nextjs-drupal
   ```

1. Create a free trial:

   [Register for a 30 day free trial with Platform.sh](https://auth.api.platform.sh/register). When you have completed signup, select the **Create from scratch** project option. Give you project a name, and select a region where you would like it to be deployed. As for the *Production environment* option, make sure to match it to this repository's settings, or to what you have updated the default branch to locally.

1. Install the Platform.sh CLI

   #### Linux/OSX

   ```bash
   curl -sS https://platform.sh/cli/installer | php
   ```

   #### Windows

   ```bash
   curl -f https://platform.sh/cli/installer -o cli-installer.php
   php cli-installer.php
   ```

   You can verify the installation by logging in (`platformsh login`) and listing your projects (`platform project:list`).

1. Create the repository

   Create a new repository on Bitbucket, set it as a new remote for your local copy, and push to the default branch. 

1. Setup the integration:

   Consult the [Bitbucket integration documentation](https://docs.platform.sh/integrations/source/bitbucket.html#setup) to finish connecting a repository to a project on Platform.sh. You will need to create an Access token on Bitbucket to do so.

</details>

### Post-install

This demo repository is set up to deploy both front and backend application containers to the production environment, and to initialize the database with files and data generated by a collection of scripts that run during Drupal's first deploy.  

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

### Local development

This section provides instructions for running the Next.js + Drupal template locally, connected to a live database instance on an active Platform.sh environment.

In all cases for developing with Platform.sh, it's important to develop on an isolated environment - do not connect to data on your production environment when developing locally. Each of the options below assume the following starting point:

```bash
platform get PROJECT_ID
cd project-name
platform environment:branch updates
```

> **Note:**
>
> For many of the steps below, you may need to include the CLI flags `-p PROJECT_ID` and `-e ENVIRONMENT_ID` if you are not in the project directory or if the environment is associated with an existing pull request.

<details>
<summary>Running the Drupal backend</summary><br />

1. **Using ddev**:

      ddev provides an integration with Platform.sh that makes it simple to develop Drupal locally. Check the [providers documentation](https://ddev.readthedocs.io/en/latest/users/providers/platform/) for the most up-to-date information. 

      In general, the steps are as follows:

      1. A configuration file has already been provided at `api/.ddev/providers/platform.yaml`, so you should not need to run `ddev config`.
      1. [Retrieve an API token](https://docs.platform.sh/development/cli/api-tokens.html#get-a-token) for your organization via the management console.
      1. Update your dedev global configuration file to use the token you've just retrieved:
         
         ```yaml
         web_environment:
         - PLATFORMSH_CLI_TOKEN=abcdeyourtoken`
         ```

      1. Run `ddev restart`.
      1. Get your project ID with `platform project:info`. If you have not already connected your local repo with the project (as is the case with a source integration, by default), you can run `platform project:list` to locate the project ID, and `platform project:set-remote PROJECT_ID` to configure Platform.sh locally.
      1. Update the `.ddev/providers/platform.yaml` file for your current setup:

         ```yaml
         environment_variables:
            project_id: PROJECT_ID
            environment: CURRENT_ENVIRONMENT
            application: drupal
         ```

      1. Get the current environment's data with `ddev pull platform`. 
      1. When you have finished with your work, run `ddev stop` and `ddev poweroff`.

1. **Using Lando**:

      Lando supports PHP applications configured to run on Platform.sh, and pulls from the same registry Platform.sh uses on your remote environments during your local builds through its own [recipe and plugin](https://docs.lando.dev/platformsh/). 


      1. When you have finished with your work, run `lando stop` and `lando poweroff`.

</details>

<details>
<summary>Running the Next.js frontend</summary><br />

After you have created a new environment, you can connect to a backend Drupal instance and develop the frontend locally with the following steps.

1. `cd client`
1. Update the environment variables for the current environment by running `./get_local_config.sh`. This will pull the generated `.env.local` file for the current environment.

   ```bash
   # This .env file is generated programmatically within the backend Drupal app for each Platform.sh environment
   # and stored within an network storage mount so it can be used locally.

   NEXT_PUBLIC_DRUPAL_BASE_URL=https://api.ENVIRONMENT-HASH-PROJECTID.REGION.platformsh.site
   NEXT_IMAGE_DOMAIN=api.ENVIRONMENT-HASH-PROJECTID.REGION.platformsh.site
   DRUPAL_SITE_ID=nextjs_site
   DRUPAL_FRONT_PAGE=/node
   DRUPAL_CLIENT_ID=CONSUMER_CLIENT_ID
   DRUPAL_CLIENT_SECRET=GENERATED_SECRET
   ```

1. Install dependencies: `yarn --frozen-lockfile`.
1. Run the development server: `yarn dev`. Next.js will then run on http://localhost:3000.

</details>

## Customizations

The following changes have been made relative to the [Next.js-Drupal documentation](https://next-drupal.org/), nameley the Getting Started documentation, to run on Platform.sh. If using this project as a reference for your own existing project, replicate the changes below to your project.

<details>
<summary>Shared files</summary><br />

- `.platform/services.yaml`, and `.platform/routes.yaml` files have been added. These provide Platform.sh-specific configuration for provisioning an Oracle MySQL container and for defining how traffic is handled between the two application containers, respectively. They are present in all projects on Platform.sh, and you may customize them as you see fit. Consult those files for more information, or take a look at the [Routes](https://docs.platform.sh/configuration/routes.html) and [Services](https://docs.platform.sh/configuration/services.html) documentation for details about configuration. 

</details>

<details>
<summary>Drupal (<code>api</code>)</summary><br />

Like the [Next.js-Drupal documentation](https://next-drupal.org/) recommends, a starter Drupal 9 site is used initially with the command `composer create-project drupal/recommended-project api`. 

- `drush/platformsh_generate_drush_yaml.php`: This file generates a Drush configuration file in the application container on every deployment.
- `api/.lando.upstream.yml`: A default Lando configuration file has been added to make starting up locally with Lando easier. See the [Local development](#local-development) section for more details. 
- `api/web/sites/default/settings.platformsh.php`: Contains Platform.sh-specific configuration, namely setting up the database connection to the MariaDB service and caching via Redis. 
- `api/web/sites/default/settings.php`: Has been modified to use the previous Platform.sh-specific settings file, plus modifications for local development with ddev.
- A `api/.platform.app.yaml` file has been added, which is required to define the build and deploy process for all application containers on Platform.sh. Take a look at the [Application](https://docs.platform.sh/configuration/services.html) documentation for more details about configuration.
- `.ddev`: ddev local development configuration has been provided. See the [Local development](#local-development) section for more details. 

A number of extra files have been included in this template to support Next.js + Drupal connections across development environments on Platform.sh. All of those files can be found in the `api/platformsh-scripts` directory. In most cases, you should be able to use 


### Configuring Next.js + Drupal across environments

The [Next.js-Drupal documentation](https://next-drupal.org/) documentation provides detailed steps to configure a relationship between a Next.js consuming client application and a Drupal backend application serving an API. 

</details>

<details>
<summary>Next.js customizations (<code>client</code>)</summary><br />

As outlined in the [Next.js-Drupal documentation](https://next-drupal.org/), the Next.js frontend application has been generated from the [Chapter Three upstream](https://github.com/chapter-three/next-drupal-basic-starter) using the `npx create-next-app -e https://github.com/chapter-three/next-drupal-basic-starter` command. The most important changes made to that starting point are listed below. You can replicate those changes to migrate your own Next.js frontend pulling data from Drupal. 

- `sharp` was added as a dependency, since it is recommended for handling images.
- The upstream repo comes with a single start command (`yarn preview`) which is a combination of two commands (`next build && next start`). During deployment these commands need to be run separately, so the commands `yarn build` and `yarn start` have been added to `package.json`. 
- A `client/.environment` file has been added. This file is sourced on a Platform.sh environment during startup, at the beginning of the deploy hook, and whenever you SSH into the environment (`platform ssh -e ENVIRONMENT_ID`). It initializes environment variables specific to this demo, related to the Drupal backend URL and initial connection credentials. 
- A `client/get_local_config.sh` script has been added. This script simplies the local development process, by connecting to an active Platform.sh environment and retrieving the required `.env.local` file needed to run Next.js on your computer. See the [Local development](#local-development) section for more details. 
- A `client/.platform.app.yaml` file has been added, which is required to define the build and deploy process for all application containers on Platform.sh. Because of how Platform.sh works, the Next.js build is delayed considerably to the `post_deploy` hook after the Drupal container has fully deployed and has begun serving its endpoints. Take a look at the [Application](https://docs.platform.sh/configuration/services.html) documentation for more details about configuration.
- `client/platformsh-scripts/test/next-drupal-debug`: Despite very detailed documentation provided from the Chapter Three team, developers often run into issues setting up the Next.js/Drupal connection for the first time. The problem is made more difficult on Platform.sh, since certain parts of the configuration need to be re-established each time a new development environment is opened. Chapter three provides a debugging tool, [`next-drupal-debug`](https://github.com/shadcn/next-drupal-debug), that uses the expected connection credentials (on the Next.js side) to test that Drupal has been properly configured. This demo template includes a copy of this tool, which has been modified slightly to pull those credentials from environment variables. You will see that the connection is tested during the `post_deploy` hook in `.platform.app.yaml` to ensure everything is working properly. 

</details>

## License

This template uses the [Foodadvisor demo repository]() provided by Strapi.io as its base, which is licensed under the [MIT License](https://github.com/strapi/foodadvisor/blob/master/LICENSE).

## Contact

This template is maintained primarily by the Platform.sh Developer Relations team, and they will be notified of all issues and pull requests you open here.

- **Community:** Share your question with the community, or see if it's already been asked on our [Community site](https://community.platform.sh).
- **Slack:** If you haven't done so already, you can join Platform.sh's [public Slack](https://chat.platform.sh/) channels and ping the `@devrel_team` with any questions.

## Resources

- [Strapi.io](https://strapi.io)
- [Strapi Documentation](https://docs.strapi.io/developer-docs/latest/getting-started/introduction.html)
- [Strapi Foodadvisor Repository](https://github.com/strapi/foodadvisor)
- [Node.js on Platform.sh](https://docs.platform.sh/languages/nodejs.html)

## Contributing

<h3 align="center">Help us keep top-notch templates!</h3>

Every one of our templates is open source, and they're important resources for users trying to deploy to Platform.sh for the first time or better understand the platform. They act as getting started guides, but also contain a number of helpful tips and best practices when working with certain languages and frameworks. 

See something that's wrong with this template that needs to be fixed? Something in the documentation unclear or missing? Let us know!

<h4 align="center"><strong>How to contribute</strong></h4>
<br />
<p align="center">
    <a href="https://github.com/platformsh-templates/nextjs-drupal/issues"><strong>Report a bug</strong></a><br />
    <a href="https://github.com/platformsh-templates/nextjs-drupal/issues"><strong>Submit a feature request</strong></a><br />
    <a href="https://github.com/platformsh-templates/nextjs-drupal/pulls"><strong>Open a pull request</strong></a><br />
</p>
<br />
<h4 align="center"><strong>Need help?</strong></h4>
<br />
<p align="center">
    <a href="https://community.platform.sh"><strong>Ask the Platform.sh Community</strong></a><br />
    <a href="https://chat.platform.sh"><strong>Join us on Slack</strong></a><br />
</p>
<br /><br />
<h3 align="center"><strong>Thanks to all of our amazing contributors!</strong></h3>

<br/>

![GitHub Contributors Image](https://contrib.rocks/image?repo=platformsh-templates/nextjs-drupal)

<br />
