# A simple static site generator.
This is a application writen in elixir and uses:

* Nimble Publisher
* Tailwind CSS
* Daisy UI

## Setup Github pages

1: Make personal access token for CI/CD  
  Go to [Settings](https://github.com/settings/profile)-> [Developer Settings](https://github.com/settings/apps) -> Personal  
  * Accesses Tokens -> [Tokens (classic)](https://github.com/settings/tokens)
  * Click [Generate new token (classic)](https://github.com/settings/tokens/new) (<- you can just jump to this directly)
  * Give the token a new token note so that you understand what this is for.
  * Set the expiration to no expiration (You are doing something that could cause you a security issue here, it's up to you to keep this secure and rotated. You should research what this token does and understand the risks involved in these tokens.)
  * Copy the newly generated personal access token (PAT) Don't lose this, you will need it later.
  * Repo Settings ⚙ -> Security (left side) -> Secrets and variables -> Repository secrets -> New Repository secret
  * Create a new repo secret name it PAT and paste in the generated token from the step before. 

2: Set Github page's branch to gh-pages under the repo settings

