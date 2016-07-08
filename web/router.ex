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

  pipeline :non_json_api do
    plug :accepts, ["json"]
  end

  scope "/", ParticipateApi do
    pipe_through :non_json_api

    post "/token", TokenController, :create
  end
end
