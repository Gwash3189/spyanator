defmodule Spyanator.Assertions.Calls.Test do
  use ExUnit.Case, async: true
  use Spyanator.Assertions

  defmodule Spy do
    use Spyanator
    def test(x, y) when is_float(x) and is_float(y) do
      x + y
    end
    def test(x, y), do: x + y
  end

  describe "when defing the number of times a function was called" do
    setup [:subject]

    test "it can be used with once/1" do
      assert Spy |> received(:test) |> once
    end

    test "it can be used with twice/1" do
      refute Spy |> received(:test) |> twice
    end

    test "it can be used with exactly/2" do
      assert Spy |> received(:test) |> exactly(1) |> time
    end

    test "it can be used with at_least/2" do
      assert Spy |> received(:test) |> at_least(1) |> time
    end

    test "it can be used with at_most/2" do
      refute Spy |> received(:test) |> at_most(0) |> times
    end
  end

  describe "when defing the arguments passed to a function" do
    setup [:subject]

    test "it can be used with with_arguments/2" do
      assert Spy |> received(:test) |> with_arguments([1, 2])
      refute Spy |> received(:test) |> with_arguments([1, 3])
    end

    test "it can be used with with_arguments/2 and twice" do
      refute Spy |> received(:test) |> with_arguments([1, 2]) |> twice
      Spy.test(1, 2)
      assert Spy |> received(:test) |> with_arguments([1, 2]) |> twice
    end
  end

  describe "when there is a complex function to def" do
    setup [:complex_subject]

    test "it still defs the function" do
      assert Spy |> received(:test) |> with_arguments([1.0, 2.0])
    end
  end

  describe "asserting that something has not been called at all" do
    Spyanator.start_spy(Spy)

    assert Spy |> received(:test) |> exactly(0) |> times
    assert Spy |> received(:test) |> at_least(0) |> times
    assert Spy |> received(:test) |> at_most(0) |> times
  end

  def subject(_ \\ nil) do
    Spyanator.start_spy(Spy)
    Spy.test(1, 2)
    :ok
  end

  def complex_subject(_ \\ nil) do
    Spyanator.start_spy(Spy)
    Spy.test(1.0, 2.0)
    :ok
  end

end
