defmodule IPDBDecoder.Database do
  @moduledoc false

  alias IPDBDecoder.MetaData

  defstruct meta: %MetaData{}, chunks: <<>>, v4node: -1

  @type t :: %__MODULE__{
          meta: Metadata.t(),
          chunks: binary,
          v4node: integer
        }

  def slice_range(database, locale) do
    start =
      database.meta
      |> Map.get(:languages)
      |> Map.get(locale, 0)

    count =
      database.meta
      |> Map.get(:fields)
      |> Enum.count()

    start..count
  end
end
