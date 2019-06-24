# IPIP.net File Format Decoder

[![Build Status](https://travis-ci.org/seniverse/ipdb_decoder.svg?branch=master)](https://travis-ci.org/seniverse/ipdb_decoder)
[![Coverage Status](https://coveralls.io/repos/github/seniverse/ipdb_decoder/badge.svg?branch=master)](https://coveralls.io/github/seniverse/ipdb_decoder?branch=master)
[![hex.pm version](https://img.shields.io/hexpm/v/ipdb_decoder.svg)](https://hex.pm/packages/ipdb_decoder)
[![hex.pm downloads](https://img.shields.io/hexpm/dt/ipdb_decoder.svg)](https://hex.pm/packages/ipdb_decoder)
![hex.pm license](https://img.shields.io/hexpm/l/ipdb_decoder.svg)
![GitHub top language](https://img.shields.io/github/languages/top/seniverse/ipdb_decoder.svg)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ipdb_decoder` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ipdb_decoder, "~> 0.1.0"}
  ]
end
```

## Usage
To prepare lookups in a given database, you need parse first and
hold the results for later usage:

```elixir
iex(1)> {:ok, database} = IPDBDecoder.parse_database_file("/path/to/ipipfree.ipdb")
```

Using the returned database contents, you could start looking up

```elixir
iex(2)> IPDBDecoder.lookup(database, "127.0.0.1")
{:ok, %{}}
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ipdb_decoder](https://hexdocs.pm/ipdb_decoder).

## ChangeLog

[CHANGELOG](https://github.com/seniverse/ipdb_decoder/blob/master/CHANGELOG.md)

## License

[Apache 2.0](https://github.com/seniverse/ipdb_decoder/blob/master/LICENSE)
