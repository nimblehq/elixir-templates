## Environment Variables

To use this workflow, you need to config these variables in the [GitHub Actions secrets](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-and-using-encrypted-secrets) of the repository:

- `WIKI_ACTION_TOKEN`: Generate [personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) to allow action push the markdown content files in `.github/wiki` to Github Wiki section.
