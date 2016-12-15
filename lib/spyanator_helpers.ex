defmodule Spyanator.Helpers do
  defmacro __using__(opts) do
    quote do
      @module Keyword.get(unquote(opts), :module)

      @spec called_once?(atom) :: boolean
      def called_once?(func_atom) do
        Spyanator.state_for(@module)
          |> Spyanator.calls_for(func_atom) == 1
      end

      @spec called_twice?(atom) :: boolean
      def called_twice?(func_atom) do
        Spyanator.state_for(@module)
          |> Spyanator.calls_for(func_atom) == 2
      end

      @spec called_thrice?(atom) :: boolean
      def called_thrice?(func_atom) do
        Spyanator.state_for(@module)
          |> Spyanator.calls_for(func_atom) == 3
      end

      @spec received?(atom) :: boolean
      def received?(func_atom) do
        Spyanator.state_for(@module)
          |> Spyanator.calls_for(func_atom) > 0
      end

      @spec called?(atom) :: boolean
      def called?(func_name) do
        @module.received?(func_name)
      end
    end

  end
end
