defmodule ThermLog do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Sqlitex.Server, [Application.get_env(:therm_log, :dbname), [name: Sqlitex.Server]]),
      worker(ThermLog.Worker, [])
    ]

    opts = [strategy: :one_for_one, name: ThermLog.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
