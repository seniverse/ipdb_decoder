# IPIP.net File Format Decoder

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
