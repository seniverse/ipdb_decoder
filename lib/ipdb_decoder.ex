defmodule IPDBDecoder do
  @moduledoc """
  IPIP.net ipdb file format decoder.

  ## Usage

  To prepare lookups in a given database, you need parse first and
  hold the results for later usage:

      iex(1)> {:ok, database} = IPDBDecoder.parse_database_file("/path/to/ipipfree.ipdb")

  Using the returned database contents, you could start looking up

      iex(3)> IPDBDecoder.lookup(database, "127.0.0.1")
      {:ok, %{}}

  """

  alias IPDBDecoder.Database
  alias IPDBDecoder.MetaData
  alias IPDBDecoder.Tire

  @type decode_options :: map
  @type decoded_value :: :cache | :end | binary | boolean | list | map | number
  @type lookup_result :: {:ok, decoded_value} | {:error, term}
  @type parse_result :: {:ok, Database.t()} | {:error, term}

  @doc false
  def default_options, do: []

  @spec parse_database_file(String.t()) :: parse_result
  def parse_database_file(path) do
    case File.read(path) do
      {:ok, data} ->
        parse_database(data)

      {:error, reason} ->
        IO.puts(reason)
        {:error, :open_file_failed}
    end
  end

  @spec parse_database(binary) :: parse_result
  def parse_database(content) do
    case content do
      <<length::size(32), meta::binary-size(length), chunks::binary>> ->
        meta = MetaData.parse(meta)
        database = %Database{meta: meta, chunks: chunks}
        v4node = Tire.find_v4node(database)
        {:ok, %Database{database | v4node: v4node}}

      _other ->
        {:error, :invalid_database}
    end
  end

  @spec lookup(Database.t(), String.t() | :inet.ip_address(), decode_options) :: lookup_result
  def lookup(parse_result, _, options \\ [])

  def lookup(%IPDBDecoder.Database{} = database, ipstring, options)
      when is_binary(ipstring) do
    options = Keyword.merge(default_options(), options)

    case :inet.parse_address(String.to_charlist(ipstring)) do
      {:ok, ip} -> lookup(database, ip, options)
      {:error, _} -> {:error, :invalid_ipaddr}
    end
  end

  def lookup(%Database{} = database, ip, options)
      when is_tuple(ip) do
    options = Keyword.merge(default_options(), options)
    Tire.find(database, ip, options)
  end

  @doc """
  Utility method to pipe `parse_database/1` directly to `lookup/2`.

  ## Usage

  Depending on how you handle the parsed database contents you may
  want to pass the results directly to the lookup.

      iex> "/path/to/database.ipdb"
      ...> |> File.read!()
      ...> |> IPDBDecoder.parse_database()
      ...> |> IPDBDecoder.pipe_lookup({127, 0, 0, 1})
      {:ok, %{...}}
  """
  @spec pipe_lookup(parse_result, :inet.ip_address(), decode_options) :: lookup_result
  def pipe_lookup(parse_result, ip, options \\ [])

  def pipe_lookup({:error, _} = error, _, _), do: error

  def pipe_lookup({:ok, database}, ip, options),
    do: lookup(database, ip, options)
end
