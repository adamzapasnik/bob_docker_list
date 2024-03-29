# Bob Docker List (DISABLED - lists are not auto updated anymore. Feel free to fork and remember to turn on the Github actions.

This app collects docker tags for Erlang and Elixir repos.

Erlang tags:
[https://raw.githubusercontent.com/adamzapasnik/bob_docker_list/master/erlang_list.txt](https://raw.githubusercontent.com/adamzapasnik/bob_docker_list/master/erlang_list.txt)

Elixir Tags:
[https://raw.githubusercontent.com/adamzapasnik/bob_docker_list/master/elixir_list.txt](https://raw.githubusercontent.com/adamzapasnik/bob_docker_list/master/elixir_list.txt)

## OS version tables

### Ubuntu

| Ubuntu | version |
| :----- | ------: |
| Groovy |   20.10 |
| Focal  |   20.04 |
| Bionic |   18.04 |
| Xenial |   16.04 |
| Trusty |   14.04 |

### Debian

| Debian   | version |
| :------- | ------: |
| Bookworm |      12 |
| Bullseye |      11 |
| Buster   |      10 |
| Stretch  |       9 |
| Jessie   |       8 |

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
