# Welcome to Invariable: Your Go-To Simple Static Site Generator

Invariable is a straightforward, easy-to-use application designed to help you create and manage static websites. Crafted with love in Elixir, it incorporates a few select tools to ensure your website building process is as smooth and efficient as possible:

- **Nimble Publisher** for managing your content with ease,
- **Tailwind CSS** for stylish, responsive designs, managed via a Mix task in the `mix.ex` file at the root,
- **DaisyUI** for adding a splash of user-friendly components, managed through NPM in the `package.json` file within the assets directory.

## Core Features:

- A simple system for pages and blog posts, utilizing static Markdown files for content creation.
- YAML-driven navigation, making it straightforward to customize your site's main navigation menu.
- Automatic deployment via GitHub Actions, enabling content updates directly through GitHub.
- A collection of convenient styles and components courtesy of Tailwind CSS and DaisyUI.

Invariable aims to simplify the website creation process, allowing you to use GitHub Actions to automatically generate a static site. This site can then be hosted directly from your GitHub repository as a GitHub Page, following the straightforward setup process detailed below.

## Getting Started:
**Fork this repository** to create a new repo under your account or organization.

## Setting Up GitHub Pages:

1. **Generate a Personal Access Token (PAT)** for CI/CD:
   - Navigate through: User Settings → Developer Settings → Personal Access Tokens → Tokens (classic).
   - Click on "Generate new token (classic)," add a note for clarity, and choose 'No Expiration' for longevity. Remember, security is key, so be sure to understand and manage the risks associated with this token.
   - Copy the newly generated PAT for later use.

2. **Create a Secret for Your Repository**:
   - Go to Repo Settings → Secrets and variables → Repository secrets → New Repository secret.
   - Name it `PAT` and paste in your generated token.

3. **Prepare Your Content**:
   - Create a new branch named `web`.
   - Update the `content_src/site_config.yml` with your site's name, description, and clean up any placeholder navigation links.

4. **Configure GitHub Actions**:
   - In the `web` branch, adjust the `.github/workflows/deploy.yml` file to trigger on pushes to the `web` branch.

5. **Launch Your Site**:
   - After your changes trigger the GitHub Actions, a `gh-pages` branch will be created.
   - Set your GitHub Pages source to the `gh-pages` branch in your repository settings.

Congratulations! 🎉 Your site should now be live.

### Additional Configuration:

- **Custom Domain**: If you're using a custom domain, update the CNAME in `.github/workflows/deploy.yml`. Uncomment and modify the `cname` field as needed. If not using a custom domain, ensure your repository name meets GitHub Pages' requirements.

Invariable is all about making web development accessible and manageable, whether you're a seasoned developer or new to the scene. Enjoy building your site!
