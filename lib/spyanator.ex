defmodule Spyanator do
  defmacro __using__(_) do
    quote do
      use Spyanator.Helpers, module: __MODULE__

      def start_spying do
        {:ok, _pid} = Agent.start_link(fn -> %{} end, name: __MODULE__)
        __MODULE__
      end

      @spec increment_calls_to(atom) :: :ok
      defp increment_calls_to(func) do
        Agent.update(__MODULE__, fn(state) ->
          func_state = Spyanator.history_for(state, func)
          incremented_count = Spyanator.calls_for(state, func) |> Spyanator.increment

          new_func_state = func_state |> Map.put(:calls, incremented_count)

          Map.put(state, func, new_func_state)
        end)
      end

      @spec cache_arguments_for_last_call!(atom, [...]) :: :ok
      defp cache_arguments_for_last_call!(func, args_array) do
        Agent.update(__MODULE__, fn(state) ->
          func_state = Spyanator.history_for(state, func)
          call_count = Spyanator.calls_for(state, func)

          args_map = case call_count do
            0 -> raise """
            #{func} has no previous calls.
            Try calling increment_calls_to/1 before cacheing the arguments
            """
            _ ->
              Map.get(func_state, :args, %{})
                |> Map.merge(Map.put(%{}, "#{call_count}", args_array))
          end

          new_func_state = Map.put(func_state, :args, args_map)
          Map.put(state, func, new_func_state)
        end)
      end
    end
  end

  def increment(n), do: n + 1

  def state_for(name) do
    Agent.get(name, fn(state) -> state end)
  end

  def history_for(state, func_name) do
    state |> Map.get(func_name, %{})
  end

  def calls_for(state, func) do
    state
      |> Map.get(func, %{})
      |> Map.get(:calls, 0)
  end
end
