Code.require_file("#{__DIR__}/espec_phoenix_extend.ex")

Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
