defmodule IPDBDecoderTest do
  @moduledoc false
  use ExUnit.Case

  @path Path.join([__DIR__, "../priv/ipipfree.ipdb"])

  test "parse_database_file" do
    database = @path |> IPDBDecoder.parse_database_file()
    {:ok, result} = IPDBDecoder.pipe_lookup(database, "127.0.0.1")
    assert result == ["本机地址", "本机地址", ""]
  end

  test "parse_database" do
    database = @path |> File.read!() |> IPDBDecoder.parse_database()
    {:ok, result} = IPDBDecoder.pipe_lookup(database, "127.0.0.1")
    assert result == ["本机地址", "本机地址", ""]
  end

  test "parse_database_nofile" do
    assert {:error, :open_file_failed} == IPDBDecoder.parse_database_file("wrongfile.ipdb")

    assert {:error, :open_file_failed} ==
             IPDBDecoder.parse_database_file("wrongfile.ipdb")
             |> IPDBDecoder.pipe_lookup("127.0.0.1")
  end

  test "lookup" do
    {:ok, database} = @path |> IPDBDecoder.parse_database_file()
    {:ok, result} = IPDBDecoder.lookup(database, "127.0.0.1")
    assert result == ["本机地址", "本机地址", ""]
  end

  test "lookup_pipe" do
    {:ok, result} =
      @path
      |> IPDBDecoder.parse_database_file()
      |> IPDBDecoder.pipe_lookup("127.0.0.1")

    assert result == ["本机地址", "本机地址", ""]
  end

  test "lookup wrong ip" do
    assert {:error, :not_found_ip} ==
             @path
             |> IPDBDecoder.parse_database_file()
             |> IPDBDecoder.pipe_lookup({1, 1, 1, 1111})
  end
end
