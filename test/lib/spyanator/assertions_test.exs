defmodule Spyanator.Assertions.Test do
  use ExUnit.Case, async: true

  describe "times/1" do
    test "returnes the provided value" do
      assert Spyanator.Assertions.times(true)
    end
  end

  describe "time/1" do
    test "returnes the provided value" do
      assert Spyanator.Assertions.times(true)
    end
  end
end
