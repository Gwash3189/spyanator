defmodule SpyanatorTest do
  use ExUnit.Case
  doctest Spyanator

  defmodule Mock do
    use Spyanator

    def increment_test, do: increment_calls_to(:test)
    def cache_arguments(list), do: cache_arguments_for_last_call!(:test, list)
  end


  describe "increment_calls_to/1" do
    setup [:start_mock]

    test "it increments the call count for the provided function" do
      Mock.increment_test
      assert :sys.get_state(Mock) == %{test: %{calls: 1}}

      Mock.increment_test
      assert :sys.get_state(Mock) == %{test: %{calls: 2}}
    end
  end

  describe "called_once?/1" do
    setup [:start_mock]

    test "returns true when the function has been called once" do
      Mock.increment_test

      assert Mock.called_once?(:test)
    end
  end

  describe "called_twice?/1" do
    setup [:start_mock]

    test "returns true when the function has been called twice" do
      Mock.increment_test
      Mock.increment_test

      assert Mock.called_twice?(:test)
    end
  end

  describe "called_thrice?/1" do
    setup [:start_mock]

    test "returns true when the function has been called three times" do
      Mock.increment_test
      Mock.increment_test
      Mock.increment_test

      assert Mock.called_thrice?(:test)
    end
  end

  describe "received?/1" do
    setup [:start_mock]

    test "returns true when the function has been called at least once" do
      Mock.increment_test

      assert Mock.received?(:test)
    end
  end

  describe "when the increment_test function is called" do
    setup [:start_mock]

    test "it returns true when the function is called" do
      Mock.increment_test

      assert Mock.called?(:test)
    end
  end

  describe "when the increment_test function is not called" do
    setup [:start_mock]

    test "it returns false when the function is called" do
      refute Mock.called?(:test)
    end
  end

  describe "when there are previous calls" do
    setup [:start_mock]

    test "cache_arguments_for_last_call!/2 caches the provided arguments" do
      Mock.increment_test
      Mock.cache_arguments([1])

      assert :sys.get_state(Mock) == %{test: %{args: %{"1" => [1]}, calls: 1}}
    end
  end

  describe "when there are not previous calls" do
    setup [:start_mock]

    test "cache_arguments_for_last_call!/2 raises an error" do
      assert_raise RuntimeError, Mock.cache_arguments([1])
    end
  end

  def start_mock(_), do:
    {:ok, spy: Mock.start_spying}
end
