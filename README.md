# Bob Docker List

This app collects docker tags for Erlang and Elixir repos.

Erlang tags:
[https://github.com/adamzapasnik/bob_docker_list/erlang_list.txt](https://github.com/adamzapasnik/bob_docker_list/erlang_list.txt)

Elixir Tags:
[https://github.com/adamzapasnik/bob_docker_list/elixir_list.txt](https://github.com/adamzapasnik/bob_docker_list/elixir_list.txt)

## Installation

Clone this repo and:

```sh
  cd bob_docker_list
  mix deps.get
  mix compile
```

## Usage

To refresh both lists run commands below. These commands will only update missing tags.

```sh
mix refresh elixir
mix refresh erlang
```

If for some reason you want to regenerate lists, run:

```sh
mix refresh elixir --force
mix refresh erlang --force
```
