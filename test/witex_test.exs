defmodule WitexTest do
  use ExUnit.Case
  doctest Witex

  test "the truth" do
    assert 1 + 1 == 2
  end

  @payload %{bar: "baz"}

  setup_all do
    {:ok, payload} = JSX.encode(@payload)
    ver = Witex.version
    HTTPlacebo.start
    HTTPlacebo.register_uri(:get, "https://api.wit.ai/message?q=show+intent&v=20160415", [body: ~s({"foo": [#{payload}]})])
    :ok
  end

  test "a" do
    response = Witex.message("show intent")
    refute response
  end
end
