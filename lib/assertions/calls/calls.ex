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

  defp handle_expected_arguments(%Calls{expected_arguments: expected_arguments, actual_arguments: actual_arguments, expected_call_count: expected_call_count}) do
    case tuple_size(actual_arguments) do
      0 -> true
      _ ->
        called_with_arguments_count = actual_arguments
          |> Tuple.to_list
          |> Enum.reduce(0, fn(actual_argument, acc) ->
            case actual_argument == expected_arguments do
              true -> acc + 1
            end
          end)

        expected_call_count == called_with_arguments_count
    end
  end
end
