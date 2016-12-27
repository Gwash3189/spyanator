defmodule Spyanator.Macros do
  @moduledoc """
  Where our special `def` macro lives.

  The `def` macro marks a function for tracking by spyanator.
  Any function will have it's arguments, return values, and
  number of calls  by `Spyanator`.

  `Spyanator.Marros.def` wraps `Kernel.def`, tracks the arguments, return values
  and number of calls. It then defferes back to `Kernel.def`.

  Spys who `use Spyanator` can be started by the `Spyanator.start_spy/1`
  function

  ```elixir
  defmodule Spy do
    use Spyanator

    def this_thing, do: true
  end
  ```
  """

  defmacro def(definition, do: block) do
    func_name = case elem(definition, 0) do
      :when -> elem(definition, 2) |> List.first |> elem(0)
      x -> x
    end

    quote do
      Kernel.def unquote(definition) do
        arguments = Enum.map(binding(), fn({_, value}) -> value end)
        Spyanator.increment_calls_to(__MODULE__, unquote(func_name))
        Spyanator.track_arguments_to(__MODULE__, unquote(func_name), arguments)
        return_value = unquote(block)
        Spyanator.track_return_value_from(__MODULE__, unquote(func_name), return_value)
        return_value
      end
    end
  end
end
