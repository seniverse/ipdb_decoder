defmodule IPDBDecoder.Tire do
  @moduledoc false

  alias IPDBDecoder.Database
  use Bitwise

  def find_v4node(database, options \\ []) do
    bits = List.duplicate(0, 80) ++ List.duplicate(1, 16)

    case find(database, bits, options) do
      {:stop, current} -> current
    end
  end

  def find(database, ip, options) when is_tuple(ip) do
    offset = 1 <<< (tuple_size(ip) * 2)

    bits =
      ip
      |> Tuple.to_list()
      |> Enum.map(fn v -> tl(Integer.digits(v + offset, 2)) end)
      |> List.flatten()

    case find(database, bits, options) do
      {:stop, _} -> {:error, :not_found_ip}
      {:ok, _} = ok -> ok
      {:error, _} = error -> error
    end
  end

  def find(database, bits, options) when is_list(bits) do
    case Enum.count(bits) do
      32 ->
        find_next(database, bits, database.v4node, options)

      _ ->
        find_next(database, bits, 0, options)
    end
  end

  def find_next(database, [head | tail], current, options) do
    %{meta: %{:node_count => total}} = database

    case binary_part(database.chunks, current <<< 3 ||| head <<< 2, 4) do
      <<next::unsigned-32>> when next == total ->
        {:error, :not_found_ip}

      <<next::unsigned-32>> when next > total ->
        find_data(database, next - total + total * 8, options)

      <<next::unsigned-integer-32>> ->
        find_next(database, tail, next, options)
    end
  end

  def find_next(_, [], current, _) do
    {:stop, current}
  end

  def find_data(database, postion, options) do
    <<offset::integer-16>> = binary_part(database.chunks, postion, 2)
    info = binary_part(database.chunks, postion + 2, offset)
    range = Database.slice_range(database, Keyword.get(options, :locale))

    value =
      info
      |> String.split("\t")
      |> Enum.slice(range)

    value =
      [database.meta[:fields], value]
      |> List.zip()
      |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)
      |> Map.new()

    {:ok, value}
  end
end
