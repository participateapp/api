# Setup

## Prerequisites

- [Elixir](http://elixir-lang.org/) (tested with Elixir version 1.4.1)
- [PostgreSQL](https://www.postgresql.org/) (tested with PostgreSQL 9.6.1)


## Build

Get dependencies and compile:

```sh
$ mix deps.get
$ mix compile
```

Create a database `participate_api_dev` and insert initial data:

```sh
$ mix ecto.setup
```

To migrate an existing database to a new version of the API server do this instead:

```sh
$ mix ecto.migrate
```

Start the API server:

```sh
$ mix phoenix.server
```

## Running tests

Create a database `participate_api_test`:

_ToDo: Should this be an `ecto` command?_

```sh
$ createdb participate_api_test
```

Run all tests:

```sh
$ mix espec
```

## Deploy to Heroku

The API can be easily deployed to [Heroku](https://www.heroku.com/home).
Their free plan is sufficient for developing and demonstration.

The Phoenix Framework documentation provides a [good overview](http://www.phoenixframework.org/docs/heroku) of how to deploy an Elixir app.

Quick walkthrough:

- We assume that you have the [Heroku CLI tool](https://devcenter.heroku.com/categories/command-line) installed.
- Login in to a Heroku account:  
  
  ```  
  $ heroku login
  ```  
- Create Heroku app:  

  ```
  $ heroku create participate-api --region eu
  ```  

  App names must be unique in the Heroku cloud. Choose your own name.  Or omit the name in the command to get a random name.  
  Possible regions are currently `us` and `eu`.  
  This command will also add a git remote called `heroku` to your git repository configuration. We will push to it later.
- Add the buildpack for Elixir apps:  
  
  ```
  $ heroku buildpacks:add https://github.com/HashNuke/heroku-buildpack-elixir.git
  ```
- Add a [PostgreSQL](https://elements.heroku.com/addons/heroku-postgresql) database as an add-on to the app:  
    
  ```
  $ heroku addons:create heroku-postgresql:hobby-dev
  ```
- Set the number of concurrent connections that the app is allowed to make to the database:  
  
  ```
  $ heroku config:set POOL_SIZE=8
  ```
  
  A free hobby-dev Heroku Postgres allows 20 connections at maximum for all running dynos accessing it.
- Generate a Phoenix secret and set a configuration variable to it:  
  
  ```
  $ heroku config:set SECRET_KEY_BASE=$(mix phoenix.gen.secret)
  ```

  This command uses bash syntax. For other systems split it in two commands. Insert the generated key into the second command:
  
  ```
  $ mix phoenix.gen.secret
  $ heroku config:set SECRET_KEY_BASE=...
  ```
- Review the settings in `elixir_buildpack.config` and `config/prod.exs`.  
  Commit any changes you may have made.
- Deploy the app by pushing the repo to Heroku:
  
  ```
  $ git push heroku master
  ```
  
  Heroku will build the app only when pushing to branch `master`.
  If you are pushing from a different local branch use:
  
  ```
  $ git push heroku my-local-branch:master
  ```
  
  Pushing will start the build process, mainly compiling the Elixir code. Watch out for possible error messages.
- Populate the database with initial content:
  
  ```
  $ heroku run "MIX_ENV=prod POOL_SIZE=2 mix ecto.migrate"
  ```
- The API should be up and running at https://participate-api.herokuapp.com  
  (Replace `participate-api` with you own app name).
  As a quick check run:

  ```
  $ heroku open
  ```
  This should display something like `{"errors":{"detail":"Page not found"}}` in your browser. (It's an error because we have currently no endpoint served at `/`.)
- To view log messages:
  
  ```
  $ heroku logs --tail
  ```
- Direct database access:
    - Show database credentials:
    
      ```
      $ heroku pg:credentials
      ```
    - You can use [pgAdmin](https://www.pgadmin.org/) to access the database with the given credentials.
    - For managing backups see [Heroku docs](https://devcenter.heroku.com/articles/heroku-postgres-backups).


## Want to get involved?

We'll pair with you so you can get up to speed quickly, and we pair on features as well. 

[Shoot us an email](mailto:oliverbwork@gmail.com), we'll add you to our Slack channel to join the discussion and talk about next steps.

Please check out [the contributing guide](CONTRIBUTING.md) and our [code of conduct](CODE_OF_CONDUCT.md)

---

Participate was inspired by [LiquidFeedback](http://liquidfeedback.org), and the book published by its authors: [Principles of Liquid Feedback](http://principles.liquidfeedback.org)
      
