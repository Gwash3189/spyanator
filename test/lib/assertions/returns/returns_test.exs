defmodule Spyanator.Assertions.Returns.Test do
  use ExUnit.Case, async: true
  use Spyanator.Assertions

  defmodule Spy do
    use Spyanator
    track test(x, y), do: x + y
    track array(x), do: x
    track tuple(x), do: x
    track string(x), do: x
    track boolean(x), do: x
    track binary(x), do: x
  end

  def subject(_ \\ nil) do
    Spyanator.start_spy(Spy)
    Spy.test(1, 2)
    :ok
  end

  def complex_subject(_ \\ nil) do
    Spyanator.start_spy(Spy)
    Spy.array([1])
    Spy.tuple({1})
    Spy.string("1")
    Spy.binary('1')
    Spy.boolean(false)
    :ok
  end

  describe "when a function is being tracked" do
    setup [:subject]

    test "it tracks the returned value" do
      assert Spy |> returned(3) |> from(:test)
    end

    test "fails if provided the wrong value" do
      refute Spy |> returned(99) |> from(:test)
    end
  end

  describe "when the function was not called" do
    setup [:subject]

    test "it returns false" do
      assert Spy |> returned(nil) |> from(:made_up) == false
    end
  end

  describe "when a function returns a non-number type" do
    setup [:complex_subject]

    test "it tracks arrays" do
      assert Spy |> returned([1]) |> from(:array)
    end

    test "it tracks tuples" do
      assert Spy |> returned({1}) |> from(:tuple)
    end

    test "it tracks strings" do
      assert Spy |> returned("1") |> from(:string)
    end

    test "it tracks binaries" do
      assert Spy |> returned('1') |> from(:binary)
    end

    test "it tracks booleans" do
      assert Spy |> returned(false) |> from(:boolean)
    end
  end
end
