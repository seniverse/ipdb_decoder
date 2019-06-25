defmodule IPDBDecoder.MetaData do
  @moduledoc false

  @type t :: %__MODULE__{
          build: non_neg_integer,
          fields: list,
          ip_version: non_neg_integer,
          languages: map,
          node_count: non_neg_integer,
          total_size: non_neg_integer
        }

  defstruct build: 0,
            fields: [],
            ip_version: 0,
            languages: [],
            node_count: 0,
            total_size: 0

  def parse(raw) do
    raw
    |> Poison.decode!()
    |> Enum.to_list()
    |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)
    |> Map.new()
  end
end
