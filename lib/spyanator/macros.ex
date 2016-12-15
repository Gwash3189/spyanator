defmodule Spyanator.Macros do
  @moduledoc """
  Where the `track` macro lives.

  The `track` macro marks a function for tracking by spyanator.
  Any function that is `track`ed will have it's arguments, return values, and
  number of calls tracked by `Spyanator`.

  Track replaces `def` when defining a function on a module.

  Spys who `use Spyanator` can be started by the `Spyanator.start_spy/1`
  function

  ```elixir
  defmodule Spy do
    use Spyanator

    track this_thing, do: true

    #not tracked
    def not_tracked, do: false
  end
  ```
  """

  defmacro track(definition, do: block) do
    func_name = case elem(definition, 0) do
      :when -> elem(definition, 2) |> List.first |> elem(0)
      x -> x
    end

    quote do
      def unquote(definition) do
        arguments = Enum.map(binding(), fn({_, value}) -> value end)
        Spyanator.increment_calls_to(__MODULE__, unquote(func_name))
        Spyanator.track_arguments_to(__MODULE__, unquote(func_name), arguments)
        return_value = unquote(block)
        Spyanator.track_return_value_from(__MODULE__, unquote(func_name), return_value)
      end
    end
  end
end
