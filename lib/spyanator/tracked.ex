defmodule Spyanator.Tracked do
  @moduledoc """
    Struct that is stored as part of a spy's state.

    * Calls
        * incremented when a function is called
    * Arguments
        * A tuple that tracks the arguments given to a tracked function
    * Returned Values
        * A tuple that tracks the return value from a tracked function
  """
  defstruct calls: 0, arguments: {}, return_values: {}
end
