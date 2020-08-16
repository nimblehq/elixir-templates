### Deployment

Commit `assets/package-lock.json`

Setup ENV for Heroku app

- DATABASE_URL
- HOST
- POOL_SIZE
- PORT
- SECRET_KEY_BASE

Setup Heroku API key

1. Create authorization token by Heroku CLI or console

    - Heroku CLI
      ```
      heroku authorizations:create --description=elixir-template-test
      ```

    - Goto `account/applications` then `Create authorization`

2. Add `HEROKU_API_KEY` secret in Github repository settings
