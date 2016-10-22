WIP: Rewrite of [participate-api](https://github.com/oliverbarnes/participate-api) in Elixir / Phoenix

# Setup

## Prerequisites

- [Elixir](http://elixir-lang.org/) (tested with Elixir version 1.3.4)
- [PostgreSQL](https://www.postgresql.org/) (tested with PostgreSQL 9.5.4)


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
