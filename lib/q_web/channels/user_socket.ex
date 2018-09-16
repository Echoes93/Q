defmodule QWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "records", QWeb.RecordsChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  ## Connection Callback
  def connect(_params, socket) do
    {:ok, socket}
  end

  ## We don't care about socket identity
  def id(_socket), do: nil
end
