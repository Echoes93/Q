defmodule Q.StateStoreTest do
  use ExUnit.Case, async: true

  setup_all do
    # start_supervised!(Q.StateStore)

    :ok
  end

  test "inserts and gets values buy keys correctly" do
    {key, value} = {:key, "value"}

    Q.StateStore.put(key, value)
    assert Q.StateStore.get(key) == value
  end
end
