defmodule QWeb.RecordsChannel do
  use QWeb, :channel
  import QWeb.RecordView

  ## :new_value Event Handler
  def process({:new_value, _event_id} = event_shadow) do
    record = EventBus.fetch_event_data(event_shadow)
    QWeb.Endpoint.broadcast!("records", "new_value", render("show.json", %{record: record}))
  end

  ## :record_deleted Event Handler
  def process({:record_deleted, _event_id} = event_shadow) do
    record_key = EventBus.fetch_event_data(event_shadow)
    QWeb.Endpoint.broadcast!("records", "record_deleted", %{"key" => record_key})
  end


  ## Join Channel Callback
  def join("records", _payload, socket) do
    records = Q.StateStore.get()
    {:ok, render("index.json",  %{records: records}), socket}
  end

  ## Incoming "new_value" message handler
  def handle_in("new_value", %{"key" => key, "value" => value}, socket) do
    Q.StateStore.put(key, value)
    {:reply, :ok, socket}
  end

  ## Incoming "delete_record" message handler
  def handle_in("delete_record", %{"key" => key}, socket) do
    Q.StateStore.delete(key)
    {:reply, :ok, socket}
  end
end
