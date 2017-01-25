defmodule Spyanator.Assertions.Calls.Assertions do
  alias Spyanator.Assertions.Calls

  @moduledoc """
    Assertions that should be used when testing the return value of a spy
  """

  @doc """
    Assertion that ensures a  function was called once
  """
  @spec once(boolean) :: boolean
  def once(false), do: false

  @doc """
    Assertion that ensures a  function was called once
  """
  @spec once(%Calls{}) :: boolean
  def once(%Calls{} = calls), do:
    calls
      |> Map.put(:expected_call_count, 1)
      |> Spyanator.Assertion.check

  @doc """
    Assertion that ensures a  function was called twice
  """
  @spec twice(boolean) :: boolean
  def twice(false, _), do: false

  @doc """
    Assertion that ensures a  function was called twice
  """
  @spec twice(boolean) :: boolean
  def twice(%Calls{} = calls), do:
    calls
      |> Map.put(:expected_call_count, 2)
      |> Map.put(:modifier, :==)
      |> Spyanator.Assertion.check

  @doc """
    Assertion that ensures a  function was called exactly *n* number
    of times
  """
  @spec exactly(false, integer) :: boolean
  def exactly(false, 0), do: true
  def exactly(false, _), do: false

  @doc """
    Assertion that ensures a  function was called exactly *n* number
    of times
  """
  def exactly(%Calls{} = calls, count), do:
    calls
      |> Map.put(:expected_call_count, count)
      |> Spyanator.Assertion.check

  @doc """
    Assertion that ensures a  function was called at least *n* number
    of times
  """
  @spec at_least(false, any) :: boolean
  def at_least(false, 0), do: true
  def at_least(false, _), do: false

  @doc """
    Assertion that ensures a  function was called at least *n* number
    of times
  """
  @spec at_least(%Calls{}, integer) :: boolean
  def at_least(%Calls{} = calls, count), do:
    calls
      |> Map.put(:expected_call_count, count)
      |> Map.put(:modifier, :>=)
      |> Spyanator.Assertion.check

  @doc """
    Assertion that ensures a  function was called at most *n* number
    of times
  """
  @spec at_least(false, any) :: boolean
  def at_most(false, 0), do: true
  def at_most(false, _), do: false

  @doc """
    Assertion that ensures a  function was called at most *n* number
    of times
  """
  @spec at_least(%Calls{}, integer) :: boolean
  def at_most(%Calls{} = calls, count), do:
    calls
      |> Map.put(:expected_call_count, count)
      |> Map.put(:modifier, :<=)
      |> Spyanator.Assertion.check
end
