defmodule Spyanator.Assertions.Test do
  alias Spyanator.Assertions
  use ExUnit.Case, async: true

  defmodule Spy do
    use Spyanator

    def test(x), do: x
  end

  test "it returns the expected value" do
    Spyanator.start_spy(Spy)

    assert Spy.test(1) == 1
  end

  describe "times/1" do
    test "returnes the provided value" do
      assert Assertions.times(true)
    end
  end

  describe "time/1" do
    test "returnes the provided value" do
      assert Assertions.times(true)
    end
  end
end
