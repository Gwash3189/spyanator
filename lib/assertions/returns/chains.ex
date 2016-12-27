defmodule Spyanator.Assertions.Returns.Chains do
  alias Spyanator.Assertions.Returns
  @moduledoc """
    functional chains that can be used to inspect what a  function
    returned
  """

  @doc """
    A function chain used to assert that a spy returned some values at any point
    in time.
  """
  @spec returned(module, any) :: {module, [any]}
  def returned(module, provided_values) when is_list(provided_values) do
    %Returns{module: module, provided_values: provided_values}
  end

  @doc """
    A function chain used to assert that a spy returned some value at any point
    in time.
  """
  @spec returned(module, any) :: {module, [any]}
  def returned(module, provided_values) do
    %Returns{module: module, provided_values: [provided_values]}
  end
end
