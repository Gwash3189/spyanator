defmodule Spyanator.Assertions.Calls.Chains do
  @moduledoc """
    functional chains that can be used to inspect how many times a
    function was called
  """
  alias Spyanator.Assertions.Calls

  @doc """
    Used to make an assertion on a single argument that a function received.
  """
  @spec with_argument(false, any) :: false
  def with_argument(false, _), do:
    false

  @doc """
    Used to make an assertion on a single argument that a function received.
  """
  @spec with_argument(%Calls{}, any) :: false | %Calls{}
  def with_argument(%Calls{call_count: count, module: module, func_name: func_name} = calls, expected_argument) do
    actual_arguments = Agent.get(Spyanator.get_pid_for_module(module), fn(state) ->
      Map.get(state, func_name) |> Map.get(:arguments)
    end)

    called_with_args_at_least_once? = actual_arguments
      |> Tuple.to_list
      |> Enum.any?(&Enum.member?(&1, expected_argument))

    to_return = calls
      |> Map.put(:expected_argument, expected_argument)
      |> Map.put(:actual_arguments, actual_arguments)

    count > 0 && called_with_args_at_least_once? && to_return
  end

  @doc """
    Used to make an assertion on the arguments that a  function received
  """
  @spec with_arguments(false, any) :: false
  def with_arguments(false, _), do: false

  @doc """
    Used to make an assertion on the arguments that a  function received
  """
  @spec with_arguments(%Calls{}, [any]) :: false | %Calls{}
  def with_arguments(%Calls{call_count: count, module: module, func_name: func_name} = calls, expected_arguments) do
    actual_arguments = Agent.get(Spyanator.get_pid_for_module(module), fn(state) ->
      Map.get(state, func_name) |> Map.get(:arguments)
    end)

    called_with_args_at_least_once? = actual_arguments
      |> Tuple.to_list
      |> Enum.member?(expected_arguments)

    to_return = calls
      |> Map.put(:expected_arguments, expected_arguments)
      |> Map.put(:actual_arguments, actual_arguments)

    count > 0 && called_with_args_at_least_once? && to_return
  end

  @doc """
    Used to start a functional chain that inspects the calls to a
    function
  """
  @spec received(module, atom) :: boolean | %Calls{call_count: pos_integer}
  def received(spy_module, func_name) do
    call_count = Agent.get(Spyanator.get_pid_for_module(spy_module), fn(state) ->
      Map.get(state, func_name, %Spyanator.Tracked{}) |> Map.get(:calls)
    end)

    call_count > 0 && %Calls{call_count: call_count, module: spy_module, func_name: func_name}
  end
end
