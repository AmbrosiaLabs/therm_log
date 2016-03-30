require Logger

defmodule ThermLog.Worker do
  use GenServer

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
    :pg2.create(:thermex_measurements)
    :pg2.join(:thermex_measurements, self())
  end

  defp initialize_database do
    Logger.info "initialize_database"
    case Sqlitex.Server.query(Sqlitex.Server, "CREATE TABLE IF NOT EXISTS temperature_readings(id INTEGER PRIMARY KEY AUTOINCREMENT, serial_number CHAR(20), temperature INTEGER, timestamp INTEGER)") do
      {:ok, results} -> Logger.info "OK: #{results}"
      {:error, reason} -> Logger.info "ERROR: #{reason}"
      _ -> Logger.info "Default case"
    end
  end

  def handle_info({serial, temperature, timestamp}, state) do
    Logger.info "handle_info"
    Logger.info { serial, temperature, timestamp }
    case store_temperature(serial, temperature, timestamp) do
      {:ok, _result} -> IO.puts "Data Saved"
      {:error, result} -> IO.puts "Unable to save data: #{result}"
      _ -> IO.puts "default case"
    end
    {:noreply, state}
  end

  defp store_temperature(serial, temperature, timestamp) do
    Sqlitex.Server.query(Sqlitex.Server, "INSERT INTO temperature_readings(serial_number, temperature, timestamp) VALUES(#{serial}, #{temperature}, #{timestamp})")
  end
end
