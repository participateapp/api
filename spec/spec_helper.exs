Code.require_file("#{__DIR__}/phoenix_helper.exs")

ESpec.start

ESpec.configure fn(config) ->
  config.before fn ->
    # Ecto.Adapters.SQL.Sandbox.checkout(ParticipateApi.Repo, [])
  end

  config.finally fn(_shared) ->
    # Ecto.Adapters.SQL.Sandbox.checkin(ParticipateApi.Repo, [])
  end
end
