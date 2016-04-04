# Witex

**A [wit.ai] http client in Elixir.**

Wit.ai documentation: [here][wit.ai/docs]

## Currently Supports

 - Intent from Messages.

## Installation

The package can be installed as:

  1. Add witex to your list of dependencies in `mix.exs`:

        def deps do
          [{:witex, "~> 0.0.1", path: "/path/to/module"}]
        end

  2. Ensure witex is started before your application:

        def application do
          [applications: [:witex]]
        end

[wit.ai]: https://wit.ai
[wit.ai/docs]: https://wit.ai/docs
