defmodule IPDBDecoderTest do
  @moduledoc false
  use ExUnit.Case

  @path Path.join([__DIR__, "../priv/ipipfree.ipdb"])
  @test_ip "202.112.84.101"
  @result %{
    :city_name => "北京",
    :country_name => "中国",
    :region_name => "北京"
  }

  test "parse_database_file" do
    database = @path |> IPDBDecoder.parse_database_file()
    {:ok, result} = IPDBDecoder.pipe_lookup(database, @test_ip)
    assert result == @result
  end

  test "parse_database" do
    database = @path |> File.read!() |> IPDBDecoder.parse_database()
    {:ok, result} = IPDBDecoder.pipe_lookup(database, @test_ip)
    assert result == @result
  end

  test "parse_database_nofile" do
    assert {:error, :open_file_failed} == IPDBDecoder.parse_database_file("wrongfile.ipdb")

    assert {:error, :open_file_failed} ==
             IPDBDecoder.parse_database_file("wrongfile.ipdb")
             |> IPDBDecoder.pipe_lookup(@test_ip)
  end

  test "lookup" do
    {:ok, database} = @path |> IPDBDecoder.parse_database_file()
    {:ok, result} = IPDBDecoder.lookup(database, @test_ip)
    assert result == @result
  end

  test "lookup_pipe" do
    {:ok, result} =
      @path
      |> IPDBDecoder.parse_database_file()
      |> IPDBDecoder.pipe_lookup(@test_ip)

    assert result == @result
  end

  test "lookup wrong ip" do
    assert {:error, :not_found_ip} ==
             @path
             |> IPDBDecoder.parse_database_file()
             |> IPDBDecoder.pipe_lookup({1, 1, 1, 1111})
  end
end
