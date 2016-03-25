defmodule ThermLog.Worker do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_channel) do
    :pg2.create(:thermex_measurements)
    :pg2.join(:thermex_measurements, self)
    {:ok, nil}
  end

  def handle_info({serial, temperature, timestamp}, state) do
    IO.inspect { serial, temperature, timestamp }
    {:noreply, state}
  end
end
