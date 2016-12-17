defmodule Spyanator.Assertions.Returns.Assertions do
  alias Spyanator.Assertions.Returns

  @moduledoc """
    Assertions that should be used when testing the return value of a spy
  """

  @doc """
    Assertion used for asserting what a spy returned at any point in time.
  """
  @spec from(false, %Returns{}) :: boolean
  def from(false, _), do: false

  @doc """
    Assertion used for asserting what a spy returned at any point in time.
  """
  @spec from(%Returns{module: module, provided_values: [any]}, atom) :: boolean
  def from(%Returns{module: module, provided_values: provided_values}, func_name) do
    Agent.get(Spyanator.get_pid_for_module(module), fn(state) ->
      func_state = Map.get(state, func_name)

      case func_state == nil do
        true -> false
        false ->
          returned_values_list = func_state #%{returned_values: {...}}
            |> Map.get(:return_values) #{[values...], ....}
            |> Tuple.to_list #[[values], [...]]
            |> List.flatten #[values]
            |> Enum.any?(&Enum.member?(provided_values, &1))
      end
    end)
  end
end
