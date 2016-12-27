defmodule Spyanator do
  @moduledoc """
    The main interface to starting and tracking the Spyanator agent
    and any Spyanator related agents.

    This module is used with `Spyanator.Macro` to track calls, return values and
    arguments sent to spys.

    To create a spy, you must `use Spyanator` and define functions like normal

    ```
    defmodule TestTheThing do
      use ExUnit.Case, async: true

      defmodule AgentSpy do
        use Spyanator

        def start(_fn, opts), do: {:ok, nil}
      end

      def start_spy(_context), do:
        {:ok, spy: Spyanator.start_spy(AgentSpy)}

        describe "when the thing is doing the thing" do
          setup [:start_spy]

          test "it does the thing" do
            #...
          end
        end
    end
    ```

    Spyanator also provides helper functions to use within your tests. These
    functions live in `Spyanator.Assertions`

    ```elixir
    defmodule TestAnotherThing do
      use ExUnit.Case, async: true
      use Spyanator.Assertions

      #...

      test "it calls :the_function" do
        assert Spy |> received(:the_function) |> once
      end
    end
    ```

    For more detail, please see `Spyanator.Assertions`
  """

  defmacro __using__(_) do
    quote do
      import Kernel, except: [def: 2]
      import Spyanator.Macros
    end
  end

  @doc """
    Starts the Spyanator process. The process is named Spyanator
  """
  def start_link(opts \\ []) do
    Agent.start(fn -> %{} end, name: Keyword.get(opts, :name, Spyanator))
  end

  @doc """
    Used to start a spy module. Required before any call tracking can be done.
  """
  @spec start_spy(module) :: {:ok, pid}
  def start_spy(spy_module) do
    {:ok, spy_pid} = Agent.start(fn -> %{} end)

    :ok = Agent.update(Spyanator, fn(state) ->
      new_state = Map.put(%{}, spy_module, %{pid: spy_pid})
      Map.merge(state, new_state)
    end)

    {:ok, spy_pid}
  end

  @doc """
    Increments the number of calls to the given function for the given module
  """
  @spec increment_calls_to(module, atom) :: integer
  def increment_calls_to(module, func_name) do
    Agent.get_and_update(get_pid_for_module(module), fn(state) ->
      old_func_state = Map.get(state, func_name, %Spyanator.Tracked{})
      new_calls_count = Map.get(old_func_state, :calls) + 1
      new_func_state = Map.put(old_func_state, :calls, new_calls_count)

      new_state = Map.put(state, func_name, new_func_state)
      {new_calls_count, new_state}
    end)
  end

  @doc """
    tracks the returned value for the given function on the given module.
    Assumes that the value was a result of the last call.
  """
  @spec track_return_value_from(module, atom, any) :: :ok
  def track_return_value_from(module, func_name, value) do
    Agent.update(get_pid_for_module(module), fn(state) ->
      old_func_state = Map.get(state, func_name, %Spyanator.Tracked{})
      old_return_values = Map.get(old_func_state, :return_values)
      calls_count = Map.get(old_func_state, :calls)

      new_return_values = Tuple.insert_at(old_return_values, calls_count - 1, [value])
      new_func_state = Map.put(old_func_state, :return_values, new_return_values)

      Map.put(state, func_name, new_func_state)
    end)
  end

  @doc """
    Tracks the arguments provided to the  function.
  """
  @spec track_arguments_to(module, atom, [any]) :: :ok
  def track_arguments_to(module, func_name, args_list) do
    Agent.update(get_pid_for_module(module), fn(state) ->
      old_func_state = Map.get(state, func_name, %Spyanator.Tracked{})
      old_arguments = Map.get(old_func_state, :arguments)
      call_count = Map.get(old_func_state, :calls)

      new_arguments = Tuple.insert_at(old_arguments, call_count - 1, args_list)
      new_func_state = Map.put(old_func_state, :arguments, new_arguments)

      Map.put(state, func_name, new_func_state)
    end)
  end

  @doc """
    Get the PID for a running spy module
  """
  @spec get_pid_for_module(module) :: pid
  def get_pid_for_module(module) do
    Agent.get(Spyanator, fn(state) ->
      Map.get(state, module) |> Map.get(:pid)
    end)
  end
end
