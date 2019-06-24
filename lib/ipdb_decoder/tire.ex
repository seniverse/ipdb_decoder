defmodule IPDBDecoder.Tire do
  @moduledoc false

  use Bitwise

  def find_v4node(database) do
    bits = List.duplicate(0, 80) ++ List.duplicate(1, 16)

    case find(database, bits) do
      {:stop, current} -> current
    end
  end

  def find(database, ip) when is_tuple(ip) do
    offset = 1 <<< (tuple_size(ip) * 2)

    bits =
      ip
      |> Tuple.to_list()
      |> Enum.map(fn v -> tl(Integer.digits(v + offset, 2)) end)
      |> List.flatten()

    case find(database, bits) do
      {:stop, _} -> {:error, :not_found_ip}
      {:ok, _} = ok -> ok
      {:error, _} = error -> error
    end
  end

  def find(database, bits) when is_list(bits) do
    case Enum.count(bits) do
      32 ->
        find_next(database, bits, database.v4node)

      _ ->
        find_next(database, bits, 0)
    end
  end

  def find_next(database, [head | tail], current) do
    %{meta: %{"node_count" => total}} = database

    case binary_part(database.chunks, current <<< 3 ||| head <<< 2, 4) do
      <<next::unsigned-32>> when next == total ->
        {:error, :not_found_ip}

      <<next::unsigned-32>> when next > total ->
        find_data(database.chunks, next - total + total * 8)

      <<next::unsigned-integer-32>> ->
        find_next(database, tail, next)
    end
  end

  def find_next(_, [], current) do
    {:stop, current}
  end

  def find_data(chunks, postion) do
    <<offset::integer-16>> = binary_part(chunks, postion, 2)
    info = binary_part(chunks, postion + 2, offset)
    {:ok, String.split(info, "\t")}
  end
end
