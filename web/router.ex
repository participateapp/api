defmodule ParticipateApi.Router do
  use ParticipateApi.Web, :router

  pipeline :oauth do
    plug :accepts, ["json"]
  end

  pipeline :api do
    plug :accepts, ["json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureAuthenticated
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  scope "/", ParticipateApi do
    pipe_through :oauth

    post "/token", TokenController, :create
  end

  scope "/", ParticipateApi do
    pipe_through :api

    get "/me", MeController, :show

    resources "/participants", ParticipantController, only: [:show]
    resources "/proposals", ProposalController
  end

end
