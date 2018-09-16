defmodule Q.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    EventBus.register_topic(:new_value)
    EventBus.register_topic(:record_deleted)
    EventBus.subscribe({QWeb.RecordsChannel, [:new_value, :record_deleted]})

    children = [
      supervisor(QWeb.Endpoint, []),
      supervisor(Q.StateStore, [nil]),
    ]

    opts = [strategy: :one_for_one, name: Q.Supervisor]
    Supervisor.start_link(children, opts)
  end


  def config_change(changed, _new, removed) do
    QWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
