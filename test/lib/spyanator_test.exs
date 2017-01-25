defmodule Spyanator.Test do
  use ExUnit.Case, async: true

  defmodule Spy do
    use Spyanator

    def def_me(x), do: x
    def def_me(x, y), do: x + y
  end

  def state_for(spy), do: :sys.get_state(spy)
  def ok(_x), do: :ok
  def subject(_ \\ nil), do: Spy.def_me(1) |> ok
  def start_spy(_context), do:
    {:ok, spy: Spyanator.start_spy(Spy)}

  describe "when starting Spyanator" do
    test "it returns {:ok, pid}" do
      assert {:ok, _pid} = Spyanator.start_link(name: :test)
    end
  end

  describe "when starting a spy" do
    test "it returns {:ok, pid}" do
      assert {:ok, _pid} = Spyanator.start_spy(Spy)
    end

    test "it maps a spys name to a pid" do
      Spyanator.start_spy(Spy)

      assert :sys.get_state(Spyanator) |> Map.get(Spyanator.Test.Spy)
    end
  end

  describe "when a spy has a pid" do
    setup [:start_spy]

    test "it can be retrieved", %{spy: {:ok, pid}} do
      assert Spyanator.get_pid_for_module(Spy) == pid
    end
  end

  describe "when a defed function is called" do
    setup [:start_spy, :subject]

    test "it defs how many times the function is called", %{spy: {:ok, spy}} do
      assert state_for(spy) |> Map.get(:def_me) |> Map.get(:calls) == 1

      subject()

      assert state_for(spy) |> Map.get(:def_me) |> Map.get(:calls) == 2
    end

    test "it defs the provided arguments", %{spy: {:ok, spy}} do
      assert state_for(spy) |> Map.get(:def_me) |> Map.get(:arguments) == {[1]}
    end

    test "it defs the return value", %{spy: {:ok, spy}} do
      assert state_for(spy) |> Map.get(:def_me) |> Map.get(:return_values) == {[1]}
    end
  end
end
