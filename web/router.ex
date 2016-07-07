defmodule ParticipateApi.Router do
  use ParticipateApi.Web, :router

  pipeline :api do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  scope "/", ParticipateApi do
    pipe_through :api
  end

  scope "/auth", ParticipateApi do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
