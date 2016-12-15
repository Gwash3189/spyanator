defmodule Spyanator.Assertions.Returns do
  @moduledoc """
    Defines the %Returns{} struct
  """
  defstruct [
    module: nil,
    returned_values_list: [],
    provided_values: [],
    expected_number_of_returns: 0
  ]
end
