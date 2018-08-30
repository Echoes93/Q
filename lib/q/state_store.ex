defmodule Q.StateStore do
  use GenServer

  def start_link(_), do: GenServer.start_link(__MODULE__, [], [name: __MODULE__])

  def get, do: GenServer.call(__MODULE__, :get)
  def get(key), do: GenServer.call(__MODULE__, {:get, key})
  def put(key, value), do: GenServer.cast(__MODULE__, {:put, key, value})


  # CALLBACKS
  def init(_) do
    {:ok, %{}}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get, key}, _from, state) do
    return_value = Map.get(state, key)
    {:reply, return_value, state}
  end

  def handle_cast({:put, key, value}, state) do
    new_state = Map.put(state, key, value)
    {:noreply, new_state}
  end
end
