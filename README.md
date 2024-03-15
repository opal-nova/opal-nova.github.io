# A simple static site generator.
This is an application written in elixir and uses:
* Nimble Publisher
* Tailwind CSS (Managed by an MIX under mix.ex in root)
* Daisy UI (Managed by NPM under pacakge.json in assets)

## Setup Github pages

1: Make personal access token for CI/CD  
  * Go to [Settings](https://github.com/settings/profile)-> [Developer Settings](https://github.com/settings/apps) -> Personal  
  * Accesses Tokens -> [Tokens (classic)](https://github.com/settings/tokens)
  * Click [Generate new token (classic)](https://github.com/settings/tokens/new) (<- you can just jump to this directly)
  * Give the token a new token note so that you understand what this is for.
  * Set the expiration to no expiration (You are doing something that could cause you a security issue here, it's up to you to keep this secure and rotated. You should research what this token does and understand the risks involved in these tokens.)
  * Copy the newly generated personal access token (PAT) Don't lose this, you will need it later.
  * Repo Settings ⚙ -> Security (left side) -> Secrets and variables -> Repository secrets -> New Repository secret
  * Create a new repo secret name it PAT and paste in the generated token from the step before. 
2: Create a new branch and call it web
3: From the web branch, update the content_src/site_config.yml file. ( Provide the site name and descripotion update, clean up placeholder links in navigation, etc )
4: From the web branch, update the opal-nova.github.io/.github/workflows/deploy.yml ( update the branch from `main` to `web`
```

on:
  push:
    branches:
      - web
```
5: Wait for the actions to have completed which should have created a gh-pages branch. Wait till this branch has been created or repeat steps to get this to work.
5: Set the Github page's branch to gh-pages under the repo settings
6: You should have a github page running at this point. 🎉

Extra Settings:
7: Update CNAME for a custom domain if needed. Open .github/workflows/deploy.yml and look for # cname: yousite.com uncomment and update as needed. If left commented make sure your site follows github's pages required repo name etc.
