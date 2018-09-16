defmodule Q.StateStore do
  use GenServer
  use EventBus.EventSource

  def start_link(_), do: GenServer.start_link(__MODULE__, [], [name: __MODULE__])

  def get, do: GenServer.call(__MODULE__, :get)
  def get(key), do: GenServer.call(__MODULE__, {:get, key})
  def put(key, value), do: GenServer.cast(__MODULE__, {:put, key, value})
  def delete(key), do: GenServer.cast(__MODULE__, {:delete, key})


  # CALLBACKS
  def init(_) do
    {:ok, %{}}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get, key}, _from, state) do
    return_value = Q.Collection.get(state, key)
    {:reply, return_value, state}
  end

  def handle_cast({:put, key, value}, state) do
    new_state = Q.Collection.put(state, key, value)
    throw_event({key, value}, :new_value)
    {:noreply, new_state}
  end

  def handle_cast({:delete, key}, state) do
    new_state = Q.Collection.delete(state, key)
    throw_event(key, :record_deleted)
    {:noreply, new_state}
  end


  # HELPERS
  defp throw_event(payload, topic) do
    params = %{topic: topic}
    EventSource.notify(params) do
      payload
    end
  end
end
