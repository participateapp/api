defmodule ParticipateApi.Router do
  use ParticipateApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ParticipateApi do
    pipe_through :api

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end
end
