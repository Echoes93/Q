defmodule QWeb.Router do
  use QWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", QWeb do
    pipe_through :api
  end
end
