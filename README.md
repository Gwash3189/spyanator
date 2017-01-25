# Spyanator

A spy library for Elixir.

You provide the mocks, we provide the spys.
We also provide ExUnit helpers for our spys.


## Installation

[Available in Hex](https://hex.pm/packages/spyanator). The package can be installed as:

  1. Add `spyanator` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:spyanator, "~> 0.0.3"}]
    end
    ```

  2. Ensure `spyanator` is started before your tests:

    ```elixir
      Spyanator.start_link()
      ExUnit.start()
    ```
