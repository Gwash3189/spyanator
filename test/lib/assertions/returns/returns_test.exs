defmodule Spyanator.Assertions.Returns.Test do
  use ExUnit.Case, async: true
  use Spyanator.Assertions

  defmodule Spy do
    use Spyanator
    def test(x, y), do: x + y
    def array(x), do: x
    def tuple(x), do: x
    def string(x), do: x
    def boolean(x), do: x
    def binary(x), do: x
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

  describe "when a function is being defed" do
    setup [:subject]

    test "it defs the returned value" do
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

    test "it defs arrays" do
      assert Spy |> returned([1]) |> from(:array)
    end

    test "it defs tuples" do
      assert Spy |> returned({1}) |> from(:tuple)
    end

    test "it defs strings" do
      assert Spy |> returned("1") |> from(:string)
    end

    test "it defs binaries" do
      assert Spy |> returned('1') |> from(:binary)
    end

    test "it defs booleans" do
      assert Spy |> returned(false) |> from(:boolean)
    end
  end
end
