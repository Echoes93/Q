defmodule QWeb.RecordsChannelTest do
  use QWeb.ChannelCase
  alias QWeb.RecordsChannel

  @new_record %{"key" => "KEY", "value" => "original value"}
  @updated_record %{"key" => "KEY", "value" => "updated value"}


  setup do
    ensure_state_store_empty()

    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(RecordsChannel, "records")

    {:ok, socket: socket}
  end


  describe "new_value message handler" do
    test "creates new record in StateStore if one with given key does not exist", %{socket: socket} do
      assert Q.StateStore.get(@new_record["key"]) == nil

      ref = push socket, "new_value", @new_record
      assert_reply ref, :ok

      assert Q.StateStore.get(@new_record["key"]) == @new_record["value"]
    end

    test "updates a record in StateStore with value, if one with given key exists in StateStore", %{socket: socket} do
      ref = push socket, "new_value", @new_record
      assert_reply ref, :ok

      update_ref = push socket, "new_value", @updated_record
      assert_reply update_ref, :ok

      assert Q.StateStore.get(@new_record["key"]) == @updated_record["value"]
    end
  end

  describe "delete_record message handler" do
    test "deletes record from StateStore if one with given key exists", %{socket: socket} do
      Q.StateStore.put(@new_record["key"], @new_record["values"])

      ref = push socket, "delete_record", @new_record
      assert_reply ref, :ok
      assert Q.StateStore.get(@new_record["key"]) == nil
    end
  end


  defp ensure_state_store_empty, do: Q.StateStore.get() |> Enum.each(fn {key, _value} -> Q.StateStore.delete(key) end)
end
