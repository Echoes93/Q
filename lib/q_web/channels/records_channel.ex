defmodule QWeb.RecordsChannel do
  use QWeb, :channel

  ## :new_value Event Handler
  def process({:new_value, _event_id} = event_shadow) do
    data = EventBus.fetch_event_data(event_shadow)
    QWeb.Endpoint.broadcast!("records", "new_value", data)
  end

  ## Join Channel Callback
  def join("records", _payload, socket) do
    records = Q.StateStore.get()
    {:ok, records, socket}
  end

  ## Incoming "new_value" message handler
  def handle_in("new_value", %{"key" => key, "value" => value}, socket) do
    Q.StateStore.put(key, value)
    {:reply, :ok, socket}
  end
end
