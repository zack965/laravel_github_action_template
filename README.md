# Automating Deployment with GitHub Actions and Laravel using SSH Keys

If you're looking to streamline your Laravel project deployment process, you can save time and ensure consistency by automating it with GitHub Actions and SSH keys. This guide will walk you through the steps to set up an automated deployment workflow.

## Manual Deployment Steps

Before automating your deployment, let's review the manual steps you've been following:

1. SSH into your server: `ssh user@host`
2. Pull the latest changes from your Git repository: `git pull`
3. Install project dependencies using Composer: `composer install`
4. Run Laravel migrations: `php artisan migrate`
5. Execute tests: `php artisan test`
6. Build assets (e.g., using Vite): `npm run build`

## Getting Started

### Step 1: SSH Key Setup

- Generate an SSH key pair if you haven't already.
- Add the public key to your server's `~/.ssh/authorized_keys` file.
- Keep your private key secure.
- generate github token token.
-  **GitHub Secrets**: Add the necessary secrets to your GitHub repository settings to securely store sensitive information. The required secrets are as follows:

    - `HOST`: The hostname or IP address of your remote server.
    - `USERNAME`: Your SSH username for connecting to the server.
    - `GITHUB_TOKEN`: The GitHub token used for authentication.
    - `ProjectPath`: The path to your Laravel project on the remote server.
    - `Username_GITHUB`: A username or identifier for authentication IN GITHUB.
    - `GithubProjectUri`: The URI of your GitHub project.

### Step 2: GitHub Actions Workflow

Create a GitHub Actions workflow by adding a `.github/workflows/laravel.yml` file to your repository with the following content:

```yaml
name: Laravel Deployment

on:
  push:
    branches:
      - main
    #workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Deploy to server
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.HOST }}
          username: ${{ secrets.USERNAME }}
          key: ${{ secrets.GITHUB_TOKEN }}
          script: "cd ${{ secrets.ProjectPath }} && ./deploy.sh ${{ secrets.Username_GITHUB }} ${{ secrets.GITHUB_TOKEN }} ${{ secrets.ProjectPath }} ${{ secrets.GithubProjectUri }}"

```




## Workflow Overview



- **Workflow Name**: "Laravel Deployment" is the name of the workflow, making it easily identifiable in GitHub Actions.

- **Trigger**: The workflow is triggered automatically when there is a push to the `main` branch. It can also be manually triggered via the GitHub Actions interface if necessary.

- **Job**: The job named "deploy" runs on an `ubuntu-latest` runner, which is a virtual machine provided by GitHub Actions.

- **Steps**: The steps define the tasks within the job:

    1. **Checkout Code**: This step uses the `actions/checkout@v2` action to ensure the workflow has access to the project's codebase.

    2. **Deploy to Server**: This step is crucial for the deployment process. It uses the `appleboy/ssh-action@master` action to establish an SSH connection to the remote server. Here's how the parameters are populated:

        - `host`: The hostname or IP address of the remote server. This value is populated from a secret named `HOST`.

        - `username`: The SSH username used for connecting to the server. It's populated from a secret named `USERNAME`.

        - `key`: Authentication is achieved using an SSH key. In this case, the GitHub token is used as the key, which is populated from a secret named `GITHUB_TOKEN`. Be cautious about using a GitHub token in this way, as it grants significant access.

        - `script`: This is a series of commands to be executed on the remote server. It appears to run a deploy script (`deploy.sh`) on the server, passing various secrets as parameters. Here's how they are used:

            - `${{ secrets.ProjectPath }}`: The path to the project on the remote server.

            - `${{ secrets.Username_GITHUB }}`: Likely a username for some form of authentication.

            - `${{ secrets.GITHUB_TOKEN }}`: The GitHub token used for authentication.

            - `${{ secrets.GithubProjectUri }}`: This seems to be a GitHub project's URI.




With this workflow in place, your Laravel project will be automatically deployed to the remote server when changes are pushed to the `main` branch. Always monitor deployments and adapt the workflow as needed to meet your project's specific requirements.

**Caution**: Be vigilant about securing your secrets, especially the use of the `GITHUB_TOKEN`, to adhere to best practices in security.

## Getting Started with deploy script (`deploy.sh`)
The `deploy.sh` script plays a crucial role in the deployment process. Here's a detailed explanation of what the script does:

```sh
#!/bin/bash

# $1 is Username_GITHUB ( your username in github )
# $2 is GITHUB_TOKEN ( your github token in github )
# $3 is Project Path in the server (ProjectPath)
# $4 is your uri of the repo of your project on github (GithubProjectUri)
echo "Deployment started ..."

# Change to the project directory
cd $3

# Pull the latest version of the app

git pull https://$1:$2@github.com/$4

echo "here you can execute any command based on your situation and what you wish to acomplish"
# composer install
# php artisan migrate
# php artisan test
echo "Deployment ended ..."


```

## Shell Script Deployment

### Step-by-step explanation

1. The first line, `#!/bin/bash`, tells the shell to use the bash interpreter to execute the script.
2. The next four lines are comments, which are used to document the script and make it more readable. They also define the three variables that the script will use: `USERNAME_GITHUB`, `GITHUB_TOKEN`, `ProjectPath`, and `GithubProjectUri`.

3. The `cd $3` command changes the current directory to the project directory, which is specified by the `ProjectPath` variable.
4. The `git pull https://$1:$2@github.com/$4` command pulls the latest version of the app from the GitHub repository, which is specified by the `GithubProjectUri` and `Username_GITHUB` and `GITHUB_TOKEN` variable.

5. The `# composer install` and `# php artisan migrate` comments are examples of commands that you can execute in this section of the script. These commands would install the Composer dependencies and migrate the database, respectively.
6. The `php artisan test` command runs the unit tests for the project.


### Example usage

To use the shell script, you would first need to replace the `USERNAME_GITHUB`, `GITHUB_TOKEN`, `ProjectPath`, and `GithubProjectUri` variables with your own values. Then, you would save the script as a file with a .sh extension, such as `deploy.sh`. Finally, you would execute the script by running the following command:


