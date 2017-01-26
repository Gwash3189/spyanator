defmodule Spyanator.Assertions.Calls do
  @moduledoc """
    Defines the %Calls{} struct
  """
  alias __MODULE__
  defstruct [
    call_count: 0,
    module: nil,
    func_name: nil,
    expected_call_count: 0,
    expected_arguments: [],
    expected_argument: nil,
    actual_arguments: {},
    modifier: :==
  ]
end

defimpl Spyanator.Assertion, for: Spyanator.Assertions.Calls do
  alias Spyanator.Assertions.Calls

  def check(false), do: false
  def check(%Calls{} = calls) do
    [
      handle_expected_arguments(calls),
      handle_expected_argument(calls),
      handle_modifiers(calls)
    ] |> Enum.all?
  end

  defp handle_modifiers(%Calls{call_count: call_count, expected_call_count: expected, modifier: mod}) do
    case mod do
      :<= -> call_count <= expected
      :>= -> call_count >= expected
      :== -> call_count == expected
    end
  end

  defp handle_expected_argument(%Calls{expected_argument: expected_argument, actual_arguments: actual_arguments}) do
    case tuple_size(actual_arguments) do
      0 -> true
      _ ->
        case expected_argument do
          nil -> true
          _ ->
            actual_arguments
              |> Tuple.to_list
              |> Enum.any?(&Enum.member?(&1, expected_argument))
        end
    end
  end

  defp handle_expected_arguments(%Calls{expected_argument: expected_argument, expected_arguments: expected_arguments, actual_arguments: actual_arguments}) do
    case expected_argument do
      nil ->
        case tuple_size(actual_arguments) do
          0 -> true
          _ ->
            actual_arguments
              |> Tuple.to_list
              |> Enum.member?(expected_arguments)
        end
      _ -> true
    end

  end
end
