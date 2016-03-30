defmodule ThermLog.Worker do
  use GenServer
  require Logger

  def start_link() do
    Logger.info "Starting ThermLog.Worker"
    GenServer.start_link(__MODULE__, [])
  end

  def init(_channel) do
    initialize_database
    initialize_channel
    {:ok, nil}
  end

  defp initialize_channel do
    Logger.info "initialize_channel"
    # :pg2.create(:thermex_measurements) |> IO.inspect
    :pg2.join(:thermex_measurements, self()) |> IO.inspect
  end

  defp initialize_database do
    Logger.info "initialize_database"
    Sqlitex.Server.query(Sqlitex.Server, "CREATE TABLE IF NOT EXISTS temperature_readings(id INTEGER PRIMARY KEY AUTOINCREMENT, serial_number CHAR(20), temperature INTEGER, timestamp INTEGER)") |> IO.inspect
  end

  def handle_info({serial, temperature, timestamp}, state) do
    Logger.info "handle_info"
    Logger.info { serial, temperature, timestamp }
    store_temperature(serial, temperature, timestamp)
    {:noreply, state}
  end

  defp store_temperature(serial, temperature, timestamp) do
    Sqlitex.Server.query(Sqlitex.Server, "INSERT INTO temperature_readings(serial_number, temperature, timestamp) VALUES(#{serial}, #{temperature}, #{timestamp})") |> IO.inspect
  end
end
