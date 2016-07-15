defmodule ParticipateApi.Router do
  use ParticipateApi.Web, :router

  # pipeline :api do
  #   plug :accepts, ["json-api"]
  #   plug JaSerializer.ContentTypeNegotiation
  #   plug JaSerializer.Deserializer
  # end

  # scope "/", ParticipateApi do
  #   pipe_through :api
  # end

  pipeline :oauth do
    plug :accepts, ["json"]
  end

  scope "/", ParticipateApi do
    pipe_through :oauth

    post "/token", TokenController, :create
  end
end
