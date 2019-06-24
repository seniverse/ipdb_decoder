defmodule IPDBDecoder.Database do
  @moduledoc false

  defstruct meta: %{}, chunks: <<>>, v4node: -1

  @type t :: %__MODULE__{
          meta: map,
          chunks: binary,
          v4node: integer
        }
end
