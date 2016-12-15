defmodule Spyanator.Assertions do
  @moduledoc """
  Where all of the test helpers live.
  This module should be used from within your test module.

  # Simple Example

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

  # Kitchen Sink Example

  ```elixir
  defmodule TestAnotherThing do
    use ExUnit.Case, async: true
    use Spyanator.Assertions

    # setup
    defmodule AgentSpy do
      use Spyanator

      track start(_fn, _opts), do: {:ok, nil}
    end

    def func, do: fn() -> %{} end

    def opts, do: [name: :test]

    def call_start(_), do:
      AgentSpy.start(func, opts)

    def start_spy(_), do:
      {:ok, spy: Spyanator.start_spy(AgentSpy)}

    describe "when the agent is started and start is called" do
      setup[:start_spy, :call_start]

      test "Agent.start was called" do
        assert AgentSpy |> received(:start) |> once
        assert AgentSpy |> received(:start) |> exactly(1) |> time
        assert AgentSpy |> received(:start) |> at_least(1) |> time
        assert AgentSpy |> received(:start) |> at_most(1) |> time
      end

      test "Agent.start was not called more than once" do
        refute AgentSpy |> received(:start) |> twice
      end

      test "Agent.start was not called more than once" do
        refute AgentSpy |> received(:start) |> exactly(5) |> times
      end

      test "Agent.start was called with a func and options" do
        assert AgentSpy |> receieved(:start)
          |> with_arguments(func, opts) |> once
      end
    end

    describe "when the agent is succesfully started" do
      setup[:start_spy, :call_start]

      test "it returns a tagged tuple" do
        assert Spy |> returned({:ok, nil}) |> from(:start)
      end
    end
  end
  ```

  # Architecture details

  Spyanator's assertions are assembled into two categories. **Chains** and **Assertions**

  The usage of `chains` and `assertions` in your test cases should be as follows

  ```
    Spy |> [chain] |> .... |> assertion
  ```

  to put it plainly

  * All pipelines must start with the Spy
  * You can have any number of chains in the middle
      * Chains will build up a data representation of your spy
      * A chain can short-ciruite the pipeline by returning false if an expectation
      does not hold up
  * assertions will validate your expectations and return either true or false
  """
  defmacro __using__(_) do
    quote do
      import Spyanator.Assertions
      import Spyanator.Assertions.Calls
      import Spyanator.Assertions.Calls.Assertions
      import Spyanator.Assertions.Calls.Chains
      import Spyanator.Assertions.Returns
      import Spyanator.Assertions.Returns.Assertions
      import Spyanator.Assertions.Returns.Chains
    end
  end

  @doc """
    Simply returns the provided value.
    fluff function that make Spyanator pipelines read nicely.
  """
  @spec times(any) :: any
  def times(result), do: result

  @doc """
    Simply returns the provided value.
    fluff function that make Spyanator pipelines read nicely.
  """
  @spec times(any) :: any
  def time(result), do: result
end
